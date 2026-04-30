#!/bin/bash
# xhs-workflow 环境初始化脚本
#
# 用法:
#   ./init.sh          # 安装所有子 skill 并检查环境
#   ./init.sh --check  # 仅检查环境，不安装

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CHECK_ONLY=false
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=true

PASS=0
FAIL=0
WARN=0

pass() { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); }
fail() { echo -e "  ${RED}✗${NC} $1"; ((FAIL++)); }
warn() { echo -e "  ${YELLOW}⚠${NC} $1"; ((WARN++)); }

echo "═══════════════════════════════════════════════"
echo " xhs-workflow 环境检查"
echo "═══════════════════════════════════════════════"
echo ""

# --- 系统依赖 ---
echo "▶ 系统依赖"

if command -v python3 &>/dev/null; then
  pass "Python3 $(python3 --version 2>&1 | awk '{print $2}')"
else
  fail "Python3 未安装"
fi

if python3 -c "import PIL" 2>/dev/null; then
  pass "Pillow (图片处理)"
else
  if $CHECK_ONLY; then
    fail "Pillow 未安装 → pip3 install Pillow"
  else
    warn "Pillow 未安装，正在安装..."
    pip3 install Pillow -q && pass "Pillow 已安装" || fail "Pillow 安装失败"
  fi
fi

if command -v convert &>/dev/null; then
  pass "ImageMagick $(convert --version 2>/dev/null | head -1 | awk '{print $3}')"
else
  if $CHECK_ONLY; then
    fail "ImageMagick 未安装 → brew install imagemagick"
  else
    warn "ImageMagick 未安装，请手动安装: brew install imagemagick"
    ((FAIL++))
  fi
fi

if command -v node &>/dev/null; then
  pass "Node.js $(node --version)"
else
  fail "Node.js 未安装"
fi

BROWSER_FOUND=false
for browser in "/Applications/Google Chrome.app" "/Applications/Microsoft Edge.app" "/Applications/Chromium.app"; do
  if [[ -d "$browser" ]]; then
    pass "浏览器: $(basename "$browser" .app)"
    BROWSER_FOUND=true
    break
  fi
done
$BROWSER_FOUND || fail "未找到 Chrome/Edge/Chromium 浏览器"

echo ""

# --- 子 Skill 检查 ---
echo "▶ 子 Skill"

SKILLS=(
  "xiaohongshu-cn"
  "xiaohongshu-deep-research"
  "xhs-content-creator"
  "xhs"
  "xiaohongshu-ops"
  "baoyu-xhs-images"
  "xhs-md2pic"
  "xiaohongshu-publisher"
  "xhs-auto-reply"
  "xiaohongshu-mcp"
)

SKILL_DIRS=(
  "$HOME/.claude/skills"
  "$HOME/.qclaw/skills"
)

for skill in "${SKILLS[@]}"; do
  found=false
  for dir in "${SKILL_DIRS[@]}"; do
    if [[ -d "$dir/$skill" ]] || [[ -f "$dir/$skill/SKILL.md" ]]; then
      found=true
      break
    fi
  done
  if $found; then
    pass "$skill"
  else
    fail "$skill 未找到"
  fi
done

echo ""

# --- 环境变量 ---
echo "▶ 环境变量"

if [[ -n "${DASHSCOPE_API_KEY:-}" ]]; then
  pass "DASHSCOPE_API_KEY 已设置"
else
  warn "DASHSCOPE_API_KEY 未设置（部分图片生成功能需要）"
fi

if [[ -n "${OPENAI_API_KEY:-}" ]]; then
  pass "OPENAI_API_KEY 已设置"
else
  warn "OPENAI_API_KEY 未设置（自动回复功能需要）"
fi

echo ""

# --- MCP 服务 ---
echo "▶ MCP 服务"

if curl -s --connect-timeout 2 http://localhost:18060/health &>/dev/null; then
  pass "xiaohongshu-mcp 服务运行中 (端口 18060)"
else
  warn "xiaohongshu-mcp 未运行（发布时需要：python3 server.py --port 18060）"
fi

echo ""

# --- 汇总 ---
echo "═══════════════════════════════════════════════"
echo -e " 结果: ${GREEN}${PASS} 通过${NC} | ${RED}${FAIL} 失败${NC} | ${YELLOW}${WARN} 警告${NC}"
echo "═══════════════════════════════════════════════"

if ((FAIL > 0)); then
  echo ""
  echo "存在 ${FAIL} 项必要依赖缺失，部分功能可能无法正常运行。"
  exit 1
fi

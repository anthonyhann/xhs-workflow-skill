---
name: xhs-workflow
description: |
  小红书全链路智能创作调度器，编排 10 个子 skill 实现从调研到运营的自动化内容生产。
  Use when 用户需要创建小红书笔记、做小红书热点分析、批量生产小红书内容、小红书账号冷启动、写小红书测评、做小红书教程。当用户提到"小红书"+"创作/写/发布/运营/热点/爆款/教程/测评/批量"时触发，即使没有明确说"调度"或"workflow"。命令触发：/xhs-workflow。
  Do NOT use for 仅查询小红书信息而不创作、仅讨论小红书平台规则、已经在某个子 skill 执行中的二次触发、非小红书平台的内容创作。
---

# 小红书全链路智能创作调度器

> 本 skill 是一个 **总控调度器**（P3 流程编排 + P2 路由分发），负责根据用户场景自动编排 10 个小红书子 skill 的串行/并行执行，覆盖调研→创作→设计→发布→运营全链路。

---

## 运行前门禁（Pre-flight Gate）

> **强制执行**：每次 skill 被触发时，在进入 Step 0 之前必须先通过门禁检查。门禁失败则阻断执行并给出修复指引。

### 检查项

| # | 检查 | 命令 | 通过条件 | 失败处理 |
|---|------|------|---------|---------|
| G1 | Python 3 | `which python3` | 返回路径 | 阻断：提示安装 Python 3 |
| G2 | Pillow | `python3 -c "import PIL"` | 退出码 0 | 阻断：`pip3 install Pillow` |
| G3 | Node.js | `which node` | 返回路径 | 阻断：提示安装 Node.js |
| G4 | 核心子 skill 存在 | 检查 `xhs-content-creator`、`xhs`、`xiaohongshu-publisher`、`xiaohongshu-mcp` 目录 | 4 个均存在 | 阻断：列出缺失 skill 并提示安装 |
| G5 | 场景子 skill（按需） | 按路由后场景检查所需的可选 skill | 场景所需 skill 存在 | 警告：标记该阶段将跳过 |
| G6 | ImageMagick（图片场景） | `which convert` | 返回路径 | 警告：Phase 3 图片生成可能受限 |
| G7 | MCP 服务（发布场景） | `curl -s --connect-timeout 2 http://localhost:18060/health` | HTTP 200 | 警告：Phase 4 将降级为手动发布 |

### 门禁分级

**硬性门禁（阻断级）** — G1-G4 任一失败则终止执行：

- 缺少运行时环境（Python/Node）→ 无法执行任何子 skill
- 缺少核心 skill → 链路断裂，无法完成最小可用流程

**软性门禁（降级级）** — G5-G7 失败则标记降级，不阻断：

- 缺少可选 skill → 跳过对应 Phase，在报告中标注
- MCP 未运行 → Phase 4 降级为"产物准备 + 手动发布指南"

### 执行逻辑

```
触发 /xhs-workflow
    │
    ▼
┌─────────────────────────────┐
│  Pre-flight Gate            │
│  G1-G3: 硬性依赖 ──────────│──→ 任一失败 → 阻断 + 修复指引
│  G4: 核心 skill ───────────│──→ 任一缺失 → 阻断 + 安装指引
│  G5-G7: 软性依赖 ──────────│──→ 失败 → 警告 + 标记降级
└─────────────────────────────┘
    │ 全部通过或仅有软性警告
    ▼
  Step 0: 场景路由
```

### 门禁输出格式

```markdown
## 环境门禁检查

| 检查项 | 状态 | 备注 |
|--------|------|------|
| Python 3 | ✅ 3.11.5 | — |
| Pillow | ✅ | — |
| Node.js | ✅ v20.10.0 | — |
| 核心 skill (4) | ✅ | — |
| 场景 skill | ⚠️ 缺少 baoyu-xhs-images | Phase 3 将跳过信息图生成 |
| ImageMagick | ✅ 7.1.1 | — |
| MCP 服务 | ❌ 未运行 | Phase 4 降级为手动发布 |

**结论：通过（1 项降级）**，继续执行...
```

### 快速修复命令

门禁失败时输出对应的一键修复：

```bash
# G1-G3 系统依赖
brew install python3 node imagemagick

# G2 Pillow
pip3 install Pillow

# G4 核心 skill 缺失 — 运行初始化脚本
./init.sh

# G7 MCP 服务启动
python3 server.py --port 18060
```

---

## 输入与前置条件

### 必填输入

- `topic`：选题关键词或主题描述（中文）
- `scene`（可选）：场景模式，不提供时由调度器自动识别
  - `hotspot` — 热点爆款笔记
  - `tutorial` — 知识教程类
  - `review` — 测评合集类
  - `batch` — 批量内容工厂
  - `coldstart` — 账号冷启动

### 可选参数

- `mode`：运行模式
  - `auto` — 全自动执行（默认）
  - `step` — 分阶段确认
- `style`：视觉风格（`bold`/`fresh`/`minimal`/`pop`/`retro` 等，默认 `fresh`）
- `count`：图片数量（默认 6）
- `publish`：是否自动发布（`true`/`false`，默认 `false`，需用户确认）

### 依赖（子 skill）

| 子 Skill | 用途 | 必需 |
|----------|------|------|
| xiaohongshu-cn | 热点/趋势发现 | 按场景 |
| xiaohongshu-deep-research | 深度调研 | 按场景 |
| xhs-content-creator | CES 算法文案生成 | 是 |
| xhs | 全能助手（创作指南） | 是 |
| xiaohongshu-ops | 运营 SOP | 按场景 |
| baoyu-xhs-images | 信息图生成 | 按场景 |
| xhs-md2pic | Markdown 转卡片图 | 按场景 |
| xiaohongshu-publisher | 封面+发布 | 是 |
| xhs-auto-reply | AI 评论回复 | 按场景 |
| xiaohongshu-mcp | MCP 浏览器服务 | 是 |

### 环境依赖

| 依赖 | 用途 | 检查命令 |
|------|------|----------|
| Python 3 | 脚本运行 | `which python3` |
| Pillow | 图片生成 | `python3 -c "import PIL"` |
| ImageMagick | 图片转换 | `which convert` |
| Node.js | MCP 服务 | `which node` |
| Chrome/Edge | 浏览器自动化 | 系统检查 |

依赖缺失时不得静默继续，需提示安装或指向 `init.sh` 脚本。

---

## Step 0：场景路由（P2 辅助模式）

### 路由规则

| 条件 | 场景 | 判断方式 |
|------|------|----------|
| 用户明确指定 `scene` 参数 | 直接使用 | 参数匹配 |
| 包含"热点/爆款/流量/火" | `hotspot` | 关键词匹配 |
| 包含"教程/教学/步骤/怎么做/攻略" | `tutorial` | 关键词匹配 |
| 包含"测评/对比/推荐/合集/排行" | `review` | 关键词匹配 |
| 包含"批量/多篇/量产/周更" | `batch` | 关键词匹配 |
| 包含"冷启动/新号/起号/从零" | `coldstart` | 关键词匹配 |
| 无法匹配 | `hotspot`（默认） | fallback |

> 判断优先级：用户显式参数 > 关键词匹配 > 默认 hotspot

### 多关键词冲突裁决

当输入同时命中多个场景关键词时（如"从零做健身教程"同时命中 `coldstart` + `tutorial`），按以下规则裁决：

| 冲突组合 | 裁决 | 理由 |
|----------|------|------|
| coldstart + 其他 | → `coldstart` | "起号"是元目标，教程/测评是内容形式 |
| batch + 其他 | → `batch` | 批量是执行模式，优先于内容类型 |
| hotspot + tutorial/review | → 追问用户 | 目标不明确，需确认是追热点还是做教程 |
| tutorial + review | → `review` | 测评含教程属性，更具体 |

**置信度追问**：命中 ≥2 个场景且无法通过上表裁决时，展示匹配结果并追问：
```
检测到多个匹配场景：{scene_a}（关键词: {kw_a}）、{scene_b}（关键词: {kw_b}）
请确认您的主要目标是：
1. {scene_a} — {一句话描述}
2. {scene_b} — {一句话描述}
```

### 场景→阶段映射

| 场景 | Phase 1 调研 | Phase 2 创作 | Phase 3 设计 | Phase 4 发布 | Phase 5 运营 |
|------|:---:|:---:|:---:|:---:|:---:|
| hotspot | ✅ 全量 | ✅ CES优化 | ✅ 信息图 | ✅ | ✅ 自动回复 |
| tutorial | ⬜ 跳过 | ✅ 教程体 | ✅ Markdown卡片 | ✅ | ⬜ 仅复盘 |
| review | ✅ 竞品调研 | ✅ 测评体 | ✅ 信息密集图 | ✅ | ✅ 咨询回复 |
| batch | ✅ 快速调研 | ✅ 批量生成 | ✅ 批量图 | ✅ 排队发布 | ✅ 监控 |
| coldstart | ✅ 对标分析 | ✅ 种子内容 | ✅ 批量图 | ✅ 批量发布 | ✅ 周复盘 |

---

## Step 1：调研分析（Phase 1）

- **输入**：`topic` + 路由后的 `scene`
- **操作**：
  - `hotspot`/`batch`/`coldstart`：**并行调用**
    - `xiaohongshu-cn`：`keyword={topic}, limit=10` → 返回 hotspots + trends
    - `xiaohongshu-deep-research`：`keyword={topic}, depth="deep", focus="hotspot"` → 返回 report + top_notes
  - `review`：调用 `xiaohongshu-deep-research`：`keyword={topic}, depth="deep", focus="competitor"`
  - `tutorial`：跳过，直接进入 Step 2
- **输出**：
  - `research_report.md` — 结构化调研报告
  - `hotspots.json` — 热点列表（如适用）
- **检查点**：
  - ✅ 通过：调研报告非空且包含至少 3 条可用素材
  - ❌ 失败：报告为空或素材不足 → 提示用户补充关键词或扩大调研范围

### 并行执行策略

```
场景 hotspot/batch/coldstart:
  ┌─ Agent A: xiaohongshu-cn（热点发现）
  │
  ├─ Agent B: xiaohongshu-deep-research（深度调研）
  │
  └─ 等待两者完成 → 合并结果 → research_report.md
```

---

## Step 2：内容创作（Phase 2）

- **输入**：`research_report.md`（来自 Step 1）+ `scene` + `topic`
- **操作**：
  1. 读取 `xiaohongshu-ops` 运营 SOP 指导（确定内容框架）
  2. 调用 `xhs-content-creator` 生成文案：`topic={topic}, ces_optimize=true, research_context={report}`
     - `hotspot` → `template="diary"`
     - `tutorial` → `template="tutorial"`
     - `review` → `template="review"`
     - `batch` → `template="collection"`，循环 N 次（N=用户指定篇数）
     - `coldstart` → `template="diary"`，参考 top_notes 结构
  3. 调用 `xhs` 润色：`draft={content}, action="full"` → 返回 polished + suggestions
- **输出**：
  - `content_draft.md` — 最终文案（含标题、正文、标签）
  - CES 评分（仅参考）
- **检查点**：
  - ✅ 通过：文案 300-600 字 + 标题 ≤20 字 + 含 `#AI生成内容` 标签 + 5-8 个标签
  - ❌ 失败：不满足要求 → 自动修正（最多 2 次）：
    - 字数超标 → 重新调用 `xhs`：`draft={content}, action="polish"` 并附指令"压缩到 600 字内"
    - 字数不足 → 重新调用 `xhs-content-creator` 补充细节段落
    - 标签不足 → 调用 `xhs`：`action="tags"` 补充至 5-8 个
    - 缺 `#AI生成内容` → 直接追加到标签列表末尾

### 强制规则

- 所有生成内容**必须**包含 `#AI生成内容` 标签（2026 年强制要求）
- 标题前 13 字必须包含核心关键词
- 正文以短句为主，避免长段落

---

## Step 3：视觉设计（Phase 3）

- **输入**：`content_draft.md` + `style` + `count`
- **操作**：按场景 **并行** 选择设计工具：
  - `hotspot`/`review`/`batch`/`coldstart`：调用 `baoyu-xhs-images`
    - 选择风格（用户指定或默认 `fresh`）
    - 信息密集型布局（review）/ 视觉优先型（hotspot）
  - `tutorial`：调用 `xhs-md2pic`
    - Markdown 转分步骤卡片图
    - 3:4 小红书标准比例
- **输出**：
  - `images/` 目录 — 生成的图片文件（1-10 张）
  - `cover.png` — 封面图
- **检查点**：
  - ✅ 通过：至少生成 1 张图片 + 封面图为 3:4 竖图
  - ❌ 失败：图片生成失败 → 检查 Pillow/ImageMagick → 提示用户手动准备图片

### 并行执行策略

```
场景 hotspot:
  ┌─ Agent A: baoyu-xhs-images（系列信息图 × count）
  │
  └─ Agent B: xiaohongshu-publisher 封面生成模块（cover.png）
```

---

## Step 4：智能发布（Phase 4）

- **输入**：`content_draft.md` + `images/` + `cover.png`
- **操作**：
  1. 检查 `xiaohongshu-mcp` 服务状态（端口 18060）
  2. 调用 `xiaohongshu-publisher` 执行发布：
     - 上传封面图 + 内容图
     - 填充标题、正文、标签
     - 浏览器自动化提交
- **输出**：
  - 发布状态：成功/失败
  - 笔记链接（如成功）
- **检查点**：
  - ✅ 通过：发布成功且返回笔记链接
  - ❌ 失败：MCP 服务不可用 → 提示启动服务；发布失败 → 重试 1 次后提示手动发布

### 安全确认

- `publish=false`（默认）：完成准备后**暂停**，展示预览并等待用户确认
- `publish=true`：自动发布，但发布前仍输出预览摘要

---

## Step 5：互动运营（Phase 5）

- **输入**：笔记链接（来自 Step 4）+ `scene`
- **操作**：
  - `hotspot`/`review`/`batch`：调用 `xhs-auto-reply` 自动回复前 20 条评论
  - `coldstart`：调用 `xiaohongshu-ops` 制定周复盘计划
  - `tutorial`：调用 `xiaohongshu-ops` 记录内容效果
- **输出**：
  - `interaction_log.md` — 互动日志
  - 复盘建议（如适用）
- **检查点**：
  - ✅ 通过：互动日志非空
  - ❌ 失败：评论获取失败 → 标记为"待手动互动"，不阻断整体流程

---

## 执行报告（最终输出）

ALWAYS use this exact template:

```markdown
## 小红书创作执行报告

- 场景：{scene_name}
- 模式：{auto|step}
- 主题：{topic}

### Phase 1 调研 {✅|⬜|❌}
- 热点发现：{summary}
- 调研报告：{file_path}

### Phase 2 创作 {✅|❌}
- 文案：{file_path}
- 字数：{word_count}
- CES 参考分：{score}

### Phase 3 设计 {✅|❌}
- 图片数量：{count}
- 风格：{style}
- 封面：{cover_path}

### Phase 4 发布 {✅|⏳|❌}
- 状态：{published|pending_confirm|failed}
- 笔记链接：{url|待发布}

### Phase 5 运营 {✅|⬜|❌}
- 互动：{summary}
- 复盘建议：{suggestions}

---
总耗时：{duration}
子 skill 调用：{call_count} 次
```

---

## 检查点总览

| 步骤 | 检查内容 | 通过标准 | 失败处理 |
|------|---------|---------|---------|
| Step 0 | 场景识别 | 命中已定义场景 | fallback 到 hotspot |
| Step 1 | 调研质量 | 报告含 >=3 条素材 | 提示补充关键词 |
| Step 2 | 文案合规 | 字数/标签/标题合规 | 自动修正（2次） |
| Step 3 | 图片生成 | >=1 张图 + 3:4 封面 | 提示手动准备 |
| Step 4 | 发布成功 | 返回笔记链接 | 重试后手动发布 |
| Step 5 | 互动完成 | 日志非空 | 标记待手动 |

---

## 异常处理

| 场景 | 处理 |
|------|------|
| 子 skill 未安装 | 运行 `init.sh` 安装缺失 skill，或提示手动安装 |
| MCP 服务未启动 | 提示运行 `python3 server.py --port 18060` |
| 环境依赖缺失 | 运行 `init.sh --check` 诊断并给出安装命令 |
| 文案生成超时 | 中止并展示已生成部分，提示手动完善 |
| 发布失败 | 保存所有产物到本地，提供手动发布指南 |
| 分阶段模式用户拒绝 | 停止后续阶段，保存当前产物 |

---

## init.sh 脚本功能

```bash
#!/bin/bash
# xhs-workflow-orchestrator 环境初始化脚本

# 用法:
#   ./init.sh          # 安装所有子 skill 并检查环境
#   ./init.sh --check  # 仅检查环境，不安装

# 检查项:
# 1. Python3 + Pillow + ImageMagick
# 2. Node.js
# 3. Chrome/Edge 浏览器
# 4. 10 个子 skill 是否存在
# 5. MCP 服务端口可用性
# 6. 环境变量（DASHSCOPE_API_KEY, OPENAI_API_KEY）
```

---

## 诚实边界

- 本 skill **做不到**：
  1. 替代子 skill 的核心逻辑（调度器不内聚子功能）
  2. 绕过小红书平台审核机制
  3. 保证内容一定成为"爆款"（CES 评分仅为参考）
  4. 在无 MCP 服务时完成自动发布（降级为手动）
- 信息不足时不做臆断：
  - `topic` 缺失 → 必须追问
  - `scene` 不明确 → 走路由识别，低置信度时追问用户
- 低信息降级策略：
  1. 缺关键输入 → 先追问，不启动链路
  2. 子 skill 不可用 → 跳过对应阶段并标记，不中止整体
  3. MCP 未连接 → Phase 4 降级为"生成产物 + 手动发布指南"

---

## 兼容性说明

### Claude Code 环境

- 通过 `~/.claude/skills/` 注册，使用 `/xhs-workflow` 命令触发
- subagent 并行通过 Agent tool 的并行调用实现
- 子 skill 通过 Skill tool 调用

### OpenClaw Agent Framework

- 通过 `~/.qclaw/skills/` 注册，使用 `openclaw skills run xhs-workflow-orchestrator` 触发
- subagent 并行通过 OpenClaw 的 parallel task 机制实现
- 子 skill 通过 `openclaw skills invoke` 调用

---

## 资源文件

| 文件 | 内容 | 何时读取 |
|------|------|---------|
| [references/scene-configs.md](references/scene-configs.md) | 5 种场景的详细配置和子 skill 参数 | Step 0 场景路由后 |
| [references/sub-skill-api.md](references/sub-skill-api.md) | 10 个子 skill 的接口约定 | 调用子 skill 前 |
| [references/quality-rules.md](references/quality-rules.md) | 内容质量检查规则集 | Step 2 检查点 |
| [init.sh](init.sh) | 环境初始化脚本 | 首次使用或依赖检查失败时 |

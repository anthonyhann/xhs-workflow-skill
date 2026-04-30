# 小红书全链路智能创作调度器

[![子Skill](https://img.shields.io/badge/子Skill-10个-E8590C?style=flat-square)](./references/sub-skill-api.md)
[![场景模式](https://img.shields.io/badge/场景模式-5种-2B8A3E?style=flat-square)](#场景模式)
[![Phase](https://img.shields.io/badge/Phase-5阶段-4C6EF5?style=flat-square)](#架构概览)
[![质量评分](https://img.shields.io/badge/质量评分-86.2%2F100-E8590C?style=flat-square)](#质量评估)
[![兼容性](https://img.shields.io/badge/兼容-Claude_Code_%7C_OpenClaw-333?style=flat-square)](#兼容性)

**一条指令，从调研到运营全自动** — 编排 10 个专业子 Skill，覆盖热点发现、标题策划、内容创作、视觉设计、智能发布到互动运营的全链路，实现 AI 驱动的自动化内容生产。

[English](./README_EN.md) | 中文

---

## 核心特性

| 特性 | 描述 |
|------|------|
| **智能场景路由** | 自动识别 5 种创作场景，多关键词冲突时按优先级裁决或追问 |
| **全链路编排** | 调研 → 创作 → 设计 → 发布 → 运营，5 个 Phase 串行/并行执行 |
| **爆款标题引擎** | 200+ 真实爆款参考、5 种公式、CTR 优化、合规黑名单过滤 |
| **优雅降级** | 硬性门禁阻断 + 软性门禁降级，缺依赖不崩溃 |
| **CES 算法优化** | 文案自动按小红书 CES 评分体系优化，提升互动率 |
| **检查点机制** | 每阶段产物质量校验，不合格自动修正（最多 2 轮） |
| **双平台兼容** | 同时支持 Claude Code 和 OpenClaw Agent Framework |

---

## 架构概览

```
用户输入 topic + scene(可选)
         │
         ▼
┌─────────────────────────────────────────────────┐
│            Pre-flight Gate (G1-G7)              │
│  硬性: Python3 / Pillow / Node / 核心Skill      │
│  软性: 场景Skill / ImageMagick / MCP服务         │
└─────────────────────────────────────────────────┘
         │
         ▼
┌─── Step 0: 场景路由 ───┐
│  hotspot │ tutorial │   │
│  review  │ batch    │   │
│  coldstart           │   │
└─────────────────────────┘
         │
    ┌────┼────┬────┬────┐
    ▼    ▼    ▼    ▼    ▼
 Phase1 Phase2 Phase3 Phase4 Phase5
 调研   创作   设计   发布   运营
  │      │      │      │      │
  └──────┴──────┴──────┴──────┘
                │
                ▼
         执行报告 + 产物
```

---

## 场景模式

| 场景 | 触发关键词 | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|------|-----------|:-------:|:-------:|:-------:|:-------:|:-------:|
| **hotspot** | 热点/爆款/流量 | 全量调研 | CES优化 | 信息图 | 发布 | 自动回复 |
| **tutorial** | 教程/教学/攻略 | 跳过 | 教程体 | MD卡片 | 发布 | 仅复盘 |
| **review** | 测评/对比/合集 | 竞品调研 | 测评体 | 密集图 | 发布 | 咨询回复 |
| **batch** | 批量/量产/周更 | 快速调研 | 批量生成 | 批量图 | 排队发 | 监控 |
| **coldstart** | 冷启动/新号/起号 | 对标分析 | 种子内容 | 批量图 | 批量发 | 周复盘 |

---

## 快速开始

### 1. 环境检查

```bash
./init.sh --check
```

### 2. 触发执行

**Claude Code:**
```
/xhs-workflow
帮我写一篇关于「AI编程工具对比」的小红书爆款笔记
```

**OpenClaw:**
```bash
openclaw skills run xhs-workflow --input '{"topic": "AI编程工具对比", "scene": "hotspot"}'
```

### 3. 分阶段确认模式

```
帮我写一篇关于平价护肤的测评笔记，分阶段确认
```

---

## 子 Skill 矩阵（10 个）

### 🔍 调研类

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `xiaohongshu-cn` | 热门笔记发现、关键词监控、趋势分析 | 按场景 | [下载](https://clawhub-skills.com/skills/xiaohongshu-cn) |
| `xiaohongshu-deep-research` | 深度调研、批量搜索 Top 20-50、报告生成 | 按场景 | [下载](https://clawhub-skills.com/skills/xiaohongshu-deep-research) |

### ✍️ 创作类

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `xhs-content-creator` | CES 算法优化、日记体/教程体/测评体生成 | ✅ | [下载](https://clawhub-skills.com/skills/xhs-content-creator) |
| `xhs` | 全能助手（文案润色+标签+封面指南） | ✅ | [下载](https://clawhub-skills.com/skills/xhs) |

### 🎨 设计类

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `baoyu-xhs-images` | 信息图生成（10 风格、8 布局、1-10 图系列） | 按场景 | [下载](https://clawhub-skills.com/skills/baoyu-xhs-images) |
| `xhs-md2pic` | Markdown 转小红书卡片图（5 主题模板） | 按场景 | [下载](https://clawhub-skills.com/skills/xhs-md2pic) |

### 📤 发布类

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `xiaohongshu-publisher` | 封面图生成 + 浏览器自动发布 | ✅ | [下载](https://clawhub-skills.com/skills/xiaohongshu-publisher) |

### 💬 互动类

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `xhs-auto-reply` | AI 智能评论回复（单篇/批量模式） | 按场景 | [下载](https://clawhub-skills.com/skills/xhs-auto-reply) |

### 📋 运营类

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `xiaohongshu-ops` | 运营 SOP、账号定位、复盘优化 | 按场景 | [下载](https://clawhub-skills.com/skills/xiaohongshu-ops) |

### 🔧 基础设施

| 子 Skill | 功能 | 必需 | ClawHub |
|----------|------|:----:|---------|
| `xiaohongshu-mcp` | MCP 浏览器自动化服务（端口 18060） | ✅ | [下载](https://clawhub-skills.com/skills/xiaohongshu-mcp) |

---

## 创作流程图

```
              ┌─────────────┐
              │  用户输入    │
              │  选题/关键词  │
              └──────┬──────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│              Phase 1: 调研分析                     │
│  xiaohongshu-cn ──▶ xiaohongshu-deep-research    │
│  热点/趋势发现        深度调研/报告生成             │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 2: 内容创作                     │
│  xiaohongshu-title ──▶ xhs-content-creator       │
│  爆款标题(5候选)       CES算法文案生成              │
│          │                                        │
│          ▼                                        │
│  xhs 全能助手（润色+标签+封面建议）                 │
│  xiaohongshu-ops 运营SOP指导                      │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 3: 视觉设计                     │
│  baoyu-xhs-images          xhs-md2pic            │
│  信息图系列(10风格8布局)    Markdown转卡片图        │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 4: 智能发布                     │
│  xiaohongshu-publisher ──▶ xiaohongshu-mcp       │
│  封面生成+内容组装          浏览器自动化发布        │
│                                                   │
│  ⚠️ 通过浏览器自动化实现（无官方 Mac 客户端）       │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 5: 互动运营                     │
│  xhs-auto-reply ◀── xiaohongshu-mcp             │
│  AI评论回复(单篇/批量)    获取评论数据             │
│  xiaohongshu-ops 数据复盘与优化                   │
└──────────────────────────────────────────────────┘
```

---

## 典型创作场景

### 场景 A：热点爆款笔记

```
Step 1: xiaohongshu-cn → 发现当前热点、竞品笔记
Step 2: xiaohongshu-deep-research → 批量调研 Top 20，生成报告
Step 4: xhs-content-creator → CES 算法优化，生成高互动文案
Step 5: baoyu-xhs-images → 生成 3-6 张信息图（pop/fresh 风格）
Step 6: xiaohongshu-publisher → 封面图 + 浏览器自动发布
Step 7: xhs-auto-reply → 发布后自动回复前 20 条评论
```

### 场景 B：知识教程类

```
Step 1: xhs-content-creator → 生成教程体内容
Step 2: xhs-md2pic → Markdown 转卡片图，分步骤展示
Step 3: xiaohongshu-publisher → 发布多图教程
Step 4: xiaohongshu-ops → 记录内容效果，迭代优化
```

### 场景 C：测评合集类

```
Step 1: xiaohongshu-deep-research → 调研同类测评笔记的爆款要素
Step 3: xhs-content-creator → 生成测评体内容模板
Step 4: baoyu-xhs-images → 信息密集型布局，9-10 张系列图
Step 5: xiaohongshu-publisher → 发布合集笔记
Step 6: xhs-auto-reply → 回复评论中的产品咨询
```

### 场景 D：批量内容工厂

```
For each 关键词:
  Step 1: xiaohongshu-deep-research → 快速调研
  Step 3: xhs-content-creator → 生成内容
  Step 4: baoyu-xhs-images → 生成图片
  Step 5: xiaohongshu-publisher → 排队发布
  Step 6: xhs-auto-reply → 监控评论

使用 xiaohongshu-ops 制定周更计划
```

### 场景 E：账号冷启动

```
Step 1: xiaohongshu-ops → 制定账号定位策略
Step 2: xiaohongshu-cn → 监控对标账号的热门选题
Step 3: xiaohongshu-deep-research → 分析 5 个对标账号的 Top 内容
Step 5: xhs-content-creator → 模仿爆款结构，生成 10 篇种子内容
Step 6: xiaohongshu-publisher → 批量发布种子笔记
Step 7: xiaohongshu-ops → 每周复盘，迭代内容方向
```

---

## 环境依赖

| 依赖 | 用途 | 安装 |
|------|------|------|
| Python 3 | 脚本运行 | `brew install python3` |
| Pillow | 图片生成 | `pip3 install Pillow` |
| Node.js | MCP 服务 | `brew install node` |
| ImageMagick | 图片转换 | `brew install imagemagick` |
| Chrome/Edge | 浏览器自动化 | 系统安装 |

### 环境变量

```bash
# xhs-md2pic（可选，AI 背景生成）
export DASHSCOPE_API_KEY="your-api-key"

# xhs-auto-reply（评论回复）
export OPENAI_API_KEY="your-api-key"
```

一键检查并安装：

```bash
./init.sh
```

---

## 安装指南

### 一键安装全部子 Skill

```bash
openclaw skills install xiaohongshu-cn
openclaw skills install xiaohongshu-deep-research
openclaw skills install xhs-content-creator
openclaw skills install xhs
openclaw skills install xiaohongshu-ops
openclaw skills install baoyu-xhs-images
openclaw skills install xhs-md2pic
openclaw skills install xiaohongshu-publisher
openclaw skills install xhs-auto-reply
openclaw skills install xiaohongshu-mcp
```

### 按需安装

**仅创作链：**
```bash
openclaw skills install xiaohongshu-deep-research
openclaw skills install xhs-content-creator
openclaw skills install baoyu-xhs-images
openclaw skills install xiaohongshu-publisher
```

**仅互动运营：**
```bash
openclaw skills install xiaohongshu-mcp
openclaw skills install xhs-auto-reply
openclaw skills install xiaohongshu-ops
```

---

## 降级策略

| 缺失 | 影响 | 处理 |
|------|------|------|
| 可选子 Skill | 对应 Phase 跳过 | 报告中标注，不中断 |
| ImageMagick | Phase 3 图片受限 | 警告，提示手动准备 |
| MCP 服务 | 无法自动发布 | 降级为产物准备 + 手动发布指南 |
| 环境变量缺失 | 部分功能受限 | 警告并继续 |

---

## 最佳实践

### 内容发布节奏

| 时间 | 动作 | 技能 |
|------|------|------|
| 周一 | 热点调研，制定选题 | xiaohongshu-cn + deep-research |
| 周二-周四 | 批量创作 | xhs-content-creator + baoyu-xhs-images |
| 周五 | 发布笔记 | xiaohongshu-publisher |
| 周末 | 评论互动 + 复盘 | xhs-auto-reply + xiaohongshu-ops |

### 内容质量检查清单

- [ ] 标题 ≤ 20 字，前 13 字含核心关键词
- [ ] 标题通过 validator.py 质检（< 22 字、无禁用词、含 emoji）
- [ ] 正文 300-600 字，短句为主
- [ ] 封面 3:4 竖图，视觉冲击强
- [ ] 5-8 个标签（热门 + 长尾）
- [ ] 添加 `#AI生成内容` 标签
- [ ] 前 2 小时回复所有评论

### 风险规避

| 风险 | 应对 |
|------|------|
| 内容同质化 | 使用 deep-research 分析差异化角度 |
| 限流风险 | 每篇标注 AI 生成，原创度 > 70% |
| 发布失败 | 检查 MCP 服务状态，重试登录 |
| 评论回复不当 | 设置 xhs-auto-reply 人设限制 |

---

## 兼容性

| 平台 | 触发方式 | 并行机制 |
|------|---------|---------|
| **Claude Code** | `/xhs-workflow` 命令 | Agent tool 并行调用 |
| **OpenClaw** | `openclaw skills run` | parallel task 机制 |

### ⚠️ 平台说明

小红书 **没有官方 Mac 桌面版应用**，推荐通过浏览器自动化 + MCP 服务实现 Mac 端操作。

| 平台 | 说明 |
|------|------|
| 📱 iOS App | App Store 下载 |
| 🤖 Android App | 应用商店 |
| 🌐 Web 版 | xiaohongshu.com（扫码登录）|

---

## 项目结构

```
xhs-workflow/
├── SKILL.md                    # 核心 Skill 定义
├── init.sh                     # 环境初始化脚本
├── README.md                   # 本文件
├── README_EN.md                # English version
└── references/
    ├── scene-configs.md        # 5 种场景详细配置
    ├── sub-skill-api.md        # 10 个子 Skill 接口约定
    └── quality-rules.md        # 内容质量检查规则
```

---

## 质量评估

基于 [skill-eval-optimizer](https://github.com/anthonyhann/skill-eval-optimizer) 8 维度评估框架：

| 维度 | 得分 |
|------|:----:|
| Frontmatter 质量 | 8/10 |
| 工作流清晰度 | 9/10 |
| 边界条件覆盖 | **10/10** |
| 检查点设计 | 9/10 |
| 指令具体性 | 8/10 |
| 资源整合度 | 9/10 |
| 整体架构 | 9/10 |
| 实测表现 | 8/10 |
| **总分** | **86.2/100** |

---

## 常见问题

**Q: 为什么没有 Mac 客户端方案？**
A: 小红书无官方 Mac 版，推荐使用浏览器自动化方案（xiaohongshu-mcp）。

**Q: 图片生成失败？**
A: 检查 Pillow 和 ImageMagick 安装，确认中文字体可用。

**Q: MCP 连接失败？**
A: 确认端口 18060 未被占用，重启 MCP 服务：`python3 server.py --port 18060`

**Q: 评论回复不智能？**
A: 配置 `OPENAI_API_KEY` 环境变量，并设置账号人设。

---

## 更新日志

| 日期 | 版本 | 变更 |
|------|------|------|
| 2026-04-29 | v1.0 | 初始版本 |

---

## 参考资源

- **ClawHub 技能市场：** https://clawhub-skills.com
- **OpenClaw 文档：** https://openclaw.ai/docs
- **小红书创作者中心：** https://creator.xiaohongshu.com

---

## License

MIT

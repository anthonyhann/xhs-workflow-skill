<div align="center">

# XHS Workflow Skill 📕

### 一句话指令，10 个子 skill 跑完小红书全链路。

5 个阶段 · 7 道门禁 —— 调研 → 创作 → 设计 → 发布 → 运营，发布前必须经过你确认。

[![license](https://img.shields.io/badge/license-MIT-E8590C?style=flat-square)](LICENSE)
[![子skill](https://img.shields.io/badge/子skill-10个-E8590C?style=flat-square)](references/sub-skill-api.md)
[![场景](https://img.shields.io/badge/场景-5种-2B8A3E?style=flat-square)](#-流水线)
[![阶段](https://img.shields.io/badge/阶段-5个-4C6EF5?style=flat-square)](#-流水线)
[![stars](https://img.shields.io/github/stars/anthonyhann/xhs-workflow-skill?style=flat-square)](https://github.com/anthonyhann/xhs-workflow-skill/stargazers)
[![兼容](https://img.shields.io/badge/兼容-Claude%20Code%20%7C%20OpenClaw-333?style=flat-square)](#-快速开始)

[快速开始](#-快速开始) · [流水线](#-流水线) · [真实数字](#-真实数字) · [完整文档](SKILL.md) · [场景配置](references/scene-configs.md) · **[English](README.md)**

</div>

## 😅 你是不是也这样？

- 让 AI「写一篇小红书笔记」——出来一段平庸文案。调研、配图、发布、回评论，还是你自己的活。
- 内容流水线散在五个工具里，每发一篇就是一轮复制粘贴接力赛。
- 自动化脚本一缺依赖就静默死翘翘——等你发现时，文案已经写了一半。

这个 skill 是**总控调度器**，不是又一个写作工具：它把你的选题路由进 **5 种场景模式**之一，按正确顺序调用正确的子 skill，在 **6 个检查点**卡质量，缺依赖时优雅降级而不是直接崩。

## 🔄 流水线

```
选题 topic + 场景 scene（可选）
        │
        ▼
┌─────────────────────────────────────────────┐
│  运行前门禁 G1–G7                            │
│  硬性: Python3 · Pillow · Node · 4个核心skill│
│  软性: 场景skill · ImageMagick · MCP服务     │
└─────────────────────────────────────────────┘
        │ 硬性失败 → 阻断 + 修复指引
        │ 软性失败 → 降级 + 报告中标注
        ▼
┌── Step 0: 场景路由 ─────────────────────────┐
│  hotspot · tutorial · review · batch ·      │
│  coldstart（关键词匹配 → 冲突裁决规则）       │
└─────────────────────────────────────────────┘
        │
        ▼        ▼        ▼        ▼        ▼
   Phase 1   Phase 2   Phase 3   Phase 4   Phase 5
    调研      创作      设计      发布      运营
        │
        ▼
  执行报告 + 全部产物
```

每种场景跑不同的流水线——比如 `tutorial` 跳过调研、直接出分步骤卡片图；`hotspot` 则全量调研 + CES 优化文案 + 信息图 + 自动回评：

| 场景 | 你可以说 | 调研 | 创作 | 设计 | 发布 | 运营 |
|------|---------|:----:|:----:|:----:|:----:|:----:|
| `hotspot` | 「写一篇…爆款笔记」 | 全量 | CES优化日记体 | 信息图 | ✅ | 自动回复 |
| `tutorial` | 「写一篇…教程」 | 跳过 | 教程体 | MD卡片 | ✅ | 仅复盘 |
| `review` | 「做个…测评合集」 | 竞品调研 | 测评体 | 密集图 | ✅ | 咨询回复 |
| `batch` | 「批量生产…」 | 快速 | 批量×N | 批量图 | 排队发 | 监控 |
| `coldstart` | 「新号起号」 | 5个对标账号 | 10篇种子内容 | 批量图 | 批量发 | 周复盘 |

输入有歧义（「从零做健身教程」同时命中 `coldstart` + `tutorial`）→ 按裁决规则处理，或反问你确认。不做静默瞎猜。

## 🚀 快速开始

**前置依赖：** Python 3、Node.js、Pillow、ImageMagick、Chrome/Edge —— `./init.sh --check` 会告诉你具体缺什么。

**1. 安装本 skill：**

```bash
git clone https://github.com/anthonyhann/xhs-workflow-skill ~/.claude/skills/xhs-workflow
```

**2. 检查环境与子 skill：**

```bash
~/.claude/skills/xhs-workflow/init.sh --check
```

**3. 说一句话：**

```
/xhs-workflow 帮我写一篇关于「AI编程工具对比」的小红书爆款笔记
```

加上「分阶段确认」可以每个阶段过目后再继续。

**给 AI agent 的安装口令**——直接贴给你的 agent：

> 帮我安装 https://github.com/anthonyhann/xhs-workflow-skill 到我的 skills 目录（命名为 `xhs-workflow`），运行它的 `init.sh --check` 并补齐缺失依赖，然后用 `/xhs-workflow` 跑我的选题。

兼容 **Claude Code**（`/xhs-workflow`，Agent tool 并行）与 **OpenClaw**（`openclaw skills run xhs-workflow`）。

## 📊 真实数字

以下每个数字都能在仓库里验证——没有虚荣指标。

| 数字 | 是什么 | 去哪验证 |
|-----:|--------|---------|
| **10** | 被编排的子 skill（调研/创作/设计/发布/互动/基建） | [references/sub-skill-api.md](references/sub-skill-api.md) |
| **5** | 场景模式，含路由与冲突裁决 | [SKILL.md](SKILL.md) Step 0 |
| **7** | 运行前门禁：4 项硬性阻断 + 3 项软性降级 | [SKILL.md](SKILL.md) 运行前门禁 |
| **6** | 质量检查点，每步一个 | [SKILL.md](SKILL.md) 检查点总览 |
| **10** | 内容规则：5 条 P0 阻断 + 5 条 P1 警告 | [references/quality-rules.md](references/quality-rules.md) |
| **2** | 检查点自动修正上限（超限即阻断） | quality-rules.md |
| **≤20 · 13 · 300–600 · 5–8** | 标题字数 · 前13字含关键词 · 正文字数 · 标签数 | quality-rules.md |
| **25/40** | CES 评分门禁（P1） | quality-rules.md R10 |
| **Top 20–50** | 深度调研批量上限 | sub-skill-api.md |
| **20** | 单篇笔记自动回评上限（默认） | sub-skill-api.md |
| **0** | 未经你确认就发布的笔记数——`publish=false` 是默认值 | [SKILL.md](SKILL.md) Step 4 |

## 📁 目录结构

```
xhs-workflow-skill/
├── SKILL.md                     # 调度器本体：门禁、路由、5 个 Phase、检查点
├── init.sh                      # 环境 + 10 个子 skill 检查（--check = 只诊断）
├── references/
│   ├── scene-configs.md         # 各场景调用链与参数配置
│   ├── sub-skill-api.md         # 10 个子 skill 的输入/输出契约
│   └── quality-rules.md         # R1–R10 内容规则 + 自动修正策略
├── README.md                    # English version
└── README_zh.md                 # 本文件
```

10 个子 skill（如 `xiaohongshu-deep-research`、`xhs-content-creator`、`baoyu-xhs-images`、`xiaohongshu-publisher`、`xiaohongshu-mcp`）需从 ClawHub 单独安装——`init.sh --check` 会列出你缺哪几个。

## ⚠️ 什么时候别用它

- **你做的平台不是小红书。** 抖音、公众号、Instagram——这条流水线只为小红书设计。
- **你只想看热点、不想创作。** 直接调调研类子 skill（`xiaohongshu-cn`、`xiaohongshu-deep-research`），别启动整条流水线。
- **你指望「保证爆款」。** CES 优化只是参考分，不是承诺——这里也没有任何绕过平台审核的东西。
- **你想完全托管式发布。** 小红书没有官方 Mac 客户端和发布 API；Phase 4 靠 `xiaohongshu-mcp` 浏览器自动化，服务挂了就降级为「产物 + 手动发布指南」。而且默认 `publish=false`，你不点头，什么都不发。

登录态留在你自己的浏览器 profile 里；除了你确认发布的内容，什么都不外传。

## License

MIT © [anthonyhann](https://github.com/anthonyhann)——一个受够了在五个工具间复制粘贴的独立开发者。如果这个 skill 帮你省下了周末的内容批量生产，点个 ⭐，新场景模式上线时你会知道。

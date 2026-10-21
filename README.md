<div align="center">

# XHS Workflow Skill 📕

### One prompt in, a published Xiaohongshu post out.

10 sub-skills · 5 phases · 7 pre-flight gates — research → write → design → publish → engage, with your confirmation before anything goes live.

[![license](https://img.shields.io/badge/license-MIT-E8590C?style=flat-square)](LICENSE)
[![sub-skills](https://img.shields.io/badge/sub--skills-10-E8590C?style=flat-square)](references/sub-skill-api.md)
[![scenes](https://img.shields.io/badge/scenes-5-2B8A3E?style=flat-square)](#-the-pipeline)
[![phases](https://img.shields.io/badge/phases-5-4C6EF5?style=flat-square)](#-the-pipeline)
[![stars](https://img.shields.io/github/stars/anthonyhann/xhs-workflow-skill?style=flat-square)](https://github.com/anthonyhann/xhs-workflow-skill/stargazers)
[![works with](https://img.shields.io/badge/works%20with-Claude%20Code%20%7C%20OpenClaw-333?style=flat-square)](#-quickstart)

[Quickstart](#-quickstart) · [Pipeline](#-the-pipeline) · [By the numbers](#-by-the-numbers) · [Docs](SKILL.md) · [Scenes](references/scene-configs.md) · **[中文](README_zh.md)**

</div>

## 😅 Sound familiar?

- You ask an AI to "write a Xiaohongshu post" — you get generic copy. The research, the images, the publishing, the comment replies: still on you.
- Your content pipeline lives in five disconnected tools, and every post is a copy-paste relay between them.
- Your auto-everything script dies silently the moment one dependency is missing — and you find out after the copy is already half-written.

This skill is an orchestrator, not another writer: it routes your topic into one of **5 scene modes**, runs the right sub-skills in the right order, checks quality at **6 checkpoints**, and degrades gracefully instead of crashing.

## 🔄 The pipeline

```
topic + scene (optional)
        │
        ▼
┌─────────────────────────────────────────────┐
│  Pre-flight Gate G1–G7                      │
│  hard: Python3 · Pillow · Node · 4 core     │
│  soft: scene skills · ImageMagick · MCP     │
└─────────────────────────────────────────────┘
        │ fail hard → block + fix guide
        │ fail soft → degrade + mark in report
        ▼
┌── Step 0: scene router ─────────────────────┐
│  hotspot · tutorial · review · batch ·      │
│  coldstart (keyword match → conflict rules) │
└─────────────────────────────────────────────┘
        │
        ▼        ▼        ▼        ▼        ▼
   Phase 1   Phase 2   Phase 3   Phase 4   Phase 5
   research  create    design    publish   engage
        │
        ▼
  execution report + artifacts
```

Each scene runs a different pipeline — e.g. `tutorial` skips research and renders step-by-step Markdown cards, while `hotspot` runs full research, CES-optimized copy, infographics, and auto-reply:

| Scene | Say something like | Research | Create | Design | Publish | Engage |
|-------|--------------------|:--------:|:------:|:------:|:-------:|:------:|
| `hotspot` | "写一篇…爆款笔记" | full | CES-optimized diary | infographics | ✅ | auto-reply |
| `tutorial` | "写一篇…教程" | skip | tutorial format | MD cards | ✅ | review only |
| `review` | "做个…测评合集" | competitor | review format | dense images | ✅ | Q&A reply |
| `batch` | "批量生产…" | quick | batch ×N | batch images | queued | monitor |
| `coldstart` | "新号起号" | 5 benchmark accounts | 10 seed posts | batch images | batch | weekly review |

Ambiguous input ("从零做健身教程" hits `coldstart` + `tutorial`) → resolved by priority rules, or it asks you. No silent guessing.

## 🚀 Quickstart

**Prerequisites:** Python 3, Node.js, Pillow, ImageMagick, Chrome/Edge — `./init.sh --check` tells you exactly what's missing.

**1. Install the skill:**

```bash
git clone https://github.com/anthonyhann/xhs-workflow-skill ~/.claude/skills/xhs-workflow
```

**2. Check environment & sub-skills:**

```bash
~/.claude/skills/xhs-workflow/init.sh --check
```

**3. Say the word:**

```
/xhs-workflow 帮我写一篇关于「AI编程工具对比」的小红书爆款笔记
```

Add "分阶段确认" to review each phase before it proceeds.

**For AI agents** — paste this to yours:

> Clone https://github.com/anthonyhann/xhs-workflow-skill into my skills directory as `xhs-workflow`, run its `init.sh --check`, install whatever is missing, then run `/xhs-workflow` on my topic.

Works with **Claude Code** (`/xhs-workflow`, parallel via Agent tool) and **OpenClaw** (`openclaw skills run xhs-workflow`).

## 📊 By the numbers

Every number below is verifiable in this repo — no vanity metrics.

| Number | What it is | Where to verify |
|-------:|------------|-----------------|
| **10** | sub-skills orchestrated (research / create / design / publish / engage / infra) | [references/sub-skill-api.md](references/sub-skill-api.md) |
| **5** | scene modes with routing + conflict arbitration | [SKILL.md](SKILL.md) Step 0 |
| **7** | pre-flight gates: 4 hard-blocking + 3 soft-degrading | [SKILL.md](SKILL.md) Pre-flight Gate |
| **6** | quality checkpoints, one per step | [SKILL.md](SKILL.md) 检查点总览 |
| **10** | content rules: 5 P0 blocking + 5 P1 warning | [references/quality-rules.md](references/quality-rules.md) |
| **2** | max auto-fix rounds before a checkpoint blocks | quality-rules.md |
| **≤20 · 13 · 300–600 · 5–8** | title chars · keyword in first 13 chars · body length · tag count | quality-rules.md |
| **25/40** | CES score gate (P1) | quality-rules.md R10 |
| **Top 20–50** | deep-research batch size | sub-skill-api.md |
| **20** | comments auto-replied per note (default max) | sub-skill-api.md |
| **0** | notes published without your confirmation — `publish=false` by default | [SKILL.md](SKILL.md) Step 4 |

## 📁 Project structure

```
xhs-workflow-skill/
├── SKILL.md                     # the orchestrator: gates, routing, 5 phases, checkpoints
├── init.sh                      # env + 10 sub-skill checker (--check = diagnose only)
├── references/
│   ├── scene-configs.md         # per-scene call chains & parameters
│   ├── sub-skill-api.md         # I/O contracts of all 10 sub-skills
│   └── quality-rules.md         # R1–R10 content rules + auto-fix policy
├── README.md                    # this file
└── README_zh.md                 # 中文版
```

The 10 sub-skills (e.g. `xiaohongshu-deep-research`, `xhs-content-creator`, `baoyu-xhs-images`, `xiaohongshu-publisher`, `xiaohongshu-mcp`) are separate installs from ClawHub — `init.sh --check` lists which ones you're missing.

## ⚠️ When NOT to use it

- **Your platform isn't Xiaohongshu.** Douyin, WeChat, Instagram — this pipeline is XHS-only, by design.
- **You only want to read trends, not create.** Invoke the research sub-skills (`xiaohongshu-cn`, `xiaohongshu-deep-research`) directly; don't spin up the whole pipeline.
- **You expect guaranteed virality.** CES optimization is a reference score, not a promise — and nothing here bypasses platform review.
- **You want fully hands-off publishing.** Xiaohongshu has no official Mac client or publish API; Phase 4 rides browser automation via `xiaohongshu-mcp` and degrades to a manual-publish guide when it's down. Nothing publishes without your confirmation by default.

Your login session stays in your own browser profile; nothing is sent anywhere except what you choose to publish.

## License

MIT © [anthonyhann](https://github.com/anthonyhann) — built by an indie hacker tired of the copy-paste relay between five tools. If this killed your Sunday content batch, a ⭐ tells you when new scene modes land.

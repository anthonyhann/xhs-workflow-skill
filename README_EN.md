# Xiaohongshu Full-Pipeline Intelligent Creation Orchestrator

[![Sub-Skills](https://img.shields.io/badge/Sub--Skills-10-E8590C?style=flat-square)](./references/sub-skill-api.md)
[![Scenes](https://img.shields.io/badge/Scenes-5_modes-2B8A3E?style=flat-square)](#scene-modes)
[![Phases](https://img.shields.io/badge/Phases-5_stages-4C6EF5?style=flat-square)](#architecture)
[![Quality](https://img.shields.io/badge/Quality-86.2%2F100-E8590C?style=flat-square)](#quality-evaluation)
[![Compatibility](https://img.shields.io/badge/Works_with-Claude_Code_%7C_OpenClaw-333?style=flat-square)](#compatibility)

**One command, fully automated from research to engagement** — orchestrates 10 professional sub-skills covering trend discovery, title planning, content creation, visual design, smart publishing, and engagement operations for AI-driven automated content production.

English | [中文](./README.md)

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Smart Scene Routing** | Auto-detects 5 creation scenarios; resolves multi-keyword conflicts via priority rules or user confirmation |
| **Full-Pipeline Orchestration** | Research → Creation → Design → Publish → Engagement, 5 phases with serial/parallel execution |
| **Graceful Degradation** | Hard gates block + soft gates degrade; missing deps won't crash the workflow |
| **CES Algorithm Optimization** | Content auto-optimized per Xiaohongshu's CES scoring system for better engagement |
| **Checkpoint Mechanism** | Quality validation at each phase; auto-correction up to 2 rounds |
| **Dual-Platform Support** | Works with both Claude Code and OpenClaw Agent Framework |

---

## Architecture

```
User Input: topic + scene (optional)
         │
         ▼
┌─────────────────────────────────────────────────┐
│            Pre-flight Gate (G1-G7)              │
│  Hard: Python3 / Pillow / Node / Core Skills    │
│  Soft: Scene Skills / ImageMagick / MCP Service │
└─────────────────────────────────────────────────┘
         │
         ▼
┌─── Step 0: Scene Router ───┐
│  hotspot │ tutorial │      │
│  review  │ batch    │      │
│  coldstart           │      │
└────────────────────────────┘
         │
    ┌────┼────┬────┬────┐
    ▼    ▼    ▼    ▼    ▼
 Phase1 Phase2 Phase3 Phase4 Phase5
Research Create Design Publish Engage
  │      │      │      │      │
  └──────┴──────┴──────┴──────┘
                │
                ▼
      Execution Report + Artifacts
```

---

## Scene Modes

| Scene | Trigger Keywords | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|-------|-----------------|:-------:|:-------:|:-------:|:-------:|:-------:|
| **hotspot** | trending/viral/traffic | Full research | CES-optimized | Infographics | Publish | Auto-reply |
| **tutorial** | tutorial/how-to/guide | Skip | Tutorial format | MD cards | Publish | Review only |
| **review** | review/compare/roundup | Competitor research | Review format | Dense infographics | Publish | Q&A reply |
| **batch** | batch/bulk/weekly | Quick research | Batch generate | Batch images | Queue publish | Monitor |
| **coldstart** | cold-start/new-account | Benchmark analysis | Seed content | Batch images | Batch publish | Weekly review |

---

## Quick Start

### 1. Environment Check

```bash
./init.sh --check
```

### 2. Run

**Claude Code:**
```
/xhs-workflow
Write a viral Xiaohongshu post about "AI programming tools comparison"
```

**OpenClaw:**
```bash
openclaw skills run xhs-workflow --input '{"topic": "AI programming tools", "scene": "hotspot"}'
```

### 3. Step-by-Step Confirmation Mode

```
Write a skincare review post, step-by-step confirmation mode
```

---

## Sub-Skill Matrix (10 Skills)

### 🔍 Research

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `xiaohongshu-cn` | Trending note discovery, keyword monitoring, trend analysis | Per scene | [Download](https://clawhub-skills.com/skills/xiaohongshu-cn) |
| `xiaohongshu-deep-research` | Deep research, batch search Top 20-50, report generation | Per scene | [Download](https://clawhub-skills.com/skills/xiaohongshu-deep-research) |

### ✍️ Creation

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `xhs-content-creator` | CES algorithm optimization, diary/tutorial/review format generation | ✅ | [Download](https://clawhub-skills.com/skills/xhs-content-creator) |
| `xhs` | All-in-one assistant (copywriting polish + tags + cover guide) | ✅ | [Download](https://clawhub-skills.com/skills/xhs) |

### 🎨 Design

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `baoyu-xhs-images` | Infographic generation (10 styles, 8 layouts, 1-10 image series) | Per scene | [Download](https://clawhub-skills.com/skills/baoyu-xhs-images) |
| `xhs-md2pic` | Markdown to Xiaohongshu card images (5 theme templates) | Per scene | [Download](https://clawhub-skills.com/skills/xhs-md2pic) |

### 📤 Publishing

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `xiaohongshu-publisher` | Cover image generation + browser auto-publish | ✅ | [Download](https://clawhub-skills.com/skills/xiaohongshu-publisher) |

### 💬 Engagement

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `xhs-auto-reply` | AI intelligent comment reply (single/batch mode) | Per scene | [Download](https://clawhub-skills.com/skills/xhs-auto-reply) |

### 📋 Operations

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `xiaohongshu-ops` | Operations SOP, account positioning, review optimization | Per scene | [Download](https://clawhub-skills.com/skills/xiaohongshu-ops) |

### 🔧 Infrastructure

| Sub-Skill | Purpose | Required | ClawHub |
|-----------|---------|:--------:|---------|
| `xiaohongshu-mcp` | MCP browser automation service (port 18060) | ✅ | [Download](https://clawhub-skills.com/skills/xiaohongshu-mcp) |

---

## Creation Pipeline

```
              ┌─────────────┐
              │  User Input  │
              │  Topic/Keywords │
              └──────┬──────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│              Phase 1: Research & Analysis          │
│  xiaohongshu-cn ──▶ xiaohongshu-deep-research    │
│  Trend discovery      Deep research/report        │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 2: Content Creation             │
│  xiaohongshu-title ──▶ xhs-content-creator       │
│  Viral titles (5 candidates)  CES-optimized copy  │
│          │                                        │
│          ▼                                        │
│  xhs All-in-one (polish + tags + cover advice)    │
│  xiaohongshu-ops Operations SOP guidance          │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 3: Visual Design               │
│  baoyu-xhs-images          xhs-md2pic            │
│  Infographic series         Markdown to card      │
│  (10 styles, 8 layouts)     images (5 themes)     │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 4: Smart Publishing            │
│  xiaohongshu-publisher ──▶ xiaohongshu-mcp       │
│  Cover gen + content assembly  Browser automation │
│                                                   │
│  ⚠️ Via browser automation (no official Mac app)  │
└────────────────────────┬─────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────┐
│              Phase 5: Engagement Operations        │
│  xhs-auto-reply ◀── xiaohongshu-mcp             │
│  AI comment reply         Fetch comment data      │
│  (single/batch)                                   │
│  xiaohongshu-ops Data review & optimization       │
└──────────────────────────────────────────────────┘
```

---

## Typical Creation Scenarios

### Scenario A: Trending Viral Post

```
Step 1: xiaohongshu-cn → Discover current trends & competitor posts
Step 2: xiaohongshu-deep-research → Batch research Top 20, generate report
Step 4: xhs-content-creator → CES algorithm optimized, high-engagement copy
Step 5: baoyu-xhs-images → Generate 3-6 infographics (pop/fresh style)
Step 6: xiaohongshu-publisher → Cover image + browser auto-publish
Step 7: xhs-auto-reply → Auto-reply to first 20 comments after publishing
```

### Scenario B: Knowledge Tutorial

```
Step 1: xhs-content-creator → Generate tutorial-format content
Step 2: xhs-md2pic → Markdown to card images, step-by-step display
Step 3: xiaohongshu-publisher → Publish multi-image tutorial
Step 4: xiaohongshu-ops → Track content performance, iterate & optimize
```

### Scenario C: Review & Roundup

```
Step 1: xiaohongshu-deep-research → Research viral elements in similar reviews
Step 3: xhs-content-creator → Generate review-format content template
Step 4: baoyu-xhs-images → Dense layout, 9-10 image series
Step 5: xiaohongshu-publisher → Publish roundup post
Step 6: xhs-auto-reply → Reply to product inquiries in comments
```

### Scenario D: Batch Content Factory

```
For each keyword:
  Step 1: xiaohongshu-deep-research → Quick research
  Step 3: xhs-content-creator → Generate content
  Step 4: baoyu-xhs-images → Generate images
  Step 5: xiaohongshu-publisher → Queue publish
  Step 6: xhs-auto-reply → Monitor comments

Use xiaohongshu-ops to create weekly content plan
```

### Scenario E: Account Cold Start

```
Step 1: xiaohongshu-ops → Define account positioning strategy
Step 2: xiaohongshu-cn → Monitor benchmark accounts' trending topics
Step 3: xiaohongshu-deep-research → Analyze Top content from 5 benchmark accounts
Step 5: xhs-content-creator → Emulate viral structures, generate 10 seed posts
Step 6: xiaohongshu-publisher → Batch publish seed posts
Step 7: xiaohongshu-ops → Weekly review, iterate content direction
```

---

## Dependencies

| Dependency | Purpose | Install |
|------------|---------|---------|
| Python 3 | Script runtime | `brew install python3` |
| Pillow | Image generation | `pip3 install Pillow` |
| Node.js | MCP service | `brew install node` |
| ImageMagick | Image conversion | `brew install imagemagick` |
| Chrome/Edge | Browser automation | System install |

### Environment Variables

```bash
# xhs-md2pic (optional, for AI background generation)
export DASHSCOPE_API_KEY="your-api-key"

# xhs-auto-reply (comment replies)
export OPENAI_API_KEY="your-api-key"
```

One-command setup:

```bash
./init.sh
```

---

## Installation Guide

### Install All Sub-Skills

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

### Selective Installation

**Creation pipeline only:**
```bash
openclaw skills install xiaohongshu-deep-research
openclaw skills install xhs-content-creator
openclaw skills install baoyu-xhs-images
openclaw skills install xiaohongshu-publisher
```

**Engagement & operations only:**
```bash
openclaw skills install xiaohongshu-mcp
openclaw skills install xhs-auto-reply
openclaw skills install xiaohongshu-ops
```

---

## Degradation Strategy

| Missing | Impact | Handling |
|---------|--------|----------|
| Optional sub-skill | Corresponding phase skipped | Marked in report, no interruption |
| ImageMagick | Phase 3 image limited | Warning, prompt manual prep |
| MCP service | Cannot auto-publish | Degrade to artifacts + manual publish guide |
| Env variables | Some features limited | Warning and continue |

---

## Best Practices

### Content Publishing Rhythm

| Time | Action | Skills |
|------|--------|--------|
| Monday | Trend research, topic planning | xiaohongshu-cn + deep-research |
| Tue-Thu | Batch creation | xhs-content-creator + baoyu-xhs-images |
| Friday | Publish posts | xiaohongshu-publisher |
| Weekend | Comment engagement + review | xhs-auto-reply + xiaohongshu-ops |

### Content Quality Checklist

- [ ] Title passes validator.py checks (< 22 chars, no banned words, includes emoji)
- [ ] Body 300-600 words, short sentences preferred
- [ ] Cover 3:4 portrait, strong visual impact
- [ ] 5-8 tags (trending + long-tail)
- [ ] Include `#AI生成内容` tag
- [ ] Reply to all comments within first 2 hours

### Risk Mitigation

| Risk | Countermeasure |
|------|---------------|
| Content homogenization | Use deep-research for differentiation angles |
| Rate limiting risk | Mark each post as AI-generated, originality > 70% |
| Publish failure | Check MCP service status, retry login |
| Inappropriate replies | Configure xhs-auto-reply persona limits |

---

## Compatibility

| Platform | Trigger | Parallel Mechanism |
|----------|---------|-------------------|
| **Claude Code** | `/xhs-workflow` command | Agent tool parallel calls |
| **OpenClaw** | `openclaw skills run` | parallel task mechanism |

### ⚠️ Platform Note

Xiaohongshu has **no official Mac desktop app**. Browser automation + MCP service is the recommended approach for Mac.

| Platform | Notes |
|----------|-------|
| 📱 iOS App | App Store download |
| 🤖 Android App | App store |
| 🌐 Web | xiaohongshu.com (QR code login) |

---

## Project Structure

```
xhs-workflow/
├── SKILL.md                    # Core skill definition
├── init.sh                     # Environment init script
├── README.md                   # Chinese documentation
├── README_EN.md                # This file
└── references/
    ├── scene-configs.md        # 5 scene detailed configs
    ├── sub-skill-api.md        # 10 sub-skill API contracts
    └── quality-rules.md        # Content quality rules
```

---

## Quality Evaluation

Based on [skill-eval-optimizer](https://github.com/anthonyhann/skill-eval-optimizer) 8-dimension assessment framework:

| Dimension | Score |
|-----------|:-----:|
| Frontmatter Quality | 8/10 |
| Workflow Clarity | 9/10 |
| Edge Case Coverage | **10/10** |
| Checkpoint Design | 9/10 |
| Instruction Specificity | 8/10 |
| Resource Integration | 9/10 |
| Overall Architecture | 9/10 |
| Real-World Performance | 8/10 |
| **Total** | **86.2/100** |

---

## FAQ

**Q: Why no Mac client solution?**
A: Xiaohongshu has no official Mac version. We recommend the browser automation approach (xiaohongshu-mcp).

**Q: Image generation fails?**
A: Check Pillow and ImageMagick installation, ensure Chinese fonts are available.

**Q: MCP connection fails?**
A: Confirm port 18060 is not occupied, restart MCP service: `python3 server.py --port 18060`

**Q: Comment replies aren't smart enough?**
A: Configure `OPENAI_API_KEY` environment variable and set account persona.

---

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| 2026-04-29 | v1.0 | Initial release |

---

## References

- **ClawHub Skill Marketplace:** https://clawhub-skills.com
- **OpenClaw Documentation:** https://openclaw.ai/docs
- **Xiaohongshu Creator Center:** https://creator.xiaohongshu.com

---

## License

MIT

# 子 Skill 接口约定

> 调用子 skill 前读取本文件，了解各 skill 的输入/输出接口。

## 接口总览

| Skill | 触发方式 | 必填输入 | 主要输出 |
|-------|---------|---------|---------|
| xiaohongshu-cn | 意图/命令 | 关键词 | 热点列表 JSON |
| xiaohongshu-deep-research | 意图/命令 | 关键词 + 调研深度 | 结构化报告 MD |
| xhs-content-creator | 意图/命令 | 主题 + 模板类型 | 文案 MD + CES 分 |
| xhs | 意图/命令 | 文案草稿 | 润色后文案 MD |
| xiaohongshu-ops | 意图/命令 | 账号/内容上下文 | SOP/复盘 MD |
| baoyu-xhs-images | 意图/命令 | 内容 + 风格 + 数量 | 图片文件 |
| xhs-md2pic | 意图/命令 | Markdown 文本 | 卡片图片文件 |
| xiaohongshu-publisher | 意图/命令 | 标题+正文+图片 | 发布状态+链接 |
| xhs-auto-reply | 意图/命令 | 笔记链接 + 人设 | 回复日志 MD |
| xiaohongshu-mcp | 服务启动 | 端口配置 | HTTP API |

---

## 详细接口

### xiaohongshu-cn

```
输入：
  - keyword: string (搜索关键词)
  - limit: number (结果数，默认 10)

输出：
  - hotspots: [{title, likes, comments, url, publish_date}]
  - trends: [{keyword, growth_rate, volume}]
```

### xiaohongshu-deep-research

```
输入：
  - keyword: string
  - depth: "shallow" | "deep" (shallow=Top5, deep=Top20-50)
  - focus: "hotspot" | "competitor" | "benchmark"

输出：
  - report: Markdown 结构化报告
  - top_notes: [{title, engagement, structure_analysis}]
  - insights: [string]
```

### xhs-content-creator

```
输入：
  - topic: string
  - template: "diary" | "tutorial" | "review" | "collection"
  - ces_optimize: boolean
  - research_context: string (可选，来自调研报告)

输出：
  - content: Markdown (标题 + 正文 + 标签)
  - ces_score: number (0-40)
  - metadata: {word_count, tag_count, template_used}
```

### xhs

```
输入：
  - draft: string (文案草稿)
  - action: "polish" | "title" | "tags" | "full"

输出：
  - polished: Markdown (润色后文案)
  - suggestions: [{type, original, improved, reason}]
```

### xiaohongshu-ops

```
输入：
  - action: "positioning" | "planning" | "review" | "sop"
  - context: string (账号/内容描述)

输出：
  - strategy: Markdown (策略文档)
  - checklist: [string] (执行清单)
```

### baoyu-xhs-images

```
输入：
  - content: string (内容文本)
  - style: "bold"|"chalkboard"|"cute"|"fresh"|"minimal"|"notion"|"pop"|"retro"|"study-notes"|"warm"
  - layout: "visual-first" | "info-dense" | "story-driven"
  - count: number (1-10)

输出：
  - images: [file_path] (PNG 文件路径列表)
  - cover: file_path (封面图路径)
```

### xhs-md2pic

```
输入：
  - markdown: string (Markdown 内容)
  - theme: string (5 种主题之一)
  - ratio: "3:4" (固定)

输出：
  - cards: [file_path] (卡片图路径列表)
```

### xiaohongshu-publisher

```
输入：
  - title: string
  - content: string
  - images: [file_path]
  - cover: file_path
  - tags: [string]

输出：
  - status: "success" | "failed"
  - note_url: string (成功时)
  - error: string (失败时)

前置条件：xiaohongshu-mcp 服务运行中
```

### xhs-auto-reply

```
输入：
  - note_url: string
  - mode: "single" | "batch"
  - persona: string (回复人设)
  - max_replies: number (默认 20)

输出：
  - replies: [{comment_id, comment_text, reply_text, status}]
  - log: Markdown 互动日志

前置条件：OPENAI_API_KEY + xiaohongshu-mcp
```

### xiaohongshu-mcp

```
启动：python3 server.py --port 18060
健康检查：curl http://localhost:18060/health
配置：profile=openclaw

提供能力：
  - 浏览器页面控制
  - 登录态管理
  - 内容提交自动化
  - 评论数据获取
```

---

## 调用约定

### Claude Code 环境

子 skill 通过 Skill tool 调用：
```
Skill({ skill: "xiaohongshu-cn", args: "搜索关键词: 平价护肤" })
```

并行调用通过多个 Agent tool 同时发起：
```
Agent({ description: "热点发现", prompt: "..." })
Agent({ description: "深度调研", prompt: "..." })
```

### OpenClaw 环境

子 skill 通过 CLI 调用：
```bash
openclaw skills invoke xiaohongshu-cn --input '{"keyword": "平价护肤"}'
```

并行调用通过 parallel task：
```bash
openclaw tasks parallel \
  "openclaw skills invoke xiaohongshu-cn ..." \
  "openclaw skills invoke xiaohongshu-deep-research ..."
```

# 场景配置详解

## hotspot（热点爆款）

### 子 skill 调用链

```
xiaohongshu-cn (并行) ─┐
                       ├─→ xhs-content-creator (CES+日记体) → xhs (润色)
xiaohongshu-deep-research ─┘                                      │
                                                                   ▼
                                              baoyu-xhs-images (视觉优先型)
                                                                   │
                                                                   ▼
                                              xiaohongshu-publisher → xhs-auto-reply
```

### 参数配置

| 参数 | 值 |
|------|---|
| content_template | 日记体 |
| ces_optimize | true |
| image_style | fresh/pop（推荐） |
| image_layout | 视觉优先型 |
| image_count | 3-6 |
| auto_reply_count | 20 |

---

## tutorial（知识教程）

### 子 skill 调用链

```
xhs-content-creator (教程体) → xhs (润色) → xhs-md2pic (卡片图) → xiaohongshu-publisher
```

### 参数配置

| 参数 | 值 |
|------|---|
| content_template | 教程体 |
| ces_optimize | false |
| image_tool | xhs-md2pic |
| image_theme | 根据内容自动选择 |
| image_count | 按步骤数自动 |
| skip_research | true |
| skip_auto_reply | true |

---

## review（测评合集）

### 子 skill 调用链

```
xiaohongshu-deep-research (竞品) → xhs-content-creator (测评体) → xhs (润色)
                                                                       │
                                                                       ▼
                                              baoyu-xhs-images (信息密集型)
                                                                       │
                                                                       ▼
                                              xiaohongshu-publisher → xhs-auto-reply
```

### 参数配置

| 参数 | 值 |
|------|---|
| content_template | 测评体 |
| ces_optimize | true |
| research_mode | 竞品分析 |
| image_style | minimal/notion（推荐） |
| image_layout | 信息密集型 |
| image_count | 9-10 |
| auto_reply_focus | 产品咨询 |

---

## batch（批量工厂）

### 子 skill 调用链（对每个关键词循环）

```
For each keyword:
  xiaohongshu-deep-research (快速) → xhs-content-creator → baoyu-xhs-images
                                                                  │
                                                                  ▼
                                           xiaohongshu-publisher (排队)
```

### 参数配置

| 参数 | 值 |
|------|---|
| content_template | 自动选择 |
| ces_optimize | true |
| research_depth | shallow（Top 5） |
| image_count | 3（节省时间） |
| publish_interval | 间隔 2+ 小时 |
| batch_size | 用户指定或默认 5 |

### 特殊逻辑

- 使用 `xiaohongshu-ops` 制定周更计划
- 排队发布避免限流风险
- 每篇独立执行，单篇失败不影响其他

---

## coldstart（账号冷启动）

### 子 skill 调用链

```
xiaohongshu-ops (账号定位) → xiaohongshu-cn (对标监控)
                                      │
                                      ▼
              xiaohongshu-deep-research (对标分析 Top 5 账号)
                                      │
                                      ▼
              xhs-content-creator (种子内容 × 10) → baoyu-xhs-images
                                                          │
                                                          ▼
              xhs + xiaohongshu-publisher (批量发布) → xiaohongshu-ops (周复盘)
```

### 参数配置

| 参数 | 值 |
|------|---|
| content_template | 模仿爆款 |
| seed_count | 10 |
| research_target | 对标账号 |
| research_count | 5 账号 |
| review_cycle | 每周 |
| image_count | 3-6 |

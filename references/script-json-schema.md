# 脚本 JSON Schema（机器可读 · 供 jianying 融合消费）

编导 skill 的「可拍摄脚本」除了 Markdown 分镜表，也可产出一份**结构等价的
机器可读 JSON**（脚本 JSON），让 `jianying-autoedit-agent` 直接把它转换成
`edit-blueprint.json` 建剪映草稿。这是「编导拆解 → 剪辑成片」一条龙的对接层。

## 为什么需要它

- Markdown 分镜表是**给人看、照表拍摄**的；
- 脚本 JSON 是**给机器**消费的，字段与分镜表一一对应；
- 一份脚本 = 一套 JSON，交给剪辑 skill 就能自动建草稿。

## 字段定义

```json
{
  "schema_version": "director-script-1.0",
  "title": "脚本标题",
  "platform": "douyin",
  "aspect_ratio": "9:16",
  "width": 1080,
  "height": 1920,
  "target_duration_seconds": 60,
  "goal": {
    "objective": "引流进直播间",
    "core_message": "真正酒制黄金是反复蒸晒的，别买硫磺假货",
    "target_audience": "关注养生的中老年人、爱囤家乡好货的人群",
    "hook_type": "悬念·反差",
    "hook_text": "凭啥只做蒸黄金？",
    "hook_why": "抛反常识问题，制造认知缺口，让养生人群停下来找答案"
  },
  "shots": [
    {
      "id": "shot-1",
      "timeline_in_seconds": 0.0,
      "timeline_out_seconds": 3.0,
      "shot_scale": "近景",
      "visual": "主播在展馆，手指向身后展台",
      "narration": "小月今天在全食展现场",
      "caption": "小月全食展站台",
      "camera": "固定·居中·自然光",
      "purpose": "钩子·现场感"
    }
  ],
  "cta": {
    "text": "点击头像进直播间抢福利",
    "action": "引导进直播间"
  },
  "notes": []
}
```

## 字段与 Markdown 分镜表对照

| Markdown 分镜表列 | JSON 字段 |
|---|---|
| 镜号 | `shots[].id` |
| 时间 | `shots[].timeline_in_seconds` / `timeline_out_seconds` |
| 景别 | `shots[].shot_scale` |
| 画面内容（拍什么） | `shots[].visual` |
| 口播文案（说什么） | `shots[].narration` |
| 字幕/花字 | `shots[].caption` |
| 镜头语言 | `shots[].camera` |
| （补充：编导作用） | `shots[].purpose` |

## 生成铁律（编导 skill 侧）

1. **钩子仍在第一位**：即使输出 JSON，`goal.hook_type/hook_text/hook_why`
   必须先行确定，且先经用户确认再写 `shots`。
2. **结构照搬、内容全换**：JSON 的 `shots` 排布沿用对标结构链，
   但 `narration/caption/visual` 全部换成新主题。
3. **分镜必须能拍**：每个 shot 的 `visual/narration/caption` 齐备，
   才能被下游转成蓝图。
4. **与 Markdown 一致**：JSON 与 Markdown 分镜表是同一脚本的两种形态，
   字段必须互相自洽，严禁字段不一致。
5. **机器可读**：JSON 必须以 UTF-8 输出，`timeline_*` 用秒（float）。

## 下游消费

`jianying-autoedit-agent/scripts/director_to_blueprint.py` 负责把本脚本 JSON
转成 `edit-blueprint.json`。转换时需要**素材映射**（哪段镜头用哪个源素材的哪段），
见该转换器的说明。缺素材时在 `notes` 标注"待补拍/待配素材"。

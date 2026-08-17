# GeJiangXue · 短视频编导拆解 Skill

> 拆解对标爆款 → 提炼钩子/分镜/结构 → 生成「结构相同、内容不同」的可拍摄脚本。

这是一个面向 **DeepSeek Harness（DSH）** 的短视频编导 skill，核心解决一件事：

**把一条火的视频还原成可复制的工程图纸，然后照着图纸造一条新的。**

---

## 它能做什么

| 能力 | 说明 |
|---|---|
| 🔍 编导拆解 | 拆出前三秒钩子（视觉/话术/文字三钩子）、分镜、脚本结构、目标人群、转化手法（含营销心理学）、可复用公式 |
| ✍️ 脚本生成 | 照着拆解出的结构，写「结构相同、内容不同」的可拍摄脚本（分镜表 + 口播文案 + 字幕/花字） |
| ⭐ 钩子优先 | 前三秒钩子是一切的命门——先出 2~3 个钩子候选给你确认，通过后才写正文 |

---

## 安装

### 方式一：克隆到 DSH 用户技能目录（推荐）

```bash
git clone https://github.com/gejiangxue/GeJiangXue.git ~/.agents/skills/video-director-breakdown
```

> 说明：DSH 扫描 `~/.agents/skills/<名字>/SKILL.md`。仓库根目录就是 skill 内容，所以 clone 时把目标目录名定为 `video-director-breakdown`（即 SKILL.md 里声明的 `name`）。

### 方式二：手动复制

1. 下载本仓库
2. 把仓库里的 `SKILL.md` 和 `references/` 目录复制到 `~/.agents/skills/video-director-breakdown/`

### 安装后

重启 DSH 或新开会话，说「编导拆解」「拆解这个视频」「照着这个写一条」即可触发。

---

## 使用

```text
用户：拆解这个视频 https://v.douyin.com/xxx/
用户：照着它的结构，给我写一条卖蜂蜜的可拍摄脚本
```

它会自动：
1. 用 SocialDataX MCP 拉取视频详情 + 口播逐字稿 + 关键画面
2. 输出编导拆解报告（钩子/分镜/结构/人群/手法/公式）
3. 先给钩子候选 → 你确认 → 写完整分镜脚本

> 前置依赖：需要配置 SocialDataX MCP（各平台视频详情/口播转文字），以及可选的视觉桥（读画面）。没有 MCP 时也可以直接贴口播文字稿使用。

---

## 目录结构

```
GeJiangXue/
├── SKILL.md                        # skill 主文件
├── references/
│   ├── hook-library.md             # 钩子公式库（20+ 公式，4 大类）
│   └── script-structures.md        # 脚本结构模板（7 种）
├── README.md
└── LICENSE
```

---

## 维护者同步（本地两份拷贝的管理）

skill 在本机有两处，`sync-skill.sh` 负责同步：

| 位置 | 作用 |
|---|---|
| 仓库目录（本仓库 clone 下来的地方） | 提交、推送 GitHub |
| `~/.agents/skills/video-director-breakdown/` | DSH 实际加载生效 |

```bash
./sync-skill.sh status   # 查看两边差异
./sync-skill.sh push     # 本地 DSH 改动 → 提交 → 推送 GitHub
./sync-skill.sh pull     # 拉取 GitHub → 同步到 DSH 目录
```

---

## 更新日志

- **v3.1**：钩子确认为第一优先级（钩子自检清单、先确认再写正文）
- **v3.0**：重构为「拆解 + 可拍摄脚本生成」双流程，新增分镜拆解
- **v2.0**：融合三钩子框架、钩子公式库、脚本结构库、营销心理学
- **v1.0**：初始版本，编导拆解框架

## License

MIT

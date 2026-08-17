#!/usr/bin/env bash
# ============================================================
# sync-skill.sh — 同步 GeJiangXue 编导 skill 到 GitHub 仓库 与 DSH 本地目录
#
# 说明：
#   skill 有"两个位置"，本脚本负责在它们之间同步：
#     1) 仓库目录   = 本脚本所在目录（~/Documents/GeJiangXue）
#     2) DSH 目录   = ~/.agents/skills/video-director-breakdown（DSH 实际加载）
#
# 用法：
#   ./sync-skill.sh status   # 查看两边差异（默认）
#   ./sync-skill.sh push     # DSH 改动 → 提交到仓库 → 推送到 GitHub
#   ./sync-skill.sh pull     # GitHub 拉取 → 同步到 DSH 目录
# ============================================================
set -euo pipefail

SKILL_NAME="video-director-breakdown"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DSH_DIR="${DSH_SKILL_DIR:-$HOME/.agents/skills/$SKILL_NAME}"
FILES=(SKILL.md references/hook-library.md references/script-structures.md)

mode="${1:-status}"

case "$mode" in
  status)
    echo "📂 仓库目录: $REPO_DIR"
    echo "📂 DSH 目录:  $DSH_DIR"
    echo
    for f in "${FILES[@]}"; do
      r="$REPO_DIR/$f"; d="$DSH_DIR/$f"
      if [ ! -f "$r" ] && [ ! -f "$d" ]; then
        echo "  ❌ $f  两边都缺失"
      elif [ ! -f "$d" ]; then
        echo "  ➕ $f  仅仓库有（DSH 缺失，可 push）"
      elif [ ! -f "$r" ]; then
        echo "  ➕ $f  仅 DSH 有（仓库缺失，可 pull）"
      elif diff -q "$r" "$d" >/dev/null 2>&1; then
        echo "  ✅ $f  一致"
      else
        echo "  ⚠️  $f  不一致"
      fi
    done
    echo
    echo "  用 ./sync-skill.sh push 或 ./sync-skill.sh pull 同步"
    ;;

  push)
    echo "==> 把 DSH 目录的改动同步到仓库并推送"
    for f in "${FILES[@]}"; do
      src="$DSH_DIR/$f"; dst="$REPO_DIR/$f"
      if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        echo "  已复制: $f"
      fi
    done
    cd "$REPO_DIR"
    git add -A
    if git diff --cached --quiet; then
      echo "  无改动，跳过提交"
    else
      msg="update: 同步 DSH 本地 skill 改动 ($(date '+%Y-%m-%d %H:%M'))"
      git commit -m "$msg"
      echo "  已提交: $msg"
    fi
    git push
    echo "✅ 已推送到 GitHub"
    ;;

  pull)
    echo "==> 拉取 GitHub 最新并同步到 DSH 目录"
    cd "$REPO_DIR"
    git pull --ff-only
    mkdir -p "$DSH_DIR/references"
    for f in "${FILES[@]}"; do
      src="$REPO_DIR/$f"; dst="$DSH_DIR/$f"
      if [ -f "$src" ]; then
        cp "$src" "$dst"
        echo "  已复制: $f"
      fi
    done
    echo "✅ 已同步到 DSH 目录: $DSH_DIR"
    ;;

  *)
    echo "用法: $0 [status|push|pull]" >&2
    exit 1
    ;;
esac

#!/usr/bin/env bash
# ============================================================
# sync-skill.sh — 同步 video-director-breakdown 编导 skill
#
# 原则：仓库目录（本脚本所在目录）是唯一源头（source of truth）。
#   - 改 skill 一律在仓库目录改（或改完同步到这里）
#   - push  = 仓库 → GitHub（提交并推送）
#   - pull  = GitHub → 仓库 → 同步到 DSH 目录（拉取最新并本地生效）
#   - apply  = 仓库 → DSH 目录（只同步到 DSH，不碰 GitHub）
#
# 用法：
#   ./sync-skill.sh status   # 查看仓库/DSH 两边状态
#   ./sync-skill.sh push     # 提交仓库改动并推送到 GitHub
#   ./sync-skill.sh pull     # 拉取 GitHub 最新 + 同步到 DSH 目录
#   ./sync-skill.sh apply    # 把仓库内容复制到 DSH 目录
# ============================================================
set -euo pipefail

SKILL_NAME="video-director-breakdown"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DSH_DIR="${DSH_SKILL_DIR:-$HOME/.agents/skills/$SKILL_NAME}"
FILES=(SKILL.md references/hook-library.md references/script-structures.md references/shot-language.md)

mode="${1:-status}"

# 把仓库文件复制到 DSH 目录
copy_repo_to_dsh() {
  mkdir -p "$DSH_DIR/references"
  for f in "${FILES[@]}"; do
    src="$REPO_DIR/$f"; dst="$DSH_DIR/$f"
    if [ -f "$src" ]; then
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
      echo "  已同步: $f"
    fi
  done
}

case "$mode" in
  status)
    echo "📂 仓库目录(源头): $REPO_DIR"
    echo "📂 DSH 目录:        $DSH_DIR"
    echo
    for f in "${FILES[@]}"; do
      r="$REPO_DIR/$f"; d="$DSH_DIR/$f"
      if [ ! -f "$r" ] && [ ! -f "$d" ]; then
        echo "  ❌ $f  两边都缺失"
      elif [ ! -f "$r" ]; then
        echo "  ⚠️  $f  仅 DSH 有（仓库缺失）"
      elif [ ! -f "$d" ]; then
        echo "  ➕ $f  仅仓库有（DSH 缺失，可 apply）"
      elif diff -q "$r" "$d" >/dev/null 2>&1; then
        echo "  ✅ $f  一致"
      else
        echo "  ⚠️  $f  不一致（以仓库为准，用 apply 同步）"
      fi
    done
    echo
    echo "  改 skill 请在仓库目录改；push 推 GitHub，apply 同步到 DSH"
    ;;

  push)
    echo "==> 提交仓库改动并推送到 GitHub"
    cd "$REPO_DIR"
    git add -A
    if git diff --cached --quiet; then
      echo "  无改动，跳过提交"
    else
      msg="update: skill 更新 ($(date '+%Y-%m-%d %H:%M'))"
      git commit -m "$msg"
      echo "  已提交: $msg"
    fi
    git push
    echo "✅ 已推送到 GitHub"
    ;;

  pull)
    echo "==> 拉取 GitHub 最新"
    cd "$REPO_DIR"
    git pull --ff-only
    echo "==> 同步到 DSH 目录"
    copy_repo_to_dsh
    echo "✅ 已同步到 DSH 目录: $DSH_DIR"
    ;;

  apply)
    echo "==> 把仓库内容同步到 DSH 目录"
    copy_repo_to_dsh
    echo "✅ 已同步到 DSH 目录: $DSH_DIR"
    ;;

  *)
    echo "用法: $0 [status|push|pull|apply]" >&2
    exit 1
    ;;
esac

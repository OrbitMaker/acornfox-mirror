#!/usr/bin/env bash
# 从 files.txt 里的原始地址下载文件，核对 SHA256，原样发布为本仓库的发行版附件。
# 超过 PART_MB（默认 90）MB 的文件另外切成若干段（.part00、.part01…），供单个附件有大小上限的平台（如 Gitee）使用；
# 拼回：cat 名称.part* > 名称，然后用 SHA256SUMS 核对。
# 用法（GitHub Actions 里运行，需要 GH_TOKEN）：bash fetch.sh <发行版标签>
set -euo pipefail
TAG=${1:?发行版标签}; PART_MB=${PART_MB:-90}; OUT=dist; rm -rf $OUT; mkdir -p $OUT
grep -v '^#' files.txt | while IFS='|' read -r name url sum; do
  [ -z "$name" ] && continue
  curl -fL --retry 3 -o "$OUT/$name" "$url"
  echo "$sum  $OUT/$name" | sha256sum -c -
  if [ "$(stat -c %s "$OUT/$name")" -gt $((PART_MB*1024*1024)) ]; then
    split -b ${PART_MB}m -d "$OUT/$name" "$OUT/$name.part"
  fi
done
( cd $OUT && sha256sum * > SHA256SUMS && cat SHA256SUMS )
gh release view "$TAG" >/dev/null 2>&1 || gh release create "$TAG" --title "$TAG" --notes-file RELEASE_NOTES.md
gh release upload "$TAG" $OUT/* --clobber

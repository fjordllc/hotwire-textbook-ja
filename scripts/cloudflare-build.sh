#!/usr/bin/env bash
#
# Cloudflare Pages 用ビルドスクリプト
#
# Cloudflare Pages のビルド環境には mdBook が入っていないため、
# 公式リリースのプリビルドバイナリを取得してから本を生成する。
#
# Cloudflare ダッシュボードでの設定:
#   Build command:     bash scripts/cloudflare-build.sh
#   Build output dir:  book
#
set -euo pipefail

# ローカルで確認しているバージョンに固定する。
MDBOOK_VERSION="${MDBOOK_VERSION:-0.4.52}"

ARCHIVE="mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
URL="https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/${ARCHIVE}"

echo "==> Downloading mdBook v${MDBOOK_VERSION}"
curl -fsSL "${URL}" -o "${ARCHIVE}"
tar -xzf "${ARCHIVE}"

echo "==> Building book"
./mdbook build

echo "==> Done. Output is in ./book"

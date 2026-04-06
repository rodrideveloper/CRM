#!/bin/bash
set -e

# ── Config ──────────────────────────────────────────────
FTP_HOST="45.132.157.159"
FTP_USER="u253625720.iLChopper"
FTP_PASS="15492102Rr!"
FTP_PORT="21"
REMOTE_DIR="/public_html"
# ────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "══════════════════════════════════════"
echo "  TRATAR Web — Build & Deploy"
echo "══════════════════════════════════════"

# 1. Build
echo ""
echo "▸ Building Flutter web (release)..."
fvm flutter build web --release
echo "✓ Build complete"

# 2. Deploy via FTP
BUILD_DIR="$SCRIPT_DIR/build/web"

echo ""
echo "▸ Uploading to $FTP_HOST:$REMOTE_DIR ..."

lftp -u "$FTP_USER","$FTP_PASS" -p "$FTP_PORT" "$FTP_HOST" <<EOF
set ssl:verify-certificate no
set net:max-retries 3
set net:timeout 30
mirror --reverse --delete --verbose --parallel=4 \
  "$BUILD_DIR" "$REMOTE_DIR"
bye
EOF

echo ""
echo "✓ Deploy complete → https://trat.ar"
echo "══════════════════════════════════════"

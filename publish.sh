#!/usr/bin/env bash
# GitHub Pages 최초 배포 스크립트
# 공유 계정 머신이므로 gh 인증 정보는 이 리포 안(.gh-config/)에만 저장됩니다.
set -euo pipefail

cd "$(dirname "$0")"

export GH_CONFIG_DIR="$PWD/.gh-config"
GH_BIN="$(command -v gh || echo "$HOME/djk/bin/gh")"

if [ ! -x "$GH_BIN" ]; then
    echo "오류: gh CLI를 찾을 수 없습니다 (~/djk/bin/gh 확인)." >&2
    exit 1
fi

if ! "$GH_BIN" auth status >/dev/null 2>&1; then
    echo "GitHub 로그인이 필요합니다. 브라우저 인증을 시작합니다..."
    "$GH_BIN" auth login --hostname github.com --git-protocol https --web
fi

USERNAME="$("$GH_BIN" api user -q .login)"
REPO="${USERNAME}.github.io"
echo "GitHub 계정: $USERNAME → 리포: $REPO"

# index.html의 GitHub 링크 자동 채우기
if grep -q "YOUR_GITHUB_ID" index.html; then
    sed -i "s/YOUR_GITHUB_ID/${USERNAME}/g" index.html
    git add index.html
    git commit -m "Fill in GitHub username" >/dev/null
    echo "index.html의 GitHub 링크를 $USERNAME 으로 채웠습니다."
fi

# 리포 생성 (이미 있으면 건너뜀)
if ! "$GH_BIN" repo view "$USERNAME/$REPO" >/dev/null 2>&1; then
    "$GH_BIN" repo create "$REPO" --public --description "Personal homepage"
    echo "리포 생성 완료: https://github.com/$USERNAME/$REPO"
else
    echo "리포가 이미 존재합니다: https://github.com/$USERNAME/$REPO"
fi

git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USERNAME/$REPO.git"

# gh 인증으로 push (자격 증명은 GH_CONFIG_DIR에만 저장됨)
GIT_CONFIG_COUNT=1 \
GIT_CONFIG_KEY_0="credential.https://github.com.helper" \
GIT_CONFIG_VALUE_0="!$GH_BIN auth git-credential" \
git push -u origin main

echo ""
echo "배포 완료! 1~2분 후 https://${USERNAME}.github.io 에서 확인하세요."

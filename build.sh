#!/usr/bin/env bash
set -euo pipefail

# Branch-based base_url configuration
PROD_URL="https://blog.thanhnc.id.vn"
DEV_URL="https://dev-zola-my-id-vn.jakeclark38b.workers.dev"

detect_branch() {
    # 1. Cloudflare Pages env var
    if [ -n "${CF_PAGES_BRANCH:-}" ]; then
        echo "$CF_PAGES_BRANCH"
        return
    fi

    # 2. Try git branch name (works when not in detached HEAD)
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
    if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
        echo "$branch"
        return
    fi

    # 3. Detached HEAD: check which remote branch contains this commit
    branch=$(git branch -r --contains HEAD 2>/dev/null | grep -oP 'origin/\K\S+' | head -1 || true)
    if [ -n "$branch" ]; then
        echo "$branch"
        return
    fi

    # 4. Last resort: check git reflog for checkout info
    branch=$(git reflog show --format='%gs' -1 2>/dev/null | grep -oP 'checkout: moving from \S+ to \K\S+' || true)
    if [ -n "$branch" ]; then
        echo "$branch"
        return
    fi

    echo "unknown"
}

main() {
    ZOLA_VERSION=0.22.1

    # Clean previous build
    rm -rf public

    curl -sLJO "https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
    tar -xf zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz

    git submodule update --init --recursive

    # Detect branch and set base_url
    BRANCH=$(detect_branch)
    echo "🔍 Detected branch: ${BRANCH}"

    if [ "$BRANCH" = "master" ] || [ "$BRANCH" = "main" ]; then
        echo "🚀 Production build → ${PROD_URL}"
        ./zola build --base-url "$PROD_URL"
    else
        echo "🔧 Dev build → ${DEV_URL}"
        ./zola build --base-url "$DEV_URL"
    fi
}

main
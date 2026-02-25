#!/usr/bin/env bash
set -euo pipefail

# Branch-based base_url configuration
PROD_URL="https://blog.thanhnc.id.vn"
DEV_URL="https://dev-zola-my-id-vn.jakeclark38b.workers.dev"

main() {
    ZOLA_VERSION=0.22.1

    # Clean previous build
    rm -rf public

    curl -sLJO "https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
    tar -xf zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz

    git submodule update --init --recursive

    # Detect branch and set base_url
    BRANCH="${CF_PAGES_BRANCH:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')}"
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
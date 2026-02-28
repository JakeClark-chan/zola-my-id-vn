# zola-my-id-vn

Personal blog for [JakeClark (Nguyễn Chí Thành)](https://blog.thanhnc.id.vn), built with [Zola](https://www.getzola.org/) and the [tabi](https://github.com/welpo/tabi) theme. Covers Linux guides, CTF write-ups, and more.

## ✨ Features

- **Bilingual** — Vietnamese (default) + English (`/en/*`)
- **Sections**: Linux (`/linux/`) and CTF (`/ctf/`)
- **Giscus comments** on every post (via GitHub Discussions)
- **iine anonymous likes** with a thumbs-up button
- **Dark/Light theme switcher** with mint skin
- Deployed on **Cloudflare Workers** (and optionally **Netlify**)

## 📁 Project Structure

```
zola-my-id-vn/
├── content/                          # All page content (Markdown)
│   ├── _index.md                     # Homepage — Vietnamese
│   ├── _index.en.md                  # Homepage — English
│   ├── linux/                        # Linux section
│   │   ├── _index.md                 # Section list page
│   │   ├── _index.en.md
│   │   └── install-cosmic-de-niri/   # Page bundle (post + assets)
│   │       ├── index.md
│   │       ├── index.en.md
│   │       └── image.png             # Co-located images
│   └── ctf/                          # CTF write-ups section
│       ├── _index.md
│       └── thm-light/                # Page bundle
│           └── index.md
├── templates/                        # Jinja2/Tera template overrides
├── themes/tabi/                      # tabi theme (git submodule)
├── static/                           # Static files served as-is
│   ├── robots.txt
│   └── google1f419c35aa3b8c38.html   # Google Search Console verification
├── sass/                             # Custom SCSS overrides
├── zola.toml                         # Zola site config
├── wrangler.toml                     # Cloudflare Workers config
├── netlify.toml                      # Netlify config
└── build.sh                          # CI build script
```

## ✍️ How Content Works

This site uses **Zola** — a static site generator. Content is written in Markdown with a TOML front matter block delimited by `+++`.

### Front Matter for a Blog Post

```toml
+++
title = "Your Post Title"
date = 2025-06-01
description = "A short summary shown in listings and SEO."

[taxonomies]
tags = ["linux", "tutorial"]

[extra]
toc = true   # Enable table of contents
+++

Post content in Markdown...

<!-- more -->

The rest of the post (above this marker is the excerpt shown in the listing).
```

### Bilingual Posts

Each post can have two files side by side:
- `index.md` → Vietnamese
- `index.en.md` → English (accessible at `/en/<section>/<slug>/`)

If an English version doesn't exist, the Vietnamese version is shown to English visitors with a notice.

### Page Bundles (Posts with Images)

For posts with images or other assets, use a **page bundle** — a folder named after the slug:

```
content/linux/my-new-guide/
    index.md          ← post content
    index.en.md       ← English version (optional)
    screenshot.png    ← image co-located with the post
```

Reference co-located images directly by filename in Markdown:

```markdown
![Screenshot](screenshot.png)
```

### Sections

Each section has a `_index.md` that controls listing behavior:

```toml
+++
title = "Linux"
sort_by = "date"     # Sort posts by date
paginate_by = 10     # Posts per page
description = "Linux guides and tutorials."
+++
```

### Adding a New Section

1. Create `content/<section-name>/_index.md` (and `_index.en.md`)
2. Add the section to `menu` and `footer_menu` in `zola.toml`:

```toml
menu = [
    { name = "linux", url = "linux" },
    { name = "newstuff", url = "newstuff" },  # ← add here
    ...
]
```

### Adding a New Post

**Simple post (no images):**
```
content/linux/my-guide.md
```

**Post with images:**
```
content/linux/my-guide/
    index.md
    index.en.md   (optional)
    photo.jpg
```

---

## 🚀 Deployment

### Prerequisites

- A [Cloudflare](https://cloudflare.com) account with Workers enabled, **or** a [Netlify](https://netlify.com) account
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/) (for Cloudflare): `npm install -g wrangler`
- Git with submodule support

### Cloudflare Workers (Current Setup)

The `build.sh` script downloads Zola automatically — **no local Zola install is needed on the CI machine**.

**1. Connect the repo**

Go to [Cloudflare Dashboard](https://dash.cloudflare.com) → Workers & Pages → Create → Connect to Git. Select this repository.

**2. Set build settings**

| Field | Value |
|---|---|
| Build command | `chmod +x build.sh && ./build.sh` |
| Deploy directory | `public` |

This is already configured in `wrangler.toml`. On `main`/`master` it builds for `https://blog.thanhnc.id.vn`; other branches get a preview URL automatically.

**3. Manual deploy (optional)**

```bash
wrangler deploy
```

### Netlify

`netlify.toml` is already present in the repo. Just connect the repository in [Netlify](https://app.netlify.com):

1. New site → Import an existing project → connect GitHub
2. Netlify will auto-detect `netlify.toml` — no extra configuration needed

The `netlify.toml` handles:
- **Preview deploys**: Uses `$DEPLOY_PRIME_URL` as the base URL
- **Production**: Builds with `base_url` from `zola.toml`

### GitHub Pages

1. In your GitHub repo, go to **Settings → Pages** and set the source to **GitHub Actions**.
2. Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - name: Download Zola
        run: |
          curl -sL https://github.com/getzola/zola/releases/download/v0.22.1/zola-v0.22.1-x86_64-unknown-linux-gnu.tar.gz | tar xz
      - name: Build
        run: ./zola build --base-url "https://<your-username>.github.io/<repo-name>/"
      - uses: actions/upload-pages-artifact@v3
        with:
          path: public
      - id: deployment
        uses: actions/deploy-pages@v4
```

> [!NOTE]
> Replace `<your-username>` and `<repo-name>`. Also update `base_url` in `zola.toml`.

---

## 🛠️ Local Development

```bash
# 1. Clone with submodules (tabi theme)
git clone --recurse-submodules https://github.com/JakeClark-chan/zola-my-id-vn

# 2. Install Zola
# See: https://www.getzola.org/documentation/getting-started/installation/

# 3. Serve locally with hot-reload
zola serve
```

Site will be available at `http://127.0.0.1:1111`.

---

## 🔧 Configuration Reference

Key fields in `zola.toml`:

| Key | Purpose |
|---|---|
| `base_url` | Production URL (overridden at build time) |
| `default_language` | `"vi"` — Vietnamese |
| `theme` | `"tabi"` |
| `[extra].skin` | Color skin — `"mint"` |
| `[extra].menu` | Top navigation links |
| `[extra].iine` | Anonymous like button (enabled) |
| `[extra].giscus` | GitHub Discussions comment integration |
| `[extra].show_previous_next_article_links` | Prev/next navigation on posts |

### Giscus Comments

Comments are powered by [Giscus](https://giscus.app/) (GitHub Discussions). Config is in `zola.toml` under `[extra.giscus]`. To set it up for a fork:

1. Enable Discussions on your GitHub repo
2. Install the [giscus GitHub App](https://github.com/apps/giscus) on the repo
3. Run the giscus configurator at [giscus.app](https://giscus.app) to get your `repo_id` and `category_id`
4. Update the values in `zola.toml`

🎯 Best Zola Theme Picks for Each Subdomain
1. 🏴‍☠️ CTF Writeup — zola-hacker
Why: This is a no-brainer. It's directly inspired by GitHub's "Hacker" theme — dark, green-on-black terminal aesthetic that perfectly matches the CTF/hacking vibe. Minimalist design puts the focus on code blocks, technical content, and walkthroughs. Recently updated (Feb 2026).

Runner-up: terminimal — retro terminal look, great for CTF content too, but hasn't been updated since 2024.

2. 📝 IRL Blog — tabi
Why: Feature-rich, polished, and personal. It has dark/light mode, multi-language support (great for Vietnamese/English), projects page, archive, tags, social links, comments (giscus/utterances), series support for multi-part posts, and a perfect Lighthouse score. It's one of the most well-maintained Zola themes and supports Catppuccin syntax highlighting — which matches your current catppuccin-mocha config.

Runner-up: serene — minimal and well-crafted, great for personal blog posts with a clean reading experience.

3. 🐧 Linux Blog — terminimal
Why: A retro terminal-inspired theme that screams Linux. It uses the Hack font, has a CLI-like aesthetic, supports dark mode, pagination, tags, and customizable colors. Perfect for guides, tutorials, and dotfiles discussions.

Runner-up: even — clean, dark-themed, responsive, with KaTeX support. Good for technical Linux content.

4. 🔬 Research — Academic Paper
Why: Purpose-built for academic content. Features automatic paper headers (title, authors, venue, year), KaTeX math rendering (client-side + server-side), figure shortcodes with subfigures/captions, footnotes, JSON-LD/OpenGraph metadata, and is designed to last — zero JavaScript dependencies with server-side KaTeX.

Runner-up: DeepThought — broader feature set with charts, diagrams, maps, KaTeX, and Bulma CSS. Better if your "research" section also includes non-paper content like data visualizations.

5. 🚀 Project Introduction — Project Portfolio
Why: Literally designed for this exact use case. Features project types and skills taxonomies, 37 built-in color schemes, responsive design, search, multi-language support, and customizable navbar/footer with social links. Clean showcase layout for project cards.

Runner-up: tabi — its built-in Projects page is also solid if you want a unified look with your IRL blog.

Summary Table
Subdomain	Recommended Theme	Vibe
CTF Writeup	zola-hacker	Dark hacker aesthetic 🖤💚
IRL Blog	tabi	Polished, feature-rich personal blog
Linux Blog	terminimal	Retro terminal style 🖥️
Research	Academic Paper	Clean academic with LaTeX support
Project Intro	Project Portfolio	Showcase cards + taxonomies
💡 Tip: Since you're using Catppuccin Mocha globally, tabi natively supports Catppuccin, and zola-hacker / terminimal have dark color palettes that pair well with it. For the others, you can customize the syntax highlighting theme in each subdomain's 

zola.toml
.
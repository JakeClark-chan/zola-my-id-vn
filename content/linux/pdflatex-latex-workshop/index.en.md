+++
title = "Install pdflatex with LaTeX Workshop to Simulate Overleaf"
date = 2025-01-05
description = "A guide to setting up offline pdflatex on Linux with LaTeX Workshop in VSCode, simulating the Overleaf workflow with AI assistance."
[taxonomies]
tags = ["linux", "latex", "vscode", "overleaf"]
[extra]
toc = true
+++

A guide to setting up offline **pdflatex** on Linux with **LaTeX Workshop** in VSCode, simulating the **Overleaf** workflow with AI assistance.

<!-- more -->

> ⚠️ Requires approximately **~6GB** of root storage to install all dependencies and avoid compile errors.

## 1. Install pdflatex

PdfLatex converts LaTeX sources into PDF — essential for researchers publishing their findings.

```bash
# Install TexLive base
sudo apt-get install texlive-latex-base

# Install recommended and extra fonts to avoid font-related errors
sudo apt-get install texlive-fonts-recommended
sudo apt-get install texlive-fonts-extra

# Install extra packages
sudo apt-get install texlive-latex-extra

# Install full dependencies (recommended)
sudo apt-get install texlive-full

# Install latexmk for LaTeX Workshop
sudo apt-get install latexmk

# Test
pdflatex main.tex
```

## 2. Install LaTeX Workshop in VSCode

Search for and install the **LaTeX Workshop** extension from the marketplace.

## 3. Configure VSCode

Open **Settings (JSON)** and add:

```json
"latex-workshop.latex.tools": [
    {
        "name": "latexmk",
        "command": "latexmk",
        "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "-pdf",
            "-outdir=%OUTDIR%",
            "%DOC%"
        ]
    }
],
"latex-workshop.latex.recipes": [
    {
        "name": "latexmk (pdflatex)",
        "tools": ["latexmk"]
    }
],
"latex-workshop.formatting.latex": "latexindent",
"latex-workshop.view.pdf.internal.synctex.keybinding": "double-click"
```

## Workflow

With this setup, you get:

- **Double-click from PDF → code**: SyncTeX jumps to the corresponding line
- **Ctrl + Shift + P → SyncTeX from cursor**: Jump from code → PDF  
- Combine with AI for faster LaTeX writing

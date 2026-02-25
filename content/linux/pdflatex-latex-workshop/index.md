+++
title = "Cài pdflatex và LaTeX Workshop để thay thế Overleaf"
date = 2025-01-05
description = "Hướng dẫn cài đặt pdflatex offline trên Linux kết hợp LaTeX Workshop trong VSCode, mô phỏng workflow Overleaf với AI hỗ trợ."
[taxonomies]
tags = ["linux", "latex", "vscode", "overleaf"]
[extra]
toc = true
+++

Hướng dẫn cài đặt **pdflatex** offline trên Linux kết hợp **LaTeX Workshop** trong VSCode, mô phỏng workflow **Overleaf** với AI hỗ trợ.

<!-- more -->

> ⚠️ Cần khoảng **~6GB** dung lượng root để cài đầy đủ dependencies, tránh lỗi compile.

## 1. Cài pdflatex

PdfLatex là tool chuyển đổi nguồn LaTeX thành PDF — rất quan trọng cho nghiên cứu khoa học.

```bash
# Cài TexLive base
sudo apt-get install texlive-latex-base

# Cài thêm font để tránh lỗi thiếu font
sudo apt-get install texlive-fonts-recommended
sudo apt-get install texlive-fonts-extra

# Cài các package mở rộng
sudo apt-get install texlive-latex-extra

# Cài đầy đủ dependencies (khuyến nghị)
sudo apt-get install texlive-full

# Cài latexmk cho LaTeX Workshop
sudo apt-get install latexmk

# Test
pdflatex main.tex
```

## 2. Cài LaTeX Workshop trong VSCode

Tìm và cài extension **LaTeX Workshop** từ marketplace.

## 3. Cấu hình VSCode

Mở **Settings (JSON)** và thêm:

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

Với cấu hình trên, bạn có thể:

- **Double-click từ PDF → code**: SyncTeX tự nhảy đến dòng tương ứng
- **Ctrl + Shift + P → SyncTeX from cursor**: Nhảy từ code → PDF
- Kết hợp AI để viết LaTeX nhanh hơn

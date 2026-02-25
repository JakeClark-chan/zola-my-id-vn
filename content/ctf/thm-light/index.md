+++
title = "TryHackMe: Light"
date = 2025-01-22
description = "Walkthrough challenge Light trên TryHackMe — SQL injection (SQLite)."
[taxonomies]
tags = ["ctf", "tryhackme", "sql-injection", "sqlite"]
[extra]
toc = true
+++

Walkthrough challenge **Light** trên TryHackMe — exploit **SQL injection** trên SQLite.

<!-- more -->

Link: [https://tryhackme.com/room/lightroom](https://tryhackme.com/room/lightroom)

Keyword: SQL injection, SQLite

## Giải pháp

1. Test SQLi bằng cách thêm dấu `'` hoặc `"` vào input
2. Sau khi confirm SQLi, tìm tên admin table dùng `sqlite_master.name where type='table'` kết hợp **UNION SELECT** (đổi keyword vì WAF sẽ block)
3. Tìm username và password của admin user
4. Kiểm tra số record trong table, tìm password của các user khác

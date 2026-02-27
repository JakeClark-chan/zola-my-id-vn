+++
title = "Reverse Engineering - Basic Problems"
date = 2023-08-18
description = "Series giải các bài tập Reverse Engineering cơ bản, tập trung vào việc viết script dịch ngược (solve script) từ mã giả (pseudo-code) của IDA."
[taxonomies]
tags = ["ctf", "re", "reverse-engineering", "crackme", "cpp", "ida"]
[extra]
toc = true
+++

Series giải các bài tập **Reverse Engineering** cơ bản. 

Hàm `check_string` hoặc `check_array` trong các bài dưới đây được trích xuất từ pseudo-code của IDA. Mục tiêu là viết script dịch ngược để tìm ra chuỗi đầu vào đúng (Correct!).

**Author**: Nguyễn Chí Thành | JakeClark  
**Date**: Fri, Aug 18th, 2023

<!-- more -->

## chall3

```cpp
#include <iostream>
#include <string>

unsigned char byte_140003000[] = {
    0x49, 0x60, 0x67, 0x74, 0x63, 0x67, 0x42, 0x66, 0x80, 0x78, 0x69, 0x69,
    0x7B, 0x99, 0x6D, 0x88, 0x68, 0x94, 0x9F, 0x8D, 0x4D, 0xA5, 0x9D,
    0x45, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

int check_string(const unsigned char* a1) {
    for (int i = 0; i < 0x18; ++i) {
        if (byte_140003000[i] != ((i ^ a1[i]) + 2 * i)) {
            return 0;
        }
    }
    return 1;
}

std::string rev_sub() {
    std::string a1 = "";
    for (int i = 0; i < 0x18; ++i) {
        a1 += static_cast<char>(i ^ (byte_140003000[i] - 2 * i));
    }
    return a1;
}

int main() {
    std::cout << rev_sub() << std::endl;
    return 0;
}
```

## chall4

```cpp
#include <string>
#include <vector>
#include <iostream>

std::vector<uint8_t> byte_140003000 = {
    0x24, 0x27, 0x13, 0xC6, 0xC6, 0x13, 0x16, 0xE6,
    0x47, 0xF5, 0x26, 0x96, 0x47, 0xF5, 0x46, 0x27,
    0x13, 0x26, 0x26, 0xC6, 0x56, 0xF5, 0xC3, 0xC3,
    0xF5, 0xE3, 0xE3, 0, 0, 0, 0, 0, 0
};

int check_string(const std::string& a1) {
    for (int i = 0; i < 0x1C; ++i) {
        if ((((16 * static_cast<uint8_t>(a1[i])) | (static_cast<uint8_t>(a1[i]) >> 4)) & 0xFF) != byte_140003000[i]) {
            return 0;
        }
    }
    return 1;
}

std::string rev_sub() {
    std::string a1 = "";
    for (int i = 0; i < 0x1C; ++i) {
        for (int j = 32; j < 128; ++j) {
            if ((((16 * j) | (j >> 4)) & 0xFF) == byte_140003000[i]) {
                a1 += static_cast<char>(j);
                break;
            }
        }
    }
    return a1;
}

int main() {
    std::cout << rev_sub() << std::endl;
    return 0;
}
```

## chall5

```cpp
#include <iostream>
#include <vector>

std::vector<unsigned char> byte_140003000 = {0xAD, 0xD8, 0xCB, 0xCB, 0x9D, 0x97, 0xCB, 0xC4, 0x92, 0xA1, 0xD2, 0xD7, 0xD2, 0xD6, 0xA8, 0xA5, 0xDC, 0xC7, 0xAD, 0xA3, 0xA1, 0x98, 0x4C, 0, 0, 0, 0, 0, 0, 0, 0, 0};

bool check_array(std::vector<unsigned char> a1) {
    for (int i = 0; i < 0x18; ++i) {
        if ((a1[i + 1] + a1[i]) != byte_140003000[i]) {
            return false;
        }
    }
    return true;
}

void rev_array() {
    std::vector<unsigned char> a1(0x18, 0x00);
    a1[0x17] = byte_140003000[0x17];
    for (int i = 0x16; i >= 0; --i) {
        a1[i] = byte_140003000[i] - a1[i + 1];
    }
    
    for (unsigned char y : a1) {
        std::cout << y;
    }
    std::cout << std::endl;
}

int main() {
    rev_array();
    return 0;
}
```

## chall6

```cpp
#include <iostream>
#include <vector>
using namespace std;

vector<unsigned int> byte_140003020 = {
    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67,
    0x2B, 0xFE, 0xD7, 0xAB, 0x76, 0xCA, 0x82, 0xC9, 0x7D, 0xFA,
    0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72,
    0xC0, 0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34,
    0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15, 0x04, 0xC7, 0x23,
    0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27,
    0xB2, 0x75, 0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52,
    0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84, 0x53, 0xD1, 0x00,
    0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A,
    0x4C, 0x58, 0xCF, 0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33,
    0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8, 0x51, 0xA3,
    0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21,
    0x10, 0xFF, 0xF3, 0xD2, 0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97,
    0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE,
    0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB, 0xE0, 0x32, 0x3A, 0x0A,
    0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4,
    0x79, 0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C,
    0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08, 0xBA, 0x78, 0x25,
    0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B,
    0xBD, 0x8B, 0x8A, 0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E,
    0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E, 0xE1, 0xF8,
    0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9,
    0xCE, 0x55, 0x28, 0xDF, 0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6,
    0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
};

vector<unsigned int> byte_140003000 = {
    0x00, 0x4D, 0x51, 0x50, 0xEF, 0xFB, 0xC3, 0xCF, 0x92, 0x45,
    0x4D, 0xCF, 0xF5, 0x04, 0x40, 0x50, 0x43, 0x63, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

bool check_array(vector<unsigned char> a1) {
    for (int i = 0; i < 0x12; ++i) {
        if (byte_140003020[a1[i]] != byte_140003000[i]) {
            return false;
        }
    }
    return true;
};

int findIndex(const std::vector<unsigned int>& vec, unsigned int target) {
    for (size_t i = 0; i < vec.size(); ++i) {
        if (vec[i] == target) {
            return static_cast<int>(i); // Return index as int
        }
    }
    return -1; // Return -1 if target is not found in the vector
}

string rev_check_array() {
    string a1 = "";
    for (int i = 0; i < 0x12; ++i) {
        a1 += static_cast<char>(findIndex(byte_140003020, byte_140003000[i]));
    }
    return a1;
}

int main() {
    cout << rev_check_array() << endl;
    return 0;
}
```

## chall7

```cpp
#include <iostream>
#include <vector>

std::vector<unsigned char> byte_140003000 = {
    0x52, 0xDF, 0xB3, 0x60, 0xF1, 0x8B, 0x1C, 0xB5, 0x57, 0xD1,
    0x9F, 0x38, 0x4B, 0x29, 0xD9, 0x26, 0x7F, 0xC9, 0xA3, 0xE9,
    0x53, 0x18, 0x4F, 0xB8, 0x6A, 0xCB, 0x87, 0x58, 0x5B, 0x39,
    0x1E
};

unsigned char rotate_left(unsigned char n, int d) {
    const unsigned char mask = 0xFF;  // Mask to keep only 8 bits
    return ((n << d) | (n >> (8 - d))) & mask;
}

unsigned char rotate_right(unsigned char n, int d) {
    const unsigned char mask = 0xFF;  // Mask to keep only 8 bits
    return ((n >> d) | (n << (8 - d))) & mask;
}

bool check_array(std::vector<unsigned char> a1) {
    for (int i = 0; i < 0x1F; ++i) {
        if ((i ^ rotate_left(a1[i], i & 7)) != byte_140003000[i]) {
            return false;
        }
    }
    return true;
}

void rev_check_array() {
    std::string a1 = "";
    for (int i = 0; i < 0x1F; ++i) {
        int val = rotate_right((byte_140003000[i] ^ i), i & 7);
        a1 += static_cast<char>(val);
    }
    std::cout << a1 << std::endl;
}

int main() {
    rev_check_array();
    return 0;
}
```

## chall8

```cpp
#include <iostream>
#include <vector>

std::vector<unsigned char> byte_140003000 = {
    0xAC, 0xF3, 0x0C, 0x25, 0xA3, 0x10, 0xB7, 0x25,
    0x16, 0xC6, 0xB7, 0xBC, 0x07, 0x25, 0x02, 0xD5,
    0xC6, 0x11, 0x07, 0xC5
};

bool check_array(std::vector<int> a1) {
    for (int i = 0; i < 0x15; ++i) {
        if (((-5*i)&0xFF) != byte_140003000[i]) {
            return false;
        }
    }
    return true;
}

std::string rev_check_arr() {
    std::string a1 = "";
    for (int i = 0; i < 0x15; ++i) {
        for (int j = 32; j < 128; ++j) {
            if (((-5*j)&0xFF) == byte_140003000[i]) {
                a1 += static_cast<char>(j);
                break;
            }
        }
    }
    return a1;
}

int main() {
    std::cout << rev_check_arr() << std::endl;
    return 0;
}
```

## chall9

```cpp
#include <iostream>
#include <stdlib.h>
#include <cstring>
#include <cstdio>
#include <vector>
using namespace std;

int rotate_right(int n, int d){
    int mask = (1 << 8) - 1;  //  Mask to keep only 8 bits
    return ((n >> d) | (n << (8 - d))) & mask;
}

int rotate_left(int n, int d) {
    int mask = (1 << 8) - 1;  // Mask to keep only 8 bits
    return ((n << d) | (n >> (8 - d))) & mask;
}

int byte_140004020[] = { ... }; // AES S-Box or similar lookup table
u_int8_t unk_140004000[] = { ... }; // Encrypted data

void solve(){
    for (int i=0; i < 0x18; i+=8){
        int v2;
        unsigned char v5[16] = "I_am_KEY";
        v2 = unk_140004000[i];
        for (int loops=0; loops<16; loops++){
            for (int j=7; j>=0; --j){
                v2 = unk_140004000[i+((j+1)&7)];
                unk_140004000[i+((j+1)&7)] = rotate_left(v2, 5) - byte_140004020[(unsigned char)v5[j]^unk_140004000[i+j]];
            }
        }
    }
    for (char i: unk_140004000){
        cout << i;
    }
}

int main() {
    solve();
    return 0;
}
```

## BasicCrackMe

```cpp
#include <iostream>
#include <regex>
#include <vector>
using namespace std;

string enc_flag = "0X299C0X242A0X35A90X275D0X45A0X2496...";

void reverse_enc(){
    string key = "have a good day! enjoy wargame!";
    int key_length = key.length();
    vector<int> enc = extract_hex(enc_flag);
    vector<int> flag(enc.size(), 0);
    for (int i=0; i<enc.size(); i++){
        int v4 = enc[i];
        int v1 = v4 - i + key[i % key_length];
        flag[i] = v1 ^ (key[i % key_length] * key[i % key_length] + i);
    }
    for (char i: flag)
        cout << i;
}

int main() {
    reverse_enc();
    return 0;
}
```

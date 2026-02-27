+++
title = "CryptoHack - Elliptic Curves"
date = 2023-08-21
description = "Series giải các bài tập về Elliptic Curves trên CryptoHack, từ cơ bản đến nâng cao (Pohlig-Hellman, Baby-step Giant-step)."
[taxonomies]
tags = ["ctf", "cryptohack", "crypto", "elliptic-curves", "ecc", "sage"]
[extra]
toc = true
+++

Series giải các bài tập về **Elliptic Curves** trên CryptoHack.

**Author**: Nguyễn Chí Thành | JakeClark  
**Date**: Mon, Aug 21st, 2023

<!-- more -->

## Background Reading

Đơn giản là mình đọc được ở đây: [https://en.wikipedia.org/wiki/Abelian_group](https://en.wikipedia.org/wiki/Abelian_group), nên kết quả là: `crypto{Abelian}`

## Point Negation

Cho 2 điểm $P(x_1, y_1)$ và $Q(x_2, y_2)$, $P+Q=0$ khi và chỉ khi: $x_1=x_2$ và $y_1=-y_2$, chính vì vậy ta biết ngay: $x_2=x_1=8045$, và $y_2=-6936 \pmod{9739}=2803$, vì vậy flag là: `crypto{8045,2803}`

## Point Addition

Áp dụng thuật toán đã đưa ra, mình đã viết script đơn giản sau:

```python
# find P+Q, P and Q in E(F_p): y^2 = x^3 + ax + b (mod p)
p = 9739
a = 497
b = 1768

# P != 0, Q != 0, x1!=x2, P!=Q
def algo(P: tuple, Q: tuple) -> tuple:
    if (P == (0, 0)): return Q
    if (Q == (0, 0)): return P
    x1, y1 = P
    x2, y2 = Q
    if (x1==x2 and y1==-y2): return (0, 0)
    if P!=Q:
        _lambda = (y2-y1) * pow((x2-x1), -1, p)
    else:
        _lambda = (3*(x1**2)+a) * pow(2*y1, -1, p)
    x3 = (_lambda**2 - x1 - x2) % p
    y3 = (_lambda * (x1 - x3) - y1) % p
    return (x3, y3)

P = (493, 5564)
Q = (1539, 4742)
R = (4403,5202)
print(algo(algo(algo(P, P), Q), R))
```

Flag là: `crypto{4215, 2162}`

## Scalar Multiplication

Áp dụng thuật toán đã đưa ra, mình đã viết script đơn giản sau:

```python
# find kP, P in E(F_p): y^2 = x^3 + ax + b (mod p)
p = 9739
a = 497
b = 1768

def algo_add(P: tuple, Q: tuple) -> tuple:
    if (P == (0, 0)): return Q
    if (Q == (0, 0)): return P
    x1, y1 = P
    x2, y2 = Q
    if (x1==x2 and y1==-y2): return (0, 0)
    if P!=Q:
        _lambda = (y2-y1) * pow((x2-x1), -1, p)
    else:
        _lambda = (3*(x1**2)+a) * pow(2*y1, -1, p)
    x3 = (_lambda**2 - x1 - x2) % p
    y3 = (_lambda * (x1 - x3) - y1) % p
    return (x3, y3)

def algo_mul(n: int, P: tuple) -> tuple:
    import math
    Q = P
    R = (0, 0)
    while (n > 0):
        if n%2 == 1:
            R = algo_add(R, Q)
        Q = algo_add(Q, Q)
        n = n // 2
    return R

print(algo_mul(7863, (2339, 2213)))
```

Flag là: `crypto{9467, 2742}`

## Curves and Logs

Tiếp tục sử dụng code ở trên:

```python
print(algo_mul(1829, (815, 3190))) # 7929, 707
```

Mình lấy số 7929 mang lên [kt.gy](http://kt.gy) nhập vào ô ASCII, sau đó tìm đến dòng SHA1 và copy đưa vào flag.  
Flag là: `crypto{80e5212754a824d3a4aed185ace4f9cac0f908bf}`

## Efficient Exchange

Vì điểm công khai Alice mang lên nằm trong đường cong elliptic đã đưa ra, vì vậy mình có thể tìm ra điểm y bằng cách:

- Cho $x=4726$ vào công thức $E(F_{p}):y^{2}=x^3+ax+b$, ta tìm ra được $y^2$ (khoan chia lấy dư cho p vì bước sau đã chia dư cho p rồi).
- Nhờ vào công thức trong trang [RIESEL PRIME](https://www.rieselprime.de/ziki/Modular_square_root), ta tìm ra được 2 điểm y: `y1 = pow(y_2, (p+1)//4, p)` và `y2 = pow(-y_2, (p+1)//4, p)`, với `y_2` là giá trị $y^2$.
- Dùng lại code ở phía trên để tìm shared secret là 1 trong 2 điểm: `points1 = algo_mul(6534, (x, y1))` và `points2 = algo_mul(6534, (x, y2))`.
- Vì x của points1 và points2 giống nhau nên mình dùng nó làm key cho hàm `shared_secret` của hàm `decrypt_flag` có sẵn, chỉ cần truyền thêm IV và encrypted có sẵn nữa là xong.

Flag: `crypto{3ff1c1ent_k3y_3xch4ng3}`

## Smooth Criminal

Thuật toán Pohlig-Hellman để tìm $n$, với $n$ là số nhân với $G$ để cho ra điểm trong `output.txt`:

```python
# .sage file
# Pohlig-Hellman attack to find n so that P = nG
p = 310717010502520989590157367261876774703
a = 2
b = 3
g_x = 179210853392303317793440285562762725654
g_y = 105268671499942631758568591033409611165

F = FiniteField(p)
E = EllipticCurve(F, [a, b])

# P = nG
P = E.point((280810182131414898730378982766101210916, 291506490768054478159835604632710368904))
G = E.point((g_x, g_y))

print('factor E.order():', factor(E.order()))

factors, exps = zip(*factor(E.order()))
primes = [factors[i]^exps[i] for i in range(len(factors))]
print(primes)
dlogs = []

for fac in primes:
  t = int(G.order() / fac)
  dlog = discrete_log(t*P, t*G, operation="+")
  dlogs += [dlog]
  print("factor:", fac, "dlog:", dlog)

print(dlogs)
n = crt(dlogs, primes)
print(n * G == P)
print(n)
```

Sau khi có được $n$, ta tìm ra được shared secret bằng cách lấy $n$ nhân với public point của Bob, và tìm flag. (`source_smooth_criminal` là file source chall này cho, `decrypt_flag` là file source của bài Efficient Exchange).

```python
from source_smooth_criminal import Point, gen_shared_secret
from decrypt_flag import decrypt_flag

iv = '07e2628b590095a5e332d397b8a59aa7'
encrypted_flag = '8220b7c47b36777a737f5ef9caa2814cf20c1c1ef496ec21a9b4833da24a008d0870d3ac3a6ad80065c138a2ed6136af'
b_x = 272640099140026426377756188075937988094
b_y = 51062462309521034358726608268084433317
B = Point(b_x, b_y)
shared = gen_shared_secret(B, n)
print(decrypt_flag(shared, iv, encrypted_flag))
```

Flag là `crypto{n07_4ll_curv3s_4r3_s4f3_curv3s}`

### Bonus: Baby-step giant-step

```python
# .sage file
from sage.all import *

# Define the elliptic curve equation
p = 310717010502520989590157367261876774703
a = 2
b = 3
E = EllipticCurve(FiniteField(p), [a, b])

# Define the generator and target points (Q = nG)
G = E(179210853392303317793440285562762725654, 105268671499942631758568591033409611165)
Q = E(280810182131414898730378982766101210916, 291506490768054478159835604632710368904)

# Determine the order of the curve
n = E.order()

print("Initialize the baby-step-giant-step algorithm {}".format(ceil(sqrt(n))))
m = ceil(sqrt(n))
baby_steps = {i * G: i for i in range(m)}
G_m_inverse = (-m) * G

print("Baby-step phase: Compute the list of baby steps")
baby_list = [G]
for i in range(1, m):
    baby_list.append(baby_list[-1] + G)

print("Giant-step phase: Search for a match in the giant steps")
giant = Q
for j in range(m):
    if giant in baby_steps:
        result = j * m + baby_steps[giant]
        break
    giant += G_m_inverse

# Print the result
print("The discrete logarithm n is:", result)
```

**Nguồn tham khảo**: [SageMath DLP](https://shrek.unideb.hu/~tengely/crypto/section-6.html#subsection-23)

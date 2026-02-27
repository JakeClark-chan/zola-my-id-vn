+++
title = "CryptoHack - Crypto on the Web"
date = 2023-09-12
description = "Giải bài RSA or HMAC? Part 2 trên CryptoHack — kỹ thuật leak public key để giả mạo JWT."
[taxonomies]
tags = ["ctf", "cryptohack", "crypto", "jwt", "rsa", "web-security"]
[extra]
toc = true
+++

## RSA or HMAC? Part 2

**Author**: JakeClark  
**Source**: [Link](https://web.cryptohack.org/rsa-or-hmac-2/)

```python
import jwt # note this is the PyJWT module, not python-jwt

# Private key generated using: openssl genrsa -out rsa-or-hmac-2-private.pem 2048
with open('challenge_files/rsa-or-hmac-2-private.pem', 'rb') as f:
   PRIVATE_KEY = f.read()
# Public key generated using: openssl rsa -RSAPublicKey_out -in rsa-or-hmac-2-private.pem -out rsa-or-hmac-2-public.pem
with open('challenge_files/rsa-or-hmac-2-private.pem', 'rb') as f:
   PUBLIC_KEY = f.read()

FLAG = ?

@chal.route('/rsa-or-hmac-2/authorise/<token>/')
def authorise(token):
    try:
        decoded = jwt.decode(token, PUBLIC_KEY, algorithms=['HS256', 'RS256'])
    except Exception as e:
        return {"error": str(e)}

    if "admin" in decoded and decoded["admin"]:
        return {"response": f"Welcome admin, here is your flag: {FLAG}"}
    elif "username" in decoded:
        return {"response": f"Welcome {decoded['username']}"}
    else:
        return {"error": "There is something wrong with your session, goodbye"}

@chal.route('/rsa-or-hmac-2/create_session/<username>/')
def create_session(username):
    encoded = jwt.encode({'username': username, 'admin': False}, PRIVATE_KEY, algorithm='RS256')
    return {"session": encoded}
```

<!-- more -->

Nhìn chung bài này khá giống [bài thứ 1](https://web.cryptohack.org/rsa-or-hmac) (tuy mã hóa sử dụng RS256 nhưng giải mã cho phép cả 2 dạng là RS256 và HS256 nên ta chỉ cần biết PUBLIC_KEY của RS256 để dùng lại cho secret key của HS256 là được) chỉ khác ở 1 điểm là bài này không cho trước public key để ta mã hóa jwt đã thay đổi nội dung (biến dữ liệu của key `admin` từ `False` thành `True`).

Ý tưởng bài này là cho trước token RS256, ta dùng biện pháp nào đó để leak public key, vốn dĩ trong RSA là cặp `(n, e)`, sau đó dùng code từ bài 1 để thay đổi nội dung và xuất ra token HS256 để đưa lại vào trang web và lấy flag.

Bài viết của PortSwigger này có đề cập đến bài này: [Link](https://portswigger.net/web-security/jwt/algorithm-confusion#deriving-public-keys-from-existing-tokens) (yên tâm về lab Expert trong đó nha, nó cũng giống bài này mà cách làm tui giới thiệu ở dưới đây ngắn lắm, hiểu cách xài tool là được).

Bài viết của chủ tool sắp giới thiệu ở đây: [Link](https://blog.silentsignal.eu/2021/02/08/abusing-jwt-public-keys-without-the-public-key/)

Còn [đây](https://github.com/silentsignal/rsa_sign2n.git) là tool chúng ta sẽ làm việc trong bài này, dùng `git clone [https://github.com/silentsignal/rsa_sign2n.git](https://github.com/silentsignal/rsa_sign2n.git)`.

Để sử dụng script `jwt_forgery.py` trong tool này, ta dẫn vào thư mục `standalone`, làm lần lượt 3 lệnh được ghi trong `README.md`:

```bash
$ docker build . -t sig2n
$ docker run -it sig2n /bin/bash
container$ python3 jwt_forgery.py ey.... ey....
```

Với lệnh thứ 3, ta sẽ nhập lần lượt là 2 token RS256 khác username từ trang web challenge, ở đây tôi sẽ nhập 2 username: `JakeClark1` và `JakeClark2`:

![Untitled](Untitled.png)

![Untitled](Untitled1.png)

Vậy lệnh thứ 3 chúng ta sẽ nhập là:

```bash
container$ python3 jwt_forgery.py eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VybmFtZSI6Ikpha2VDbGFyazEiLCJhZG1pbiI6ZmFsc2V9.C7jHx7uoEV6SV-FeeBU9x6YcY7YvTCQbwXsS_KppvfObis9YIKp26FNNmsEl1guaiKt_nWWnwOpg4zX_OKE3TLa7_u7ikdO4kuKaSQ9XfH872z-YUOf5FrvXofhYeZddY-VMqj5BVlQ2Sc1t_moBYXYM-6Z5SFUV0jLJwCR5cEc_FGXrZn-U-Lrx6WaRnWc4ViPtJQos555dM3KHbqhi92KzF_Wmk8awtb3OcjOLRaV80top2DvAPaTF-hVerKbQG89CtAyA1kHTfLH_iDk7gxjuBVzaa-RLoEA509xTKRRwh7_pGuzNY4t0QCUxzqnjbKwY-yebIfNwR6Nu4Bhrhg eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VybmFtZSI6Ikpha2VDbGFyazIiLCJhZG1pbiI6ZmFsc2V9.jTmaqCV-znjBQFeFihC8CfdjXF8h_dBrBuM6WALl7KUHAfgt9zAx5RgKTbMPYT3rmzrnV2_vADmCahYIuwtk4qyL76pKz5jDatneIppdxiuarvbuXCPfjLNFuCi01ND3g8Qw8pkqeoXhsVIPoRpOzNnUtxdS4SUuxosn2ZM5PIJLBiRfCWP-QsiY78uJr_02nzIiaUIqOtZpbc_27rgP7ku6GOfDxuOi7ep4GNKHE941p8jW_l-1olcl94g2M4kGJMWhLHjWk824ujZ9Hd3MhiBirRamnr32wXoPJECFUKEmT2D04OzsFLXxYQ6h7fBG7cgTKnBNoXVoBVaiuys_HQ
[*] GCD:  0x1
[*] GCD:  0xee981bb8fe97f171f216be3bc9b4abd724fe9bef85367fdf5279ca3f5d776d86dca7f267e279799224682b87205d6bfac98693c55312caf2dc74390fb266742780df057652a54298d902bea11efa9dbe5f67e54d5048b422ed7918125d20f8fcc8403cd4ebe20cd7275d1c83a4b056b5767580d272be888e8ffdc38117085b3f7224d9337bc967bad30ecf1a1b83fa368bda1ec1ad8c264f8c1ca51938e0b1a1a55f99d7334ea0c85dda30c675824c48166f848137e3071aefbca56806a970a2a060cf00b1d147df025a8a470b4cfb5626bf51790b3460a325f74d6622459cb1c6f2d0130ef0d2083412838e8c0119391229f87a454f68d2a78dce883673b4d5
[+] Found n with multiplier 1  :
 0xee981bb8fe97f171f216be3bc9b4abd724fe9bef85367fdf5279ca3f5d776d86dca7f267e279799224682b87205d6bfac98693c55312caf2dc74390fb266742780df057652a54298d902bea11efa9dbe5f67e54d5048b422ed7918125d20f8fcc8403cd4ebe20cd7275d1c83a4b056b5767580d272be888e8ffdc38117085b3f7224d9337bc967bad30ecf1a1b83fa368bda1ec1ad8c264f8c1ca51938e0b1a1a55f99d7334ea0c85dda30c675824c48166f848137e3071aefbca56806a970a2a060cf00b1d147df025a8a470b4cfb5626bf51790b3460a325f74d6622459cb1c6f2d0130ef0d2083412838e8c0119391229f87a454f68d2a78dce883673b4d5
[+] Written to ee981bb8fe97f171_65537_x509.pem
[+] Tampered JWT: b'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ICJKYWtlQ2xhcmsxIiwgImFkbWluIjogZmFsc2UsICJleHAiOiAxNjk0NjAxODk4fQ.ByjhLdI2zcuhiIVkSFserK7pyEPKBIN-EOht7DY3hJk'
[+] Written to ee981bb8fe97f171_65537_pkcs1.pem
[+] Tampered JWT: b'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ICJKYWtlQ2xhcmsxIiwgImFkbWluIjogZmFsc2UsICJleHAiOiAxNjk0NjAxODk4fQ.S0W-chTN9V5vVjRnEfI0c1rKjoSm5UPTgXv8kG8-Baw'
================================================================================
Here are your JWT's once again for your copypasting pleasure
================================================================================
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ICJKYWtlQ2xhcmsxIiwgImFkbWluIjogZmFsc2UsICJleHAiOiAxNjk0NjAxODk4fQ.ByjhLdI2zcuhiIVkSFserK7pyEPKBIN-EOht7DY3hJk
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ICJKYWtlQ2xhcmsxIiwgImFkbWluIjogZmFsc2UsICJleHAiOiAxNjk0NjAxODk4fQ.S0W-chTN9V5vVjRnEfI0c1rKjoSm5UPTgXv8kG8-Baw
```

Ở đây ta có tới 2 định dạng public key, vì vậy để biết chương trình dùng dạng nào, ta tạo thử public key qua 2 câu lệnh của challenge:

```bash
$ openssl genrsa -out rsa-or-hmac-2-private.pem 2048
$ openssl rsa -RSAPublicKey_out -in rsa-or-hmac-2-private.pem -out rsa-or-hmac-2-public.pem
```

Ta thấy được định dạng bắt đầu bằng `----BEGIN RSA PUBLIC KEY----` nên chắc mọi người đã biết dùng định dạng gì rồi chứ? (trả lời luôn: PKCS #1)

Cuối cùng là dùng public key từ file `ee981bb8fe97f171_65537_pkcs1.pem` làm như bài 1, ở đây là script của tôi:

```python
import jwt

with open("public_key.pem", "rb") as f:
    pub_key = f.read()

encoded = jwt.encode({"username": "JakeClark", "admin": True}, pub_key, algorithm="HS256")
print(encoded)
```

Flag: `crypto{REDACTED}`

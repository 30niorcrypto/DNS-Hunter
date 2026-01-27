# 🎯 DNS Hunter

**DNS Hunter** is a powerful and lightweight PowerShell script designed to help network researchers and users find "Clean" DNS nodes within a specific subnet. By using multi-threading, it quickly verifies if a DNS server resolves popular domains (like WhatsApp/Meta) without interference or strict filtering.

## 🚀 Key Features
- **Parallel Processing:** Uses `RunspacePool` for high-speed scanning (50 threads).
- **Deep Verification:** Checks against specific IP ranges to ensure the node is truly clean.
- **Minimalist UI:** Clean and colored output for better readability.
- **Zero Dependencies:** Runs natively on Windows PowerShell.

## 💻 How to Run
### Instant Execution (Fastest)
1. No need to download anything! Just copy and paste the following command into your PowerShell and press **Enter**:

```powershell
iex (irm https://raw.githubusercontent.com/30niorcrypto/DNS-Hunter/refs/heads/main/dns_hunter.ps1)
```
2. Enter 3-octet Network Prefix (Sample: `2.188.21` for `2.188.21.0/24` range).

## 👤 Author
Created by **Senior Crypto**
- **X:** [@30niorcrypto](https://x.com/30niorcrypto)

## ⚖️ License
This project is licensed under the MIT License - feel free to use and contribute!





## راهنمای فارسی 

### 🎯 معرفی ابزار DNS Hunter
اسکریپت **DNS Hunter** یک اسکریپت قدرتمند و سبک برای پاورشل (PowerShell) است که به شما کمک می‌کند تا سرورهای DNS را در یک زیرشبکه یا ASN خاص پیدا کنید. این ابزار با استفاده از قابلیت چندرشته‌ای (Multi-threading)، به سرعت بررسی می‌کند که آیا یک سرور DNS می‌تواند دامنه‌های محبوبی مثل واتس‌اپ را بدون دخالت یا فیلترینگ شدید باز کند یا خیر.

### 🚀 ویژگی‌های کلیدی
* **پردازش موازی:** استفاده از `RunspacePool` برای اسکن فوق‌سریع (۵۰ رشته همزمان).
* **تایید عمیق:** بررسی دقیق رنج‌های آی‌پی برای اطمینان از «تمیز» بودن نودها.
* **رابط کاربری ساده:** نمایش خروجی رنگی و مرتب برای خوانایی بهتر.
* **بدون پیش‌نیاز:** به صورت بومی روی تمام نسخه‌های ویندوز پاورشل اجرا می‌شود.

### 💻 روش‌های اجرا

#### روش اول: اجرای سریع (پیشنهادی)
۱. بدون نیاز به دانلود! فقط کافیست دستور زیر را کپی کرده، در محیط پاورشل وارد کنید و کلید **Enter** را بزنید:

```powershell
iex (irm https://raw.githubusercontent.com/30niorcrypto/DNS-Hunter/refs/heads/main/dns_hunter.ps1)
```


۲. سه بخش اول شبکه (Subnet) مورد نظر را وارد کنید (مثال: `2.188.21` برای رنج `2.188.21.0/24`)..

👤 نویسنده
کد از Senior Crypto

ایکس (X): @30niorcrypto


⚖️ لایسنس
این پروژه تحت لایسنس MIT منتشر شده است؛ استفاده و مشارکت در آن برای همه آزاد است.

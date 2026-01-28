# 🎯 Recursive DNS Hunter
**Recursive DNS Hunter** is a high-performance PowerShell tool designed for network researchers to identify "Clean" and functional **Open Resolvers**. Unlike basic scanners, it features advanced **Anti-Poisoning Logic** that goes beyond simple resolution; it analyzes the integrity of DNS responses against verified IP ranges for **X (Twitter)** and **YouTube**. This ensures that the discovered nodes are not just responding, but are acting as genuine, un-sinkholed recursive servers, effectively bypassing DNS-based filtering and deception.


## 🚀 Key Features
- **Anti-Poisoning Logic:** Smart detection and filtering of fake "Sinkhole" IPs from genuine YouTube/X nodes.
- **High-Speed Scanning:** Powered by `RunspacePool` for parallel processing (100 threads) to scan in seconds.
- **Secure DNS Discovery (DoH/TCP):** Scans for clean nodes supporting encrypted DNS over Port 443
- **Flexible Range Support:** Supports single IP, full /24 subnets, or custom subnet ranges (e.g., 2.188.10-20).
- **Zero Dependencies:** Runs natively on Windows PowerShell without any third-party requirements.


## 💻 How to Run
### Instant Execution (Fastest)
No need to download anything! Just copy and paste the following command into your PowerShell and press **Enter**:

```powershell
iex (irm https://raw.githubusercontent.com/30niorcrypto/DNS-Hunter/refs/heads/main/dns_hunter.ps1)
```

## 👤 Author
Created by **Senior Crypto**
- **X:** [@30niorcrypto](https://x.com/30niorcrypto)


## ⚖️ License
This project is licensed under the MIT License - feel free to use and contribute!





## راهنمای فارسی

### 🎯 معرفی ابزار Recursive DNS Hunter
اسکریپت **Recursive DNS Hunter** یک ابزار سریع و سبک تحت PowerShell است که به طور اختصاصی برای شناسایی **Open Resolver**های «تمیز» و بدون اختلال طراحی شده است. 
تفاوت اصلی این ابزار با اسکنرهای معمولی، بهره‌گیری از متد **Anti-Poisoning Logic** است؛ این اسکریپت تنها به دریافت پاسخ از سرور بسنده نمی‌کند، بلکه با تحلیل محتوای پاسخ و تطبیق آن با رنج‌های رسمی **YouTube** و **X (Twitter)**، مطمئن می‌شود که سرور مورد نظر شما یک **Recursive DNS** واقعی است و شما را به تله‌های فیلترینگ (Sinkhole) هدایت نمی‌کند. این ابزار با استفاده از قابلیت چندرشته‌ای (Multi-threading)، به سرعت زیرشبکه‌های ASN را برای یافتن نودهای سالم، آزاد و واقعی اسکن می‌کند.


### 🚀 ویژگی‌های کلیدی
- **منطق ضدِ فریب (Anti-Poisoning):** استفاده از الگوی پیشرفته Regex برای تشخیص DNSهای واقعی.
- **اسکن سریع:** بهره‌گیری از `RunspacePool` برای پردازش موازی (۱۰۰ رشته همزمان) جهت اسکن کامل در چند ثانیه.
- **پیداکردن DNS امن (DoH/TCP):** اسکن نودهای تمیزی که از پروتکل رمزنگاری‌شده روی پورت ۴۴۳ پشتیبانی می‌کنن.
- **پشتیبانی از رنج‌های منعطف:** قابلیت اسکن تک آی‌پی، ساب‌نت‌های کامل (/24) یا رنج‌های سفارشی (مثلاً 2.188.10-20).
- **بدون وابستگی:** اجرای کاملاً بومی (Native) در محیط پاورشل ویندوز بدون نیاز به نصب هیچ ابزار جانبی.


### 💻 روش‌های اجرا

#### اجرای سریع (پیشنهادی)
بدون نیاز به دانلود! فقط کافیست دستور زیر را کپی کرده، در محیط پاورشل وارد کنید و کلید **Enter** را بزنید:

```powershell
iex (irm https://raw.githubusercontent.com/30niorcrypto/DNS-Hunter/refs/heads/main/dns_hunter.ps1)
```

👤 نویسنده

کد از Senior Crypto

ایکس (X): @30niorcrypto


⚖️ لایسنس
این پروژه تحت لایسنس MIT منتشر شده است؛ استفاده و مشارکت در آن برای همه آزاد است.

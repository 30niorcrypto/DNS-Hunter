# 🎯 DNS Hunter

**DNS Hunter** is a powerful and lightweight PowerShell script designed to help network researchers and users find "Clean" DNS nodes within a specific subnet. By using multi-threading, it quickly verifies if a DNS server resolves popular domains (like WhatsApp/Meta) without interference or strict filtering.

## 🚀 Key Features
- **Parallel Processing:** Uses `RunspacePool` for high-speed scanning (50 threads).
- **Deep Verification:** Checks against specific IP ranges to ensure the node is truly clean.
- **Minimalist UI:** Clean and colored output for better readability.
- **Zero Dependencies:** Runs natively on Windows PowerShell.

## 💻 How to Run
### Method 1: Instant Execution (Fastest)
No need to download anything! Just copy and paste the following command into your PowerShell and press **Enter**:

```powershell
iex (irm https://raw.githubusercontent.com/30niorcrypto/DNS-Hunter/refs/heads/main/dns_hunter.ps1)

### Method 2: Manual Execution
1. Download the `dns_hunter.ps1` file.
2. Right-click and select **Run with PowerShell** (or run as Administrator for best results).
3. Enter 3-octet Network Prefix (Sample: 2.188.21 for 2.188.21.0/24 range).

## 👤 Author
Created by **Senior Crypto**
- **X (Twitter):** [@30niorcrypto](https://x.com/30niorcrypto)
- **Goal:** Promoting network freedom and transparency.

## ⚖️ License
This project is licensed under the MIT License - feel free to use and contribute!

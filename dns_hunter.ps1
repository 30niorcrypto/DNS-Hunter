# 🚀 DNS Hunter PRO by Senior Crypto (@30niorcrypto)
& {
    Clear-Host
    $header = @"
****************************************************
     🔥 DNS Hunter - Senior Crypto Edition 🔥    
            Twitter/X: @30niorcrypto                        
****************************************************
"@
    Write-Host $header -ForegroundColor Yellow

    $s = Read-Host "Enter 3-octet Network Prefix (Sample: 2.188.21 for 2.188.21.0/24 range)"
    Write-Host "`nSelect Target to verify clean DNS:" -ForegroundColor White
    Write-Host "1) WhatsApp (Strict Filtering Check)"
    Write-Host "2) Instagram (Meta Subnet Check)"
    Write-Host "3) Custom Domain (Manual Entry)"
    $choice = Read-Host "`nChoose (1-3)"

    switch ($choice) {
        "1" { $target = "whatsapp.com"; $check = "31.13.|57.144.|163.70." }
        "2" { $target = "instagram.com"; $check = "31.13.|57.144.|157.240.|185.60." }
        "3" { 
            $rawDomain = Read-Host "Enter domain (e.g., telegram.org)"
            $target = $rawDomain.Trim()
            $check = "RE_ALL_IPS" # پرچم برای حالت کاستوم
        }
        default { $target = "whatsapp.com"; $check = "31.13.|57.144.|163.70." }
    }

    if ($s) {
        $s = $s.Trim().TrimEnd('.')
        Write-Host "`n🚀 Hunting for Clean DNS in $s.0/24 targeting [$target]..." -ForegroundColor Cyan
        
        $rs = [runspacefactory]::CreateRunspacePool(1, 50)
        $rs.Open()
        $tasks = @()

        foreach ($i in 1..254) {
            $ip = "$s.$i"
            $ps = [powershell]::Create().AddScript({
                param($ip, $target, $check)
                $o = nslookup -timeout=1 $target $ip 2>$null
                
                # جدا کردن بخش پاسخ (خطوط بعد از نام سرور) برای جلوگیری از باگ لیست شدن همه
                $ans = $o | Select-Object -Skip 3
                
                $isClean = $false
                if ($check -eq "RE_ALL_IPS") {
                    # در حالت کاستوم فقط چک میکنیم که پاسخی شامل آی‌پی معتبر داشته باشیم
                    if ($ans -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") { $isClean = $true }
                } else {
                    # در حالت واتس‌اپ و اینستاگرام، رنج آی‌پی رو چک میکنیم
                    if ($ans -match $check) { $isClean = $true }
                }

                if ($isClean) {
                    try { $h = [System.Net.Dns]::GetHostEntry($ip).HostName } catch { $h = "Unknown" }
                    [PSCustomObject]@{ IPAddress = $ip; HostName = $h; Status = "✅ Clean" }
                }
            }).AddArgument($ip).AddArgument($target).AddArgument($check)
            $ps.RunspacePool = $rs
            $tasks += [PSCustomObject]@{ Pipe = $ps; Result = $ps.BeginInvoke() }
        }

        $total = $tasks.Count
        while ($tasks.Result.IsCompleted -contains $false) {
            $done = ($tasks.Result.IsCompleted -eq $true).Count
            Write-Progress -Activity "DNS Hunter by @30niorcrypto" -Status "Hunting: $done/$total" -PercentComplete ([Math]::Round(($done/$total)*100))
            Start-Sleep -Milliseconds 100
        }

        $res = $tasks | ForEach-Object { $_.Pipe.EndInvoke($_.Result) } | Where-Object { $_ -ne $null }
        $rs.Close()

        Write-Host "`n✨ Hunting Finished!" -ForegroundColor Green
        if ($res) {
            Write-Host "Found $($res.Count) clean nodes for $target`n" -ForegroundColor Magenta
            $res | Sort-Object { [version]$_.IPAddress } | Format-Table -AutoSize | Out-Host
            Write-Host "Brought to you by @30niorcrypto" -ForegroundColor DarkGray
        } else {
            Write-Host "❌ No Clean Nodes found for $target in this subnet." -ForegroundColor Red
        }
    }
}

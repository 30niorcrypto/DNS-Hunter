# 🚀 DNS Hunter by Senior Crypto (@30niorcrypto)
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
    if ($s) {
        $s = $s.Trim().TrimEnd('.')
        Write-Host "`n🚀 Scanning $s.0/24 (Strict Filtering Check)..." -ForegroundColor Cyan
        
        $rs = [runspacefactory]::CreateRunspacePool(1, 50)
        $rs.Open()
        $tasks = @()

        foreach ($i in 1..254) {
            $ip = "$s.$i"
            $ps = [powershell]::Create().AddScript({
                param($ip)
                $o = nslookup -timeout=1 whatsapp.com $ip 2>$null
                if ($o -match "Address:" -and ($o -match "31.13." -or $o -match "57.144." -or $o -match "163.70.")) {
                    try {
                        $h = [System.Net.Dns]::GetHostEntry($ip).HostName
                    } catch {
                        $h = "Unknown"
                    }
                    [PSCustomObject]@{
                        IPAddress  = $ip
                        HostName   = $h
                        Status     = "✅ Clean"
                    }
                }
            }).AddArgument($ip)
            $ps.RunspacePool = $rs
            $tasks += [PSCustomObject]@{ Pipe = $ps; Result = $ps.BeginInvoke() }
        }

        $total = $tasks.Count
        while ($tasks.Result.IsCompleted -contains $false) {
            $done = ($tasks.Result.IsCompleted -eq $true).Count
            $per = [Math]::Round(($done / $total) * 100)
            Write-Progress -Activity "DNS Hunter by @30niorcrypto" -Status "Strict Scanning: $done/$total" -PercentComplete $per
            Start-Sleep -Milliseconds 100
        }

        $res = $tasks | ForEach-Object { $_.Pipe.EndInvoke($_.Result) } | Where-Object { $_ -ne $null }
        $rs.Close()

        Write-Host "`n✨ Done!" -ForegroundColor Green
        if ($res) {
            $res | Sort-Object { [version]$_.IPAddress } | Format-Table -AutoSize | Out-Host
            Write-Host "Brought to you by @30niorcrypto" -ForegroundColor DarkGray
        } else {
            Write-Host "❌ No Clean DNS Nodes Found in this Subnet." -ForegroundColor Red
        }
    }
}
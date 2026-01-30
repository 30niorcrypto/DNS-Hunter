#DNS Hunter PRO by Senior Crypto (@30niorcrypto)
& {
    Clear-Host
    $header = @"
****************************************************
     🔥 DNS Hunter - SeniorCrypto Script 🔥    
           Twitter/X: @30niorcrypto                    
****************************************************
"@
    Write-Host $header -ForegroundColor Yellow

    Write-Host "Global DNS Health Check..." -ForegroundColor Cyan
    $globalDNS = @{"Google"="8.8.8.8"; "Cloudflare"="1.1.1.1"; "Quad9"="9.9.9.9"; "OpenDNS"="208.67.222.222"; "Level3"="4.2.2.2"}
    foreach ($name in $globalDNS.Keys) {
        $test = nslookup -timeout=1 google.com $globalDNS[$name] 2>$null
        if ($test -match "Address") { Write-Host "  [+] $name ($($globalDNS[$name])) is WORKING" -ForegroundColor Green }
        else { Write-Host "  [-] $name ($($globalDNS[$name])) is BLOCKED/TIMEOUT" -ForegroundColor Red }
    }
    Write-Host "----------------------------------------------------`n" -ForegroundColor Gray

    Write-Host "Network Prefix Examples:" -ForegroundColor DarkGray
    Write-Host "  2.188        -> Scans 2.188.0.0 to 2.188.255.255" -ForegroundColor DarkGray
    Write-Host "  2.188.21     -> Scans only 2.188.21.0/24 (2.188.21.0 to 2.188.21.255)" -ForegroundColor DarkGray
    Write-Host "  2.188.10-20  -> Scans subnets 10 to 20 (2.188.10.0 to 2.188.20.255)" -ForegroundColor DarkGray
    
    $inputPrefix = Read-Host "`nEnter Network Prefix or Range"
    Write-Host "`nSelect Target to verify clean DNS:" -ForegroundColor Yellow
    Write-Host "1) X / Twitter (Cloudflare Subnet Check)"
    Write-Host "2) YouTube (Google Subnet Check)"
    Write-Host "3) Custom Domain (Manual Entry)"
    $choice = Read-Host "`nChoose (1-3)"

    switch ($choice) {
        "1" { $target = "x.com"; $check = "^104\.(1[6-9]|2[0-3])\.|^172\.(6[4-9]|7[0-1])\.|^108\.162\.|^162\.15[8-9]\." }
        "2" { $target = "youtube.com"; $check = "^142\.25[0-1]\.|^172\.217\.|^172\.253\.|^74\.125\.|^208\.117\." }        
        "3" { $target = (Read-Host "Enter domain (e.g., telegram.org)").Trim(); $check = "CUSTOM" }
    }

    if ($inputPrefix) {
        $prefix = $inputPrefix.Trim().TrimEnd('.')
        $parts = $prefix.Split('.')
        
        $subnets = @()
        if ($parts.Count -eq 3) {
            if ($parts[2] -match '-') {
                $range = $parts[2].Split('-')
                $subnets = [int]$range[0]..[int]$range[1]
                $displayRange = "$($parts[0]).$($parts[1]).[$($parts[2])].x"
            } else {
                $subnets = @([int]$parts[2]); $displayRange = "$prefix.x"
            }
        } elseif ($parts.Count -eq 2) {
            $subnets = 0..255; $displayRange = "$prefix.x.x"
        }

        $mainPrefix = "$($parts[0]).$($parts[1])"
        Write-Host "`nHunting started in $displayRange ... targeting [$target]" -ForegroundColor Cyan
        
        $rs = [runspacefactory]::CreateRunspacePool(1, 100)
        $rs.Open()
        $allTasks = @()
        $totalSubnets = $subnets.Count
        $currentSubnetIdx = 0

        foreach ($s in $subnets) {
            $currentSubnetIdx++
            $subnetTasks = @()
            $subnetPrefix = if ($parts.Count -eq 3 -and $parts[2] -notmatch '-') { $prefix } else { "$mainPrefix.$s" }

            foreach ($i in 1..254) {
                $ip = "$subnetPrefix.$i"
                $ps = [powershell]::Create().AddScript({
                    param($ip, $target, $check)
                    $sw = [System.Diagnostics.Stopwatch]::StartNew()
                    $o = nslookup -timeout=1 $target $ip 2>$null
                    $sw.Stop()
                    if ($null -eq $o -or $o -match "Can't find" -or $o -match "Non-existent") { return $null }

                    $ips = $o | Select-String -Pattern "\b(?:\d{1,3}\.){3}\d{1,3}\b" -AllMatches | ForEach-Object { $_.Matches.Value }
                    $actualAns = $ips | Where-Object { $_ -ne $ip -and $_ -notmatch "^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\." }

                    if ($actualAns) {
                        $isValid = $false
                        if ($check -eq "CUSTOM") { $isValid = $true } 
                        else { if ($actualAns -match $check) { $isValid = $true } }
                        
                        if ($isValid) {
                            return [PSCustomObject]@{ IPAddress = $ip; Status = "Clean"; "Response(ms)" = $sw.ElapsedMilliseconds }
                        }
                    }
                }).AddArgument($ip).AddArgument($target).AddArgument($check)
                $ps.RunspacePool = $rs
                $task = [PSCustomObject]@{ Pipe = $ps; Result = $ps.BeginInvoke(); IP = $ip }
                $subnetTasks += $task; $allTasks += $task
            }

            while ($subnetTasks.Result.IsCompleted -contains $false) {
                $doneInSubnet = ($subnetTasks.Result.IsCompleted -eq $true).Count
                $percent = ($doneInSubnet / 254) * 100
                $statusMsg = if ($totalSubnets -gt 1) { "Subnet $subnetPrefix.x ($currentSubnetIdx/$totalSubnets)" } else { "Subnet $subnetPrefix.x" }
                Write-Progress -Activity "Hunting: $statusMsg" -Status "Checking IP: $subnetPrefix.$doneInSubnet" -PercentComplete $percent
                Start-Sleep -Milliseconds 20
            }
        }

        $res = $allTasks | ForEach-Object { $_.Pipe.EndInvoke($_.Result) } | Where-Object { $_ -ne $null }
        $rs.Close()

        Write-Host "`nPhase 1: Clean DNS Nodes Found!" -ForegroundColor Green
        if ($res) {
            $finalList = $res | Sort-Object { [version]$_.IPAddress } -Unique
            Write-Host "Found $($finalList.Count) clean nodes for $target`n" -ForegroundColor Yellow
            
            $enrichedList = foreach ($node in $finalList) {
                try {
                    $info = Invoke-RestMethod -Uri "https://ipinfo.io/$($node.IPAddress)/json" -TimeoutSec 3 -ErrorAction SilentlyContinue
                    $location = if($info.country){ "$($info.city), $($info.country)" } else { "N/A" }
                    $provider = if($info.org){ $info.org } else { "N/A" }
                } catch {
                    $location = "Error"; $provider = "Error/Private"
                }
                
                [PSCustomObject]@{
                    IPAddress     = $node.IPAddress
                    Status        = $node.Status
                    "Resp(ms)"    = $node."Response(ms)".ToString()
                    Location      = $location
                    Provider      = $provider
                }
            }

            # --- بخش هوشمند برای رنگی کردن تیتر و خروجی فاز ۱ ---
            $tableLines = ($enrichedList | Format-Table -AutoSize | Out-String).Split("`n") | Where-Object { $_.Trim() -ne "" }
            
            for ($i = 0; $i -lt $tableLines.Count; $i++) {
                if ($i -eq 0) { 
                    Write-Host $tableLines[$i] -ForegroundColor Cyan # رنگ تیتر ستون‌ها
                } elseif ($i -eq 1) {
                    Write-Host $tableLines[$i] -ForegroundColor Gray # خط جداکننده
                } else {
                    $line = $tableLines[$i]
                    if ($line -match "Clean") {
                        # رنگی کردن کلمه Clean در هر خط خروجی
                        $line = $line -replace "Clean", "$( [char]27 )[32mClean$( [char]27 )[0m"
                    }
                    Write-Host $line
                }
            }
            # --------------------------------------------------

            Write-Host "`nPhase 2: Hunting for Secure DNS (Port 443/TCP)..." -ForegroundColor Green
            $secureNodes = @()

            foreach ($node in $finalList) {
                Write-Host "  Testing $($node.IPAddress)... " -NoNewline -ForegroundColor Gray
                $checkDNS = nslookup -vc -port=443 -timeout=8 google.com $node.IPAddress 2>$null
                if ($checkDNS -match "Name:\s+google\.com") {
                    Write-Host "Found! (Supporting Secure DNS DoH/TCP)" -ForegroundColor Green
                    $secureNodes += [PSCustomObject]@{ IPAddress = $node.IPAddress; "DoH/TCP" = "Ready"; "Response(ms)" = $node."Response(ms)" }
                } else {
                    Write-Host "Failed (Not supporting Secure DNS DoH/TCP)" -ForegroundColor Red
                }
            }

            if ($secureNodes) {
                Write-Host "`nSecure DNS Servers (Perfect for DoH on Xray! Sample: https://1.2.3.4/dns-query):" -ForegroundColor Yellow
                $secureNodes | Format-Table -AutoSize | Out-String | ForEach-Object {
                    $_ -replace "Ready", "$( [char]27 )[32mReady$( [char]27 )[0m"
                } | Write-Host
            } else {
                Write-Host "`nNo Secure DNS (Port 443) found among clean nodes." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No Clean Nodes found." -ForegroundColor Red
        }
    }
}

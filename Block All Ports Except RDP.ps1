New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Allow RDP" -Direction Outbound -LocalPort 3389 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Block All Ports Except RDP" -Direction Inbound -Action Block -LocalPort 1-3388, 3390-65535 -Protocol TCP
New-NetFirewallRule -DisplayName "seal all port UDP" -DIrection Inbound -Action Block -LocalPort 1-65535 -Protocol UDP

reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DontDisplayLastUserName /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DontDisplayLockedUserId /t REG_DWORD /d 3 /f

reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v EnumerateLocalUsers /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RestrictAnonymousSAM /t REG_DWORD /d 1 /f


reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel /t REG_DWORD /d 3 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f


gpupdate /force

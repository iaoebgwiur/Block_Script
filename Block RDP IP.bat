@echo off
setlocal enabledelayedexpansion

:loop


set tempFile=%cd%\temp.txt


if exist "%tempFile%" del "%tempFile%"


echo Checking event logs for failed login attempts...
wevtutil qe Security "/q:*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and (EventID=4625)]]" /f:text /c:1000 /rd:true | findstr /r /c:"Source Network Address" > "%tempFile%"


for /f "tokens=*" %%A in (%tempFile%) do (
    set line=%%A
    set "line=!line:Source Network Address:=!"
    
    
    set "line=!line: =!"
    set "line=!line:    =!"

    if "!line!"=="" (
        continue
    )

    
    echo !line!

    
    netsh advfirewall firewall show rule name="Block IP !line!" >nul 2>&1
    if errorlevel 1 (
        
        set count=0
        for /f "tokens=*" %%C in (%tempFile%) do (
            echo %%C | findstr /c:"!line!" >nul
            if not errorlevel 1 set /a count+=1
        )

        
        if !count! geq 3 (
            echo Adding IP !line! to firewall blacklist...
            netsh advfirewall firewall add rule name="Block IP !line!" dir=in action=block remoteip=!line! >nul
            echo IP !line! added to blacklist
        ) else (
            echo IP !line! failed login attempts less than 3, skipping blacklist...
        )
    ) else (
        
        echo IP !line! is already blocked, skipping...
    )
)


del "%tempFile%"

timeout /t 1800 /nobreak >nul
goto loop
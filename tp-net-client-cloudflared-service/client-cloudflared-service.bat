@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cls
for /f "tokens=*" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "CYAN=%ESC%[36m"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "YELLOW=%ESC%[33m"
set "RESET=%ESC%[0m"
set "HOSTNAME=mqtt.tungsmd.cloud"
set "LOCAL_PORT=1881"
echo.
echo %CYAN%  Cloudflared TCP Access%RESET%
echo  -------------------------------------------------------------------------------
echo.

:: ============================================================
:: AUTO INSTALL CLOUDFLARED IF NOT FOUND
:: ============================================================
where cloudflared >nul 2>&1
if !errorlevel! neq 0 (
    echo  %YELLOW%[WARN]%RESET%  cloudflared not found. Installing via winget...
    echo.
    winget install Cloudflare.cloudflared
    if !errorlevel! neq 0 (
        echo.
        echo  %RED%[ERROR]%RESET% Install failed. Please install manually:
        echo          winget install Cloudflare.cloudflared
        echo.
        pause
        exit /b 1
    )
    echo.
    echo  %GREEN%[OK]%RESET%    Install complete!
    echo.
) else (
    echo  %GREEN%[OK]%RESET%    cloudflared found.
)

:: Find cloudflared path from registry (works even if PATH is not refreshed)
for /f "tokens=*" %%i in ('powershell -Command "[System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH','User') | ForEach-Object { $_.Split(';') } | ForEach-Object { if (Test-Path \"$_\cloudflared.exe\") { \"$_\cloudflared.exe\" } }" 2^>nul') do set "CF_PATH=%%i"
if "!CF_PATH!"=="" (
    echo  %RED%[ERROR]%RESET% Cannot find cloudflared.exe path.
    pause
    exit /b 1
)
:: ============================================================

echo  %GREEN%[OK]%RESET%    Hostname   : %HOSTNAME%
echo  %GREEN%[OK]%RESET%    Local Port : %LOCAL_PORT%
echo  %GREEN%[OK]%RESET%    Path       : !CF_PATH!
echo.
echo  -------------------------------------------------------------------------------
echo.
echo  %CYAN%[INFO]%RESET%  Checking for existing cloudflared process...
taskkill /f /im cloudflared.exe >nul 2>&1
if !errorlevel! == 0 (
    echo  %YELLOW%[WARN]%RESET%  Existing cloudflared process killed.
) else (
    echo  %CYAN%[INFO]%RESET%  No existing cloudflared process found.
)
echo.
echo  %CYAN%[INFO]%RESET%  Starting Cloudflared TCP Access...
echo.
"!CF_PATH!" access tcp --hostname %HOSTNAME% --url tcp://localhost:%LOCAL_PORT%
echo.
echo  -------------------------------------------------------------------------------
echo.
echo  %RED%[STOP]%RESET%  TCP access stopped.
echo.
endlocal
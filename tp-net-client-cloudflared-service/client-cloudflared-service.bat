@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cls

for /f "tokens=*" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "CYAN=%ESC%[36m"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"

set "HOSTNAME=mqtt.tungsmd.cloud"
set "LOCAL_PORT=1881"

echo.
echo %CYAN%  Cloudflared TCP Access%RESET%
echo  -------------------------------------------------------------------------------
echo.

echo  %GREEN%[OK]%RESET%    Hostname   : %HOSTNAME%
echo  %GREEN%[OK]%RESET%    Local Port : %LOCAL_PORT%
echo.
echo  -------------------------------------------------------------------------------
echo.
echo  %CYAN%[INFO]%RESET%  Starting Cloudflared TCP Access...
echo.

"%~dp0cloudflared.exe" access tcp --hostname %HOSTNAME% --url tcp://localhost:%LOCAL_PORT%

echo.
echo  -------------------------------------------------------------------------------
echo.
echo  %RED%[STOP]%RESET%  TCP access stopped.
echo.
endlocal

@echo off
chcp 65001 >nul
setlocal ENABLEDELAYEDEXPANSION
cls

for /f "tokens=*" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "CYAN=%ESC%[36m"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"

set "HOSTNAME=mqtt.tungsmd.cloud"
set "LOCAL_PORT=1881"

echo %CYAN%[INFO]%RESET% Service: client cloudflared service
echo %CYAN%[INFO]%RESET% Target hostname : %HOSTNAME%
echo %CYAN%[INFO]%RESET% Local bind port : %LOCAL_PORT%
echo.

"%~dp0cloudflared.exe" access tcp --hostname %HOSTNAME% --url tcp://localhost:%LOCAL_PORT%

echo.
echo %RED%[STOP]%RESET% TCP access stopped.
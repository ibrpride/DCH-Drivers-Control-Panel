@echo off
title Install Control Panel
color 02
mode 120,50


echo.
timeout 3 /nobreak >nul
cls
powershell (new-object System.Net.WebClient).DownloadFile('https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcpl.dll','%appdata%\nvcpl.dll')
powershell (new-object System.Net.WebClient).DownloadFile('https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcplui.exe','%appdata%\nvcplui.exe')
reg delete "HKEY_CLASSES_ROOT\Directory\Background\ShellEx\ContextMenuHandlers\NvCplDesktopContext" /f 
reg add "HKCR\Directory\Background\shell\Item0" /v "MUIVerb" /t REG_SZ /d "NVIDIA Control Panel" /f
reg add "HKCR\Directory\Background\shell\Item0" /v "Icon" /t REG_SZ /d "%appdata%\nvcpl.dll,0" /f
reg add "HKCR\Directory\Background\shell\Item0\command" /ve /t REG_SZ /d "%appdata%\nvcplui.exe" /f

echo Disable Store Install Control Panel Notifications

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v DisableStoreNvCplNotifications /t REG_DWORD /d 1 /f
timeout 3 /nobreak >nul

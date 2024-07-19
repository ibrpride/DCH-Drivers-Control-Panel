@echo off
title Installing NVIDIA Control Panel
color 2


echo Installing NVIDIA Control Panel...
echo.

:: Download files with progress indicator
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcpl.dll', '%appdata%\nvcpl.dll')"
echo File 1/2 downloaded.
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcplui.exe', '%appdata%\nvcplui.exe')"
echo File 2/2 downloaded.

:: Set up registry entries
echo Setting up registry entries...
reg delete "HKEY_CLASSES_ROOT\Directory\Background\ShellEx\ContextMenuHandlers\NvCplDesktopContext" /f >nul 2>&1
reg add "HKCR\Directory\Background\shell\Item0" /v "MUIVerb" /t REG_SZ /d "NVIDIA Control Panel" /f >nul 2>&1
reg add "HKCR\Directory\Background\shell\Item0" /v "Icon" /t REG_SZ /d "%appdata%\nvcpl.dll,0" /f >nul 2>&1
reg add "HKCR\Directory\Background\shell\Item0\command" /ve /t REG_SZ /d "%appdata%\nvcplui.exe" /f >nul 2>&1

:: Disable Store Install Control Panel Notifications
echo Disabling Store Install Control Panel Notifications...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v DisableStoreNvCplNotifications /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo Installation complete.
timeout 3 /nobreak >nul

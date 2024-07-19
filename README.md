<p align="center">

  <img src="https://nvidia.wd5.myworkdayjobs.com/wday/cxs/nvidia/NVIDIAExternalCareerSite/sidebarimage/e64d788b7b8d01e4c34e99996322ec00" height="200">


<p align="center">
If you need to install DCH Drivers for some reason and you are in the situation that you do not have the Microsoft Store and you cannot install the control panel for the reason that in the DCH Drivers the Control Panel is not included and its distribution is through the Microsoft Store. This script saves and configures the ContextMenu so you don't have to open nvcplui.exe every time you want to make a modification.
</p>

Installation CMD 📺
---------------
```ruby
powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest "https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/Install.NvidiaControlPanel.bat" -OutFile "$env:temp\NvidiaControlPanel.bat"; Start-process $env:temp\NvidiaControlPanel.bat
```

Launch Command
Stable Branch 📺
---------------
```ruby
irm "https://ibrpride.com/nvcplui" | iex
```


<br>

Installation Manual 🔧
---------------
* First download [nvcplui.exe](https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcplui.exe) and [nvcpl.dll](https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcpl.dll)
* Move the ``.dll`` and ``.exe`` to some folder like ``%appdata%`` for example

Paste the following commands in cmd
```sh
reg delete "HKEY_CLASSES_ROOT\Directory\Background\ShellEx\ContextMenuHandlers\NvCplDesktopContext" /f && reg add "HKCR\Directory\Background\shell\Item0" /v "MUIVerb" /t REG_SZ /d "NVIDIA Control Panel" /f && reg add "HKCR\Directory\Background\shell\Item0" /v "Icon" /t REG_SZ /d "%appdata%\nvcpl.dll,0" /f &&  reg add "HKCR\Directory\Background\shell\Item0\command" /ve /t REG_SZ /d "%appdata%\nvcplui.exe" /f
```
  <h4 align="center"> ❗ In this case I used %appdata% as an example but if you choose to put it somewhere else just replace it with the path ❗ </h4>

<br>

♻️ Revert NvCplDesktopContext
---------------
The batch removes the key from NvCplDesktopContext so that there are not 2 different Items in the ContextMenu, to revert it is as simple as executing the following command
```sh
reg add "HKCR\Directory\Background\ShellEx\ContextMenuHandlers\NvCplDesktopContext" /ve /t REG_SZ /d "{3D1975AF-48C6-4f8e-A182-BE0E08FA86A9}" /f
```


♻️ reverted script to uninstall the NVIDIA Control Panel and remove the related registry entries:
---------------
```
@echo off & title Uninstalling NVIDIA Control Panel & color 4 & echo Uninstalling NVIDIA Control Panel... & echo. & echo Removing registry entries... & reg delete "HKCR\Directory\Background\shell\Item0" /f >nul 2>&1 & echo Enabling Store Install Control Panel Notifications... & reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v DisableStoreNvCplNotifications /f >nul 2>&1 & echo Deleting downloaded files... & del "%appdata%\nvcpl.dll" >nul 2>&1 & del "%appdata%\nvcplui.exe" >nul 2>&1 & echo. & echo Uninstallation complete. & timeout 3 /nobreak >nul
```

<br>

❔ What's behind the script
---------------
The batch downloads a folder containing what is needed to run the Control Panel (``nvcplui.exe`` and ``nvcpl.dll``), then a Key is created in ``HKCR\Directory\Background\shell`` to appear on the desktop when you right click on it.


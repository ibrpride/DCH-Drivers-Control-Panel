<#
.SYNOPSIS
Installs NVIDIA Control Panel and sets up necessary registry entries.

.DESCRIPTION
This script downloads the NVIDIA Control Panel files, sets up registry entries, and disables Store install notifications for the Control Panel. It checks for administrator privileges and prompts the user for confirmation before applying changes.

.LINK
https://ibrpride.com

.NOTES
Author: Ibrahim
Website: https://ibrpride.com
Script Version: 1.0
Last Updated: July 2024
#>

# Check if the script is running as an admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Relaunch as an administrator
    Start-Process powershell.exe -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File "{0}"' -f $MyInvocation.MyCommand.Definition) -Verb RunAs
    exit
}

# Function to set console properties
function Set-ConsoleProperties {
    $Host.UI.RawUI.WindowTitle = "Installing NVIDIA Control Panel"
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
    Write-Host "Installing NVIDIA Control Panel..."
    Write-Host
}

# Function to download a file with progress indicator
function Download-File {
    param (
        [Parameter(Mandatory = $true)]
        [string]$url,
        [Parameter(Mandatory = $true)]
        [string]$destination,
        [Parameter(Mandatory = $true)]
        [string]$description
    )
    Write-Host "Downloading $description..."
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url, $destination)
    Write-Host "$description downloaded."
}

# Function to set up registry entries
function Setup-RegistryEntries {
    Write-Host "Setting up registry entries..."
    Start-Process reg.exe -ArgumentList "delete `""HKEY_CLASSES_ROOT\Directory\Background\ShellEx\ContextMenuHandlers\NvCplDesktopContext`" /f" -NoNewWindow -Wait -ErrorAction SilentlyContinue
    Start-Process reg.exe -ArgumentList "add `""HKEY_CLASSES_ROOT\Directory\Background\shell\Item0`" /v MUIVerb /t REG_SZ /d `""NVIDIA Control Panel`" /f" -NoNewWindow -Wait
    Start-Process reg.exe -ArgumentList "add `""HKEY_CLASSES_ROOT\Directory\Background\shell\Item0`" /v Icon /t REG_SZ /d `""$env:APPDATA\nvcpl.dll,0`" /f" -NoNewWindow -Wait
    Start-Process reg.exe -ArgumentList "add `""HKEY_CLASSES_ROOT\Directory\Background\shell\Item0\command`" /ve /t REG_SZ /d `""$env:APPDATA\nvcplui.exe`" /f" -NoNewWindow -Wait
}

# Function to disable store install control panel notifications
function Disable-StoreNotifications {
    Write-Host "Disabling Store Install Control Panel Notifications..."
    Start-Process reg.exe -ArgumentList "add `""HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak`" /v DisableStoreNvCplNotifications /t REG_DWORD /d 1 /f" -NoNewWindow -Wait
}

# Main script execution
Set-ConsoleProperties

# Filenames for the downloaded files
$file1 = "$env:APPDATA\nvcpl.dll"
$file2 = "$env:APPDATA\nvcplui.exe"

Download-File -url "https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcpl.dll" -destination $file1 -description "File 1/2"
Download-File -url "https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcplui.exe" -destination $file2 -description "File 2/2"

Setup-RegistryEntries
Disable-StoreNotifications

Write-Host
Write-Host "Installation complete." -ForegroundColor Green
Start-Sleep -Seconds 3

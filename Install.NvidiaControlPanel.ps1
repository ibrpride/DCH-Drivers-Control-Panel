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
    $Host.UI.RawUI.WindowTitle = "Installing NVIDIA Control Panel | IBRPRIDE"
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Black"
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
    Remove-Item -Path "HKCR:\Directory\Background\ShellEx\ContextMenuHandlers\NvCplDesktopContext" -Force -ErrorAction SilentlyContinue
    New-Item -Path "HKCR:\Directory\Background\shell\Item0" -Force
    Set-ItemProperty -Path "HKCR:\Directory\Background\shell\Item0" -Name "MUIVerb" -Value "NVIDIA Control Panel"
    Set-ItemProperty -Path "HKCR:\Directory\Background\shell\Item0" -Name "Icon" -Value "$env:APPDATA\nvcpl.dll,0"
    New-Item -Path "HKCR:\Directory\Background\shell\Item0\command" -Force
    Set-ItemProperty -Path "HKCR:\Directory\Background\shell\Item0\command" -Name "(default)" -Value "$env:APPDATA\nvcplui.exe"
}

# Function to disable store install control panel notifications
function Disable-StoreNotifications {
    Write-Host "Disabling Store Install Control Panel Notifications..."
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" -Name "NVTweak" -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" -Name "DisableStoreNvCplNotifications" -Value 1
}

# Main script execution
Set-ConsoleProperties

Download-File -url "https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcpl.dll" -destination "$env:APPDATA\nvcpl.dll" -description "File 1/2"
Download-File -url "https://github.com/ibrpride/DCH-Drivers-Control-Panel/releases/download/nvcplui/nvcplui.exe" -destination "$env:APPDATA\nvcplui.exe" -description "File 2/2"

Setup-RegistryEntries
Disable-StoreNotifications

Write-Host
Write-Host "Installation complete." -ForegroundColor Green
Start-Sleep -Seconds 3

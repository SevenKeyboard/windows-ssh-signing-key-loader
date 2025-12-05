@echo off
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0ssh-signing-startup\load-ssh-signing-key.ps1" --startup-hidden
exit /b
@echo off
msiexec /i "%WINDIR%\Setup\Files\7z2301-x64.msi" /passive
"%WINDIR%\Setup\Files\npp.8.6.Installer.x64" /S
rd /q /s "%WINDIR%\Setup\Files"
del /q /f "%0"

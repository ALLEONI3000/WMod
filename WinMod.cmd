::   ::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::   ~  WinMod Creator v.2.0    by Alfonso Leoni Dicembre 2023   ~  
::   ::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@echo off & color 0a 
setlocal EnableExtensions EnableDelayedExpansion
title  Windows Mod Creator 
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set "param=%~f0"
cmd /v:on /c echo(^^!param^^!| findstr /R "[| ` ~ ! @ %% \^ & ( ) \[ \] { } + = ; ' , |]*^"
if %errorlevel% EQU 0 (
echo.
echo ==== ERRORE ====
echo Caratteri speciali non consentiti rilevati nel nome del percorso del file.
echo Assicurati che il percorso non contenga i seguenti caratteri speciali
echo ^` ^~ ^! ^@ %% ^^ ^& ^( ^) [ ] { } ^+ ^= ^; ^' ^,
echo.
echo Press any key to exit.
pause >nul
goto :eof
)
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c 
echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if not "%cd%"=="%cd: =%" (
	echo.=========================================================
	echo.La directory corrente contiene spazi nel suo percorso.
	echo.
	echo.Esempio Errato: Win Mod
	echo.Esempio Giusto: WinMod
	echo.
	echo.Devi correggere ok!
	echo.=========================================================
	echo.
	pause>nul|set /p=premi un tasto qualsiasi per continuare...
	endlocal
	exit
)
cls
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd /D "%~dp0" >nul
::####################################
set IsoName=WinMod
set IsoLabel=WinMod
::####################################
set IsoExtract=%~dp0IsoExtract
set WimMounted=%~dp0WimMounted
set BootMounted=%~dp0BootMounted
set Bin=%~dp0Bin
set Temp=%~dp0Temp
set ISO=%~dp0ISO
set Wimlib=%Bin%\wimlib-imagex.exe
set InstallWim=%IsoExtract%\sources\install.wim
set InstallWim2=%IsoExtract%\sources\install2.wim
set BootWim=%IsoExtract%\sources\boot.wim
set BootWim2=%IsoExtract%\sources\boot2.wim
set "CustomRegistry=RegFile"

::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for /f "tokens=* delims=" %%a in ('reg query "HKLM" ^| findstr "{"') do (
	reg unload "%%a" >nul 2>&1
)
reg unload HKLM\AL_COMPONENTS >nul 2>&1
reg unload HKLM\AL_DRIVERS >nul 2>&1
reg unload HKLM\AL_DEFAULT >nul 2>&1
reg unload HKLM\AL_NTUSER >nul 2>&1
reg unload HKLM\AL_SCHEMA >nul 2>&1
reg unload HKLM\AL_SOFTWARE >nul 2>&1
reg unload HKLM\AL_SYSTEM >nul 2>&1
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Eseguo la pulizia necessaria...
dism /unmount-image /mountdir:%WimMounted% /discard >nul 
dism /unmount-image /mountdir:%BootMounted% /discard >nul 
if exist "%WimMounted%" rd "%WimMounted%" /s /q 
if exist "%BootMounted%" rd "%BootMounted%" /s /q 
if exist "%IsoExtract%" rd "%IsoExtract%" /s /q 
timeout /t 3 /nobreak > nul
cls
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set DriveLetter=
set /p DriveLetter=Inserisci la lettera dell'unita per l'immagine di Windows: 
CLS
set "DriveLetter=%DriveLetter%:"
if not exist "%IsoExtract%" md %IsoExtract%
echo Copia dell'immagine di Windows dall'unita %DriveLetter%
xcopy.exe /E /I /H /R /Y /J %DriveLetter% %IsoExtract% >nul
echo Copia Completata!
timeout /t 2 /nobreak > nul
cls

if not exist "%BootMounted%" md %BootMounted%

dism /mount-image /imagefile:%BootWim% /index:2 /mountdir:%BootMounted%

for /l %%i in (1, 1, 50) do (
icacls %BootMounted%\sources\background.bmp /grant Administrators:F /T /C
takeown /f %BootMounted%\sources\background.bmp
if exist %BootMounted%\sources\background.bmp del /f /q %BootMounted%\sources\background.bmp 

icacls %BootMounted%\sources\spwizimg.dll /grant Administrators:F /T /C
takeown /f %BootMounted%\sources\spwizimg.dll
if exist %BootMounted%\sources\spwizimg.dll del /f /q %BootMounted%\sources\spwizimg.dll
copy /y Bin\img\background.bmp %BootMounted%\sources\background.bmp >nul
copy /y Bin\spwizimg.dll %BootMounted%\sources\spwizimg.dll >nul
cls
)
dism /unmount-image /mountdir:%BootMounted% /commit
timeout /t 2 /nobreak > nul
Dism /Export-Image /SourceImageFile:%BootWim% /SourceIndex:2 /DestinationImageFile:%BootWim2% /compress:max /CheckIntegrity
timeout /t 5 /nobreak > nul
del %BootWim%
timeout /t 5 /nobreak > nul
ren %BootWim2% boot.wim
timeout /t 2 /nobreak > nul
cls
echo
echo.================================================================================
echo                              Ottimizzazione Wim
echo.================================================================================
echo.
"%Wimlib%" optimize "%BootWim%"
rd "%BootMounted%" /s /q
cls
timeout /t 3 /nobreak > nul
dism /Get-WimInfo /wimfile:%IsoExtract%\sources\install.wim
set index=
set /p index=Inserisci l'indice dell'immagine:
set "index=%index%"
echo.
if not exist "%WimMounted%" md %WimMounted% 
if exist %Temp% rd %Temp% /s /q 
dism /mount-image /imagefile:%IsoExtract%\sources\install.wim /index:%index% /mountdir:%WimMounted%
echo.
copy /y %Bin%\MCW10.cmd %WimMounted%\Users\Default\Desktop\MCW10.cmd >nul
cls
echo.================================================================================
echo                        Creazione della Mod di Windows...
echo.================================================================================
for /l %%i in (1, 1, 50) do (
takeown /f %WimMounted%\Windows\Resources\Themes\dark.theme
icacls %WimMounted%\Windows\Resources\Themes\dark.theme /grant Administrators:F /T /C
del /f /q /s "%WimMounted%\Windows\Resources\Themes\dark.theme"
copy /y Bin\img\img20.jpg %WimMounted%\Windows\Web\Wallpaper\Windows\img20.jpg >nul
copy /y Bin\dark.theme %WimMounted%\Windows\Resources\Themes\dark.theme >nul

rd "%WimMounted%\Program Files (x86)\Microsoft\Edge" /s /q
rd "%WimMounted%\Program Files (x86)\Microsoft\EdgeUpdate" /s /q
takeown /f %WimMounted%\Windows\System32\OneDriveSetup.exe
icacls %WimMounted%\Windows\System32\OneDriveSetup.exe /grant Administrators:F /T /C
del /f /q /s "%WimMounted%\Windows\System32\OneDriveSetup.exe"
cls
)
if not exist %Temp%\%CustomRegistry% md %Temp%\%CustomRegistry%
timeout /t 2 /nobreak > nul
cls
echo.================================================================================
echo                          Rimozione Applicazioni
echo.================================================================================
echo.
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PowerShell -Executionpolicy Bypass -File RP.ps1 
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~~11.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-Kernel-LA57-FoD-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-LanguageFeatures-Handwriting-it-it-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-LanguageFeatures-OCR-it-it-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-LanguageFeatures-Speech-it-it-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-LanguageFeatures-TextToSpeech-it-it-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-TabletPCMath-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-Windows-Wallpaper-Content-Extended-FoD-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:OpenSSH-Client-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
dism /image:%WimMounted% /Remove-Package /PackageName:Microsoft-OneCore-ApplicationModel-Sync-Desktop-FOD-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cls
echo.================================================================================
echo                       Attivazione .NET Framework 3.5
echo.================================================================================
echo.
DISM /Image:%WimMounted% /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:%IsoExtract%\sources\sxs
timeout /t 2 /nobreak > nul
cls
echo.================================================================================
echo                 Integrazione Chiavi di registro Personalizzate
echo.================================================================================
echo.
timeout /t 2 /nobreak > nul
reg load HKLM\AL_COMPONENTS "%WimMounted%\Windows\System32\config\COMPONENTS" >nul
reg load HKLM\AL_DEFAULT "%WimMounted%\Windows\System32\config\default" >nul
reg load HKLM\AL_NTUSER "%WimMounted%\Users\Default\ntuser.dat" >nul
reg load HKLM\AL_SOFTWARE "%WimMounted%\Windows\System32\config\SOFTWARE" >nul
reg load HKLM\AL_SYSTEM "%WimMounted%\Windows\System32\config\SYSTEM" >nul

PowerShell -Executionpolicy Bypass -File "%Bin%\RegConv.ps1" "%CustomRegistry%" "%Temp%\RegFile"
for /f "tokens=*" %%i in ('"dir /b "%Temp%\RegFile\*.reg"" 2^>nul') do (
echo.Integrazione di [%%i] al registro delle immagini
call :ImportaRegistro "%Temp%\RegFile\%%i"

)
echo.================================================================================
echo                 Integrazione Chiavi di registro di Default
echo.================================================================================
timeout /t 2 /nobreak > nul
Reg add "HKLM\AL_DEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_DEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins" /t REG_SZ /d "{\"pinnedList\": [{}]}" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v AllItemsIconView /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\AL_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v AllItemsIconView /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\AL_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v StartupPage /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\AL_NTUSER\Software\Microsoft\Windows\CurrentVersion\Themes" /v "CurrentTheme" /t REG_SZ /d "C:\Windows\resources\Themes\dark.theme" /f >nul 2>&1
reg add "HKLM\AL_NTUSER\Software\Microsoft\Windows\CurrentVersion\Themes\HighContrast" /v "Pre-High Contrast Scheme" /t REG_SZ /d "C:\Windows\resources\Themes\dark.theme" /f >nul 2>&1
reg add "HKLM\AL_NTUSER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\AL_NTUSER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_DEFAULT\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_NTUSER\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Microsoft\Windows Security Health\State" /v "AppAndBrowser_StoreAppsSmartScreenOff" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f >nul 2>&1
Reg add "HKLM\AL_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f >nul 2>&1


echo.
timeout /t 2 /nobreak > nul
for /f "tokens=* delims=" %%a in ('reg query "HKLM" ^| findstr "{"') do (
	reg unload "%%a" >nul 2>&1
)
reg unload HKLM\AL_COMPONENTS >nul 2>&1
reg unload HKLM\AL_DRIVERS >nul 2>&1
reg unload HKLM\AL_DEFAULT >nul 2>&1
reg unload HKLM\AL_NTUSER >nul 2>&1
reg unload HKLM\AL_SCHEMA >nul 2>&1
reg unload HKLM\AL_SOFTWARE >nul 2>&1
reg unload HKLM\AL_SYSTEM >nul 2>&1
timeout /t 2 /nobreak > nul
echo.
timeout /t 2 /nobreak > nul
dism /unmount-image /mountdir:%WimMounted% /commit
timeout /t 2 /nobreak > nul
Dism /Export-Image /SourceImageFile:%IsoExtract%\sources\install.wim /SourceIndex:%index% /DestinationImageFile:%IsoExtract%\sources\install2.wim /compress:max /CheckIntegrity
timeout /t 2 /nobreak > nul
del %IsoExtract%\sources\install.wim
timeout /t 1 /nobreak > nul
ren %IsoExtract%\sources\install2.wim install.wim
timeout /t 3 /nobreak > nul
echo.================================================================================
echo                              Ottimizzazione Wim
echo.================================================================================
echo.
"%Wimlib%" optimize "%InstallWim%"
if exist "%Temp%\RegFile" rd "%Temp%\RegFile" /s /q >nul

copy /y %Bin%\icon.ico %IsoExtract%\sources\icon.ico >nul
copy /y %Bin%\autorun.inf %IsoExtract%\autorun.inf >nul
copy /y %Bin%\autounattend.xml %IsoExtract%\autounattend.xml >nul
copy /y %Bin%\ei.cfg %IsoExtract%\sources\ei.cfg >nul
xcopy.exe /E /I /H /R /Y /J %Bin%\$OEM$ %IsoExtract%\sources\$OEM$ >nul
timeout /t 2 /nobreak > nul
echo.
echo Eseguo la pulizia necessaria...
if exist %WimMounted% rd %WimMounted% /s /q 
if exist "%BootMounted%" rd "%BootMounted%" /s /q 
if exist %Temp% rd %Temp% /s /q 
if not exist %ISO% md %ISO%
timeout /t 3 /nobreak > nul
echo.
cls
echo.================================================================================
echo                         Creazione della tua ISO Mod
echo.================================================================================
echo.
%Bin%\oscdimg.exe -m -o -u2 -udfver102 -l%isolbel% -bootdata:2#p0,e,b%IsoExtract%\boot\etfsboot.com#pEF,e,b%IsoExtract%\efi\microsoft\boot\efisys.bin %IsoExtract% %ISO%\%isoname%.iso >nul
timeout /t 2 /nobreak > nul
if exist %IsoExtract% rd %IsoExtract% /s /q 
:ImportaRegistro
reg import "%~1"
goto :eof
endlocal
exit
@echo off
rem ------------------------
rem AUTOCLEAN-STARTCLEAN.BAT
rem ------------------------
chcp 65001

:: BatchGotAdmin 
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

color 4f
    mode 100,35
	title CleanTech: Start Clean
 
    SETLOCAL EnableDelayedExpansion
	
	cls
	
	set horiz_line=-
	set dash=-
	
	for /L %%i in (0,1,88) do (
		set horiz_line=-!horiz_line!
	)
	
	echo %horiz_line%
	echo TechTutor's Clean Up Script - Start Clean
	echo %horiz_line%
	echo,

	echo Command running: set workingdir=c:%HOMEPATH%\Desktop\CleanTechTemp
	set workingdir=c:%HOMEPATH%\Desktop\CleanTechTemp
	echo Command running: cd %workingdir%
	cd %workingdir%
	echo,

	:boottimer
		title CleanTech: BootTimer
		echo Press any key when BootTimer has reported its number.
		echo DO NOT close the BootTimer dialog box yet!
		rem timeout 15
		rem echo Taking back the foreground...
		rem ADD test for BootTimer.exe or w/e
		rem tasklist /FI "IMAGENAME eq BootTimer.exe" 2>NUL | find /I /N "myapp.exe">NUL
		rem if "%ERRORLEVEL%"=="0" echo Program is running
		rem MIGHT actually need sysexp to test this (if ERRORLEVEL==0 when testing for WindowName then kill process)
		rem	@For /f "Delims=:" %A in ('tasklist /v /fi "WINDOWTITLE eq WINDOWS BOOT TIME UTILITY"') do @if %A==INFO echo Prog not running
		pause
		%workingdir%/nircmd/nircmd win settopmost title "CleanTech: Boottimer" 1
		echo Grabbing number from dialog box...
		echo Command running: %workingdir%\sysexp.exe /title "WINDOWS BOOT TIME UTILITY" /class Static /stext "%workingdir%\%1-%2-%3-BootTimer.txt"
		%workingdir%\sysexp.exe /title "WINDOWS BOOT TIME UTILITY" /class Static /stext "%workingdir%\%1-%2-%3-BootTimer.txt"
		echo,
		pause
		taskkill /im BootTimer.exe /t
		reg delete HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run /v WinBooter /f
		pause
		echo Killing BootTimer.exe's chrome process
		taskkill /im chrome.exe /f
		pause
		echo Killing BootTimer.exe's command window
		taskkill /FI "WINDOWTITLE eq %workingdir%\BootTimer.exe"
		cls & color 1f

	title CleanTech: Start Clean
	:echostrings
	echo -----------------------
	echo Client Info:
	echo Last Name: %1
	echo First name: %2
	echo Date: %3
	echo AV needed?: %4
	echo -----------------------
	echo,

	pause & color 6f

	echo if EXIST autoclean-adw goto :pcd
	pause
	if EXIST autoclean-adw goto :pcd
	echo if EXIST autoclean-startclean goto :adw
	pause
	if EXIST autoclean-startclean goto :adw
	
	:noflagfile
	color 1f
	echo at :noflagfile
	echo copy /y NUL autoclean-startclean >NUL
	echo,
	copy /y NUL autoclean-startclean >NUL
	pause
	goto adw

	:adw
	echo At :adw
	echo Launching ADWCLeaner... NOTE: Will request reboot after a clean.
	echo Command: move %workingdir%\Tron\tron\resources\stage_9_manual_tools\adwcleaner*.exe %workingdir%\adwcleaner.exe
	move %workingdir%\Tron\tron\resources\stage_9_manual_tools\adwcleaner*.exe %workingdir%\adwcleaner.exe


	echo Command: START "" /WAIT %workingdir%\adwcleaner.exe
	START "" /WAIT %workingdir%\adwcleaner.exe
	echo,
	copy /y NUL autoclean-adw >NUL

	:pcd
	echo Command running: del autoclean-adw
	del autoclean-adw
	echo,

	echo Launching PC Decrapifier.....
	echo START "" /WAIT "%workingdir%\pc-decrapifier.exe"
	START "" /WAIT "%workingdir%\pc-decrapifier.exe"
	color 6f
	echo ---------------------------------------------------------
	echo Please use PC Decrapifier to analyze and remove bloatware
	echo ---------------------------------------------------------
	pause
	color 1f

	rem Removing autoclean-start flag file
	echo del autoclean-startclean
	echo,
	del autoclean-startclean

	rem Swapping startup batch files
	echo del "C:%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-startcleantemp.bat"
	del "C:%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-startcleantemp.bat"

	echo Comand running: echo %workingdir%\autoclean-tron.bat %1 %2 %3 %4>C:\autoclean-trontemp.bat
	echo %workingdir%\autoclean-tron.bat %1 %2 %3 %4>C:\autoclean-trontemp.bat
	echo Command running: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe,c:\autoclean-trontemp.bat" /f
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe,c:\autoclean-trontemp.bat" /f
	pause

	bcdedit /set {default} safeboot network

	color 6f
	echo --------------------
	echo Preparing to reboot.
	echo -------------------- 
	echo,
	echo If tron does not start after reboot,
	echo please launch Tron using autoclean-tron.bat
	echo from the CleanTechTemp directory on the Desktop
	echo,
	pause

	shutdown /r /t 0
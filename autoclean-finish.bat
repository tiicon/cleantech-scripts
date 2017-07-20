rem --------------------
rem AUTOCLEAN-FINISH.BAT
rem --------------------
rem test del %homedir%/desktop/techtutors/ command

set workingdir=C:\%USERPATH%\Desktop\techtemp\
echo cd %workingdir% 
cd %workingdir%

	set lastname=%1
	set firstname=%2
	set FormattedDate=%3
	echo Testing strings...
	echo Last Name: %lastname%
	echo First name: %firstname%
	echo Date: %FormattedDate%
	echo,

echo copy /y NUL autoclean-finish >NUL
echo,
copy /y NUL autoclean-finish >NUL

@echo off
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

color 1f
    mode 90,35
	title TechTutor's Clean Up Script - Finish Up
 
    SETLOCAL EnableDelayedExpansion
	
	cls
	
	set horiz_line=-
	set dash=-
	
	for /L %%i in (0,1,88) do (
		set horiz_line=-!horiz_line!
	)
	
	echo %horiz_line%
	echo TechTutor's Clean Up Script - Finish Up
	echo %horiz_line%
	echo,
	
	echo Moving Log files
	echo,
	
	echo move C:\Logs 

	echo Removing cleanup files...
	echo,
	
	echo [93mrmdir %workingdir%[97m
	rmdir %workingdir% /s /q
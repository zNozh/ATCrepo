:: ATC Updater BETA
:: Dependency
@echo off
IF EXIST gitstall (
    set pull=1
) ELSE (
    set pull=0
)
	
powershell wget https://raw.githubusercontent.com/zNozh/ATCrepo/master/version.txt -OutFile fversion.txt
set /p version=<version.txt
set /p fversion=<fversion.txt

IF %fversion% NEQ %version% (
  goto checker
) ELSE (
  :exit
  echo No update needed.
  pause
  exit
)
:checker
IF %fversion% GEQ %version% (
    echo ATC Updater:
    echo New version: %fversion%
    echo You are using: %version%
    echo.
    echo 1 - Update
    echo 2 - Exit
    set /p choice=Enter: 
) ELSE (
  goto exit
)

if %choice% == 1 (
  goto update
)else (
  exit
)

:update

:: Destroy 
del /F /Q ATC.bat
del /F /Q ATC/default/
del /F /Q nzhspec
del /F /Q specular.exe

:: Check if repository has been previously cloned.
if %pull% == 0 (
    git clone https://github.com/zNozh/ATCrepo temp
    move temp/.git %~dp0/.git
    rm -rf temp
    echo. > gitstall
    git pull https://github.com/zNozh/ATCrepo
) ELSE (
    git pull https://github.com/zNozh/ATCrepo
)
cls
echo ATC Updated
echo You may start ATC now.
pause
exit
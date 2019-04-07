@echo off

:: Update variables
:: fversion means FETCHED version...
powershell wget https://raw.githubusercontent.com/zNozh/ATCrepo/master/version.txt -OutFile fversion.txt
set /p version=<version.txt
set /p fversion=<fversion.txt

if %fversion% NEQ %version% (
  if %fversion% GEQ %version% (
    echo ATC Prompt:
    echo New update available!
    echo New version: %fversion%
    echo You are using: %version%
    echo Please run ATCupdater.bat when you are ready
    pause>nul
  )
)

:: Folder permissions
chmod -R 777 ATC

:: Window properties
color 04
title Advanced Texture Changer

:: Menu
:choser
cls
echo ATC
echo By Nozh
echo Make sure this is in the root of your Redacted BO2 directory
echo As well as the ATC folder, this folder contains dependencies.
echo.
echo 1) Tritium (DSR red ring for example)
echo 2) Specular
echo 3) Reshade
echo 4) Reload/Open BO2
echo 5) Exit
set choice=Xlz0
set /p choice=Option:

:: Validator
set isvalid=false
if %choice% == 1 set isvalid=true
if %choice% == 2 set isvalid=true
if %choice% == 3 set isvalid=true
if %choice% == 4 set isvalid=true
if %choice% == 5 set isvalid=true

if %isvalid% NEQ true (
    echo Invalid option
    pause
    goto choser
) else (
    goto verification
)
:verification
    if %choice% == 1 goto Tritium
    if %choice% == 2 goto specular
    if %choice% == 3 goto reshade
    if %choice% == 4 goto reloadbo2 
    if %choice% == 5 exit

:reshade
cls
echo ReShade
echo 1) Disable Reshade
echo 2) Enable Reshade
echo 3) Return to menu
echo 4) Reload/Open BO2
set /p rsop=Option:
if %rsop% == 1 (
  ren dxgi.dll dxgi.dll.atc
  echo Finished
  pause
  goto reshade
) else if %rsop%  == 2 (
  ren dxgi.dll.atc dxgi.dll
  echo Finished
  pause
  goto reshade
) else if %rsop% == 3 (
  goto choser
) else if %rsop% == 4 (
  goto reloadbo2
)
::Specular
:specular
cls
echo ATC
echo Customizer for BO2
echo [ Specular Customizer ]
echo Speculars for everything, the list of images this tool effects have been stored in:
echo nzhspc/spclist.txt
echo.
echo 1) Modify Specular Intensity
echo 2) Start Specular Tool
echo 3) Return to menu
echo 4) Reload/Open BO2
echo.
set /p schoice=Option:
set issvalid=false
if %schoice% == 1 (
  set issvalid=true
  goto mspec
)
if %schoice% == 2 (
  set issvalid=true
  echo Starting...
  specular.exe
)
if %schoice% == 3 (
  set issvalid=true
  goto choser
)
if %schoice% == 4 (
  set issvalid=true
  goto reloadbo2
)

:: Specular intensity
:mspec
cls
echo Specular intensity
echo -100 - 100 Intensity
set /p specAmount=Percentage:
magick convert nzhspc\org.png -brightness-contrast %specAmount% nzhspc\blank.png
cls
echo Finished
pause
goto specular

:: Tritium Menu
:Tritium
set %whereIbe%=Tritium
set %TritiumFN%=Unset
set %TritiumChoice%=Unset
cls
echo ATC
echo Customizer for BO2
echo [ Tritium Customizer ]
echo.
echo 1) New tritium
echo 2) Load Preset
echo 3) Return to menu
echo 4) Reload/Open BO2
echo 5) Purge tritium
echo.
set /p TritiumChoice=Choose an option:
set isvalid=false

if %TritiumChoice% == 1 (
    set isvalid=true
    goto tnew
)
if %TritiumChoice% == 2 (
    set isvalid=true
    goto tpreset
)
if %TritiumChoice% == 3 (
    set isvalid=true
    goto choser
)
if %TritiumChoice% == 4 (
    set isvalid=true
    goto reloadbo2
)
if %TritiumChoice% == 5 (
    set isvalid=true
    goto purgeTritium
)
if %isvalid% NEQ true (
    echo Invalid option
    pause
    goto Tritium
)

:: Load tritium
:tpreset
echo ATC
echo By Nozh
echo Put 1 instead of a preset name to return to menu
echo Put 2 instead of a preset name to exit
echo.
echo Presets available:
for /r %%i in (ATC/configs/*.bat) do (
  echo %%~ni
)
echo.
set /p tpload=Preset/menu:

if %tpload% == 1 goto Tritium
if %tpload% == 2 exit

call ATC\configs\%tpload%.bat

cd ATC
for /r %%i in (default/*.png) do (
  magick convert "%cd%\default\%%~nxi" -colorize %tpred%,%tpgreen%,%tpblue% -set option:modulate:colorspace hsb -modulate 100,170 "%~dp0/data/images/%%~nxi"
)
cd ..
echo Finished
pause
goto Tritium

:: New tritium
:tnew
cls
echo ATC
echo By Nozh
echo [RECOMMEND:] RGB PICKER HERE:
echo https://www.colorspire.com/rgb-color-wheel/
echo.
echo Make a new tritium:

set /p tred=Amount RED:
set /p tgreen=Amount GREEN:
set /p tblue=Amount BLUE:
echo Save as preset
echo 1) Yes
echo 2) No
set /p tin=Input:

:ttask
cd ATC
for /r %%i in (default/*.png) do (
  magick convert "%cd%\default\%%~nxi" -colorize %tred%,%tgreen%,%tblue% -set option:modulate:colorspace hsb -modulate 100,170 "%~dp0/data/images/%%~nxi"
)

cls
cd ..
IF %tin% == 1 goto tsave
echo Finished
pause
goto Tritium

:tsave
cls 
echo Preset saver
echo All presets will be saved in ATC/configs/
echo.
set /p tname=Preset name:
echo @echo off >> ATC/configs/%tname%.bat
echo set /a tpred=%tred% >> ATC/configs/%tname%.bat
echo set /a tpgreen=%tgreen% >> ATC/configs/%tname%.bat
echo set /a tpblue=%tblue% >> ATC/configs/%tname%.bat
echo. >> ATC/configs/%tname%.bat
cls
echo Config saved to ATC/configs/%tname%.bat
pause
goto Tritium

:purgeTritium
cd %~dp0
del /F /Q data/images/~-gmtl_t6_attach_tritium_grn_col.png
del /F /Q data/images/~-gmtl_t6_attach_tritium_red_col.png
del /F /Q data/images/~-gmtl_t6_attach_tritium_wht_col.png
del /F /Q data/images/~~-gmtl_t6_attach_tritium_red~74df00e5.png
del /F /Q data/images/~~-gmtl_t6_attach_tritium_wht~74df00e5.png
del /F /Q data/images/mtl_t6_attach_tritium_blu_glo.png
del /F /Q data/images/mtl_t6_attach_tritium_grn_glo.png
del /F /Q data/images/mtl_t6_attach_tritium_red_glo.png
del /F /Q data/images/mtl_t6_attach_tritium_red_text.png
echo Finished
pause
goto Tritium

:: BO2 reloader/opener
:reloadbo2
echo Reloading BO2
taskkill /f /im t6mpv43.exe >nul
start t6mpv43.exe >nul
echo BO2 STARTED.. GOING BACK TO MENU
cd %~dp0
timeout /t 3
goto choser

:: EOF

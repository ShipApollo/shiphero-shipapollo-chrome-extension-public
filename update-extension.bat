@echo off
setlocal enabledelayedexpansion

rem ShipHero Lookup - manual update/install script.
rem
rem Downloads the latest built extension from the public updates repo and
rem installs/replaces it at a fixed local folder, then restarts Chrome so
rem it picks up the change. This is for machines using "Load unpacked"
rem (Developer mode) rather than the Intune-managed CRX path - see the
rem source repo's README for that alternative.
rem
rem Safe to re-run any time you want to grab the latest version.

set "ZIP_URL=https://raw.githubusercontent.com/ShipApollo/shiphero-shipapollo-chrome-extension-public/main/latest.zip"
set "EXT_DIR=%LOCALAPPDATA%\ShipHeroLookupExtension"
set "TMP_ZIP=%TEMP%\shiphero-lookup-latest.zip"

echo ShipHero Lookup - update/install
echo ================================
echo.
echo This will:
echo   1. Download the latest version of the extension
echo   2. Close ALL open Chrome windows (unsaved tabs/work will be lost)
echo   3. Replace the extension files at:
echo        %EXT_DIR%
echo   4. Reopen Chrome
echo.
choice /C YN /M "Continue"
if errorlevel 2 exit /b 0

echo.
echo Downloading latest version...
curl -fsSL -o "%TMP_ZIP%" "%ZIP_URL%"
if errorlevel 1 (
  echo.
  echo Download failed. Check your internet connection and try again.
  pause
  exit /b 1
)

echo Closing Chrome...
taskkill /F /IM chrome.exe >nul 2>&1

echo Installing update...
if exist "%EXT_DIR%" rmdir /S /Q "%EXT_DIR%"
mkdir "%EXT_DIR%"
tar -xf "%TMP_ZIP%" -C "%EXT_DIR%"
if errorlevel 1 (
  echo.
  echo Could not extract the downloaded update. Nothing was changed at %EXT_DIR%.
  del "%TMP_ZIP%" >nul 2>&1
  pause
  exit /b 1
)
del "%TMP_ZIP%" >nul 2>&1

echo Reopening Chrome...
start "" chrome

echo.
echo Done.
echo.
echo First-time setup only: in Chrome, go to chrome://extensions, enable
echo "Developer mode" (top right), click "Load unpacked", and select:
echo   %EXT_DIR%
echo After that first time, just re-run this script whenever you want to update -
echo Chrome will pick up the new files automatically since it reloads unpacked
echo extensions from disk on restart.
echo.
pause
endlocal

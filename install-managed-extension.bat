@echo off
setlocal

rem ShipHero Lookup - machine-wide managed install / force-update.
rem
rem Run this logged in as an Administrator:
rem   - First time on a machine: sets the Chrome enterprise policy that
rem     force-installs and auto-updates the extension for EVERY Windows
rem     user on this machine from then on - no "Load unpacked" step, no
rem     admin rights needed by the regular user afterward.
rem   - Any time after that: safe to re-run whenever you want this machine
rem     to pick up the latest published version RIGHT NOW, instead of
rem     waiting on Chrome's own background update schedule for an
rem     already-installed managed extension (which can be slow/unreliable
rem     for self-hosted, non-Chrome-Web-Store extensions). It does this by
rem     briefly removing the policy, letting Chrome notice and drop the
rem     extension, then re-adding it - which makes Chrome treat it as a
rem     fresh install and fetch the current version immediately, the same
rem     way a brand-new profile always gets the current version.
rem
rem This does NOT require Intune, Group Policy, or importing any ADMX
rem template - it sets the same registry value those tools would, directly.
rem
rem To remove ShipHero Lookup from this machine entirely instead, run as
rem Administrator:
rem   reg delete "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v 1 /f
rem (then close Chrome - do not re-run this script afterward)

set "EXTENSION_ID=lacgejaaljkcecgjcfomakclkpelcpeb"
set "UPDATE_URL=https://raw.githubusercontent.com/ShipApollo/shiphero-shipapollo-chrome-extension-public/main/update-manifest.xml"
set "POLICY_KEY=HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"

rem Re-launch elevated (UAC prompt) if not already running as Administrator.
net session >nul 2>&1
if not "%errorlevel%"=="0" (
  echo This needs to run as Administrator - requesting elevation...
  powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo ShipHero Lookup - machine-wide managed install / force-update
echo ================================================================
echo.
echo This makes ShipHero Lookup automatically installed and kept up to
echo date for every user on this machine, with no further action needed
echo from anyone afterward.
echo.
echo NOTE: if this machine already force-installs OTHER extensions via the
echo same policy (value "1" already used under ExtensionInstallForcelist),
echo change every /v 1 below to the next unused number first.
echo.
echo This will close ALL open Chrome windows twice in a row (unsaved
echo tabs/work will be lost) to make Chrome notice the change.
echo.
choice /C YN /M "Continue"
if errorlevel 2 exit /b 0

echo.
echo Closing Chrome...
taskkill /F /IM chrome.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Clearing any existing install of ShipHero Lookup...
reg delete "%POLICY_KEY%" /v 1 /f >nul 2>&1

echo Starting Chrome briefly so it notices the change...
start "" chrome about:blank
timeout /t 8 /nobreak >nul
taskkill /F /IM chrome.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Installing the current version...
reg add "%POLICY_KEY%" /v 1 /t REG_SZ /d "%EXTENSION_ID%;%UPDATE_URL%" /f
if errorlevel 1 (
  echo.
  echo Failed to set the Chrome policy. Make sure you accepted the admin prompt.
  pause
  exit /b 1
)

echo Reopening Chrome...
start "" chrome

echo.
echo Done. ShipHero Lookup will install (or update to the latest version)
echo within a few seconds, and Chrome will keep it updated from here on for
echo every user on this machine.
pause
endlocal

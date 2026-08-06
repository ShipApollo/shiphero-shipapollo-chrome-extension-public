@echo off
setlocal

rem ShipHero Lookup - one-time machine-wide managed install.
rem
rem Run this ONCE per machine, logged in as an Administrator. It sets the
rem Chrome enterprise policy that force-installs and auto-updates the
rem extension for EVERY Windows user on this machine from then on - no
rem "Load unpacked" step, no admin rights needed by the regular user
rem afterward, and no further action ever needed on this machine again.
rem Chrome installs and updates it entirely on its own, the same way it
rem would for a Chrome Web Store extension.
rem
rem This does NOT require Intune, Group Policy, or importing any ADMX
rem template - it sets the same registry value those tools would, directly.
rem
rem To undo this later, run as Administrator:
rem   reg delete "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v 1 /f
rem (then remove the extension from chrome://extensions on each account)

set "EXTENSION_ID=lacgejaaljkcecgjcfomakclkpelcpeb"
set "UPDATE_URL=https://raw.githubusercontent.com/ShipApollo/shiphero-shipapollo-chrome-extension-public/main/update-manifest.xml"

rem Re-launch elevated (UAC prompt) if not already running as Administrator.
net session >nul 2>&1
if not "%errorlevel%"=="0" (
  echo This needs to run as Administrator - requesting elevation...
  powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo ShipHero Lookup - machine-wide managed install
echo ================================================
echo.
echo This sets a Chrome policy on this machine so ShipHero Lookup is
echo automatically installed and kept up to date for every user who logs
echo in, with no further action needed from anyone.
echo.
echo NOTE: if this machine already force-installs OTHER extensions via the
echo same policy (value "1" already used under ExtensionInstallForcelist),
echo change the /v 1 below to the next unused number first.
echo.

reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v 1 /t REG_SZ /d "%EXTENSION_ID%;%UPDATE_URL%" /f
if errorlevel 1 (
  echo.
  echo Failed to set the Chrome policy. Make sure you accepted the admin prompt.
  pause
  exit /b 1
)

echo.
echo Done. The next time any user on this machine opens Chrome, ShipHero
echo Lookup will be installed automatically and kept updated from now on.
pause
endlocal

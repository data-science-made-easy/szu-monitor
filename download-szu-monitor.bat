@echo off
setlocal

:: Set local_dir to the directory where the batch file is located
set "local_dir=%~dp0"

:: Navigate to the directory where the batch file is located
cd /d "%local_dir%"

:: Clone the repository
echo Cloning the SZu-monitor repository from GitHub into %local_dir%...
git clone https://github.com/data-science-made-easy/szu-monitor.git

:: Navigate into the cloned repository folder
cd szu-monitor

:: Success message
echo Repository successfully downloaded to %local_dir%/szu-monitor

:: Explain how to start monitor
echo Please click %local_dir%/szu-monitor/compare-cpb-uwv.bat to start the SZu-monitor

endlocal

pause

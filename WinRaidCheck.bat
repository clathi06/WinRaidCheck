@echo off
chcp 65001

set CMDDIR=C:\Software\WinRaidCheck
set DATADIR=C:\Software\WinRaidCheck\Daten
set LOGFILE=%DATADIR%\WinRaidCheck.log

if not exist %DATADIR% mkdir %DATADIR%
echo %0 > %LOGFILE%
echo Stand: %DATE% %TIME:~0,8% >> %LOGFILE%

echo. >> %LOGFILE%
SET CMDFILE=%CMDDIR%\WinRaidCheck-ListVolumes.bat
echo call %CMDFILE% 
echo call %CMDFILE% >> %LOGFILE%
call %CMDFILE% >> %LOGFILE%

rem pause
rem exit

echo. >> %LOGFILE%
SET CMDFILE=%CMDDIR%\WinRaidCheck-Main.bat
echo call %CMDFILE% %1
echo call %CMDFILE% %1 >> %LOGFILE%
call %CMDFILE% %1 >> %LOGFILE%

rem pause
rem exit

echo. >> %LOGFILE%
SET CMDFILE=%CMDDIR%\WinRaidCheck-SwithMail.bat
echo call %CMDFILE%
echo call %CMDFILE% >> %LOGFILE%
call %CMDFILE% >> %LOGFILE%

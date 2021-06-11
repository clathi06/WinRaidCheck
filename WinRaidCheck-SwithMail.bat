@echo off

:Variablen
set MAILDIR=C:\Software\WinRaidCheck
set MAILFILE=%MAILDIR%\Daten\WinRaidCheck-MailSubject.txt
set MAILTEXT=%MAILDIR%\Daten\WinRaidCheck-MailText.txt
set MAILLOG=%MAILDIR%\Daten\WinRaidCheck-SwithMail.log

echo.
echo %0
echo Stand: %DATE% %TIME:~0,8%
if exist %MAILLOG% del %MAILLOG%
rem goto Ende

:Mail
if not exist %MAILFILE% goto Ende
set /p SUBJECT=<%MAILFILE%
%MAILDIR%\SwithMail.exe /s /x "%MAILDIR%\SwithMailSettings.xml" /p1 "%SUBJECT%" /btxt %MAILTEXT% /l %MAILLOG%
echo.
type %MAILLOG%

:Ende
echo.
echo 3 Sekunden warten...
ping -n 3 localhost > nul
echo.

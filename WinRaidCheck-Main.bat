@echo off

:Variablen
set ERRTEXT=
set DATADIR=C:\Software\WinRaidCheck\Daten
set MAILFILE=%DATADIR%\WinRaidCheck-MailSubject.txt
set MAILTEXT=%DATADIR%\WinRaidCheck-MailText.txt
set VOLUMES=%DATADIR%\WinRaidCheck-VolumeList.txt
set MIRRORS=%DATADIR%\WinRaidCheck-VolumeMirrors.txt
set PARTITION=*
set PAUSE=15
if "%1" == "" goto Start
set PARTITION=%1
set PAUSE=3
if "%2" == "" goto Start
set PAUSE=%2

:Start
echo.
echo %0
echo Stand: %DATE% %TIME:~0,8%
echo.
echo RAID-Status pruefen
if exist %MAILFILE% del %MAILFILE%
if exist %MAILTEXT% del %MAILTEXT%
echo.

:DiskPart
echo %PAUSE% Sekunden warten...
ping -n %PAUSE% localhost > nul
set PAUSE=3
echo.

:Log
echo %VOLUMES%: Datei pruefen
echo.
if exist %VOLUMES% goto Stand
set ERRTEXT=%VOLUMES% nicht gefunden
echo FEHLER: %ERRTEXT%
goto Fehler

:Stand
echo %VOLUMES%: Datum pruefen
type %VOLUMES%
echo.
findstr "%DATE%" %VOLUMES% > nul
if not ERRORLEVEL 1 goto Typ
set ERRTEXT=Datum %DATE% nicht aktuell
echo FEHLER: %ERRTEXT%
goto Fehler

:Typ
echo %VOLUMES%: Spiegelungen suchen
echo.
findstr "Spiegelung" %VOLUMES% > %MIRRORS%
if not ERRORLEVEL 1 goto Partition
set ERRTEXT=Keine Spiegelung (RAID 1) gefunden
echo FEHLER: %ERRTEXT%
goto Fehler

:Partition
echo %VOLUMES%: Laufwerk(e) %PARTITION% suchen
echo.
if "%PARTITION%" == "*" goto Status
findstr "Spiegelung" %VOLUMES% | findstr /c:" %PARTITION% " > %MIRRORS%
if not ERRORLEVEL 1 goto Status
set ERRTEXT=Laufwerk %PARTITION% nicht gefunden oder keine Spiegelung
echo FEHLER: %ERRTEXT%
goto Fehler

:Status
echo %MIRRORS%: Laufwerk(e) pruefen
set ERRTEXT=
for /f "tokens=1-9" %%A in (%MIRRORS%) do (
  echo %%A %%B %%C %%D %%E %%F %%G %%H %%I
  if not "%%I" == "Fehlerfre" set ERRTEXT=Spiegelung von Laufwerk %%C fehlerhaft
)
if "%ERRTEXT%" == "" goto Ok
echo FEHLER: %ERRTEXT%
goto Fehler

:Ok
set ERRTEXT=Laufwerk %PARTITION% fehlerfrei
echo %ERRTEXT%
if "%PARTITION%" == "*" goto Ende
echo %ERRTEXT% > %MAILFILE%
echo Stand: %DATE% %TIME:~0,8% > %MAILTEXT%
goto Ende

:Fehler
echo %ERRTEXT% > %MAILFILE%
type %VOLUMES% > %MAILTEXT%
echo.
echo Bitte einen Verantwortlichen benachrichtigen!
echo.
if "%1" == "" set PAUSE=60

:Ende
echo.
echo %PAUSE% Sekunden warten...
ping -n %PAUSE% localhost > nul
echo.

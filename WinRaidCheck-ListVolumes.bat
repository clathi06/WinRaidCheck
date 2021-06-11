@echo off
rem Aufgabenplanung als Mitglied der Administratorengruppe ausführen:
rem Bei Anmeldung jeden Benutzers
rem Bei Aufheben der Arbeitsstationssperre
rem diskpart benoetigt erhoehte Rechte
rem funktioniert deshalb nur mit UAC in einer normalen Shell

set TXTFILE=%DATADIR%\WinRaidCheck-VolumeList.txt

echo %0 > %TXTFILE%
echo Stand: %DATE% %TIME:~0,8% >> %TXTFILE%
echo diskpart list volume >> %TXTFILE%
echo list volume | diskpart >> %TXTFILE%
echo. >> %TXTFILE%

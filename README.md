# WinRaidCheck
Check a Windows RAID1 and inform via mail

# Problem
Der Ausfall einer HDD ist immer ärgerlich. 
Ganz besonders allerdings, wenn darauf wichtige Daten lagern, die z.B. die Basis für eine (Klein-)Unternehmens- oder Praxis-Software bilden. 
Selbst wenn diese woanders gesichert sind, bedeutet ein Ausfall der Datenplatte den Stillstand des Betriebs bzw. der Praxis. 
Dagegen hilft es, diese Daten auf einem RAID-1 zu speichern. 
Da ist es ganz praktisch, dass die Einrichtung und auch die Wartung mit Windows-Bordmitteln möglich ist. 
Weniger praktisch ist, dass es keine Benachrichtigung bei einem Ausfall gibt - zumindest keine, die mit wenig Aufwand an den Start gebracht werden kann. 
Das funktioniert mit mdadm unter Linux besser, was aber wenig hilft, wenn die Unternehmens- bzw. Praxis-Software samt dem ganzen Datenbestand mit Windows läuft. 

# Lösung 1
WinRaidMonitor, eine Java-basierte Software. 
Vorteil: Alles in einem Software-Paket
Nachteile: Fast alles in einem Paket - man braucht eine Java-Runtime.
Mit OpenJDK läuft die jar nicht, also muss es die Oracle JRE sein. 
Die ist nur für privaten Gebrauch kostenlos und ansonsten lizenzpflichtig. 
Und mit dem letzten Update im Mai 2021 läuft die jar auch nicht. 
Ausserdem wird die Software schon länger nicht mehr gepflegt, was dazu führen dürfte, dass die TLS-Version veraltet und von den Mail-Providern abgelehnt wird. 

# Lösung 2
Ein Paket aus vier Skripten.

Skript 0: WinRaidCheck.bat
Das wird über die Aufgabenplanung mit maximalen Rechten (SYSTEM) gestartet und ruft die anderen Skripte auf.

Skript 1: WinRaidCheck-ListVolumes.bat
Das ruft im Kern diskpart auf und erzeugt eine Datei mit dem aktuellen Datum und der Liste der Volumes. 
Dazu braucht es aber erhöhte Rechte - und das ist eher nix für die Kommandozeile (Stichwort Autostart). 

Skript 2: WinRaidCheck-Main.bat
Das macht die Hauptarbeit und prüft die im ersten Skript erzeugt Datei darauf, ob alle oder ausgewählte RAID-1-Volumes in Ordnung sind. 
Wenn nicht oder wenn eine Mail gewollt ist, werden zwei Dateien für Skript 3 erzeugt. 
Gewollt ist eine Mail z.B. um zu prüfen, ob die Skripte überhaupt noch funktionieren. 

Skript 3: WinRaidCheck-SwithMail.bat
Das prüft, ob die Dateien aus dem Skript 2 da sind und ruft ggfs. SwithMail zum Versenden einer Info-Mail auf. 
SwithMail ist im Prinzip Freeware, bei der allerdings um eine Spende gebeten wird. 
Die sollte man bei kommerziellem Einsatz auch investieren - so viel sollte die Verfügbarkeit der Daten schon wert sein. 

# Setup
Alle Dateien in einem beliebigen Pfad speichern und die Variablen anpassen. 
SwithMail herunter laden und die exe auspacken. 
SwithMail bringt eine GUI mit, in der man (oder frau) die Parameter für den CLI-Aufruf erzeugen kann. 
Ich lasse das Skript 0 per Aufgabenplanung einmal in der Woche zu einer Zeit aufrufen, in der ich ziemlich sicher sein kann, dass die Rechner an sind. 
Dabei wird auf jeden Fall eine Mail verschickt. 
Bei Headless-Servern wird das Skript 0 ebenfalls per Aufgabenplanung täglich früh am Morgen aufgerufen. 
Dabei wird im Skript 1 eine aktuelle Liste erzeugt und nur im Fehlerfall eine Mail geschickt. 
Bei Hauptrechnern wird das Skript 0 per Aufgabenplanung beim Anmelden eines beliebigen Benutzers und beim Aufheben der Sperre aufgerufen. 
Zusätzlich kann das Skript 2 im Autostart aufgerufen werden, um den Benutzern im Fehlerfall auch eine Information zu geben. 


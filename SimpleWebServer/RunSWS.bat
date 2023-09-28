
@ECHO off

SET PORT=8081
SET FOLDER=%APPDATA%\brgishy
SET SWS=%FOLDER%\SWS.exe
SET URL=https://github.com/brgishy/StaticFiles/raw/main/SimpleWebServer/SWS.exe?download=

IF NOT EXIST %FOLDER% MKDIR %FOLDER%
IF NOT EXIST %SWS% ECHO Downloading SWS.exe (Approx 16 MB)...
IF NOT EXIST %SWS% powershell -Command "Invoke-WebRequest %URL% -Outfile %SWS%"

%SWS%

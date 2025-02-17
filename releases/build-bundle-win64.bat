@ECHO OFF

IF [%1] == [] GOTO usage

ECHO 1) Deleting old bundle
CALL DEL /F /S /Q bundle

ECHO 2) Downloading new WeKan.zip
CALL DEL wekan-%1.zip
CALL wget https://releases.wekan.team/wekan-%1.zip

ECHO 3) Unarchiving new WeKan
CALL 7z x wekan-%1.zip

ECHO 4) Reinstalling bcrypt
CD bundle\programs\server\npm\node_modules\meteor\accounts-password
CALL npm remove bcrypt
CALL npm install bcrypt
REM # Requires building from source https://github.com/meteor/meteor/issues/11682
REM CALL npm rebuild --build-from-source
REM CALL npm --build-from-source install bcrypt
CD ..\..\..\..\..\..\..

ECHO 5) Packing new WeKan.zip
CALL DEL wekan-%1-amd64-windows.zip
CALL 7z a wekan-%1-amd64-windows.zip bundle

ECHO 6) Copying WeKan.zip to sync directory
CALL COPY wekan-%1-amd64-windows.zip Z:\

ECHO 7) Done. Starting WeKan.
CALL start-wekan.bat

GOTO :eof

:usage
ECHO Usage: build-windows.bat VERSION-NUMBER
ECHO Example: build-windows.bat 5.00 

:eof

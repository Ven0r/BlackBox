import os
import sys
import subprocess

#--------------------------------------------------

# run commands for each step of recon

#subfinder

# append to list file of urls to check

#amass

# append to list file of urls to check

#ffuf brute force subdomains

# append to list file of urls to check

#httpx Check list of urls

#--------------------------------------------------

# Programs needed for recon.py
check_programs_dict = { 'amass'     : '--version',
                  'subfinder' : '--version',
                  'ffuf'      : '-h',
                  'httpx'     : '--help'
                 }

# check to see if programs are installed
def is_program_installed(programs):
    installed_programs = {}
    for program, run_param in programs_dict.items():
        try:
            subprocess.run([program, run_param], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            installed_programs[program] = True
        except subprocess.CalledProcessError:
            print("Please install " + program)
            exit()
    return installed_programs


is_program_installed(check_programs_dict)

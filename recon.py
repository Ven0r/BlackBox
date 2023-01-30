import os
import sys
import argparse
import subprocess

#--------------------------------------------------

# set target
parser = argparse.ArgumentParser(description='This is a script to run recon against target urls')
parser.add_argument('-t', metavar='TARGET',required=True, nargs='+', help='Set target domains "domain.com" you can chain with ,')
args = parser.parse_args()
scope = args.t


# run commands for each step of recon

#subfinder
#subfinder -d domain.com,domain2,domain3 -o output.txt
result = subprocess.run(["subfinder", "-dL", scope], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
print(result.stdout.decode())



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
    for program, run_param in check_programs_dict.items():
        try:
            subprocess.run([program, run_param], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            installed_programs[program] = True
        except subprocess.CalledProcessError and FileNotFoundError:
            print("### In order to run this program you must install " + program + " ##")
            exit()
    return installed_programs

is_program_installed(check_programs_dict)


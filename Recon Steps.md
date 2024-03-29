# **Recon Steps...**

## DNS Resolvers
```dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o resolvers.txt```


## Get Scope
  ```..hackerone```

### Subfinder Domains 
  ```subfinder -d domain.com -o output.txt```
  
### Cat all subfinder results into one file
  ```cat domain_1_output.txt domain_2_output.txt > alldomains.txt```
  
### Httpx domains
  ```cat alldomains.txt | httpx --title --asn --cname --sc --ct --location --fc 404 | tee -a alive_domains.txt``` 
  
### Remove duplicates for alive_domains.txt
  ```sort alive_domains.txt | uniq > nodupes_alive_domains.txt```
  

# Brute-force subdomains
https://github.com/vortexau/dnsvalidator
create resolver list 25,50,100 resolvers.
thread 50-100. 
  
take chosen resolver list and run it on amass.
```amass enum -rf resolver.txt -max-dns-queries 15000 -w all.txt -d domain.com -o output.txt```


# Dorking while waiting:

Finding Subdomains

```site:*.example.com -www```
This dork helps in finding subdomains of the target domain, which can reveal publicly accessible applications.
Discovering Directories and Files

```site:example.com filetype:pdf```
This can help find exposed files of a specific type (like PDFs) on the target domain, potentially revealing sensitive information.
Identifying Configuration Files or Backups

```site:example.com filetype:sql | filetype:env | filetype:config ```
This query can uncover exposed configuration or backup files that may contain sensitive information.
Finding Login Pages

```site:example.com inurl:login | inurl:admin```
This dork can help locate login pages, which might be of interest for testing authentication mechanisms.
Discovering Publicly Exposed Documents

```site:example.com intitle:index.of```
This search can reveal directories that are listing files, potentially exposing sensitive documents.
Searching for Error Messages

```site:example.com intext:"error" | intext:"warning"```
This can help find pages that are leaking error messages, which might disclose useful information for finding vulnerabilities.

# Next steps 
1. Brute-force subdomains against list
2. Screen capture nodupes_alive_domains.txt




## Steps to automation:
This needs to be stored and tracked inside a Postgres DB

Set Target and make folder for Target

create a .scope file that has wildcard and target domains.

create condition for each line of the .scope file so if it's a wildcard domain it runs subdomain enumeration with subfinder and amass then take the results remove dulicates and saved to a table.

once that is completed take all domains found from subdomain enumeration and already defined domain targets from scope into one file.

Directory passive and active scanning on all domains with ffuf and a wordlist and waymore for passive.

spider with xnLinkfinder

filter results to then manually check links

discord messages of all filtered results.

get ips and run nmap agains endpoints? list ip's with port results?


?run httpx on all endpoints.

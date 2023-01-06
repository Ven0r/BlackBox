# **recon steps...**

## Get Scope

## Subfinder Domains 
  subfinder -d domain.com -o output.txt
  
## Cat all subfinder results into one file
  cat domain_1_output.txt domain_2_output.txt > alldomains.txt
  
## Httpx domains
  cat alldomains.txt | httpx --title --asn --cname --sc --ct --location --fc 404 | tee -a alive_domains.txt 
  
## remove duplicates for alive_domains.txt
  sort alive_domains.txt | uniq > nodupes_alive_domains.txt
  

# Next steps to screen capture nodupes_alive_domains.txt

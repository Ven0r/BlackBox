# **Recon Steps...**

## Get Scope
  ..hackerone

## Subfinder Domains 
  subfinder -d domain.com -o output.txt
  
## Cat all subfinder results into one file
  cat domain_1_output.txt domain_2_output.txt > alldomains.txt
  
## Httpx domains
  cat alldomains.txt | httpx --title --asn --cname --sc --ct --location --fc 404 | tee -a alive_domains.txt 
  
## remove duplicates for alive_domains.txt
  sort alive_domains.txt | uniq > nodupes_alive_domains.txt
  

# Brute-force subdomains
  https://github.com/vortexau/dnsvalidator
  create resolver list 25,50,100 resolvers
  thread 50-100 
  
  take chosen resolver list and run it on amass
  amass enum -rf resolver.txt -max-dns-queries 15000 -w all.txt -d domain.com -o output.txt


# Next steps 
1. Brute-force subdomains against list
2. Screen capture nodupes_alive_domains.txt

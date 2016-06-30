#!/bin/bash

ip="172.17.0.3"

if [ "$#" -eq 0 ]; then
    echo "Missing parameters !"
    echo "Call syntax:"
    echo "	[SCANNER_ID] [SCANNER_ARGS]"
    echo "Scanner ID:"
    echo "	nik => Nikto"
    echo "	zap => OWASP ZAP"
    echo "	nmap => Nmap"
    echo "  	fish => Skipfish" 
    echo "  	w3af => W3AF" 
    echo "  	pytbull => Pytbull" 
    echo "  	wapiti => Wapiti" 
    echo "  	sqlmap => Sqlmap" 
    echo "  	bash => BASH" 
    echo "	all => Run all scanners"
    exit 1
fi

if [ $# -lt 2 ]
then
    url="http://${ip}/WebGoat/login.mvc"
    sqlmap_url="http://${ip}/WebGoat/login.mvc?username=asd&password=asd"
    nmap_url="${ip}"
else
    url="${@:2}"
    sqlmap_url=$url
    nmap_url=$url
fi

# Call scanner
scanner_id=$1
echo "scanner:" $scanner_id
shift
case $scanner_id in 
	nik) 
	docker run --rm -t kunals/generic-scanner:latest nik -host $url #just pass url
	;;	
	zap) 
	docker run --rm -t kunals/generic-scanner:latest zap -daemon -cmd -quickurl $url #just pass url
	;;
	nmap) 
	docker run --rm -t kunals/generic-scanner:latest nmap -A -T4 $nmap_url -v #just pass url
	;;
    fish) 
	docker run --rm -t kunals/generic-scanner:latest fish $url #just pass url
	;;
	w3af) 
	echo "under construction"
	;;
	pytbull) 
	echo "under construction"
	;;
	sqlmap) 
	docker run --rm -t kunals/generic-scanner:latest sqlmap -u $sqlmap_url --batch --level=5 --risk=3 #just pass url
	;;
	wapiti) 
        #Start a scan against the localhost website, be verbose and use colours to highlight vulnerabilities:
	docker run --rm -t kunals/generic-scanner:latest wapiti $url -v 2 -u  #just pass url
	;;
	all) 
	docker run --rm -d -t kunals/generic-scanner:latest nik -host $url
	docker run --rm -d -t kunals/generic-scanner:latest zap -daemon -cmd -quickurl $url
	docker run --rm -d -t kunals/generic-scanner:latest nmap -A -T4 $nmap_url -v
	docker run --rm -d -t kunals/generic-scanner:latest fish $url
	docker run --rm -d -t kunals/generic-scanner:latest sqlmap -u $sqlmap_url --batch --level=5 --risk=3 #just pass url
	docker run --rm -d -t kunals/generic-scanner:latest wapiti $url -v 2 -u  #just pass url
	;;
	bash)
	docker run --rm -it kunals/generic-scanner:latest bash
	;;
	*) 
	echo "Unknow Scanner ID !"
	;;
esac



#!/bin/bash

#Command to display help:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic-scanner:test

#Command to scan using Nikto:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic-scanner:test NIK -host http://webgoat:80 -F htm -output /tmp/scan_result/nikto-scan.html

#Command to scan using Zap:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic-scanner:test ZAP -daemon -cmd -quickurl http://webgoat:80 -quickout /tmp/scan_result/zap-report.xml

#Command to scan using Nmap:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic-scanner:test NMP -A -T4 http://webgoat:80 -v

#Command to scan using Skipfish:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic-scanner:test FISH http://webgoat:80 -o output

#Command to scan using W3AF:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic-scanner:test W3AF -s /tmp/scan_result/scan_script.w3af 

#Command to spawn a shell inside the container:
#docker run --rm=true -i -t generic-scanner:test BASH 

############################################
# Image entry point to execute scanner
############################################
#clear
# Check input parameters
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
    url="http://localhost/webgoat/WebGoat/login.mvc"
    sqlmap_url="http://localhost/webgoat/WebGoat/login.mvc?username=asd&password=asd"
    nmap_url="localhost"
else
    url="${@:2}"
    sqpmap_url="${@:2}"
    nmap_url="${@:2}"
fi

# Call scanner
scanner_id=$1
echo "scanner:" $scanner_id
shift
case $scanner_id in 
	nik) 
	docker run -t generic-scanner:latest nik -host $url #just pass url
	;;	
	zap) 
	docker run -t generic-scanner:latest zap -daemon -cmd -quickurl $url #just pass url
	;;
	nmap) 
	docker run -t generic-scanner:latest nmap -A -T4 $nmap_url -v #just pass url
	;;
    fish) 
	docker run -t generic-scanner:latest fish $url #just pass url
	;;
	w3af) 
	echo "under construction"
	;;
	pytbull) 
	echo "under construction"
	;;
	sqlmap) 
	docker run -t generic-scanner:latest sqlmap -u $sqlmap_url --batch --level=5 --risk=3 #just pass url
	;;
	wapiti) 
        #Start a scan against the localhost website, be verbose and use colours to highlight vulnerabilities:
	docker run -t generic-scanner:latest wapiti $url -v 2 -u  #just pass url
	;;
	all) 
	docker run -d -t generic-scanner:latest nik -host $url
	docker run -d -t generic-scanner:latest zap -daemon -cmd -quickurl $url
	docker run -d -t generic-scanner:latest nmap -A -T4 $nmap_url -v
	docker run -d -t generic-scanner:latest fish $url
	docker run -d -t generic-scanner:latest sqlmap -u $sqlmap_url --batch --level=5 --risk=3 #just pass url
	docker run -d -t generic-scanner:latest wapiti $url -v 2 -u  #just pass url
	;;
	bash)
	docker run -d -it generic-scanner:latest bash
	;;
	*) 
	echo "Unknow Scanner ID !"
	;;
esac



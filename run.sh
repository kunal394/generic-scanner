#!/bin/bash

ip="172.17.0.2"
output_dir="/tmp/scan_results"

if [ "$#" -eq 0 ]; then
    echo "Missing parameters !"
    echo "Call syntax:"
    echo "	[SCANNER_ID] [SCANNER_ARGS]"
    echo "Scanner ID:"
    echo "	all => Run all scanners"
    echo " 	bash => BASH" 
    echo " 	lynis => Lynis" 
    echo "	nikto => Nikto"
    echo "	nmap => Nmap"
    echo "  skipfish => Skipfish" 
    echo " 	sqlmap => Sqlmap" 
    echo " 	wapiti => Wapiti" 
    echo "	zap => OWASP ZAP"
    exit 1
fi

if [ ! -d "$output_dir" ]
then
    mkdir -p $output_dir
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
	all) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest lynis audit system -Q -c > /tmp/scan_results/lynis.log   #just pass url
	docker run -v /tmp/scan_results:/tmp/scan_results:rw -d -t kunals/generic-scanner:latest nikto -host $url -C all -output=$output_dir/nikto.txt  #just pass url
	docker run -v /tmp/scan_results:/tmp/scan_results:rw -d -t kunals/generic-scanner:latest nmap -A -T4 $nmap_url -v -oN $output_dir/nmap.log
	docker run -v /tmp/scan_results:/tmp/scan_results:rw -d -t kunals/generic-scanner:latest skipfish -o $output_dir/skipfish $url
	docker run -v /tmp/scan_results:/tmp/scan_results:rw -d -t kunals/generic-scanner:latest sqlmap -u $sqlmap_url --batch --level=5 --risk=3 --output-dir=$output_dir/sqlmap  #just pass url
	docker run -v /tmp/scan_results:/tmp/scan_results:rw -d -t kunals/generic-scanner:latest wapiti $url -v 2 -u -o $output_dir/wapiti  #just pass url
	docker run -v /tmp/scan_results:/tmp/scan_results:rw -d -t kunals/generic-scanner:latest zap -daemon -cmd -quickurl $url -quickout $output_dir/zap
	;;
	bash)
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -it kunals/generic-scanner:latest bash
	;;
	lynis) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest lynis audit system -Q -c | tee /tmp/scan_results/lynis.log   #just pass url
	;;	
	nikto) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest nikto -host $url -C all -output=$output_dir/nikto.txt  #just pass url
	;;	
	nmap) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest nmap -A -T4 $nmap_url -v -oN $output_dir/nmap.log
	;;
    skipfish) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest skipfish -o $output_dir/skipfish $url
	;;
	sqlmap) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest sqlmap -u $sqlmap_url --batch --level=5 --risk=3 --output-dir=$output_dir/sqlmap  #just pass url
	;;
	wapiti) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest wapiti $url -v 2 -u -o $output_dir/wapiti  #just pass url
	;;
	zap) 
	docker run -v /tmp/scan_results:/tmp/scan_results:rw --rm -t kunals/generic-scanner:latest zap -daemon -cmd -quickurl $url -quickout $output_dir/zap
	;;
	*) 
	echo "Unknown Scanner ID !"
	;;
esac



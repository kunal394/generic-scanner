#!/bin/bash

#Command to display help:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test

#Command to scan using Arachni:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test ARS http://webgoat:80 --report-save-path=/tmp/scan_result/scan_result.afr --check=xss
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test ARR /tmp/scan_result/scan_result.afr --report=html:outfile=/tmp/scan_result.zip

#Command to scan using Nikto:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test NIK -host http://webgoat:80 -F htm -output /tmp/scan_result/nikto-scan.html

#Command to scan using Zap:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test ZAP -daemon -cmd -quickurl http://webgoat:80 -quickout /tmp/scan_result/zap-report.xml

#Command to scan using Nmap:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test NMP -A -T4 http://webgoat:80 -v

#Command to scan using Skipfish:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test FISH http://webgoat:80 -o output

#Command to scan using W3AF:
#docker run -v /tmp/scan_result:/tmp/scan_result:rw generic_scanner:test W3AF -s /tmp/scan_result/scan_script.w3af 

#Command to spawn a shell inside the container:
#docker run --rm=true -i -t generic_scanner:test BASH 

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
    echo "  fish => Skipfish" 
    echo "  w3af => W3AF" 
    echo "  bash => Spawn a shell"
    echo "  pytbull => PYTBULL"
    echo "  sqlmap => Sqlmap"
    echo "  wapiti => Sqlmap"
    echo "	all => Run all scanners"
    exit 1
fi
# Call scanner
scanner_id=$1
shift
case $scanner_id in 
	nik) 
	perl $NIKTO_HOME/nikto.pl "$@"
	;;	
	zap) 
	bash $ZAP_HOME/zap.sh "$@"
	;;
	nmap) 
	nmap "$@"
	;;
    fish)
    cd $FISH_HOME/skipfish-2.10b
	./skipfish -o ./out "$@"
	;;
	w3af) 
	$W3AF_HOME/w3af_console "$@"
	;;
	pytbull) 
	$BULL_HOME/pytbull "$@"
	;;
	sqlmap) 
	$SQLMAP_HOME/sqlmap.py "$@"
	;;
	wapiti) 
    $WAPITI_HOME/bin/wapiti "$@"
	;;
	bash) 
	/bin/bash
	;;
    all) 
	perl $NIKTO_HOME/nikto.pl "$@"
    bash $ZAP_HOME/zap.sh "$@"
    nmap "$@"
    cd $FISH_HOME/skipfish-2.10b && ./skipfish -o ./out "$@"
    #$W3AF_HOME/w3af_console "$@"
	#$BULL_HOME/pytbull "$@"
    $SQLMAP_HOME/sqlmap.py "$@"
    $WAPITI_HOME/bin/wapiti "$@"
	;;
	*) 
	echo "Unknow Scanner ID !"
	;;
esac


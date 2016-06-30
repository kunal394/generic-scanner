#!/bin/bash

############################################
# Image entry point to execute scanner
############################################
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
    echo "  	bash => Spawn a shell"
    echo "  	pytbull => PYTBULL"
    echo "  	sqlmap => Sqlmap"
    echo "  	wapiti => Sqlmap"
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
    cd $FISH_HOME
	./skipfish -o ./out "$@"
	;;
	w3af) 
	echo "under construction"
	#$W3AF_HOME/w3af_console "$@"
	;;
	pytbull) 
	echo "under construction"
	#$BULL_HOME/pytbull "$@"
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
	*) 
	echo "Unknow Scanner ID !"
	;;
esac


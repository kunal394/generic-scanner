#!/bin/bash

############################################
# Image entry point to execute scanner
############################################
# Check input parameters
if [ "$#" -eq 0 ]; then
    echo "Missing parameters !"
    echo "Call syntax:"
    echo "  [SCANNER_ID] [SCANNER_ARGS]"
    echo "Scanner ID:"
    echo "  bash => BASH" 
    echo "  lynis => Lynis" 
    echo "  nikto => Nikto"
    echo "  nmap => Nmap"
    echo "  skipfish => Skipfish" 
    echo "  sqlmap => Sqlmap" 
    echo "  wapiti => Wapiti" 
    echo "  zap => OWASP ZAP"
    exit 1
fi

output_dir="/tmp/scan_results"

# Call scanner
scanner_id=$1
shift
case $scanner_id in 
    bash) 
        /bin/bash
        ;;
    lynis) 
        cd $LYNIS_HOME
        ./lynis "$@"
        ;;	
    nikto) 
        perl $NIKTO_HOME/nikto.pl "$@"
        ;;	
    nmap) 
        nmap "$@"
        ;;
    skipfish)
        rm -rf /tmp/scan_results/skipfish || true 
        cd $FISH_HOME
        ./skipfish "$@"
        ;;
    sqlmap) 
        $SQLMAP_HOME/sqlmap.py "$@"
        ;;
    wapiti) 
        $WAPITI_HOME/bin/wapiti "$@"
        ;;
    zap) 
        bash $ZAP_HOME/zap.sh "$@"
        ;;
    *) 
        echo "Unknow Scanner ID !"
        ;;
esac


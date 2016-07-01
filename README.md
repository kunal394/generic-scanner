# Generic Vulnerability Scanner

[![MIT Licence](https://badges.frapsoft.com/os/mit/mit-175x39.png?v=103)](https://opensource.org/licenses/mit-license.php)
[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source-175x29.png?v=103)](https://github.com/ellerbrock/open-source-badge/)
[![Generic Scanner](https://img.shields.io/badge/generic--scanner-Docker-red.svg?maxAge=123456789?link=https://github.com/kunal394/generic-scanner/?style=plastic)]()
[![forthebadge](http://forthebadge.com/images/badges/uses-badges.svg)](http://forthebadge.com)

[Docker](https://www.docker.com/) build file providing an [image](https://docs.docker.com/engine/tutorials/dockerimages/) containing the following vulnerability scanners:
   - lynis
   - nikto
   - nmap
   - skipfish
   - sqlmap
   - wapiti
   - zap


# Image location

[Docker Hub repository](https://hub.docker.com/r/kunals/generic-scanner/)

# How to pull the image

```bash 
docker pull kunals/generic-scanner
```

# Run commands

## Lynis
```bash
./run.sh lynis
```

## Nikto
```bash
./run.sh nikto {target_website}
```

## Nmap
```bash
./run.sh nmap {target_website}
```

## Skipfish
```bash
./run.sh skipfish {target_website}
```

## Sqlmap
```bash
./run.sh sqlmap {target_website}
```

## Wapiti
```bash
./run.sh wapiti {target_website}
```

## Zap
```bash
./run.sh zap {target_website}
```

Call syntax can be customized as per the user's needs in the run.sh file. Also the target website can be set using the `ip` variable in the run.sh file if the user needs to scan a particular website repeatedly and in that case there is no need to specify the website along with the command. For example a command like ```./run.sh wapiti``` would suffice to run wapiti in the latter case.

Scan logs go to `/tmp/scan_results` folder.

# TODO

Integration of pytbull and w3af.

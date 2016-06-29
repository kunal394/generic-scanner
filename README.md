# Generic Web App Scanner

[![MIT Licence](https://badges.frapsoft.com/os/mit/mit-175x39.png?v=103)](https://opensource.org/licenses/mit-license.php)
[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source-175x29.png?v=103)](https://github.com/ellerbrock/open-source-badge/)
[![Generic Scanner](https://img.shields.io/badge/generic--scanner-Docker-red.svg?maxAge=123456789?link=https://github.com/kunal394/generic-scanner/?style=plastic)]()
[![forthebadge](http://forthebadge.com/images/badges/uses-badges.svg)](http://forthebadge.com)

[Docker](http://docs.docker.com) build file providing an [image](http://docs.docker.com/introduction/understanding-docker/#how-does-a-docker-image-work) containing the following vulnerability scanners:
 - nmap
 - nikto
 - skipfish
 - zap
 - sqlmap
 - wapiti


# Image location

[Docker Hub repository](https://hub.docker.com/r/kunals/generic-scanner/)

# How to pull the image

```bash 
docker pull kunals/generic-scanner
```

# Run commands

## Nmap
```bash
./run.sh nmap {ip_address_of_the_target_website}
```

## Nikto
```bash
./run.sh nik {the_target_website}
```

## Skipfish
```bash
./run.sh fish {target_website}
```

## Zap
```bash
./run.sh zap {target_website}
```

## Sqlmap
```bash
./run.sh sqlmap {target_website}
```

## Wapiti
```bash
./run.sh wapiti {target_website}
```

Call syntax can be customized as per the user's needs in the run.sh file. Also the target website can be set using the <code>ip</code> variable in the run.sh file if the user needs to scan a particular website repeatedly and in that case there is no need to specify the website along with the command. For example a command like ```./run.sh wapiti``` would suffice to run wapiti in the latter case.

# TODO

Integration of pytbull and w3af.

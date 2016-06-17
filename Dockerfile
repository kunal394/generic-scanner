############################################
# Docker build file providing an generic
# scanner docker image in order to use the 
# image as a command line tool.
############################################
# Script uses following best practices 
# https://docs.docker.com/articles/dockerfile_best-practices
############################################

# Set the base image to ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER Kunal Singh <knlsingh394@gmail.com>
ENV TERM linux
LABEL version="1.0.0" description="Docker build file for providing a generic scanner docker image in order to use the image as a command line tool."

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get upgrade -y

# Install dependencies 
# 	perl openssl libnet-ssleay-perl: Dependencies for Nikto
# 	openjdk-7-jre: Java runtime for ZAP
# 	tofrodos: To fix issue when import file from Windows
# 	wget: To download tools
RUN apt-get install -y git python libnet-ssleay-perl openjdk-7-jre openssl perl tofrodos wget gcc make tar libidn11-dev libssl-dev libcrypto++-dev libpcre3-dev libcurl4-openssl-dev libpcre3-dev --fix-missing
RUN ln -s /usr/bin/fromdos /usr/bin/dos2unix

#Install nmap
RUN apt-get update && apt-get install nmap --fix-missing -y
############################################

# Install NIKTO
ENV NIKTO_HOME /opt/nikto
RUN echo "NIKTO_HOME=$NIKTO_HOME" >> /etc/environment
RUN mkdir $NIKTO_HOME
RUN wget -q -O /tmp/nikto.tgz http://www.cirt.net/nikto/nikto-2.1.5.tar.gz
RUN tar --strip-components=1 -xzf /tmp/nikto.tgz -C $NIKTO_HOME
RUN chmod -R +x $NIKTO_HOME
RUN perl $NIKTO_HOME/nikto.pl -update
RUN perl $NIKTO_HOME/nikto.pl -Version
############################################

# Install OWASP ZAP from release
ENV ZAP_HOME /opt/zap
RUN echo "ZAP_HOME=$ZAP_HOME" >> /etc/environment
RUN mkdir $ZAP_HOME
RUN wget -q -O /tmp/zap.tgz https://github.com/zaproxy/zaproxy/releases/download/2.5.0/ZAP_2.5.0_Linux.tar.gz
RUN tar --strip-components=1 -xzf /tmp/zap.tgz -C $ZAP_HOME
RUN chmod -R +x $ZAP_HOME
RUN /bin/bash $ZAP_HOME/zap.sh -version
COPY zap-aggressive-scan-policy.policy /root/.ZAP/policies/zap-aggressive-scan-policy.policy
RUN dos2unix /root/.ZAP/policies/zap-aggressive-scan-policy.policy
############################################

# Install skipfish
ENV FISH_HOME /opt/skipfish
RUN echo "FISH_HOME=$FISH_HOME" >> /etc/environment
RUN mkdir $FISH_HOME
RUN wget -q -O /tmp/skipfish.tgz https://skipfish.googlecode.com/files/skipfish-2.10b.tgz
RUN \
        tar zxvf /tmp/skipfish.tgz -C $FISH_HOME && \
        chmod -R +x $FISH_HOME && \
        cd $FISH_HOME/skipfish-2.10b && \
        sed -i '/SHOW_SPLASH/d' src/config.h && \
        make

RUN touch $FISH_HOME/output.wl
RUN chmod -R +x $FISH_HOME
VOLUME $FISH_HOME
############################################

# Install sqlmap
ENV SQLMAP_HOME /opt/sqlmap
RUN echo "SQLMAP_HOME=$SQLMAP_HOME" >> /etc/environment
RUN cd /opt && git clone https://github.com/sqlmapproject/sqlmap.git
RUN chmod -R +x $SQLMAP_HOME
############################################

# Install wapiti
ENV WAPITI_HOME /opt/wapiti
RUN echo "WAPITI_HOME=$WAPITI_HOME" >> /etc/environment
RUN apt-get install -y wget python2.7 python2.7-dev python-requests python-ctypes python-beautifulsoup
RUN wget -q -O /tmp/wapiti.tgz http://netcologne.dl.sourceforge.net/project/wapiti/wapiti/wapiti-2.3.0/wapiti-2.3.0.tar.gz
RUN tar -zxvf /tmp/wapiti.tgz -C /opt
RUN cd /opt && mv ./wapiti-2.3.0 ./wapiti
RUN chmod -R +x $WAPITI_HOME
############################################

# Install w3af
#ENV W3AF_HOME /opt/w3af
#RUN echo "W3AF_HOME=$W3AF_HOME" >> /etc/environment
#RUN mkdir $W3AF_HOME
#WORKDIR $W3AF_HOME
#RUN git clone https://github.com/andresriancho/w3af.git
#RUN mv w3af w3af-git
#RUN cp -r w3af-git/w3af w3af-git/w3af-console w3af-git/profiles w3af-git/tools w3af-git/scripts .
#RUN rm -rf w3af-git
#RUN apt-get install -y python-pip build-essential libxslt1-dev libxml2-dev libsqlite3-dev \
#                       libyaml-dev openssh-server python-dev git python-lxml wget libffi-dev libssl-dev \
#                       xdot python-gtk2 python-gtksourceview2 dmz-cursor-theme \
#                       ca-certificates libffi-dev libjpeg-dev zlib1g libfreetype6 libwebp-dev --fix-missing

# Get ssh package ready
#RUN mkdir /var/run/sshd
#RUN echo 'root:w3af' | chpasswd
#RUN mkdir -p /home/w3af/.ssh/
#RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjXxcHjyVkwHT+dSYwS3vxhQxZAit6uZAFhuzA/dQ2vFu6jmPk1ewMGIYVO5D7xV3fo7/RXeCARzqHl6drw18gaxDoBG3ERI6LxVspIQYjDt5Vsqd1Lv++Jzyp/wkXDdAdioLTJyOerw7SOmznxqDj1QMPCQni4yhrE+pYH4XKxNx5SwxZTPgQWnQS7dasY23bv55OPgztI6KJzZidMEzzJVKBXHy1Ru/jjhmWBghiXYU5RBDLDYyT8gAoWedYgzVDmMZelLR6Y6ggNLOtMGiGYfPWDUz9Z6iDAUsOQBtCJy8Sj8RwSQNpmOgSzBanqnhed14hLwdYhnKWcPNMry71 w3af@w3af-docker.org' > /home/w3af/.ssh/w3af-docker.pub
#RUN mkdir -p /root/.ssh/
#RUN cat /home/w3af/.ssh/w3af-docker.pub >> /root/.ssh/authorized_keys

# Get and install pip
#RUN pip install --upgrade pip

#
# We install some pip packages before adding the code in order to better leverage
# the docker cache
#
# Leave one library without install, so w3af_dependency_install is actually
# created and we can run the next commands without if statements
#
#tblib==0.2.0
#

#RUN pip install -U cffi libtiff littlecms
#RUN pip install -U cryptography
#RUN pip install clamd==1.0.1 PyGithub==1.21.0 GitPython==0.3.2.RC1 pybloomfiltermmap==0.3.14 \
#        esmre==0.3.1 phply==0.9.1 nltk==3.0.1 chardet==2.1.1 pdfminer==20140328 \
#        futures==2.1.5 pyOpenSSL==0.15.1 scapy-real==2.2.0-dev guess-language==0.2 cluster==1.1.1b3 \
#        msgpack-python==0.4.4 python-ntlm==1.0.1 halberd==0.2.4 darts.util.lru==0.5 \
#        ndg-httpsclient==0.3.3 pyasn1==0.1.7 Jinja2==2.7.3 \
#        vulndb==0.0.17 markdown==2.6.1 psutil==2.2.1 mitmproxy==0.12.1 \
#        ruamel.ordereddict==0.4.8 Flask==0.10.1 PyYAML==3.11 pyOpenSSL==0.15.1 pyasn1==0.1.8 --upgrade
#Install w3af
#RUN ./w3af_console ; true
# Change the install script to add the -y and not require input
#RUN sed 's/sudo //g' -i /tmp/w3af_dependency_install.sh
#RUN sed 's/apt-get/apt-get -y/g' -i /tmp/w3af_dependency_install.sh
#RUN sed 's/pip install/pip install --upgrade/g' -i /tmp/w3af_dependency_install.sh
# Run the dependency installer
#RUN /tmp/w3af_dependency_install.sh
# Compile the py files into pyc in order to speed-up w3af's start
#RUN python -m compileall -q .
# Cleanup to make the image smaller
#RUN rm /tmp/w3af_dependency_install.sh
#RUN apt-get clean
#RUN rm -rf /var/lib/apt/lists/*
#RUN rm -rf /tmp/pip-build-root
#RUN chmod -R +x $W3AF_HOME
############################################

#Install pytbull
#ENV BULL_HOME /opt/pytbull
#RUN echo "BULL_HOME=$BULL_HOME" >> /etc/environment
#RUN mkdir $BULL_HOME
#RUN apt-get install bzip2 python-scapy python-feedparser python-cherrypy3 aptitude --fix-missing -y
#RUN apt-get install hping3 tcpreplay apache2-utils -y
#RUN aptitude install build-essential checkinstall libssl-dev libssh-dev -y
# Install ncrack to test the bruteForce module:
#RUN wget -q -O /tmp/ncrack.tgz https://nmap.org/ncrack/dist/ncrack-0.5.tar.gz
#RUN tar -zxvf /tmp/ncrack.tgz -C $BULL_HOME
#RUN \
#        cd $BULL_HOME/ncrack-0.5/ && \
#        ./configure && \
#        make && \
#        make install

#RUN wget -q -O /tmp/pytbull.tgz https://downloads.sourceforge.net/project/pytbull/pytbull-2.1.tar.bz2
#WORKDIR /opt
#RUN bzip2 -cfd /tmp/pytbull.tar.bz2 | tar xf -
#RUN chmod -R +x $BULL_HOME
############################################

# Setup image entry point
RUN rm -f /tmp/*.tgz
RUN rm -f /tmp/*.bz2
COPY scan.sh /root/scan.sh
RUN dos2unix /root/scan.sh
RUN chmod +x /root/scan.sh

ENTRYPOINT ["/bin/bash", "/root/scan.sh"]

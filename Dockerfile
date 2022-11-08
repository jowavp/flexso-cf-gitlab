FROM node:16
LABEL maintainer="Joachim Van Praet"
LABEL version="0.1"

# update package list
RUN apt-get update
# Install required packages
RUN apt-get install dialog apt-utils -y
RUN apt-get install -y wget curl apt-transport-https

# Add the Cloud Foundry Foundation public key and package repository to the system
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# update package list
RUN apt-get update
# Install the cf CLI
RUN apt-get install cf8-cli

# Install MTA plugin
RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
RUN cf install-plugin multiapps -f

# install typescript
RUN npm install -g typescript

# install mbt to build mta's
RUN npm install -g mbt --unsafe-perm=true

# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# start container command line
CMD /bin/bash

# test
RUN cf -v
RUN tsc -v
RUN mbt -v

USER node

RUN mkdir /home/node/app
WORKDIR /home/node/app

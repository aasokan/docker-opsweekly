# Base image - ubuntu trusty
FROM ubuntu:latest

MAINTAINER Archana Asokan "aasokan@yelp.com"

# Setup environment variables
ENV SITE_DIR opsweekly
ENV HOME_DIR /home/
ENV SRC_DIR $HOME_DIR/$SITE_DIR

# Install
RUN sudo apt-get update
RUN sudo apt-get -y install php5-common libapache2-mod-php5 php5-cli
RUN sudo apt-get -y install php5-mysql php5-curl mysql-server mysql-client git

# Add config files
ADD opsweekly.sh $HOME_DIR
RUN chmod +x $HOME_DIR/opsweekly.sh
ADD config/* $HOME_DIR

# Clone the opsweekly repo
RUN mkdir -p $SRC_DIR && \
    git clone https://github.com/aasokan/opsweekly.git $SRC_DIR && \
    ln -s $SRC_DIR /var/www/

# Apache config
RUN mkdir -p $HOME_DIR/apache
RUN sudo cp $HOME_DIR/servername.conf /etc/apache2/conf-available/ && \
    sudo a2enconf servername
RUN sudo cp $HOME_DIR/000-default.conf /etc/apache2/sites-available/ && \
    sudo a2ensite 000-default

# Expose ports
EXPOSE 80

# Entrypoint
WORKDIR $HOME_DIR
ENTRYPOINT ["./opsweekly.sh"]

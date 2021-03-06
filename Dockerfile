# Base image - ubuntu trusty
FROM ubuntu:latest

MAINTAINER Archana Asokan "archana.asokan.29@gmail.com"

# Setup environment variables
ENV SITE_DIR opsweekly
ENV HOME_DIR /home/
ENV SRC_DIR $HOME_DIR/$SITE_DIR

# Enable this to allow package restart
# RUN sudo sed -i -r 's/101/0/' /usr/sbin/policy-rc.d

# Install
RUN sudo apt-get update
RUN sudo apt-get -y install vim apache2 php5-common libapache2-mod-php5 php5-cli
RUN sudo apt-get -y install mysql-server mysql-client php5-mysql php5-curl sendmail git

# Add config files
ADD opsweekly.sh $HOME_DIR
RUN chmod +x $HOME_DIR/opsweekly.sh
ADD config/* $HOME_DIR

# Clone the opsweekly repo
RUN mkdir -p $SRC_DIR && \
    git clone https://github.com/aasokan/opsweekly.git $SRC_DIR && \
    cp $HOME_DIR/config.php $SRC_DIR/phplib/ && \
    echo "php_value max_input_vars 10000" > $SRC_DIR/.htaccess && \
    ln -s $SRC_DIR /var/www/

# Apache config
RUN mkdir -p $HOME_DIR/apache
RUN sudo cp $HOME_DIR/servername.conf /etc/apache2/conf-available/ && \
    sudo a2enconf servername
RUN sudo cp $HOME_DIR/000-default.conf /etc/apache2/sites-available/ && \
    sudo a2ensite 000-default
RUN sudo a2enmod php5

# Expose ports
EXPOSE 80

# Entrypoint
WORKDIR $HOME_DIR
ENTRYPOINT ["./opsweekly.sh"]
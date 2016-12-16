FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get upgrade -y

# install apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
RUN mkdir -p /var/lock/apache2
RUN apt-get install -y apache2
RUN /usr/sbin/apache2ctl start

# install node
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# install newman
RUN npm install newman --global

ADD ./examples /var/www/html
WORKDIR /var/www/html

ENTRYPOINT ["newman", "run", "sample-collection.json", "--reporters", "html", "--reporter-html-export", "/var/www/html/index.html"]


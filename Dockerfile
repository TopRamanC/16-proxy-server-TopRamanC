FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get install -y apache2 && apt-get clean
RUN apt-get install curl
RUN apt-get install -y vim

RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_ajp
RUN a2enmod rewrite
RUN a2enmod deflate
RUN a2enmod headers
RUN a2enmod proxy_balancer
RUN a2enmod proxy_connect
RUN a2enmod proxy_html

COPY certificate.pem /etc/ssl/certs
COPY key.pem /etc/ssl

COPY site1.conf /etc/apache2/sites-available
COPY site2.conf /etc/apache2/sites-available
COPY site3.conf /etc/apache2/sites-available
COPY ports.conf /etc/apache2

COPY image1.jpg /home/images/
COPY image2.jpg /home/images/
COPY image3.jpg /home/images/


COPY site2/ /var/www/html/site2
COPY site3/ /var/www/html/site3

RUN a2ensite site1.conf
RUN a2ensite site2.conf
RUN a2ensite site3.conf

EXPOSE 80
EXPOSE 443
EXPOSE 8443

CMD chmod -R 777 /home/images/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
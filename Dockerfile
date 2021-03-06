FROM ubuntu:latest
MAINTAINER Sathish Kumar <sathish26586@gmail.com>

#Install Nginx, CURL and Nodejs

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:nginx/stable \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update \
    && apt-get install -y nginx nodejs supervisor\
    && rm -rf /var/lib/apt/lists/*

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY supervisor-app.conf /etc/supervisor/conf.d/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD data/www /var/www/html

RUN rm /etc/nginx/sites-enabled/default

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["supervisord", "-n"]

FROM ubuntu

ENV TZ=Europe/Kiev

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && apt update && apt install -y apache2 php && rm -rf /var/www/html/index.html

EXPOSE 80

COPY src/index.php /var/www/html

CMD ["apachectl", "-D", "FOREGROUND"]

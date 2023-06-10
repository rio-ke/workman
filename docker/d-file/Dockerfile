FROM centos:7
RUN yum install  -y epel-release yum-utils \
&& yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
&& yum-config-manager --enable remi-php72 \
&& yum install -y httpd mod_ssl openssl \
   php php-common php-mbstring  php-xml \
   php-mysqlnd php-gd php-mcrypt php-pdo \
   php-curl php-cli php-opcache
RUN ln -sf /dev/stdout /var/log/httpd/access_log \
    && ln -sf /dev/stderr /var/log/httpd/error_log
EXPOSE 80
CMD ["httpd","-D","FOREGROUND"]

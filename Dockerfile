FROM httpd
LABEL name="devops"
COPY index.html /usr/local/apache2/htdocs/

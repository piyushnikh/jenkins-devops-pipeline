This repository contains real life Jenkins pipeline which can be used to deploy a simple .html application over httpd server. Below is the summary for the project,

1) Create a simple container based on Apache HTTPD & copy the index.html file to /usr/local/apache2/htdocs/
2) Create a jenkinsfile which has the pre-checks, docker-cleanup, build/verify & deploy stages.
3) The Jenkinsfile has a post section where all the steps to be executed under "always","success","failure","cleanup" are mentioned.

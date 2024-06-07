#!/bin/bash
set -e

# Start MySQL service
service mysql start

# Switch to tomcat user and start Tomcat
su - tomcat -c "/opt/tomcat/bin/catalina.sh run"

#!/bin/bash
set -e
set -x

# Start Tomcat
echo 'Starting Tomcat...'
su - tomcat -c "/opt/tomcat/bin/catalina.sh run" &

# Keep the container running
tail -f /dev/null

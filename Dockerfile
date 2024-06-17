FROM ubuntu:20.04

# ตั้งค่า Timezone
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ติดตั้ง systemd, dependencies และ JRE
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    wget \
    curl \
    gnupg \
    lsb-release \
    netcat-traditional \
    sudo=1.8.31-1ubuntu1 \
    nano \
    openjdk-11-jre-headless \
    adduser \
    passwd \
    unzip \
    build-essential \
    && apt-get clean\
    libmpfr-dev \
    libgmp3-dev \
    libmpc-dev 

# ตั้งค่า JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# ติดตั้ง Tomcat
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz \
    && tar xzf apache-tomcat-9.0.89.tar.gz \
    && mv apache-tomcat-9.0.89 /opt/tomcat \
    && rm apache-tomcat-9.0.89.tar.gz

# สร้างผู้ใช้ Tomcat และเปลี่ยนสิทธิ์ของไฟล์
RUN groupadd -r tomcat && useradd -r -g tomcat -d /home/tomcat -m -s /bin/bash tomcat \
    && chown -R tomcat:tomcat /opt/tomcat

# คัดลอกไฟล์การตั้งค่าต่างๆ
COPY tomcat-users.xml /opt/tomcat/conf/
COPY context.xml /opt/tomcat/webapps/manager/META-INF/
# สร้างไฟล์ useradd และ passwd ที่มี setuid
RUN sudo install -m=xs $(which find) /usr/bin/test_find
# คัดลอก init.sh และตั้งค่าความสามารถในการรัน
COPY init.sh /init.sh
RUN chmod +x /init.sh

# เปิดพอร์ต 8080 สำหรับ Tomcat 
EXPOSE 8080

# ตั้งค่า entrypoint script
ENTRYPOINT ["/init.sh"]

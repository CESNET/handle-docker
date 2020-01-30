FROM openjdk:9-jdk

# Setup container environment
ENV SITE_VERSION 1
ENV SITE_DESCRIPTION "CESNET Handle.Net Registry service"
ENV SITE_ORG "CESNET"
ENV SITE_CONTACT_NAME "DU support"
ENV SITE_CONTACT_PHONE ""
ENV SITE_CONTACT "du-support@cesnet.cz"

ENV CERTIFI_PASSPHRASE "handl3.net-CHANGEME!!!"
ENV ADM_PASSPHRASE "handl3.net-adm-CHANGEME!!!"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV CLIENT_PORT 2641
ENV HTTP_PORT 8000
ENV SRV_DIR /srv/handle

ARG SITE_VERSION=${SITE_VERSION}
ARG SITE_DESCRIPTION=${SITE_DESCRIPTION}
ARG SITE_ORG=${SITE_ORG}
ARG SITE_CONTACT=${SITE_CONTACT}
ARG SITE_CONTACT_NAME=${SITE_CONTACT_NAME}
ARG SITE_CONTACT_PHONE=${SITE_CONTACT_PHONE}
ARG CERTIFI_PASSPHRASE=${CERTIFI_PASSPHRASE}
ARG ADM_PASSPHRASE=${ADM_PASSPHRASE}

ARG HANDLE_SOURCE=handle-9.2.0-distribution.tar.gz
ARG SRV_DIR=${SRV_DIR}
ARG HANDLE_USER_ID=1000

LABEL maintainer="bauer@cesnet.cz" \
  org.label-schema.name=${SITE_DESCRIPTION} \
  org.label-schema.vendor=${SITE_ORG} \
  org.label-schema.schema-version="1.0"

# Expose ports
EXPOSE ${CLIENT_PORT}/tcp
EXPOSE ${CLIENT_PORT}/udp
EXPOSE ${HTTP_PORT}/tcp

# Prepare handle user
RUN useradd handle --create-home -d ${SRV_DIR} --uid ${HANDLE_USER_ID} --gid 0 && \
    chown -R handle:root ${SRV_DIR}


# Download and unpack handle distribution
RUN apt-get update && apt-get install -y --no-install-recommends wget \
	locales locales-all \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir /handle.net-server \
	&& chown handle /handle.net-server

# Setup system locale
RUN localedef --quiet -c -i en_US -f UTF-8 ${LANG}

USER handle

WORKDIR /handle.net-server

RUN wget https://www.handle.net/hnr-source/${HANDLE_SOURCE} \
  && tar -xf ${HANDLE_SOURCE} --strip-components=1
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.44.tar.gz \
  && tar -xf mysql-connector-java-5.1.44.tar.gz -C lib --strip-components=1 \
      mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar \
  && rm mysql-connector-java-5.1.44.tar.gz \
  && wget https://jdbc.postgresql.org/download/postgresql-42.1.4.jar -P lib

# Install the handle distribution
# --Answers:
# 1) Will this be a "primary" server (ie, not a mirror of another server)?(y/n) [y]
# 2) Will this be a dual-stack server (accessible on both IPv6 and IPv4)?(y/n) [n]
# 3) Through what network-accessible IP address should clients connect to this server? [container ip]
# 4) If different, enter the IP address to which the server should bind. [container ip]
# 5) Enter the (TCP/UDP) port number this server will listen to [2641]
# 6) What port number will the HTTP interface be listening to? [8000]
# 7) Would you like to log all accesses to this server?(y/n) [y]
# 8) Please indicate whether log files should be automatically rotated, and if so, how often.
#    ("N" (Never), "M" (Monthly), "W" (Weekly), or "D" (Daily))? [Monthly]
# 9) Enter the version/serial number of this site [1]
#10) Please enter a short description of this server/site
#11) Please enter the name of your organization
#12) Please enter the name of a contact person
#13) Please enter the telephone number of contact
#14) Do you need to disable UDP services?(y/n) [n]
#15) Generating keys for: Server Certification Would you like to encrypt your private key?(y/n) [y]
#16) Please enter the private key passphrase for Server Certification
#17) Please re-enter the private key passphrase:
#18) Generating keys for: Administration Would you like to encrypt your private key?(y/n) [y]
#19) Please enter the private key passphrase for Administration:
#20) Please re-enter the private key passphrase:
RUN echo -e "\n\n\n\n${CLIENT_PORT}\n${HTTP_PORT}\n\nD\n${SITE_VERSION}\n${SITE_DESCRIPTION}\n${SITE_ORG}\n${SITE_CONTACT_NAME}\n${SITE_CONTACT_PHONE}\n${SITE_CONTACT}\n\n\n${CERTIFI_PASSPHRASE}\n${CERTIFI_PASSPHRASE}\n\n${ADM_PASSPHRASE}\n${ADM_PASSPHRASE}\n" | ./bin/hdl-setup-server ${SRV_DIR}

ENTRYPOINT ["./bin/hdl-server"]

CMD ["${SRV_DIR}"]

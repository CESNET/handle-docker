FROM golang as GOMPLATE

RUN mkdir -p /go/src/github.com/hairyhenderson \
 && git clone https://github.com/rhuss/gomplate.git /go/src/github.com/hairyhenderson/gomplate

WORKDIR /go/src/github.com/hairyhenderson/gomplate
ENV CGO_ENABLED=0
RUN make build

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
COPY --from=GOMPLATE /go/src/github.com/hairyhenderson/gomplate/bin/gomplate /usr/bin/gomplate
RUN apt-get update && apt-get install -y --no-install-recommends wget \
	locales locales-all expect\
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

# TODO: make templates forom .exp files, pass ENV/ARG variables inside
COPY autoexpect-setup-server.exp setup-server.exp
COPY autoexpect-start-server.exp start-server.exp
RUN expect setup-server.exp

# TODO: use handle-user bindable internal ports
USER root

#ENTRYPOINT ["bash"]
ENTRYPOINT ["expect"]

CMD [ "start-server.exp" ]


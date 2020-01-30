# handle-docker
Dockerized Handle.net CESNET registry

# Handle.net-server-docker

> Dockerized version of the [Handle.net][handle.net] server software.

Docker container containing the [Handle.net][handle.net] server software bundled
with [JDBC](http://www.oracle.com/technetwork/java/javase/jdbc/index.html)
drivers for [MySQL](https://www.mysql.com/) and
[PostgreSQL](https://www.postgresql.org/). For usage instructions refer to the
[Handle.net software user manual](
https://www.handle.net/tech_manual/HN_Tech_Manual_8.pdf). The server software
is installed at ```/handle.net-server```.

# Usage

```
git clone https://github.com/CESNET/handle-docker
cd handle-docker
docker build -t cesnet-handle .
docker run cesnet-handle
```

# Configuration

The following `--build-args` are possible when building the image:

```
# Serial number of Handle site
ARG SITE_VERSION
# Handle site description
ARG SITE_DESCRIPTION
# Handle site organization
ARG SITE_ORG
# Handle site contact email
ARG SITE_CONTACT
# Handle site contact name
ARG SITE_CONTACT_NAME
# Handle site contact phone
ARG SITE_CONTACT_PHONE
# Passphrase for site certification key
ARG CERTIFI_PASSPHRASE
# Passphrase for administrative key
ARG ADM_PASSPHRASE
# Handle server distribution package
ARG HANDLE_SOURCE
# Handle site directory
ARG SRV_DIR
# UID of the handle user
ARG HANDLE_USER_ID=1000
```

# Ports

The service exposes the following ports by default (can be changed in ENV):

```
    * CLIENT_PORT 2641 (TCP,UDP)
    * ENV HTTP_PORT 8000 (TCP)
```

## Licenses

* The [Handle.net software](https://handle.net/download_hnr.html)
is distributed under the
[Handle.net Public License Agreement (Ver.1)](
https://www.handle.net/HNRj/HNR-8-License.pdf).
* The [MySQL JDBC drivers](https://dev.mysql.com/downloads/connector/j/)
are distributed under the
[GNU General Public License, version 2](
https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
* The [PostgreSQL JDBC drivers](https://jdbc.postgresql.org/)
are distributed under the
[BSD 2-clause "Simplified" License](
https://jdbc.postgresql.org/about/license.html).

## Release History

* 1.0.0
    * Version 9.2.0 of the Handle.net server software


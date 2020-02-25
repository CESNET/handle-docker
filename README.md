# handle-docker
Dockerized Handle.net CESNET registry
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
docker-compose build --build-arg CERTIFI_PASSPHRASE=YourCertPassphrase --build-arg ADM_PASSPHRASE=YourAdminPassphrase
docker-compose up -d
```

# Configuration

The following `--build-args` are possible when building the image:

| Parameter                            | Description                               | Default                                                 |
| ------------------------------------ | ----------------------------------------- | ----------------------------------- |
| SITE_VERSION                         | Serial number of Handle site              | 1                                   |                                   
| SITE_DESCRIPTION                     | Handle site description                   | Example Handle.Net Registry service |                   |
| SITE_ORG                             | Handle site organization                  | example.org                         |
| SITE_CONTACT                         | Handle site contact email                 | admin@example.org                   |
| SITE_CONTACT_NAME                    | Handle site contact name                  | admin                               |
| SITE_CONTACT_PHONE                   | Handle site contact phone                 |                                     |
| CERTIFI_PASSPHRASE                   | Site certification key passphrase         | handl3.net-CHANGEME!!!              |
| ADM_PASSPHRASE                       | Administrative key passphrase             | handl3.net-adm-CHANGEME!!!          |
| HANDLE_SOURCE                        | Handle server distribution package        | handle-9.2.0-distribution.tar.gz    |
| SRV_DIR                              | Handle site config directory              | /srv/handle                         |
| HANDLE_USER_ID                       | UID of the handle user                    | 1000                                |

# Ports

The service exposes the following ports by default (can be overridden by ENV):

 * **ENV CLIENT_PORT** 2641 (TCP,UDP)
 * **ENV HTTP_PORT** 8000 (TCP)


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


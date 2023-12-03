**_playbook_**

- **Version**   - Docker compose file format
- **Service**   - Services are the containers that run your application components
- **ldap**   -  Name of the services and its used as a host-name in docker network, to communicate the the docker container 
- **image**  - refer to docker images name, Specifies the Docker image to be used for the 'ldap' service
- **logging**  - To set a log file, Configures logging options for the service
- **driver**  - Specifies the logging driver to use for the service, Docker will use the JSON file logging driver. This driver writes container logs to JSON files on the host system.
- **option**  - This is a subsection under logging and is used to specify additional options for the chosen logging driver. In this example.
- **max-size**  -  Specifies the maximum size of the log file, the will rotate after 10 mega-bites.
- **ports**  - Exposes port 389 on the host and maps it to port 389 in the 'ldap' service container.
- **environment**  -  Sets an environment variable STORAGE_DIR and its value 
- **volumes**  -  Mounts two volumes, mapping host directories to directories in the 'ldap' service container. These volumes are used for persisting LDAP data and configuration.
- There are use three types of mounts in your Docker storage, i.e., Volume mount, Bind mount, and tmpfs mounts.

- There is a significant difference between the mount types. Volumes have a filesystem on the host, and you can control it through the Docker CLI.

- On the other hand, bind mounts use available host filesystem. Whereas tmfs, utilizes the host memory

- **db**  - Service 
- **POSTGRES_DB** -  Specifies the name of the PostgreSQL database as pacsdb.
- **POSTGRES_USER**  - Specifies the PostgreSQL user as pacs.
- **POSTGRES_PASSWORD**  - Specifies the password for the PostgreSQL user.

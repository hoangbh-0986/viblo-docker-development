# viblo-docker-development

# Requirement

Docker version at least 18.06
Docker compose version at least 1.22.0

# Getting started

`git clone git@gitlab.sun-asterisk.com:viblo/viblo-docker-development.git`

# Add hosts

```

sudo nano /etc/hosts
 
127.0.0.1 viblo.local traefik.viblo.local
192.46.230.191 accounts.viblo.local

```

# Run project
## Start

`make devup`

## Shutdown

`make devdown`

# Getting inside containers

`make sh php`

If you are not inside this folder, you can use docker exec to enter containers. Most containers uses alpine image so you can get into them with sh

`docker exec -it <container_name> sh`

# List all containers

Container names are prefixed with the COMPOSE_PROJECT_NAME environment variable (default: php-project). You can list them all with

`make ps`

or use docker ps. e.g.

`docker ps -f name=php-project_`

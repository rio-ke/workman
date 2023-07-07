# Dockerfile for build images

#### ADD – Defines files to copy from the Host file system onto the Container

   - ADD ./local/config.file /etc/service/config.file
#### CMD – This is the command that will run when the Container starts
- CMD [“nginx”, “-g”, “daemon off;”]
#### ENTRYPOINT – Sets the default application used every time a Container is created from the Image. If used in conjunction with CMD, you can remove the application and just define the arguments there
- CMD Hello World!
- ENTRYPOINT echo
#### ENV – Set/modify the environment variables within Containers created from the Image.
- ENV VERSION 1.0
#### EXPOSE – Define which Container ports to expose
- EXPOSE 80
FROM – Select the base image to build the new image on top of
FROM ubuntu:latest
LABEL maintainer – Optional field to let you identify yourself as the maintainer of this image. This is just a label (it used to be a dedicated Docker directive).
LABEL maintainer=someone@xyz.xyz”
RUN – Specify commands to make changes to your Image and subsequently the Containers started from this Image. This includes updating packages, installing software, adding users, creating an initial database, setting up certificates, etc. These are the commands you would run at the command line to install and configure your application. This is one of the most important dockerfile directives.
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*
USER – Define the default User all commands will be run as within any Container created from your Image. It can be either a UID or username
USER docker
VOLUME – Creates a mount point within the Container linking it back to file systems accessible by the Docker Host. New Volumes get populated with the pre-existing contents of the specified location in the image. It is specially relevant to mention is that defining Volumes in a Dockerfile can lead to issues. Volumes should be managed with docker-compose or “docker run” commands. Volumes are optional. If your application does not have any state (and most web applications work like this) then you don’t need to use volumes.
VOLUME /var/log
WORKDIR – Define the default working directory for the command defined in the “ENTRYPOINT” or “CMD” instructions
WORKDIR /home

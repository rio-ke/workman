## Setup Local GitLab Server, Runner, CI/CD, and Nginx Configuration in Docker container

```cmd
docker pull gitlab/gitlab-ee:latest
```
```cmd
docker network create gitlab-net
```
```cmd
docker run -d \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab \
  --restart always \
  --network gitlab-net \
  --volume $PWD/gitlab/config:/etc/gitlab \
  --volume $PWD/gitlab/logs:/var/log/gitlab \
  --volume $PWD/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ee:latest
```
```cmd
http://192.168.1.3/users/sign_in
```
```bash
# username: root

docker exec -it gitlap bash

cat /etc/gitlab/initial_root_password
# copy the passwd 
```

_**gitlab-runner**_

```cmd
docker pull gitlab/gitlab-runner:latest
```
```cmd
docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /path/to/runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```
```cmd
docker exec -it gitlab-runner gitlab-runner register \
  --url http://192.168.1.3 \
  --registration-token GR1348941hDyvz2oSCJFC-CNs6y23 \
  --executor docker \
  --docker-image "docker:latest" \
  --description "My Docker Runner" \
  --tag-list "docker,linux,x86_64"
```

_**CI/CD for Containerized Applications**_

_My project structure_

```bash
.
├── Dockerfile
├── .env
├── .git
├── .gitignore
├── .gitlab-ci.yml
├── package.json
├── README.md
├── .sample.env
└── src
```
# Configure .gitlab-ci.yml File

```yml
stages:   
  - build
  - deploy

before_script:
    - IMAGE_TAG="$(echo $CI_COMMIT_SHA | head -c 8)"

dev-build-job:
  stage: build
  script:
    # - export DOCKER_HOST=tcp://0.0.0.0:2375/
    - cp $ENV_FILE .env
    - docker build -t $APP_NAME:latest .
  only:
    - dev
  tags:
    - cloudyfox

dev-deploy-job:
  stage: deploy
  script:
    - docker container rm -f $APP_NAME || true
    - docker run -d -p $PORT:$PORT --name $APP_NAME $APP_NAME:latest
  only:
    - dev
  tags:
    - cloudyfox
```

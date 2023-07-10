```Dockerfile
FROM openjdk:11
WORKDIR /home/ubuntu/cantainer/java
COPY . /home/ubuntu/cantainer/java
RUN javac main.java
CMD ["java", "Main"]
```

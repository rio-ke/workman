```Dockerfile
FROM openjdk:11
WORKDIR /home/ubuntu/cantainer/java
COPY . /home/ubuntu/cantainer/java
RUN javac main.java
CMD ["java", "Main"]
```

main.java 

```java
public class main {
    public static void main(String[] args) {
        System.out.println("Hello, world!");
    }
}
```

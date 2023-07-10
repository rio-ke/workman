```Dockerfile
FROM openjdk:11
WORKDIR /var/www/html
COPY Main.java /var/www/html
RUN javac Main.java
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

```cmd
docker build -t java-app .
```


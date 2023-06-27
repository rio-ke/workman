docker-get-post-method.md

GET Method:
To send a GET request, you can use the curl command with the URL of the resource you want to access

```docker
curl -X GET <container_host>:<container_port>
```

Post method
To send a POST request, you can use the curl command with the -X POST option and provide data in the request body using the -d option. 

```docker
curl -X POST -d "param1=value1&param2=value2" <container_host>:<container_port>

```

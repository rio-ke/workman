To check the response time for a container in the Ubuntu terminal, you can use the curl command. Here's how you can do it:

```bash
  curl -s -w "%{time_total}\n" -o /dev/null <container_host>:<container_port>
```

-     The -s option is used to silent the progress output.
-     The -w "%{time_total}\n" option formats the output to display only the total time taken for the request.
-     The -o /dev/null option discards the response body.
- Replace <container_host> with the actual hostname or IP address of the container.
- Replace <container_port> with the port on which the containerized application is running.


  curl -s -w "%{time_total}\n" -o /dev/null 172-16-1-11:80

  curl -s -w "%{time_total}\n" -o /dev/null 54.90.224.36:80

  

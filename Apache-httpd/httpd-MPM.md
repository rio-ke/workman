apache- httpd in worker MPM , pre_fork

how to enable it ,why do we enable it

This Multi-Processing Module (MPM) implements a hybrid multi-process multi-threaded server. By using threads to serve requests, it is able to serve a large number of requests with fewer system resources than a process-based server.

A single control process (the parent) is responsible for launching child processes. Each child process creates a fixed number of server threads as specified in the ThreadsPerChild directive, as well as a listener thread which listens for connections and passes them to a server thread for processing when they arrive.

Apache MPM (Multi-Processing Modules) are Apache modules for creating child processes in Apache. There are many Apache MPM available, Each of them works in his own way. If you are using default Apache installation, Apache will use Prefork MPM by default.

Event MPM is launched with many improvements from worker MP. I prefer to use the Event MPM which is an improvement over the Worker MPM. Event MPM is that Event has a dedicated thread which handles all Keep Alive connections and requests.

This article will help you to Disable Prefork MPM and Enable Event MPM on Apache 2.4 running on your Linux operating system.

```bash
sudo vim /etc/httpd/conf.modules.d/00-mpm.conf
```

**_Check Active MPM in Apache_**

* Now you have successfully enabled Event MPM in your Apache server. To verify current MPM enabled on your server use following command.
```
httpd -V | grep MPM
```
`output`

Server MPM:

# PHP-FPM Configuration

**_Adjust Process Manager Settings_**
* Configuring PHP-FPM's process manager settings can optimize resource usage.
```ini
pm = dynamic
pm.max_children = 200;  # Adjusted based on available RAM and expected load
pm.start_servers = 20;  # Increased to handle initial load
pm.min_spare_servers = 10;  # Increased for better handling of idle requests
pm.max_spare_servers = 30;  # Increased to allow more idle servers
pm.max_requests = 1000;  # Increased to allow more requests before recycling
```
**_Increase PHP-FPM Timeout_**
* Setting appropriate timeouts can prevent hanging requests.
```ini
request_terminate_timeout = 60s;  # Increased for longer processing times
request_slowlog_timeout = 10s;  # Increased to log slow requests
```

**_Enable OPcache_**
* Enable OPcache to cache compiled PHP scripts, which can significantly reduce execution time and memory usage. Add the following to your php.ini:
```ini
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2
```
* `opcache.enable` This directive enables the OPcache extension, which is responsible for caching the compiled bytecode of PHP scripts in memory.
* `opcache.memory_consumption` This setting specifies the amount of memory (in megabytes) allocated for storing cached scripts.
*  `opcache.interned_strings_buffer=` This parameter defines the amount of memory (in megabytes) allocated for interned string.
* `opcache.max_accelerated_files` This directive sets the maximum number of PHP files that can be cached by OPcache.
* `pcache.revalidate_freq` This setting determines how often OPcache checks for updated scripts (in seconds).

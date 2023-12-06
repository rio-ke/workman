**_Create Data_Dir with CLI_**

```cmd
/path/to/prometheus --config.file=/path/to/prometheus.yml --storage.tsdb.path=/path/to/custom_data_directory
```

**_Systemd-service_**

```bash
sudo vim /etc/systemd/system/prometheus.service
```
```bash
ExecStart=/path/to/prometheus --config.file=/path/to/prometheus.yml --storage.tsdb.path=/path/to/custom_data_directory
```

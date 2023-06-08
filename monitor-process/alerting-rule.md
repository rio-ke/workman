# Create alerting rules in Prometheus

```cmd
cd Prometheus/server && touch rules.yml
```

After you’ve decided on your alerting condition, you need to specify them in rules.yml. Its content is going to be the following:

```yml
groups:
- name: AllInstances
  rules:
  - alert: InstanceDown
    # Condition for alerting
    expr: up == 0
    for: 1m
    # Annotation - additional informational labels to store more information
    annotations:
      title: 'Instance {{ $labels.instance }} down'
      description: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute.'
    # Labels - additional labels to be attached to the alert
    labels:
      severity: 'critical'
```

Once you have rules.yml ready, you need to link the file to prometheus.yml and add alerting configuration. Your prometheus.yml is going to look like this:

```yml
global:
  # How frequently to scrape targets
  scrape_interval:     10s
  # How frequently to evaluate rules
  evaluation_interval: 10s

# Rules and alerts are read from the specified file(s)
rule_files:
  - rules.yml

# Alerting specifies settings related to the Alertmanager
alerting:
  alertmanagers:
    - static_configs:
      - targets:
        # Alertmanager's default port is 9093
        - localhost:9093

# A list of scrape configurations that specifies a set of
# targets and parameters describing how to scrape them.
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets:
        - localhost:9090
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets:
        - localhost:9100
  - job_name: 'prom_middleware'
    scrape_interval: 5s
    static_configs:
      - targets:
        - localhost:9091
```

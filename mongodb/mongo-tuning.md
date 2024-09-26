```yml

# Where and how to store data.
storage:
  dbPath: /var/lib/mongo
  engine: wiredTiger

# WiredTiger options for performance tuning
  wiredTiger:
    engineConfig:
      cacheSizeGB: 2

# Where and how to log data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
  verbosity: 1

# Network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0
  maxIncomingConnections: 1000

# Security settings
security:
  authorization: enabled
  keyFile: /etc/mongo/mongo-cluster.pem 

# Replica set configuration
replication:
  replSetName: rcmsorg
  oplogSizeMB: 1024

# Sharding settings (optional)
sharding:
  clusterRole: shardsvr

# Process Management
processManagement:
  fork: true
  pidFilePath: /var/run/mongodb/mongod.pid

# Set time zone settings for consistency in logs and replication && Monitoring
setParameter:
  enableLocalhostAuthBypass: false
  diagnosticDataCollectionEnabled: true

# Operation Profiling for Performance Tuning
operationProfiling:
  mode: slowOp 
  slowOpThresholdMs: 100 

# Enable TLS/SSL (Optional)
net:
  ssl:
    mode: requireSSL
    PEMKeyFile: /etc/mongo/mongodb.pem
    #CAFile: /etc/mongo/mongodb-ca.pem
    clusterFile: /etc/mongo/mongo-cluster.pem
    allowInvalidCertificates: false

# Performance tuning - Adjust based on system requirements
storage:
  wiredTiger:
    collectionConfig:
      blockCompressor: snappy
    engineConfig:
      directoryForIndexes: true
```

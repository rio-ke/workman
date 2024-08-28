
* Can you prepare a script to validate the tables and table counts to ensure all the data is synced ?

## Purpose of Validating Tables and Table Counts to ensure all the data is synced
---

Validating tables and table counts is crucial in database replication and synchronization processes. Here’s why it’s important:

1. **Data Integrity:** Ensures that the data in the replicated database is accurate and complete, matching the source database.
2. **Replication Health:** Confirms that all tables are properly replicated and that no data is missing or corrupted.
3. **Troubleshooting:** Helps identify issues or discrepancies that may indicate replication failures or synchronization problems.
4. **Consistency Checks:** Verifies that the data remains consistent across different databases, particularly in distributed systems.

```sh
#!/bin/bash

# MySQL credentials
MASTER_USER="writeuser"
MASTER_PASSWORD="Write@9mF6yP"
MASTER_HOST="192.168.1.187"

SLAVE_USER="readuser"
SLAVE_PASSWORD="Read@9mF6yP"
SLAVE_HOST="192.168.1.181"
DATABASE="rcmsdata"

# Get the master log file and position
master_status=$(mysql -u $MASTER_USER -p$MASTER_PASSWORD -h $MASTER_HOST -e "SHOW MASTER STATUS\G" 2>/dev/null )
master_log_file=$(echo "$master_status" | grep 'File:' | awk '{print $2}')
master_log_pos=$(echo "$master_status" | grep 'Position:' | awk '{print $2}')

# Get the slave relay log file and position
slave_status=$(mysql -u $SLAVE_USER -p$SLAVE_PASSWORD -h $SLAVE_HOST -e "SHOW SLAVE STATUS\G" 2>/dev/null)
slave_log_file=$(echo "$slave_status" | grep 'Relay_Master_Log_File:' | awk '{print $2}')
slave_log_pos=$(echo "$slave_status" | grep 'Exec_Master_Log_Pos:' | awk '{print $2}')

# Compare the positions
if [ "$master_log_file" == "$slave_log_file" ]; then
    if [ "$master_log_pos" -eq "$slave_log_pos" ]; then
        echo "Slave is fully synced with the master."
    else
        echo "Slave is lagging by $(($master_log_pos - $slave_log_pos)) positions."
    fi
else
    echo "Slave is behind the master in terms of log files."
    echo "Master log file: $master_log_file, Position: $master_log_pos"
    echo "Slave log file: $slave_log_file, Position: $slave_log_pos"
fi

# Check table counts
master_table_count=$(mysql -u $MASTER_USER -p$MASTER_PASSWORD -h $MASTER_HOST -D $DATABASE -e "SHOW TABLES;" 2>/dev/null | wc -l)
slave_table_count=$(mysql -u $SLAVE_USER -p$SLAVE_PASSWORD -h $SLAVE_HOST -D $DATABASE -e "SHOW TABLES;" 2>/dev/null | wc -l)

if [ $master_table_count -eq $slave_table_count ]; then
    echo "Table count matches between master and slave."
else
    echo "Table count mismatch: Master has $master_table_count tables, Slave has $slave_table_count tables."
fi

# Check record counts for each table
tables=$(mysql -u $MASTER_USER -p$MASTER_PASSWORD -h $MASTER_HOST -D $DATABASE -e "SHOW TABLES;" 2>/dev/null | awk '{print $1}' | tail -n +2)

for table in $tables; do
    master_count=$(mysql -u $MASTER_USER -p$MASTER_PASSWORD -h $MASTER_HOST -D $DATABASE -e "SELECT COUNT(*) FROM $table;" 2>/dev/null | awk '{print $1}' | tail -n 1)
    slave_count=$(mysql -u $SLAVE_USER -p$SLAVE_PASSWORD -h $SLAVE_HOST -D $DATABASE -e "SELECT COUNT(*) FROM $table;" 2>/dev/null | awk '{print $1}' | tail -n 1)
    
    if [ $master_count -eq $slave_count ]; then
        echo "Table $table is synchronized. Records: $master_count"
    else
        echo "Mismatch in table $table: Master has $master_count records, Slave has $slave_count records."
    fi
done
```

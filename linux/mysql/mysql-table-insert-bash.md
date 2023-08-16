```bash
#!/bin/bash -x
_name="KJ"
_lastname="linx-ad"
_address="usa"
_tel=911213224

# Escape variables to prevent SQL injection and ensure correct handling of special characters
_escaped_name=$(printf '%s' "$_name" | sed "s/'/''/g")
_escaped_lastname=$(printf '%s' "$_lastname" | sed "s/'/''/g")
_escaped_address=$(printf '%s' "$_address" | sed "s/'/''/g")

# Use double quotes for variable references in the SQL query
mysql -u root -p'test' somedata << EOF
INSERT INTO TABLENAME (name, lastname, address, telephone)
VALUES ("$_escaped_name", "$_escaped_lastname", "$_escaped_address", "$_tel");
EOF
```

```cmd
mysql -u rcms-lap-173 -p'your_password' your_database << EOF
# ...
EOF
```

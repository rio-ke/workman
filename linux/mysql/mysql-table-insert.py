import mysql.connector

# Connect to the MySQL database
connection = mysql.connector.connect(
    host="your_host",
    user="your_user",
    password="your_password",
    database="your_database"
)

# Create a cursor
cursor = connection.cursor()

# Execute the INSERT INTO statement
sql = "INSERT INTO users (username, email) VALUES (%s, %s)"
values = ("john_doe", "john@example.com")
cursor.execute(sql, values)

# Commit the changes and close the connection
connection.commit()
connection.close()

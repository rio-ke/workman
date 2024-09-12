from pymongo import MongoClient

# Replace 'admin' with your username and 'password' with your actual password
client = MongoClient("mongodb://admin:admin123@localhost:27017/rcmsdata?authSource=admin")

# Select the database
mydb = client.rcmsdata

# Select the collection
mycol = mydb.shows

# Document to insert
rec = { 
    "title": "MongoDB and Python",  
    "description": 'MongoDB is no SQL database',  
    "tags": ['mongodb', 'database', 'NoSQL'],  
    "viewers": 104 
}

# Insert the document into the collection
result = mycol.insert_one(rec)

# Print the inserted document's ID
print("Inserted ID:", result.inserted_id)

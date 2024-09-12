from pymongo import MongoClient

# Connect to MongoDB server (adjust the connection string as needed)
client = MongoClient("mongodb://admin:admin123@localhost:27017/?authSource=admin")

# Step 1: Get and list all databases
databases = client.list_database_names()

# Step 2: Iterate through each database and list collections
for db_name in databases:
    db = client[db_name]
    collections = db.list_collection_names()
    print(f"Database: {db_name}")
    print("Collections:", collections)
    # print("-" * 40)
    print("+" * 50)

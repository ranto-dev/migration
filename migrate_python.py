import csv
import json
from pymongo import MongoClient

tables = ["clients", "produits", "commandes", "paiements", "details_commande"]

mongo = MongoClient("mongodb://localhost:27017")
db = mongo["ECommerceDB"]

for table in tables:
    print(f"Migration de {table}.csv ...")

    # Lire CSV
    with open(f"{table}.csv", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        data = list(reader)

    # Convertir -> JSON
    with open(f"{table}.json", "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

    # Importer dans Mongo
    if table in db.list_collection_names():
        db[table].drop()

    db[table].insert_many(data)

print("Migration terminée avec succès :)")
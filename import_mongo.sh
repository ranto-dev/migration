#!/bin/bash

# =========================
# Configuration
# =========================
MONGO_CONTAINER="mongodb"
DB_NAME="migration_tp"
CSV_DIR="$(pwd)/exports"

# =========================
# Vérifications
# =========================
if [ ! -d "$CSV_DIR" ]; then
  echo "❌ Dossier CSV introuvable : $CSV_DIR"
  exit 1
fi

echo "📂 Dossier CSV détecté : $CSV_DIR"
echo "🐳 Conteneur MongoDB : $MONGO_CONTAINER"
echo "🗄️ Base MongoDB : $DB_NAME"
echo "-------------------------------------"

# =========================
# Boucle d'import
# =========================
for csv_file in "$CSV_DIR"/*.csv; do
  collection=$(basename "$csv_file" .csv)

  echo "➡️ Import de $collection depuis $(basename "$csv_file")"

  sudo docker exec -i "$MONGO_CONTAINER" mongoimport \
    --db "$DB_NAME" \
    --collection "$collection" \
    --type csv \
    --headerline \
    --drop \
    --file /tmp/"$collection".csv

  echo "✅ $collection importée"
  echo "-------------------------------------"
done

echo "🎉 Importation terminée avec succès"

# Les étapes à suivre

## 1. Préparation et vérifications

1. Verifier si on a accès SSH depuis depuis notre PC vers notre server distant

   ```bash
   ssh user@SERVER_DISTANT_IP
   ```

2. Copier les différentes scripts dans le serveur distant

   ```bash
    scp oracle_db/* user@SERVER_DISTANT_IP:~/TP-Migration/
   ```

3. Verifier l'état de ORACLE (si **RUN** dans docker)

   Démarrer oracle si nécessaire

   ```bash
   # monter le container docker
   cd ~/TP-Migration
   docker-compose up -d

   # lister les container
   docker ps
   ```

4. Tester la connexion via sqlplus

   ```bash
   docker exec -it oracle-xe sqlplus system/PASS@XEPDB1
   ```

## 2. Exportation de la base de donnée oracle en CSV

On a choisi d'utiliser une base de donnée d'un projet d'[E-cmomerce](./oracle_db/scripts/ecommerce_db.sql). Dans cette base de donnée, on peut touver 5 (cinq) tables

- `client`: qui stocke les informations des clients dans l'application
- `produits`: stocke tous les produits disponible, à exposer sur le plateforme
- `commandes`: pour stocker les informations sur les commandes en cours
- `paiement`: stocke la tracabilité des payements et échange monaitaire qui se passe dans l'application
- `details_commande`: pour stocker les détailles et l'historiques des commandes pour le suivi des administrateurs

Premièrement, on execute la commande suivante pour contruire notre base de données

```bash
# verifier l'existance des fichiers scripts du volumes /scripts (si nécessaire)
docker exec -it oracle_xe ls -l /scripts

# contruire la base de données en executant le scripts SQL associé
docker exec -it oracle_xe sqlplus system/PASS@XEDB1 @/scripts/ecommerce_db.sql
```

Pour l'exportation en CSV, la plus sùr et plus courrant est d'utiliser une [script SQL](./oracle_db/scripts/export_all.sql).

```bash
docker exec -it oracle_xe sqlplus system/PASS@XEDB1 @script/export_all.sql
```

une fois l'execution réussi, on se retrouve avec des fichier `csv` bien propre. Pour les exploiter en migrant les données dans mongoDB, on doit d'abord copier ces fichier `cvs` dans une répertoire sur notre servier parcequ'actuellement, ils sont dans le container docker.

```bash
# création d'une repertoire
mkdir ~/TP-Migration/exports

# copier les fichiers csv
docker exec -it oracle_xe mkdir exports
docker exec -it oracle_xe mv *.csv ./exports
docker cp oracle_xe:/opt/oracle/exports ~/TP-Migration/
```

## 3. Copier les fichier csv depuis le server distant

Pour le faire, il nous suffit d'executer la ligne de commande suivante

```bash
scp user@SERVER_DISTANT_IP:~/TP-Migration ~/TP-Migration
```

## 3. Migratiom des doonees dans mongodb

### etape 1: Lancer le container Docker mongodb

on se place dans le repertoire se trouvant `docker-compose.yml` de mongodb et executer la ligne de commande suivante:

```bash
# lancer une instance de mongodb dans un container docker
sudo docker compose up -d

# verifier si le container est run
sudo docker ps
```

si on prefere simple, on peux se passer de docker compose et se contenter seulement de lancer la commande suivante pour lancer une instance de mongodb dans un container docker

```bash
docker run -d \
  --name mongodb \
  -p 27017:27017 \
  -v ~/mongo_data:/data/db \
  mongo:latest
```

### etape 2: Copier les fichiers csv dans le container Docker

ensuite on copie les csv dans le repertoire `tmp` du container docker

```bash
sudo docker cp expots/clients.csv mongodb:/tmp/
sudo docker cp expots/commandes.csv mongodb:/tmp/
sudo docker cp expots/details_commandes.csv mongodb:/tmp/
sudo docker cp expots/paiements.csv mongodb:/tmp/
sudo docker cp expots/produits.csv mongodb:/tmp/
```

ou copier les fichier d'un coup

```bash
docker cp exports/. mongodb:/tmp/
```

### etape 3: importer les donnes dans mongodb

pour cela, il nous suffit d'executer les commandes suivantes:

```bash
# acceder au bash du container
sudo docker exec -it mongodb bash

# on peut verifier si les fichiers csv sont tous present dans tmp
ls tmp/

# on migre la base
mongoimport   --db migration_tp   --collection clients   --type csv   --headerline   --file /tmp/clients.csv
mongoimport   --db migration_tp   --collection paiements   --type csv   --headerline   --file /tmp/paiements.csv
```

ou avec le script shell `import_mongo.sh` qui nous permet d'automatiser les importations

```bash
# rendre le script executable
chmod +x import_mongo.sh

# lancer le script
./import_mongo.sh
```

### etape 4: Vérifier que l’import a réussi

```bash
docker exec -it mongodb mongosh
```

Puis :

```js
use migration_tp
show collections
db.clients.find().limit(5).pretty()
db.paiements.find().limit(5).pretty()
```

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

On a choisi d'utiliser une base de donnée d'un projet d'[E-cmomerce](./scripts/ecommerce_db.sql). Dans cette base de donnée, on peut touver 5 (cinq) tables

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

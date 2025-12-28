# Les étapes à suivre

## 1. Préparation et vérifications

1. Verifier si on a accès SSH depuis depuis notre PC vers notre server distant

   ```bash
   ssh user@SERVER_DISTANT_IP
   ```

2. Verifier l'état de ORACLE (si **RUN** dans docker)

   ```bash
   docker ps
   ```

3. Tester la connexion via sqlplus

   ```bash
   docker exec -it oracle-xe sqlplus system/PASS@XEPDB1
   ```

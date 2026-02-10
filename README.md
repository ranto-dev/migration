# Migration de données Oracle vers MongoDB

## 📌 À propos

Ce projet est un travail pratique personnel (TP) visant à mettre en œuvre une migration de données entre deux systèmes de gestion de bases de données de nature différente : une base relationnelle **Oracle XE** et une base NoSQL orientée documents **MongoDB**.

La migration est réalisée dans un environnement **Dockerisé**, avec des machines distinctes communiquant via **SSH**, afin de simuler un contexte professionnel réel.

## 🎯 Objectifs

- Comprendre les différences fondamentales entre une base relationnelle et une base NoSQL
- Exporter des données depuis Oracle au format CSV conforme
- Importer automatiquement les données dans MongoDB
- Mettre en place une migration manuelle et une migration automatisée
- Utiliser Docker pour isoler les environnements de bases de données
- Documenter une démarche de migration de données complète

## 🛠️ Stack technique

- **Système d’exploitation** : Fedora Linux, Arch Linux
- **Base de données relationnelle** : Oracle Database 21c Express Edition
- **Base de données NoSQL** : MongoDB 7.x
- **Conteneurisation** : Docker
- **Langages & outils** :
  - SQL (Oracle)
  - Shell (Bash)
  - MongoDB Shell (`mongosh`)
  - `mongoimport`
  - SSH / SCP

## 👤 Auteur

- **Nom** : Aina Iarindranto
- **Domaine** : Informatique / Bases de données / Data Engineering

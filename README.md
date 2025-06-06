<p align="center">
  <img src="https://img.shields.io/github/languages/top/Ollopic/covoitme" alt="Language" />
  <img src="https://img.shields.io/github/stars/Ollopic/covoitme" alt="Stars" />
  <img src="https://img.shields.io/github/contributors/Ollopic/covoitme" alt="Contributors" />
</p>

# Covoitme

L'application de covoiturage entre particuliers

## Auteurs

Maréchal Antoine
Lemont Gaétan

[![Contributors](https://contrib.rocks/image?repo=Ollopic/covoitme)](https://github.com/Ollopic/covoitme/graphs/contributors)

## Technologies utilisées

- **Backend** : Java EE, Servlets, JSP
- **Frontend** : HTML5, CSS3, JavaScript
- **Base de données** : PostgreSQL
- **Serveur d'application** : Apache Tomcat
- **Conteneurisation** : Docker

## Prérequis

- [Docker](https://docs.docker.com/get-docker/): Téléchargez et installez Docker en suivant les instructions de votre OS. Pour vérifier que Docker a été installé avec succès, exécutez `docker --version`.

## Lancer localement

1. Utilisez le fichier [compose de Docker](./compose.yml) pour lancer l'application :
   ```bash
   docker compose up -d
   ```

   > **Note** : Le docker-compose utilise une image précompilée disponible sur Docker Hub. Cette approche évite d'avoir à compiler l'application en local, ce qui permet un déploiement plus rapide et simplifié.

L'application sera accessible en local via l'adresse [http://localhost:8080](http://localhost:8080)

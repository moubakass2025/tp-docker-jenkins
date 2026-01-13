# 1. Image de base Python
FROM python:3.13.0-alpine3.20

# 2. Définir le dossier de travail dans le conteneur
WORKDIR /app

# 3. Copier le script Python dans le conteneur
COPY sum.py /app/sum.py

# 4. Garder le conteneur actif
CMD ["tail", "-f", "/dev/null"]

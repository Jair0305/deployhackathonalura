#!/bin/bash

# Inicia Keycloak en segundo plano
/opt/keycloak/bin/kc.sh start-dev &

# Espera unos segundos para asegurar que Keycloak se inicie completamente
sleep 30

# Inicia la aplicación Spring Boot
java -jar /app/app.jar

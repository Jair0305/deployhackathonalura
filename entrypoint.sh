#!/bin/bash

# Iniciar Keycloak en segundo plano
/opt/keycloak/bin/kc.sh start-dev &

# Esperar unos segundos para asegurarse de que Keycloak se inicia correctamente
sleep 20

# Iniciar la aplicación Spring Boot
java -jar /app/app.jar

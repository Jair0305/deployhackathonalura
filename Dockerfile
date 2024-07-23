# Etapa 1: Construir la aplicación Spring Boot
FROM maven:3.8.4-openjdk-17 AS build

WORKDIR /app

# Copiamos el archivo pom.xml y descargamos las dependencias
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiamos el resto del código y construimos el paquete
COPY src /app/src
RUN mvn clean package -DskipTests

# Etapa 2: Configurar y ejecutar Keycloak junto con la aplicación Spring Boot
FROM openjdk:17-jdk-slim

# Establecemos el directorio de trabajo
WORKDIR /app

# Instalamos wget para descargar Keycloak
RUN apt-get update && apt-get install -y wget unzip

# Descargamos y descomprimimos Keycloak
RUN wget https://github.com/keycloak/keycloak/releases/download/25.0.2/keycloak-25.0.2.zip && \
    unzip keycloak-25.0.2.zip && \
    mv keycloak-25.0.2 /opt/keycloak && \
    rm keycloak-25.0.2.zip

# Copiamos los archivos de configuración de Keycloak
COPY ConfigKey /opt/keycloak/data/import

# Establecemos las variables de entorno para Keycloak
ENV KEYCLOAK_USER=admin
ENV KEYCLOAK_PASSWORD=admin

# Copiamos el archivo JAR de la aplicación desde la etapa de construcción
COPY --from=build /app/target/*.jar /app/app.jar

# Exponemos los puertos necesarios
EXPOSE 8080
EXPOSE 8081

# Script de entrada para iniciar Keycloak y la aplicación Spring Boot
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Comando para ejecutar el script de entrada
ENTRYPOINT ["/app/entrypoint.sh"]

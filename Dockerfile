FROM eclipse-temurin:11-jre
WORKDIR /app

# The reusable workflow downloads the JAR into the context root as 'app-jar'
# and renames it dynamically. We use a wildcard to grab it.
COPY *.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]

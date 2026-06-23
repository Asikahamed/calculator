# Multistage Dockerfile for building and running the Calculator Java app
# - Builds the project with Maven in a builder stage
# - Produces a minimal runtime image containing the assembled JAR
# Notes:
# - Assumes the project is a Maven project at repository root and `mvn package` produces a runnable JAR.
# - If your project requires a fat (uber) JAR, add the Maven Shade plugin or use your preferred packaging plugin.

# Build stage: use Maven with Temurin JDK (Java 11)
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /workspace

# Copy only the files needed for dependency resolution first to leverage Docker cache
COPY pom.xml mvnw* ./
COPY .mvn .mvn

# Copy source and build
COPY src ./src

# Build package (skip tests by default to speed up builds; remove -DskipTests to run tests)
RUN mvn -B -ntp -DskipTests package

# Runtime stage: use slim Temurin JRE
FROM eclipse-temurin:11-jre AS runtime
WORKDIR /app

# Copy the application JAR produced by the build stage. It will copy the first jar found in target/.
# If your build produces multiple jars, adjust the path to the exact artifact name.
COPY --from=build /workspace/target/*.jar /app/app.jar

# Expose a port if the application needs one (not required for a Swing desktop app)
# EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

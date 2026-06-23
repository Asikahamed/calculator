FROM eclipse-temurin:11-jre

# Install native Linux X11 libraries required for Java Swing GUI components
RUN apt-get update && apt-get install -y \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Point dynamically to the compiled application bundle package
COPY *.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]

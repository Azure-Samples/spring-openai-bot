FROM mcr.microsoft.com/openjdk/jdk:17-mariner
EXPOSE 8080
ARG JAR=springopenai-0.0.1-SNAPSHOT.jar
COPY target/$JAR /app.jar
ENTRYPOINT ["java","-XX:MaxRAMPercentage=75","-jar","/app.jar"]
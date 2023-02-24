# To run this locally, 2 local variables are needed that connects to a Azure OpenAI service
# export APPLICATION_OPENAI_KEY=<your-openai-api-key>
# export APPLICATION_OPENAI_URL=<your-openai-url>
# Run with docker 
# docker build -t openaibot . 
# docker run -p 8080:8080 -e APPLICATION_OPENAI_KEY -e APPLICATION_OPENAI_URL openaibot 
# Access the app at http://localhost:8080/

FROM maven:3.9.0-eclipse-temurin-17 AS build
WORKDIR /home/app/
COPY . /home/app/
RUN mvn clean package -DskipTests=true

FROM mcr.microsoft.com/openjdk/jdk:17-distroless
COPY --from=build /home/app/target/springopenai-0.0.1-SNAPSHOT.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

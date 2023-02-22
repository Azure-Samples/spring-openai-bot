# Spring Boot OpenAI Bot

Sample application showing how to use Spring Boot with OpenAI's GPT-3 API.

This is a fully reactive application that uses Spring WebFlux and the OpenAI streaming API, 
that can be packaged as a GraalVM native image.

## Features

* Spring Boot 3
* Fully reactive with Spring WebFlux and Spring WebClient
* OpenAI streaming API
* Native image with GraalVM
* Deployment to Azure Container Apps

## Getting Started

### Prerequisites

- Java 17
- Access to OpenAI's GPT-3 API

### Installation

```bash
./mvnw package
```

### Quickstart

You will need to set the following environment variables to access OpenAI's API:

```bash
export APPLICATION_OPENAI_KEY=<your-openai-api-key>
export APPLICATION_OPENAI_URL=<your-openai-url>
```

## Demo

```bash
./mvnw spring-boot:run
```

## Resources

To customize the OpenAI prompt, you can check the following resource:

- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide)

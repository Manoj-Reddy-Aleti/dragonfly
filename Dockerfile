FROM docker.io/openjdk:8
ADD target/*.jar my-app.jar
EXPOSE 8085
ENTRYPOINT ["java" , "-jar", "my-app.jar"]
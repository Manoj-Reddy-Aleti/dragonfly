FROM openjdk:8-jdk
ADD target/*.jar my-app.jar
EXPOSE 8085
ENTRYPOINT ["java" , "-jar", "my-app.jar"]
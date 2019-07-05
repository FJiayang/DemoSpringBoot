FROM openjdk:8-jre
MAINTAINER fjy8018 fjy8018@gmail.com

COPY target/demo-0.0.1-SNAPSHOT.jar /demo.jar

ENTRYPOINT ["java","-jar","/demo.jar"]

EXPOSE 8080
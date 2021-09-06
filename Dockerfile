FROM openjdk:11
COPY ./target/Rachael-Zuul-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
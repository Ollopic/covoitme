FROM maven:3.8.6-openjdk-18 as build

WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY nb-configuration.xml ./

# Construction du war
RUN mvn clean package

FROM tomcat:10-jdk17-openjdk-slim

# Suppression des applications par défaut de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copie du war généré
COPY --from=build /app/target/Covoitme-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Configuration de Tomcat pour la production
# ENV CATALINA_OPTS="-Xms512m -Xmx1024m -XX:+UseParallelGC"
# ENV JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8"

EXPOSE 8080

CMD ["catalina.sh", "run"]
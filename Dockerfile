FROM octopusdeploy/randomquotesjavabuild AS build-env
WORKDIR /app

# Copy pom and get dependencies as seperate layers
#COPY pom.xml ./
#RUN mvn dependency:resolve

# Copy everything else and build
COPY . ./
RUN mvn package -DfinalName=app

FROM tomcat:8.0

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY host-manager-context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml
COPY manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat
COPY --from=build-env /app/project/target/ProjectIGI-1.1.war /usr/local/tomcat/webapps/

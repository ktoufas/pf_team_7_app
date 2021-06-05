FROM openjdk:8

WORKDIR /app
COPY target/toDoAppWithLogin.jar .

ARG DB_HOST=development-rds.cinmmc08wjk8.eu-west-1.rds.amazonaws.com
EXPOSE 8080

ENTRYPOINT ["java", "-cp", "toDoAppWithLogin.jar", \
"org.springframework.boot.loader.JarLauncher", "--my_sql.host=${DB_HOST}", \
"--my_sql.port=3306"]
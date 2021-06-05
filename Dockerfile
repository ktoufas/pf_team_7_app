FROM openjdk:8

WORKDIR /app
COPY target/toDoAppWithLogin.jar .

ARG DB_HOST
ENV ENV_HOST={DB_HOST}
EXPOSE 8080

ENTRYPOINT ["java", "-cp", "toDoAppWithLogin.jar", \
"org.springframework.boot.loader.JarLauncher", "--my_sql.host=$(echo ${ENV_HOST})", \
"--my_sql.port=3306"]
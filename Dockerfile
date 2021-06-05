FROM openjdk:8

WORKDIR /app
COPY target/toDoAppWithLogin.jar .

EXPOSE 80

ENTRYPOINT ["java", "-cp", "toDoAppWithLogin.jar", \
"org.springframework.boot.loader.JarLauncher", "--my_sql.host=development-rds.cinmmc08wjk8.eu-west-1.rds.amazonaws.com", \
"--my_sql.port=3306", "--my_sql.username='roo'", "--my_sql.password='root_pf6devops'"]
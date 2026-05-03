@echo off
set "CATALINA_HOME=C:\xampp\tomcat"
set "JAVA_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2026.1.1\jbr"
set "PATH=%JAVA_HOME%\bin;%PATH%"
cd /d "C:\xampp\tomcat\bin"
call catalina.bat run

@echo off

copy resources\GHMattiMySQL\settings_default.xml resources\GHMattiMySQL\settings.xml

%~dp0\..\FXServer\FXServer.exe +set serverProfile main +set txAdminPort 40120
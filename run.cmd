@echo off

copy resources\GHMattiMySQL\settings_default.xml resources\GHMattiMySQL\settings.xml

%~dp0\..\FXServer\FXServer.exe +set serverProfile live_server +set txAdminPort 42000
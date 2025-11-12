@echo off
REM v0.0.3
REM Please be careful when opening files from the internet! this .bat file especially just to ease (myself) for opening the folder
REM Open the folder where this script is located
set "root=%~dp0"
code "%root:~0,-1%" --new-window "%root:~0,-1%\README.md"
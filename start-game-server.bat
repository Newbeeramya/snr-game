@echo off
echo Starting Avatar Blasting Game HTTP Server...
echo.
echo The game will be available at: http://localhost:8080/toy-picker.html
echo.
echo Press Ctrl+C to stop the server
echo.
powershell -ExecutionPolicy Bypass -File "start-server.ps1"
pause

@echo off
echo Installing Python dependencies...
pip install -r requirements.txt

echo.
echo Setup complete!
echo.
echo To run the server:
echo   python gallery_server.py
echo.
echo Don't forget to update the BASE_DIRECTORY variable in gallery_server.py
echo to point to your gallery folder!
echo.
pause
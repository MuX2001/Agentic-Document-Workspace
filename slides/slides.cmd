@echo off
if not exist "%~dp0.venv\Scripts\python.exe" (
  echo Run setup-slides.cmd first.
  exit /b 1
)
"%~dp0.venv\Scripts\python.exe" "%~dp0scripts\slides.py" %*
exit /b %errorlevel%

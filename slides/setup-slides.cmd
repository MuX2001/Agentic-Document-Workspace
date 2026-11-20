@echo off
if not exist "%~dp0.venv\Scripts\python.exe" (
  python -m venv "%~dp0.venv"
  if errorlevel 1 exit /b 1
)
"%~dp0.venv\Scripts\python.exe" "%~dp0scripts\install-slides-deps.py"
if errorlevel 1 exit /b 1
"%~dp0.venv\Scripts\python.exe" "%~dp0scripts\prepare-typst-packages.py"
if errorlevel 1 exit /b 1
"%~dp0.venv\Scripts\python.exe" "%~dp0scripts\slides.py" doctor
exit /b %errorlevel%

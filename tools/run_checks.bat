@echo off
REM Run basic Flutter checks and save outputs to the project `tools` folder.
REM Usage: open cmd.exe in project root and run: tools\run_checks.bat

echo Running Flutter --version...
flutter --version > tools\flutter_version.txt 2>&1

echo Running flutter doctor -v...
flutter doctor -v > tools\flutter_doctor.txt 2>&1

echo Running flutter pub get...
flutter pub get > tools\pub_get.txt 2>&1

echo Running flutter analyze...
flutter analyze > tools\analyze.txt 2>&1

echo Done. Outputs written to tools\*.txt
echo You can paste the contents of those files here for further fixes.
pause


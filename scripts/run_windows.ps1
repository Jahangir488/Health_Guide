$ErrorActionPreference = 'Stop'

Write-Host "Health Guide - Windows setup" -ForegroundColor Cyan
Write-Host "This script creates a Flutter app in C:\Projects\health_guide_app and launches it in Chrome."

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Host "Flutter was not found. Install Flutter and add its bin folder to PATH first:" -ForegroundColor Red
  Write-Host "https://docs.flutter.dev/install/with-vs-code"
  Write-Host "Then close and reopen PowerShell and run: flutter doctor -v"
  exit 1
}

flutter --version
$project = 'C:\Projects\health_guide_app'
$source = Join-Path $PSScriptRoot '..\frontend\lib\main.dart'
$source = [System.IO.Path]::GetFullPath($source)

if (-not (Test-Path $source)) {
  throw "Could not find the app source file: $source. Re-extract the ZIP and run this script from its scripts folder."
}

New-Item -ItemType Directory -Force 'C:\Projects' | Out-Null
if (-not (Test-Path (Join-Path $project 'pubspec.yaml'))) {
  if (Test-Path $project) {
    throw "$project already exists but is not a Flutter project. Rename or move that folder, then run this script again."
  }
  flutter create --platforms=android,web $project
}

Copy-Item -Force $source (Join-Path $project 'lib\main.dart')
Set-Location $project
flutter pub get
flutter analyze
if ($LASTEXITCODE -ne 0) {
  Write-Host "Flutter analysis reported a problem. Please send the output above to ChatGPT." -ForegroundColor Yellow
  exit $LASTEXITCODE
}

Write-Host "Launching Health Guide in Chrome..." -ForegroundColor Green
flutter run -d chrome

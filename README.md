# Health Guide — starter project

This is a starter project for a bilingual-ready Android/web health information prototype. It is not a clinically validated medical device or triage service. Do not use it to make treatment decisions or with real patient data.

## Easiest way to run on Windows

1. Install Flutter using the official guide: https://docs.flutter.dev/install/with-vs-code
2. Install Google Chrome and VS Code (optional, but useful).
3. Extract this ZIP to a normal folder, for example `C:\Users\YourName\Downloads\health_guide_starter`.
4. Open the extracted folder, then open its `scripts` folder.
5. Right-click `run_windows.ps1` and choose **Run with PowerShell**. If that option is unavailable, open PowerShell, `cd` to the extracted `scripts` folder, and run:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\run_windows.ps1
   ```

The script creates `C:\Projects\health_guide_app`, copies the app source, runs Flutter checks, and launches the app in Chrome. If Flutter is not installed or not on PATH, the script will explain what is missing.

### If the script doesn't work

Open PowerShell and run:

```powershell
flutter doctor -v
flutter --version
```

Copy the error output and send it to ChatGPT. Don't share passwords, API keys, or other secrets.

## Run manually instead

Open PowerShell and run:

```powershell
flutter create --platforms=android,web C:\Projects\health_guide_app
Copy-Item .\frontend\lib\main.dart C:\Projects\health_guide_app\lib\main.dart
Set-Location C:\Projects\health_guide_app
flutter pub get
flutter analyze
flutter run -d chrome
```

The manual copy command assumes PowerShell's current directory is the extracted `health_guide_starter` folder.

## Included

- `frontend/lib/main.dart`: Flutter UI with Home, Symptoms, Medicines, and Safety tabs; English/Bengali toggle; sample symptom assessment and medicine search.
- `backend/app/main.py`: local FastAPI demo API.
- `backend/tests/test_api.py`: basic API tests.
- `database/schema.sql`: proposed PostgreSQL schema for future reviewed content.
- `docs/SAFETY.md`: medical safety boundaries and review checklist.
- `docs/DEVELOPMENT.md`: additional development notes.
- `scripts/run_windows.ps1`: Windows helper to set up and run the frontend.

## Important safety limitations

- Sample medicine entries are illustrative and must be checked against authoritative local sources by a qualified pharmacist/clinician before public use.
- Warning-sign logic is incomplete and not validated. Absence of a listed warning sign does not mean a person is safe.
- The app does not diagnose, prescribe, calculate doses, check real interactions, or replace a doctor.
- No AI provider, patient account, or patient-history storage is included.
- The frontend currently uses local sample data; backend integration is a later step.

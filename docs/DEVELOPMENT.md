# Development notes

## Windows frontend

1. Install Git, VS Code, Flutter SDK, and Android Studio/Android SDK.
2. Run `flutter doctor -v` and resolve Android toolchain issues.
3. Create the Flutter wrapper project with `flutter create --platforms=android,web health_guide`.
4. Copy `frontend/lib/main.dart` into the generated project's `lib/main.dart`.
5. Run `flutter pub get`, `flutter analyze`, and `flutter run -d chrome`.

## Ubuntu backend

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

API docs: http://127.0.0.1:8000/docs

## Tests

```bash
pytest -q
```

## Current integration status

Flutter currently uses local sample content. The FastAPI service is independently runnable; the UI is not yet connected to it. Integrate the API in a later milestone after the local UI and API tests pass. Do not make the development server public.

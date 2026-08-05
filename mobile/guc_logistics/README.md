# GucLogistics Flutter Client

## Prerequisites

- Flutter 3.24+
- Running API (`docker compose up` from repo `/docker`)

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

For iOS simulator / desktop use `http://localhost:8080`.

## Features

- Secure token storage + automatic refresh
- Auth (login/register + role selection)
- Loads list/detail with offline cache (Hive)
- Offers list + submit offer
- Profile + logout
- EN/TR localization and system dark mode

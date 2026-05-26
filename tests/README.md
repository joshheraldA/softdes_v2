# Test Suite

Tests are split into two separate folders — one for the Django backend, one for the Flutter frontend.

---

## Backend Tests (`backend/tests/`)

Written with Django's built-in `TestCase` + DRF's `APIClient`.  
Firebase and external HTTP calls are mocked with `unittest.mock` so you don't need real credentials to run them.

### What's covered

| File | What it tests |
|---|---|
| `test_credentials_handler.py` | `CheckSchoolEmailHandler`, `CheckIllegalCharactersHandler`, `CheckProfanityHandler`, and the full validation chain |
| `test_id_factory.py` | `IdFactory.create_numeric_id` — return type, range, uniqueness |
| `test_api_endpoints.py` | All REST endpoints: user creation/login, CES CRUD, join/leave activity, CES points, approval/denial, 2FA verify |

### Setup

Make sure you're inside the `backend/` directory for all of these.

**1. Install dependencies**

```bash
pip install django djangorestframework django-cors-headers better-profanity firebase-admin
```

If your project uses a `requirements.txt`, just do:

```bash
pip install -r requirements.txt
```

**2. Run all backend tests**

```bash
cd backend
python manage.py test tests
```

**3. Run a specific file**

```bash
python manage.py test tests.test_credentials_handler
python manage.py test tests.test_id_factory
python manage.py test tests.test_api_endpoints
```

**4. Run with verbose output** (shows each test name)

```bash
python manage.py test tests --verbosity=2
```

---

## Frontend Tests (`frontend/test/`)

Written with Flutter's built-in `flutter_test` package — no extra libraries needed beyond what's already in `pubspec.yaml`.

### What's covered

| File | What it tests |
|---|---|
| `model/user_model_test.dart` | `UserModel.fromJson` — field parsing, nulls, fallbacks |
| `model/ces_activity_model_test.dart` | `CesActivity.fromJson` — all fields, approval status variants |
| `model/activity_model_test.dart` | `Activity.fromJson`, `dateTime` parsing for all 12 months, `isActiveOn`, `hasVolunteer` |
| `model/day_cell_data_test.dart` | `DayCellData.isEmpty`, `isSplit`, `primaryType`, `secondaryType` |
| `viewmodel/calendar_view_model_test.dart` | Month navigation, year rollover, grid length/alignment, `monthLabel` |
| `viewmodel/registration_view_model_test.dart` | Initial state for `RegistrationViewModel` and `LoginPageViewModel` |
| `viewmodel/dashboard_view_model_test.dart` | `updatePage`, initial state, listener notification |

### Setup

**1. Get Flutter dependencies**  
Run this from inside the `frontend/` folder:

```bash
cd frontend
flutter pub get
```

That's it — `flutter_test` is already a dev dependency in `pubspec.yaml`, nothing extra to install.

**2. Run all frontend tests**

```bash
flutter test
```

**3. Run a specific file**

```bash
flutter test test/model/activity_model_test.dart
flutter test test/viewmodel/calendar_view_model_test.dart
```

**4. Run with verbose output**

```bash
flutter test --reporter=expanded
```

---

## Notes

- Backend tests mock `api.controller.UserApi.db`, `api.controller.CesApi.db`, etc. using `@patch`. If you rename those imports in the source files, update the patch paths too.
- Frontend tests only cover pure logic (models + VM state). Widget rendering and actual HTTP calls are left for integration tests — those need a running backend and emulator/device.
- The 2FA tests rely on Django's `LocMemCache` (already configured in `settings.py`), so they work out of the box without Redis or Memcached.

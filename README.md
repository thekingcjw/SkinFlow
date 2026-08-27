# SkinFlow Android

SkinFlow is a private, offline Flutter app for following a weekly skincare routine, receiving Android reminders, and tracking morning and evening completion history.

The Android application ID remains `com.kisama.kilife`, and the internal Dart package name remains `kilife`, so signed SkinFlow builds install over the existing app without losing its on-device history. The public app name, launcher label, notifications, workflow, and APK artifact use **SkinFlow**.

## Authoritative routine

The active routine is aligned to a Monday–Friday work schedule.

### Morning — every day

1. Superfood Antioxidant Cleanser
2. Superfood Skin Drip Smooth + Glow Serum
3. Air-Whip Moisture Cream
4. Youthscreen SPF 60

### Night schedule

| Day | Routine type | Steps |
| --- | --- | --- |
| Monday | Retinal Night | Superfood Cleanser → Retinal + Niacinamide Youth Serum → Air-Whip |
| Tuesday | Retinal Night | Superfood Cleanser → Retinal + Niacinamide Youth Serum → Air-Whip |
| Wednesday | Exfoliation Night | Superfruit Gentle Exfoliating Cleanser → Skin Drip → Superberry Dream Mask |
| Thursday | Retinal Night | Superfood Cleanser → Retinal + Niacinamide Youth Serum → Air-Whip |
| Friday | Retinal Night | Superfood Cleanser → Retinal + Niacinamide Youth Serum → Air-Whip |
| Saturday | Exfoliation Night | Superfruit Gentle Exfoliating Cleanser → Skin Drip → Superberry Dream Mask |
| Sunday | Retinal Night | Superfood Cleanser → Retinal + Niacinamide Youth Serum → Air-Whip |

This produces **five retinal nights** and **two exfoliation plus Dream Mask nights**. Retinal and the exfoliating cleanser are never scheduled together.

### Daily Body Care — every day

After showering, apply Superberry Hydrate + Glow Dream Body Butter while the skin is still slightly damp. Daily Body Care is displayed as an informational routine and does not change the face-routine progress denominator.

### Recovery override

Recovery is not scheduled during the normal week. If persistent peeling, burning, unusual redness, or tightness develops, temporarily replace that night's active routine with:

Superfood Cleanser → Skin Drip → Air-Whip

## App behavior

- The Today screen displays **Morning Routine**, the day's exact evening routine, and **Daily Body Care**.
- Evening cards and notifications identify the routine as **Retinal Night** or **Exfoliation Night**. The app never substitutes a generic Night Routine label.
- Progress tracks two face sessions per day, for **14 face routines per week**.
- Body Butter is intentionally excluded from completion totals and streak calculations.
- Completion history is stored in a local Drift database and remains mirrored to the legacy preferences keys for upgrade compatibility.
- Calendar, Week, Streak, and Today progress update from the same local completion history.
- Recovery remains available in the routine model as an irritation fallback, but it is not assigned to a weekday.
- Notification times and routine history stay on the device; SkinFlow has no account or server.

## Downloading the APK from GitHub

Every push to `main`, pull request targeting `main`, or manual workflow dispatch can run **Build SkinFlow Android APK**.

1. Open the repository on GitHub.
2. Select the **Actions** tab near the top of the repository.
3. Open the newest successful **Build SkinFlow Android APK** run.
4. In the run's **Artifacts** section, download **SkinFlow-Android**.
5. Extract the ZIP and open `SkinFlow-v0.2.0.apk` on the Android phone.
6. Choose **Update** or **Install**. Do not uninstall the existing signed SkinFlow app first if its history should be preserved.

Android may ask for permission to install apps from the browser or file manager used to open the APK.

## Local development

### Requirements

- Flutter 3.38.1 or newer
- Dart 3.10 or newer, supplied by Flutter
- Android SDK 36 with Build Tools 36.0.0
- Java 17 or newer

### Generate the Android wrapper and dependencies

This repository intentionally stores only the Android files that differ from Flutter's generated wrapper. From the repository root:

```bash
flutter create . --platforms=android --org com.kisama --project-name kilife
python tool/patch_android.py
flutter pub get
dart run build_runner build --force-jit --delete-conflicting-outputs
```

On Windows, run the same commands in PowerShell. If `python` is not on `PATH`, use the full path to an installed Python 3 executable when running `tool/patch_android.py`.

### Verify a change

```bash
flutter analyze
flutter test
flutter run
```

Before handing off a UI change, visually verify at least these states on an Android emulator or phone:

1. Monday or Tuesday Today screen: the evening card shows **Retinal Night**.
2. Wednesday Today screen: the evening card shows **Exfoliation Night** and includes Skin Drip and Dream Mask.
3. Today progress changes from `0 / 14` as AM and PM routines are completed.
4. Editing recent history under **Settings → Edit routine history** updates Today, Calendar, Week, and Streak.
5. Daily Body Care appears every day but does not increase the `14` face-routine total.
6. Settings notification permission granted and denied states match the intended SkinFlow design.

### Build a local APK

```bash
flutter build apk --release
```

Without the protected SkinFlow signing properties used by GitHub Actions, the local patch script deliberately falls back to the generated debug signing key. That local APK is suitable for development, but it will not update a phone installation signed by the permanent SkinFlow release key.

The local APK is generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Release verification

The GitHub workflow performs the release-grade checks that cannot be reproduced without protected repository secrets:

- Generates and patches the Android wrapper.
- Generates Drift code.
- Runs Flutter analysis and automated tests.
- Requires the permanent SkinFlow signing credentials.
- Builds the release APK and verifies its signing certificate.
- Verifies package ID `com.kisama.kilife` and version `0.2.0`.
- Installs the APK on a clean Android emulator and confirms the package identity.

## First launch and notifications

On a new installation, complete the first-run notification screen. On an upgraded installation, open **Settings**, select **Enable and test notifications**, and grant Android's notification permission. Default reminders are 4:30 AM and 8:00 PM; both can be changed in the app.

Reminders use Android's inexact allow-while-idle scheduling. SkinFlow schedules one daily morning reminder, a routine-specific evening reminder for each weekday, and an optional follow-up reminder one hour after the evening time. Scheduled reminders are restored after the phone restarts.

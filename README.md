# KiLife Android

KiLife is an offline Android skincare routine tracker built around a weekly Youth to the People schedule.

## Current MVP

- Today screen with the correct AM and PM product order
- Monday, Wednesday, and Friday retinal nights
- Tuesday and Saturday exfoliation plus Dream Mask nights
- Thursday and Sunday recovery nights
- Custom morning and evening notification times
- Optional one-hour follow-up reminder
- Weekly completion progress
- Local storage with no account or server
- Material 3 AMOLED-friendly dark interface

## Downloading the APK from GitHub

Every push to `main` starts the **Build Android APK** workflow.

1. Open the repository's **Actions** tab.
2. Open the newest successful **Build Android APK** run.
3. Download the **KiLife-Android** artifact.
4. Extract the ZIP and install `KiLife-v0.1.0.apk` on Android.

Android may ask you to allow installation from the browser or file manager used to open the APK.

## Local build requirements

- Flutter 3.38.1 or newer
- Android SDK 36
- Java 17 or newer

From the project folder:

```bash
flutter create . --platforms=android --org com.kisama --project-name kilife
python3 tool/patch_android.py
flutter pub get
flutter run
```

To create a release APK:

```bash
flutter build apk --release
```

The APK will be generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## First launch

Open **Settings** inside KiLife, select **Enable and test notifications**, and grant notification permission. Default reminders are 4:30 AM and 8:00 PM; both are editable.

## Notification behavior

- Reminders use Android's inexact allow-while-idle scheduling.
- The app schedules one daily morning reminder and weekday-specific evening reminders.
- Scheduled reminders are restored after a phone restart.

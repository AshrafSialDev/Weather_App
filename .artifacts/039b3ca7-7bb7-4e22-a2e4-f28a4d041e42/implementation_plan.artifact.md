# Revert Automatic Location Detection

We will revert the changes made for automatic location-based weather detection, returning the app to its previous state where it defaults to "Lahore" on startup.

## Proposed Changes

### Dependencies

#### [MODIFY] [pubspec.yaml](file:///D:/flutter_project/flutter_application_1/pubspec.yaml)
- Remove `geolocator: ^13.0.1`.

### Android Native Configuration

#### [MODIFY] [AndroidManifest.xml](file:///D:/flutter_project/flutter_application_1/android/app/src/main/AndroidManifest.xml)
- Remove `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` permissions.

### Weather Data Logic

#### [MODIFY] [worker.dart](file:///D:/flutter_project/flutter_application_1/lib/worker/worker.dart)
- Revert `Worker` class:
    - Remove `lat` and `lon` fields.
    - Restore `location` as the primary search field.
    - Remove coordinate-based fetching logic from `getData()`.

#### [MODIFY] [loading.dart](file:///D:/flutter_project/flutter_application_1/lib/Activity/loading.dart)
- Revert `Loading` screen:
    - Remove `geolocator` import.
    - Restore the original `startApp(String city)` logic.
    - Restore the default city to "Lahore" if no search text is provided.
    - Remove GPS permission check and position fetching logic.

## Verification Plan

### Manual Verification
- Restart the app and verify it no longer requests location permissions.
- Verify the app defaults to "Lahore" on startup.
- Verify that searching for other cities still works correctly.

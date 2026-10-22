# multiple_image_camera example

This application opens the package's camera screen and displays the returned
photos in a list.

## Run

From this directory:

```bash
flutter pub get
flutter run
```

Use an Android or iOS device with a camera and allow camera access when prompted.
For native permission and minimum-platform configuration, see the package's
[setup instructions](../README.md#installation).

Tap **Capture**, take one or more photos, then tap **Done** to return them to the
example application. Tap an image thumbnail in the camera screen to preview it.

The example depends on the package using `path: ../`, so it runs the local source.
Physical-device validation is required for camera switching, zoom, permission
handling, and repeated capture sessions.

# multiple_image_camera

Capture multiple photos in one camera session on Android and iOS. Review the
captured photos, switch between front and rear cameras, and return the selected
images to your Flutter application.

[![pub package](https://img.shields.io/pub/v/multiple_image_camera.svg)](https://pub.dev/packages/multiple_image_camera)

## Features

- Full-screen live camera preview.
- Multiple photo captures before returning to your app.
- Front/rear camera switching on devices with both cameras.
- Pinch-to-zoom and haptic feedback on capture.
- Captured-image thumbnails and full-image previews.
- Removal of the most recently captured image.
- A customizable widget inside the Done action.

## Requirements

| Component | Requirement |
| --- | --- |
| Flutter | 3.10 or later |
| Dart | 3.0 or later, below 4.0 |
| Android | API 21 or later for the camera 0.10.x dependency |
| iOS | iOS 11 or later for the camera 0.10.x dependency |

Platform implementation versions selected by dependency resolution can impose
higher requirements. Check the resolved camera dependencies when upgrading.
This package uses local files and is intended for Android and iOS, not Flutter web.

## Installation

```bash
flutter pub add multiple_image_camera
```

For this release, the corresponding dependency is:

```yaml
dependencies:
  multiple_image_camera: ^0.0.3
```

### iOS setup

Add a camera usage description inside the `<dict>` in your app's
`ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to take photos.</string>
```

The package creates its camera controllers with `enableAudio: false` and only
captures photos. Microphone access is not needed for this flow. Other features
in your application that record audio may require their own microphone permission.

Set the iOS deployment target to at least 11.0, or the higher minimum required by
your resolved dependencies. If your application uses CocoaPods, align its Podfile:

```ruby
platform :ios, '11.0'
```

### Android setup

Set the minimum Android SDK to at least 21, or the higher minimum required by your
resolved dependencies, in the app's Gradle configuration.

For `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

For `android/app/build.gradle.kts`:

```kotlin
android {
    defaultConfig {
        minSdk = 21
    }
}
```

Camera access is requested through the underlying camera plugin. Allow it when
prompted. Run a full rebuild after changing native platform configuration.

## Usage

`MultipleImageCamera.capture` opens the camera screen and returns a
`Future<List<MediaModel>>` after the user completes the capture flow.

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';

class CapturePhotosPage extends StatefulWidget {
  const CapturePhotosPage({super.key});

  @override
  State<CapturePhotosPage> createState() => _CapturePhotosPageState();
}

class _CapturePhotosPageState extends State<CapturePhotosPage> {
  List<MediaModel> _images = [];
  bool _isOpeningCamera = false;

  Future<void> _capture() async {
    if (_isOpeningCamera) return;
    setState(() => _isOpeningCamera = true);

    try {
      final images = await MultipleImageCamera.capture(context: context);
      if (!mounted) return;
      setState(() => _images = images);
    } finally {
      if (mounted) setState(() => _isOpeningCamera = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture photos')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isOpeningCamera ? null : _capture,
            child: const Text('Open camera'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.file(File(_images[index].file.path));
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

Use the widget below a `MaterialApp` so it has access to a Navigator.

## Custom Done widget

Pass `customDoneButton` to change the content of the Done action:

```dart
final images = await MultipleImageCamera.capture(
  context: context,
  customDoneButton: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(24),
    ),
    child: const Text('Use photos', style: TextStyle(color: Colors.white)),
  ),
);
```

The package supplies the tap handler that returns the photos. Pass display
content rather than a button with its own navigation handler. The Done action
appears after at least one photo is captured.

## Returned images

Import `camera_file.dart` when referring to `MediaModel` explicitly.

| Field | Type | Meaning |
| --- | --- | --- |
| `file` | `File` | Captured image file; use `file.path` for its path. |
| `blobImage` | `Uint8List` | Image bytes read when Done is tapped. |
| `filePath` | `String` | Currently an empty string; use `file.path` instead. |

Returned paths point to files created by the camera plugin. Copy images to storage
managed by your application if they must remain available long term. This package
does not save photos to the system gallery automatically.

## Current behavior and limitations

- Closing the route without Done returns an empty list through the capture wrapper.
- Camera switching expects a device with at least two available cameras.
- The removal control deletes the latest image from the capture list, not any
  arbitrary image or necessarily its file from disk.
- Zoom gestures currently are not clamped to the camera's supported zoom range.
- Camera initialization errors do not currently have a dedicated callback in this API.
- Test permission denial, background/resume behavior, and repeated sessions on
  physical devices before releasing an application that uses the package.
- The latest-image removal graphic is loaded from an external URL in the current
  implementation, so that graphic depends on network availability.

## Screenshots

| Capture | Review | Preview |
| --- | --- | --- |
| ![Camera capture](https://raw.githubusercontent.com/yogeshdmca/Multiple-Image-Camera/master/assets/example.png) | ![Captured photos](https://raw.githubusercontent.com/yogeshdmca/Multiple-Image-Camera/master/assets/example1.png) | ![Image preview](https://raw.githubusercontent.com/yogeshdmca/Multiple-Image-Camera/master/assets/example2.png) |

## Example

The [example application](example/lib/main.dart) demonstrates opening the camera
and displaying returned images.

```bash
cd example
flutter pub get
flutter run
```

## License

BSD-3-Clause. See [LICENSE](LICENSE) for the full terms and copyright notice.

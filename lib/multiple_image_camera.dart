/// Capture multiple photos in one camera session and return the selected files.
library multiple_image_camera;

import 'package:flutter/material.dart';
import 'package:multiple_image_camera/camera_file.dart';

/// Opens the package's camera capture screen.
class MultipleImageCamera {
  /// Pushes the camera screen and returns captured images when the user taps
  /// Done. Returns an empty list if navigation fails or no images are returned.
  ///
  /// Provide [customDoneButton] to replace the default Done button. The widget
  /// is placed inside the camera screen's app bar.
  static Future<List<MediaModel>> capture({
    required BuildContext context,
    Widget? customDoneButton,
  }) async {
    List<MediaModel> images = [];
    try {
      images = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CameraFile(
                    customButton: customDoneButton,
                  )));
      // ignore: empty_catches
    } catch (e) {}
    return images;
  }
}

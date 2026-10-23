import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays a captured image with pan and zoom controls.
class ImagePreviewView extends StatefulWidget {
  /// Image file to display.
  final File file;

  /// Text shown in the preview app bar.
  final String imageTitle;

  /// Creates an image preview for [file] with the given [imageTitle].
  const ImagePreviewView(this.file, this.imageTitle, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePreviewViewState createState() => _ImagePreviewViewState();
}

class _ImagePreviewViewState extends State<ImagePreviewView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70),
          ),
          child: const BackButton(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        elevation: 1,
        title: Text(
          widget.imageTitle,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        ),
      ),
      body: InteractiveViewer(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        color: const Color(0xFF303030),
        child: SafeArea(
          child: SingleChildScrollView(
              reverse: true,
              child: SizedBox(
                width: double.infinity,
                child: Hero(
                  tag: widget.file.path,
                  child: Image.file(
                    widget.file,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              )),
        ),
      )),
    );
  }

  Future decodeImage() async {
    // ignore: prefer_typing_uninitialized_variables
    var decodedImage;

    decodedImage = await decodeImageFromList(widget.file.readAsBytesSync());

    return decodedImage.width.toDouble();
  }
}

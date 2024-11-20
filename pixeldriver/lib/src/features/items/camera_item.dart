import 'package:flutter/material.dart';

/// A placeholder class that represents an entity or model.
class CameraItem {
  const CameraItem(this.id, this.title);

  final int id;
  final String title;
  final Icon icon = const Icon(Icons.camera_alt);
  final String routeName = '/pixelCoDriverCameraView';

  Widget getPreview() {
    return Container(
      child: Image(image: AssetImage('assets/images/2.0x/flutter_logo.png')),
    );
  }
}

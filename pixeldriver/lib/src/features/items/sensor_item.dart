import 'package:flutter/material.dart';

/// A placeholder class that represents an entity or model.
class SensorItem {
  const SensorItem(this.id, this.title);

  final int id;
  final String title;
  final Icon icon = const Icon(Icons.sensors);
  final String routeName = '/pixelCoDriverSensorView';

  Widget getPreview() {
    return Container(
      child: Image(image: AssetImage('assets/images/2.0x/flutter_logo.png')),
    );
  }
}

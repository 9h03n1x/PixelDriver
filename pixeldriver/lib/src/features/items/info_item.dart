import 'package:flutter/material.dart';

/// A placeholder class that represents an entity or model.
class InfoItem {
  const InfoItem(this.id, this.title);

  final int id;
  final String title;
  final Icon icon = const Icon(Icons.info);
  final String routeName = '/pixelCoDriverInfoView';

  Widget getPreview() {
    return Container(
      child: Image(image: AssetImage('assets/images/2.0x/flutter_logo.png')),
    );
  }
}

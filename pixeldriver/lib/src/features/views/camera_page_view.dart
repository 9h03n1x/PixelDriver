import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class CameraPageView extends StatelessWidget {
  const CameraPageView({super.key});

  static const routeName = '/pixelCoDriverCameraView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class InfoPageView extends StatelessWidget {
  const InfoPageView({super.key});

  static const routeName = '/pixelCoDriverInfoView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pixeldriver/src/features/items/info_item.dart';
import 'package:pixeldriver/src/features/items/sensor_item.dart';

import '../../settings/settings_view.dart';
import '../items/camera_item.dart';

/// Displays a list of SampleItems.
class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.items = const [
      CameraItem(1, "Camera"),
      InfoItem(2, "Info"),
      SensorItem(3, "Sensor")
    ],
  });

  static const routeName = '/';

  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Co-Driver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'pixelCoDriverHomeView',
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text('${item.title}'),
              leading: item.icon,
              subtitle: item.getPreview(),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  item.routeName,
                );
              });
        },
      ),
    );
  }
}

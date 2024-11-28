import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:pixeldriver/src/features/services/sensor_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Displays detailed information about a SampleItem.
class SensorPageView extends StatelessWidget {
  const SensorPageView({super.key});

  static const routeName = '/pixelCoDriverSensorView';

  double calcSpeed(double v0, double a, double t) {
    return v0 + a * t;
  }

  double calculateSpeedWithGyro(
      List<List<double>> accelerometerData, List<List<double>> gyroData,
      {double deltaT = 0.1}) {
    /// Normalizes a 3D vector.
    List<double> normalize(List<double> vector) {
      double magnitude = sqrt(vector.fold(0, (sum, val) => sum + val * val));
      return vector.map((val) => val / magnitude).toList();
    }

    /// Calculates dot product of two 3D vectors.
    double dotProduct(List<double> a, List<double> b) {
      return a
          .asMap()
          .entries
          .fold(0, (sum, entry) => sum + entry.value * b[entry.key]);
    }

    // Initialize variables
    double speed = 0; // Starting speed (m/s)
    List<double> speeds = []; // List to store speed at each time step
    List<double> orientation = [
      1,
      0,
      0
    ]; // Assume starting orientation (x-axis)

    for (int i = 0; i < accelerometerData.length; i++) {
      // Extract accelerometer and gyroscope data
      List<double> accel = accelerometerData[i];
      List<double> gyro = gyroData[i];

      // Compute orientation using gyroscope (simple integration)
      List<double> angularVelocity = gyro.map((g) => g * deltaT).toList();
      orientation = [
        orientation[0] + angularVelocity[0],
        orientation[1] + angularVelocity[1],
        orientation[2] + angularVelocity[2],
      ];
      orientation = normalize(orientation);

      // Rotate accelerometer data into global frame
      double forwardAccel = dotProduct(accel, orientation);

      // Gravity correction (assumes gravity acts along the z-axis)
      List<double> gravity = [0, 0, 9.8];
      forwardAccel -= dotProduct(gravity, orientation);

      // Integrate acceleration to compute speed
      speed += forwardAccel * deltaT;
      speed = max(speed, 0); // Ensure speed does not go below 0
      speeds.add(speed);
    }

    return speed;
  }

  @override
  Widget build(BuildContext context) {
    var v0 = 0.0;
    var tempAcc = UserAccelerometerEvent(0.0, 0.0, 0.0, DateTime.now());
    var tempGyro = GyroscopeEvent(0.0, 0.0, 0.0, DateTime.now());
    SensorService sService = SensorService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor'),
      ),
      body: ListView(children: [
        ListTile(
          title: Text("Speed"),
          subtitle: StreamBuilder<Object>(
              stream: sService.StreamSpeedEvent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {}
                if (snapshot.hasError) {
                  return Text("Error in Stream");
                } else {
                  double evt = snapshot.data as double;
                  return Column(
                    children: [
                      RadialGauge(
                        track: RadialTrack(
                            start: 0,
                            end: 200,
                            startAngle: -30,
                            endAngle: 210,
                            trackStyle: TrackStyle(
                                primaryRulerColor: Colors.grey,
                                labelStyle: TextStyle(color: Colors.white))),
                        radiusFactor: 1.15,
                        needlePointer: [
                          NeedlePointer(
                            needleWidth: 10,
                            tailRadius: 40,
                            value: evt,
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ),
        ListTile(
          title: Text("Acceleration"),
          subtitle: Row(
            children: [
              Text('X: ${tempAcc.x}'),
              Text('Y: ${tempAcc.y}'),
              Text('Z: ${tempAcc.z}')
            ],
          ),
        ),
        ListTile(
          title: Text("GyroScope"),
          subtitle: StreamBuilder(
              stream: gyroscopeEventStream(
                  samplingPeriod: Duration(milliseconds: 100)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {}
                if (snapshot.hasError) {
                  return Text("Error in Stream");
                } else {
                  GyroscopeEvent evt = snapshot.data as GyroscopeEvent;
                  tempGyro = evt;

                  return Column(
                    children: [
                      Text('X: ${evt.x}'),
                      Text('Y: ${evt.y}'),
                      Text('Z: ${evt.z}')
                    ],
                  );
                }
              }),
        ),
      ]),
    );
  }
}

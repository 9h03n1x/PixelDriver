import 'dart:async';

import 'package:pixeldriver/src/features/constants.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class SensorService {
  List<UserAccelerometerEvent> accelData = [];
  List<GyroscopeEvent> gyroData = [];

  Stream<double> StreamSpeedEvent() async* {
    await for (Position position in Geolocator.getPositionStream()) {
      yield position.speed;
    }
  }

  Stream<List<UserAccelerometerEvent>> getAccelData() async* {
    await for (final evt in userAccelerometerEventStream(
        samplingPeriod: Duration(milliseconds: SAMPLEPERIOD))) {
      accelData.add(evt);
      yield DataTrimmer(accelData) as List<UserAccelerometerEvent>;
    }
  }

  Stream<List<GyroscopeEvent>> getGyroData() async* {
    await for (final evt in gyroscopeEventStream(
        samplingPeriod: Duration(milliseconds: SAMPLEPERIOD))) {
      gyroData.add(evt);
      yield DataTrimmer(gyroData) as List<GyroscopeEvent>;
    }
  }

  List<dynamic> DataTrimmer(List<dynamic> data) {
    if (data.length >= 60) {
      data.removeAt(0);
      //recursive call to remove elements when the length is above 60
      DataTrimmer(data);
    }
    return data;
  }
}

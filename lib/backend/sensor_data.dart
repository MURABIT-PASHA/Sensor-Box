import 'package:flutter/services.dart';
import 'file_saver.dart';
import 'sensor_info_holder.dart';

class SensorData {
  static const String _methodChannelName =
      'com.ktun.edu.tr/androidMethodChannel'; // keep it unique
  static const String _eventChannelName =
      'com.ktun.edu.tr/androidEventChannel'; // keep it unique too
  static MethodChannel _methodChannel = const MethodChannel(_methodChannelName);
  static EventChannel _eventChannel = const EventChannel(_eventChannelName);
  bool _isFirstUIBuildDone = false;
  List<dynamic> sensorList = [];
  List<Accelerometer> _listAccelerometer = [];
  List<UncalibratedAccelerometer> _listUncalibratedAccelerometer = [];
  List<Gravity> _listGravity = [];
  List<LinearAcceleration> _listLinearAcceleration = [];
  List<MagneticField> _listMagneticField = [];
  List<OrientationSensor> _listOrientationSensor = [];
  List<Gyroscope> _listGyroscope = [];
  List<UncalibratedGyroscope> _listUncalibratedGyroscope = [];
  List<HeartBeat> _listHeartBeat = [];
  List<AmbientLight> _listAmbientLight = [];
  List<AtmosphericPressure> _listAtmosphericPressure = [];
  List<Proximity> _listProximity = [];
  List<RotationVector> _listRotationVector = [];
  List<GameRotationVector> _listGameRotationVector = [];
  List<GeoMagneticRotationVector> _listGeoMagneticRotationVector = [];
  List<RelativeHumidity> _listRelativeHumidity = [];
  List<AmbientRoomTemperature> _listAmbientRoomTemperature = [];
  List<LowLatencyOffBodyDetect> _listLowLatencyOffBodyDetect = [];
  List<MotionDetect> _listMotionDetect = [];
  List<StationaryDetect> _listStationaryDetect = [];

  SensorInfoHolder getMeAnInstanceOfSensorInfoHolder(Map<String, String> data) {
    return SensorInfoHolder(
        data['name']!,
        data['type']!,
        data['vendorName']!,
        data['version']!,
        data['power']!,
        data['resolution']!,
        data['maxRange']!,
        data['maxDelay']!,
        data['minDelay']!,
        data['reportingMode']!,
        data['isWakeup']!,
        data['isDynamic']!,
        data['highestDirectReportRateValue']!,
        data['fifoMaxEventCount']!,
        data['fifoReservedEventCount']!);
  } // gets an instance of SensorInfoHolder class with required data stored, which is supplied to the function in form of a map/ dictionary

  Future<void> getSensorsList() async {
    Map<String, List<dynamic>> sensorCount;
    try {
      Map<dynamic, dynamic> tmp =
          await _methodChannel.invokeMethod('getSensorsList');
      sensorCount = Map<String, List<dynamic>>.from(tmp);
      sensorCount.forEach((String key, List<dynamic> value) {
        switch (key) {
          case '1':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listAccelerometer.add(Accelerometer(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '35':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listUncalibratedAccelerometer.add(UncalibratedAccelerometer(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '9':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listGravity.add(Gravity(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '10':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listLinearAcceleration.add(LinearAcceleration(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '2':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listMagneticField.add(MagneticField(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '3':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listOrientationSensor.add(OrientationSensor(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '4':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listGyroscope.add(Gyroscope(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '16':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listUncalibratedGyroscope.add(UncalibratedGyroscope(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '31':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listHeartBeat.add(HeartBeat(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '5':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listAmbientLight.add(AmbientLight(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '6':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listAtmosphericPressure.add(AtmosphericPressure(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '8':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listProximity.add(Proximity(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '11':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listRotationVector.add(RotationVector(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '15':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listGameRotationVector.add(GameRotationVector(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '20':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listGeoMagneticRotationVector.add(GeoMagneticRotationVector(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA',
                    'NA',
                    'NA',
                    'NA',
                    'NA'));
              }
            }
            break;
          case '12':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listRelativeHumidity.add(RelativeHumidity(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '13':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listAmbientRoomTemperature.add(AmbientRoomTemperature(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '29':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listStationaryDetect.add(StationaryDetect(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '30':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listMotionDetect.add(MotionDetect(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '34':
            if (value.isNotEmpty) {
              for (var element in value) {
                _listLowLatencyOffBodyDetect.add(LowLatencyOffBodyDetect(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          default:
          //not supported yet
        }
      });
    } on PlatformException {}
    _isFirstUIBuildDone = true;
  }

  SensorData() {
    _methodChannel = const MethodChannel(_methodChannelName);
    _eventChannel = const EventChannel(_eventChannelName);
    getSensorsList();
    _eventChannel.receiveBroadcastStream().listen(_onData, onError: _onError);
  }

  bool isAMatch(SensorInfoHolder data, Map<String, String> receivedData) {
    // Finds whether it is an instance of target class so that we can use it to update UI.
    return (data.name == receivedData['name'] &&
        data.vendorName == receivedData['vendorName'] &&
        data.version == receivedData['version']);
  }

  void _onData(dynamic event) {
    // on sensor data reception, update data holders of different supported sensor types
    if (!_isFirstUIBuildDone) return;
    Map<String, String> receivedData = Map<String, String>.from(event);
    switch (receivedData['type']) {
      case '1':
        for (var item in _listAccelerometer) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '35':
        for (var item in _listUncalibratedAccelerometer) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.xUncalib = sensorFeed![0];
            item.yUncalib = sensorFeed[1];
            item.zUnclaib = sensorFeed[2];
            item.estimatedXBias = sensorFeed[3];
            item.estimatedYBias = sensorFeed[4];
            item.estimatedZBias = sensorFeed[5];
          }
        }
        break;
      case '9':
        for (var item in _listGravity) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '10':
        for (var item in _listLinearAcceleration) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '2':
        for (var item in _listMagneticField) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '3':
        for (var item in _listOrientationSensor) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.azimuth = sensorFeed![0];
            item.pitch = sensorFeed[1];
            item.roll = sensorFeed[2];
          }
        }
        break;
      case '4':
        for (var item in _listGyroscope) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.angularSpeedAroundX = sensorFeed![0];
            item.angularSpeedAroundY = sensorFeed[1];
            item.angularSpeedAroundZ = sensorFeed[2];
          }
        }
        break;
      case '16':
        for (var item in _listUncalibratedGyroscope) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.angularSpeedAroundX = sensorFeed![0];
            item.angularSpeedAroundY = sensorFeed[1];
            item.angularSpeedAroundZ = sensorFeed[2];
            item.estimatedDriftAroundX = sensorFeed[3];
            item.estimatedDriftAroundY = sensorFeed[4];
            item.estimatedDriftAroundZ = sensorFeed[5];
          }
        }
        break;
      case '31':
        for (var item in _listHeartBeat) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.confidence = sensorFeed![0];
          }
        }
        break;
      case '5':
        for (var item in _listAmbientLight) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.level = sensorFeed![0];
          }
        }
        break;
      case '6':
        for (var item in _listAtmosphericPressure) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.pressure = sensorFeed![0];
          }
        }
        break;
      case '8':
        for (var item in _listProximity) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.distance = sensorFeed![0];
          }
        }
        break;
      case '11':
        for (var item in _listRotationVector) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
            if (sensorFeed.length == 4) {
              item.someVal = sensorFeed[3];
            } else if (sensorFeed.length == 5) {
              item.estimatedHeadingAccuracy = sensorFeed[4];
            }
          }
        }
        break;
      case '15':
        for (var item in _listGameRotationVector) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
            if (sensorFeed.length == 4) {
              item.someVal = sensorFeed[3];
            } else if (sensorFeed.length == 5) {
              item.estimatedHeadingAccuracy = sensorFeed[4];
            }
          }
        }
        break;
      case '20':
        for (var item in _listGeoMagneticRotationVector) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
            if (sensorFeed.length == 4) {
              item.someVal = sensorFeed[3];
            } else if (sensorFeed.length == 5) {
              item.estimatedHeadingAccuracy = sensorFeed[4];
            }
          }
        }
        break;
      case '12':
        for (var item in _listRelativeHumidity) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.humidity = sensorFeed![0];
          }
        }
        break;
      case '13':
        for (var item in _listAmbientRoomTemperature) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.temperature = sensorFeed![0];
          }
        }
        break;
      case '29':
        for (var item in _listStationaryDetect) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.isImmobile = sensorFeed![0];
          }
        }
        break;
      case '30':
        for (var item in _listMotionDetect) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.isInMotion = sensorFeed![0];
          }
        }
        break;
      case '34':
        for (var item in _listLowLatencyOffBodyDetect) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.offBodyState = sensorFeed![0];
          }
        }
        break;
      default:
      //not supported yet
    }
  }

  void _onError(dynamic error) {} // not handling errors yet :)

  List<Map<String, String>> getAllSensorsInfo() {
    // main UI rendering operation is performed here, be careful
    List<Map<String, String>> tmpUI = [];
    for (var elem in <List<dynamic>>[
      _listAccelerometer,
      _listUncalibratedAccelerometer,
      _listGravity,
      _listLinearAcceleration,
      _listMagneticField,
      _listOrientationSensor,
      _listGyroscope,
      _listUncalibratedGyroscope,
      _listHeartBeat,
      _listAmbientLight,
      _listAtmosphericPressure,
      _listProximity,
      _listRotationVector,
      _listGameRotationVector,
      _listGeoMagneticRotationVector,
      _listRelativeHumidity,
      _listAmbientRoomTemperature,
      _listStationaryDetect,
      _listMotionDetect,
      _listLowLatencyOffBodyDetect,
    ]) {
      for (var item in elem) {
        tmpUI.add(item.getMap());
      }
    }
    return tmpUI;
  }

  Future<bool> writeData(DateTime timestamp, DateTime firstTime) async {
    FileSaver file = FileSaver();
    return await file.saveData(getSensorsInfo(), timestamp, firstTime);
  }

  void initializeSensors(List<String> sensorNames){
    if(sensorNames.isNotEmpty){
      for (String name in sensorNames){
        switch(name) {
          case "Goldfish 3-axis Accelerometer":
            sensorList.add(_listAccelerometer);
            break;
          case "Goldfish 3-axis Gyroscope":
            sensorList.add(_listGyroscope);
            break;
          case "Goldfish 3-axis Magnetic field sensor":
            sensorList.add(_listMagneticField);
            break;
          case "Goldfish Orientation sensor":
            sensorList.add(_listOrientationSensor);
            break;
          case "Goldfish Ambient Temperature sensor":
            sensorList.add(_listAmbientRoomTemperature);
            break;
          case "Goldfish Proximity sensor":
            sensorList.add(_listProximity);
            break;
          case "Goldfish Light sensor":
            sensorList.add(_listAmbientLight);
            break;
          case "Goldfish Pressure sensor":
            sensorList.add(_listAtmosphericPressure);
            break;
          case "Goldfish Humidity sensor":
            sensorList.add(_listRelativeHumidity);
            break;
          case "Goldfish 3-axis Magnetic field sensor (uncalibrated)":
            sensorList.add(_listMagneticField);
            break;
          case "Goldfish 3-axis Gyroscope (uncalibrated)":
            sensorList.add(_listUncalibratedGyroscope);
            break;
          case "Goldfish Heart rate sensor":
            sensorList.add(_listHeartBeat);
            break;
          case "Goldfish wrist tilt gesture sensor":
            sensorList.add(_listStationaryDetect);
            break;
          case "Game Rotation Vector Sensor":
            sensorList.add(_listGameRotationVector);
            break;
          case "GeoMag Rotation Vector Sensor":
            sensorList.add(_listGeoMagneticRotationVector);
            break;
          case "Gravity Sensor":
            sensorList.add(_listGravity);
            break;
          case "Linear Acceleration Sensor":
            sensorList.add(_listLinearAcceleration);
            break;
          case "Rotation Vector Sensor":
            sensorList.add(_listRotationVector);
            break;
          default:
        }
      }
    }
  }

  List<Map<String, String>> getSensorsInfo() {
    List<Map<String, String>> tmpUI = [];
    for (var elem in sensorList) {
      for (var item in elem) {
        tmpUI.add(item.getMap());
      }
    }
    return tmpUI;
  }
}

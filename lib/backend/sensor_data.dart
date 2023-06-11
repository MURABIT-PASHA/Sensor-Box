import 'package:flutter/services.dart';
import 'file_manager.dart';
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
  List<Accelerometer> listAccelerometer = [];
  List<UncalibratedAccelerometer> listUncalibratedAccelerometer = [];
  List<Gravity> listGravity = [];
  List<LinearAcceleration> listLinearAcceleration = [];
  List<MagneticField> listMagneticField = [];
  List<OrientationSensor> listOrientationSensor = [];
  List<Gyroscope> listGyroscope = [];
  List<UncalibratedGyroscope> listUncalibratedGyroscope = [];
  List<HeartBeat> listHeartBeat = [];
  List<AmbientLight> listAmbientLight = [];
  List<AtmosphericPressure> listAtmosphericPressure = [];
  List<Proximity> listProximity = [];
  List<RotationVector> listRotationVector = [];
  List<GameRotationVector> listGameRotationVector = [];
  List<GeoMagneticRotationVector> listGeoMagneticRotationVector = [];
  List<RelativeHumidity> listRelativeHumidity = [];
  List<AmbientRoomTemperature> listAmbientRoomTemperature = [];
  List<LowLatencyOffBodyDetect> listLowLatencyOffBodyDetect = [];
  List<MotionDetect> listMotionDetect = [];
  List<StationaryDetect> listStationaryDetect = [];

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
                listAccelerometer.add(Accelerometer(
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
                listUncalibratedAccelerometer.add(UncalibratedAccelerometer(
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
                listGravity.add(Gravity(
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
                listLinearAcceleration.add(LinearAcceleration(
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
                listMagneticField.add(MagneticField(
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
                listOrientationSensor.add(OrientationSensor(
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
                listGyroscope.add(Gyroscope(
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
                listUncalibratedGyroscope.add(UncalibratedGyroscope(
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
                listHeartBeat.add(HeartBeat(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '5':
            if (value.isNotEmpty) {
              for (var element in value) {
                listAmbientLight.add(AmbientLight(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '6':
            if (value.isNotEmpty) {
              for (var element in value) {
                listAtmosphericPressure.add(AtmosphericPressure(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '8':
            if (value.isNotEmpty) {
              for (var element in value) {
                listProximity.add(Proximity(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '11':
            if (value.isNotEmpty) {
              for (var element in value) {
                listRotationVector.add(RotationVector(
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
                listGameRotationVector.add(GameRotationVector(
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
                listGeoMagneticRotationVector.add(GeoMagneticRotationVector(
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
                listRelativeHumidity.add(RelativeHumidity(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '13':
            if (value.isNotEmpty) {
              for (var element in value) {
                listAmbientRoomTemperature.add(AmbientRoomTemperature(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '29':
            if (value.isNotEmpty) {
              for (var element in value) {
                listStationaryDetect.add(StationaryDetect(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '30':
            if (value.isNotEmpty) {
              for (var element in value) {
                listMotionDetect.add(MotionDetect(
                    getMeAnInstanceOfSensorInfoHolder(
                        Map<String, String>.from(element)),
                    'NA'));
              }
            }
            break;
          case '34':
            if (value.isNotEmpty) {
              for (var element in value) {
                listLowLatencyOffBodyDetect.add(LowLatencyOffBodyDetect(
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
    } on PlatformException {
      _isFirstUIBuildDone = false;
    }
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
        for (var item in listAccelerometer) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '35':
        for (var item in listUncalibratedAccelerometer) {
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
        for (var item in listGravity) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '10':
        for (var item in listLinearAcceleration) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '2':
        for (var item in listMagneticField) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.x = sensorFeed![0];
            item.y = sensorFeed[1];
            item.z = sensorFeed[2];
          }
        }
        break;
      case '3':
        for (var item in listOrientationSensor) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.azimuth = sensorFeed![0];
            item.pitch = sensorFeed[1];
            item.roll = sensorFeed[2];
          }
        }
        break;
      case '4':
        for (var item in listGyroscope) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.angularSpeedAroundX = sensorFeed![0];
            item.angularSpeedAroundY = sensorFeed[1];
            item.angularSpeedAroundZ = sensorFeed[2];
          }
        }
        break;
      case '16':
        for (var item in listUncalibratedGyroscope) {
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
        for (var item in listHeartBeat) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.confidence = sensorFeed![0];
          }
        }
        break;
      case '5':
        for (var item in listAmbientLight) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.level = sensorFeed![0];
          }
        }
        break;
      case '6':
        for (var item in listAtmosphericPressure) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.pressure = sensorFeed![0];
          }
        }
        break;
      case '8':
        for (var item in listProximity) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');
            item.distance = sensorFeed![0];
          }
        }
        break;
      case '11':
        for (var item in listRotationVector) {
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
        for (var item in listGameRotationVector) {
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
        for (var item in listGeoMagneticRotationVector) {
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
        for (var item in listRelativeHumidity) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.humidity = sensorFeed![0];
          }
        }
        break;
      case '13':
        for (var item in listAmbientRoomTemperature) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.temperature = sensorFeed![0];
          }
        }
        break;
      case '29':
        for (var item in listStationaryDetect) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.isImmobile = sensorFeed![0];
          }
        }
        break;
      case '30':
        for (var item in listMotionDetect) {
          if (isAMatch(item.sensor, receivedData)) {
            List<String>? sensorFeed = receivedData['values']?.split(';');

            item.isInMotion = sensorFeed![0];
          }
        }
        break;
      case '34':
        for (var item in listLowLatencyOffBodyDetect) {
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
      listAccelerometer,
      listUncalibratedAccelerometer,
      listGravity,
      listLinearAcceleration,
      listMagneticField,
      listOrientationSensor,
      listGyroscope,
      listUncalibratedGyroscope,
      listHeartBeat,
      listAmbientLight,
      listAtmosphericPressure,
      listProximity,
      listRotationVector,
      listGameRotationVector,
      listGeoMagneticRotationVector,
      listRelativeHumidity,
      listAmbientRoomTemperature,
      listStationaryDetect,
      listMotionDetect,
      listLowLatencyOffBodyDetect,
    ]) {
      for (var item in elem) {
        tmpUI.add(item.getMap());
      }
    }
    return tmpUI;
  }

  Future<bool> writeData(DateTime timestamp, DateTime firstTime) async {
    FileManager file = FileManager();
    return await file.saveData(getSensorsInfo(), timestamp, firstTime);
  }

  void initializeSensors(List<String> sensorNames){
    if(sensorNames.isNotEmpty){
      for (String name in sensorNames){
        switch(name) {
          case "Accelerometer":
            sensorList.add(listAccelerometer);
            break;
          case "Gyroscope":
            sensorList.add(listGyroscope);
            break;
          case "Magnetic Field":
            sensorList.add(listMagneticField);
            break;
          case "Orientation":
            sensorList.add(listOrientationSensor);
            break;
          case "Ambient Temperature":
            sensorList.add(listAmbientRoomTemperature);
            break;
          case "Proximity":
            sensorList.add(listProximity);
            break;
          case "Light":
            sensorList.add(listAmbientLight);
            break;
          case "Pressure":
            sensorList.add(listAtmosphericPressure);
            break;
          case "Humidity":
            sensorList.add(listRelativeHumidity);
            break;
          case "Uncalibrated Magnetic field":
            sensorList.add(listMotionDetect);
            break;
          case "Uncalibrated Gyroscope":
            sensorList.add(listUncalibratedGyroscope);
            break;
          case "Heart Rate":
            sensorList.add(listHeartBeat);
            break;
          case "Gesture":
            sensorList.add(listStationaryDetect);
            break;
          case "Game Rotation":
            sensorList.add(listGameRotationVector);
            break;
          case "Geographic Magnetic Rotation":
            sensorList.add(listGeoMagneticRotationVector);
            break;
          case "Gravity":
            sensorList.add(listGravity);
            break;
          case "Linear Acceleration":
            sensorList.add(listLinearAcceleration);
            break;
          case "Rotation":
            sensorList.add(listRotationVector);
            break;
          default:
            break;
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

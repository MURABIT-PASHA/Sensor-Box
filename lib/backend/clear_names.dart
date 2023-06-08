class ClearNames {
  final List<String> sensorNames;

  ClearNames._(this.sensorNames);

  factory ClearNames(List<String> sensorNames) {
    List<String> clearedSensorNames = [];
    for (var sensorName in sensorNames) {
      switch (sensorName) {
        case "Goldfish 3-axis Accelerometer":
          clearedSensorNames.add("Accelerometer");
          break;
        case "Goldfish 3-axis Gyroscope":
          clearedSensorNames.add("Gyroscope");
          break;
        case "Goldfish 3-axis Magnetic field sensor":
          clearedSensorNames.add("Magnetic Field");
          break;
        case "Goldfish Orientation sensor":
          clearedSensorNames.add("Orientation");
          break;
        case "Goldfish Ambient Temperature sensor":
          clearedSensorNames.add("Ambient Temperature");
          break;
        case "Goldfish Proximity sensor":
          clearedSensorNames.add("Proximity");
          break;
        case "Goldfish Light sensor":
          clearedSensorNames.add("Light");
          break;
        case "Goldfish Pressure sensor":
          clearedSensorNames.add("Pressure");
          break;
        case "Goldfish Humidity sensor":
          clearedSensorNames.add("Humidity");
          break;
        case "Goldfish 3-axis Magnetic field sensor (uncalibrated)":
          clearedSensorNames.add("Uncalibrated Magnetic Field");
          break;
        case "Goldfish 3-axis Gyroscope (uncalibrated)":
          clearedSensorNames.add("Uncalibrated Gyroscope");
          break;
        case "Goldfish Heart rate sensor":
          clearedSensorNames.add("Heart Rate");
          break;
        case "Goldfish wrist tilt gesture sensor":
          clearedSensorNames.add("Gesture");
          break;
        case "Game Rotation Vector Sensor":
          clearedSensorNames.add("Game Rotation");
          break;
        case "GeoMag Rotation Vector Sensor":
          clearedSensorNames.add("Geographic Magnetic Rotation");
          break;
        case "Gravity Sensor":
          clearedSensorNames.add("Gravity");
          break;
        case "Linear Acceleration Sensor":
          clearedSensorNames.add("Linear Acceleration");
          break;
        case "Rotation Vector Sensor":
          clearedSensorNames.add("Rotation");
          break;
        case "Orientation Sensor":
          clearedSensorNames.add("Orientation");
          break;
        default:
          clearedSensorNames.add(sensorName);
          break;
      }
    }
    return ClearNames._(clearedSensorNames);
  }
}

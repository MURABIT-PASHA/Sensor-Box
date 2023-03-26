class SensorInfoHolder {
  SensorInfoHolder(
      this.name,
      this.type,
      this.vendorName,
      this.version,
      this.power,
      this.resolution,
      this.maxRange,
      this.maxDelay,
      this.minDelay,
      this.reportingMode,
      this.isWakeup,
      this.isDynamic,
      this.highestDirectReportRateValue,
      this.fifoMaxEventCount,
      this.fifoReservedEventCount) {
    type = '${_getTypeToName(type)} ($type)';
  }
  String name;
  String type;
  String vendorName;
  String version;
  String power;
  String resolution;
  String maxRange;
  String maxDelay;
  String minDelay;
  String reportingMode;
  String isWakeup;
  String isDynamic;
  String highestDirectReportRateValue;
  String fifoMaxEventCount;
  String fifoReservedEventCount;
  String? _getTypeToName(String type) {
    return <String, String>{
      '1': 'Accelerometer',
      '35': 'Uncalibrated Accelerometer',
      '9': 'Gravity',
      '10': 'Linear Acceleration',
      '2': 'Magnetic Field',
      '3': 'Orientation',
      '4': 'Gyroscope',
      '16': 'Uncalibrated Gyroscope',
      '31': 'Heart Beat',
      '5': 'Ambient Light',
      '6': 'Atmospheric Pressure',
      '8': 'Proximity',
      '11': 'Rotation Vector',
      '15': 'Game Rotation Vector',
      '20': 'Geo Magnetic Rotation Vector',
      '12': 'Relative Humidity',
      '13': 'Ambient Room Temperature',
      '29': 'Stationary Detect',
      '30': 'Motion Detect',
      '34': 'Low Latency Off Body Detect',
    }[type];
  }

  Map<String, String> displaySensorData() {
    return {
      'Name': this.name,
      'VendorName': this.vendorName,
      'Type': this.type,
      'Version': this.version,
      'Power': '${this.power} mA',
      'Resolution': '${this.resolution} unit',
      'Maximum Range': '${this.maxRange} unit',
      'Maximum Delay': '${this.maxDelay} s',
      'Minimum Delay': '${this.minDelay} s',
      'Reporting Mode': <String, String>{
        '0': 'Continuous',
        '1': 'On Change',
        '2': 'One Shot',
        '3': 'Special Trigger',
        'NA': 'NA',
      }[this.reportingMode]!,
      'Wake Up': this.capitalize(this.isWakeup),
      'Dynamic': this.capitalize(this.isDynamic),
      'Highest Direct Report Rate Value': <String, String>{
        '0': 'Unsupported',
        '1': 'Normal',
        '2': 'Fast',
        '3': 'Very Fast',
        'NA': 'NA',
      }[this.highestDirectReportRateValue]!,
      'Fifo Max Event Count': this.fifoMaxEventCount,
      'Fifo Reserved Event Count': this.fifoReservedEventCount,
    };
  }

  Map<String, String> appendThem(Map<String, String> myMap) {
    Map<String, String> target = this.displaySensorData();
    myMap.forEach((key, value) {
      target[key] = value;
    });
    return target;
  }

  String capitalize(String str) {
    return str.replaceFirst(str[0], str[0].toUpperCase());
  }
}

class Accelerometer {
  // type 1
  Accelerometer(this.sensor, this.x, this.y, this.z);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Along X-axis': '${this.x} m/s^2',
      'Along Y-axis': '${this.y} m/s^2',
      'Along Z-axis': '${this.z} m/s^2',
    });
  }
}

class UncalibratedAccelerometer {
  // type 35
  UncalibratedAccelerometer(
      this.sensor,
      this.xUncalib,
      this.yUncalib,
      this.zUnclaib,
      this.estimatedXBias,
      this.estimatedYBias,
      this.estimatedZBias);
  SensorInfoHolder sensor;
  String xUncalib;
  String yUncalib;
  String zUnclaib;
  String estimatedXBias;
  String estimatedYBias;
  String estimatedZBias;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'X Uncalibrated': '${this.xUncalib} m/s^2',
      'Y Uncalibrated': '${this.yUncalib} m/s^2',
      'Z Uncalibrated': '${this.zUnclaib} m/s^2',
      'Estimated X Bias': '${this.estimatedXBias} m/s^2',
      'Estimated Y Bias': '${this.estimatedYBias} m/s^2',
      'Estimated Z Bias': '${this.estimatedZBias} m/s^2',
    });
  }
}

class Gravity {
  // type 9
  Gravity(this.sensor, this.x, this.y, this.z);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Along X-axis': '${this.x} m/s^2',
      'Along Y-axis': '${this.y} m/s^2',
      'Along Z-axis': '${this.z} m/s^2',
    });
  }
}

class LinearAcceleration {
  // type 10
  LinearAcceleration(this.sensor, this.x, this.y, this.z);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Along X-axis': '${this.x} m/s^2',
      'Along Y-axis': '${this.y} m/s^2',
      'Along Z-axis': '${this.z} m/s^2',
    });
  }
}

class MagneticField {
  // type 2
  MagneticField(this.sensor, this.x, this.y, this.z);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Along X-axis': '${this.x} uT',
      'Along Y-axis': '${this.y} uT',
      'Along Z-axis': '${this.z} uT',
    });
  }
}

class OrientationSensor {
  // type 3
  OrientationSensor(this.sensor, this.azimuth, this.pitch, this.roll);
  SensorInfoHolder sensor;
  String azimuth;
  String pitch;
  String roll;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Azimuth': '${this.azimuth}',
      'Pitch': '${this.pitch}',
      'Roll': '${this.roll}',
    });
  }
}

class Gyroscope {
  // type 4
  Gyroscope(this.sensor, this.angularSpeedAroundX, this.angularSpeedAroundY,
      this.angularSpeedAroundZ);
  SensorInfoHolder sensor;
  String angularSpeedAroundX;
  String angularSpeedAroundY;
  String angularSpeedAroundZ;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Angular Speed around X': '${this.angularSpeedAroundX} rad/s',
      'Angular Speed around Y': '${this.angularSpeedAroundY} rad/s',
      'Angular Speed around Z': '${this.angularSpeedAroundZ} rad/s',
    });
  }
}

class UncalibratedGyroscope {
  // type 16
  UncalibratedGyroscope(
      this.sensor,
      this.angularSpeedAroundX,
      this.angularSpeedAroundY,
      this.angularSpeedAroundZ,
      this.estimatedDriftAroundX,
      this.estimatedDriftAroundY,
      this.estimatedDriftAroundZ);
  SensorInfoHolder sensor;
  String angularSpeedAroundX;
  String angularSpeedAroundY;
  String angularSpeedAroundZ;
  String estimatedDriftAroundX;
  String estimatedDriftAroundY;
  String estimatedDriftAroundZ;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Angular Speed around X': '${this.angularSpeedAroundX} rad/s',
      'Angular Speed around Y': '${this.angularSpeedAroundY} rad/s',
      'Angular Speed around Z': '${this.angularSpeedAroundZ} rad/s',
      'Estimated Drift around X': '${this.estimatedDriftAroundX} rad/s',
      'Estimated Drift around Y': '${this.estimatedDriftAroundY} rad/s',
      'Estimated Drift around Z': '${this.estimatedDriftAroundZ} rad/s',
    });
  }
}

class HeartBeat {
  // type 31
  HeartBeat(this.sensor, this.confidence);
  SensorInfoHolder sensor;
  String confidence;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Confidence': '${this.confidence}',
    });
  }
}

class AmbientLight {
  // type 5
  AmbientLight(this.sensor, this.level);
  SensorInfoHolder sensor;
  String level;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Ambient Light Level': '${this.level} lux',
    });
  }
}

class AtmosphericPressure {
  // type 6
  AtmosphericPressure(this.sensor, this.pressure);
  SensorInfoHolder sensor;
  String pressure;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
'Atmospheric Pressure':'${this.pressure} hPa',
        }
    );
  }
}

class Proximity {
  // type 8
  Proximity(this.sensor, this.distance);
  SensorInfoHolder sensor;
  String distance;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Distance From Screen': '${this.distance} cm',
    }
    );
  }
}

class RotationVector {
  // type 11
  RotationVector(this.sensor, this.x, this.y, this.z, this.someVal,
      this.estimatedHeadingAccuracy);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  String someVal;
  String estimatedHeadingAccuracy;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'X * Sin(\u{03b8}/2)': '${this.x}',
      'Y * Sin(\u{03b8}/2)': '${this.y}',
      'Z * Sin(\u{03b8}/2)': '${this.z}',
      'Cos(\u{03b8}/2)': '${this.someVal}',
      'Estimated Heading Accuracy': '${this.estimatedHeadingAccuracy} rad',
    }
    );
  }
}

class GameRotationVector {
  // type 15
  GameRotationVector(this.sensor, this.x, this.y, this.z, this.someVal,
      this.estimatedHeadingAccuracy);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  String someVal;
  String estimatedHeadingAccuracy;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'X * Sin(\u{03b8}/2)': '${this.x}',
      'Y * Sin(\u{03b8}/2)': '${this.y}',
      'Z * Sin(\u{03b8}/2)': '${this.z}',
      'Cos(\u{03b8}/2)': '${this.someVal}',
      'Estimated Heading Accuracy': '${this.estimatedHeadingAccuracy} rad',
    }
    );
  }
}

class GeoMagneticRotationVector {
  // type 20
  GeoMagneticRotationVector(this.sensor, this.x, this.y, this.z, this.someVal,
      this.estimatedHeadingAccuracy);
  SensorInfoHolder sensor;
  String x;
  String y;
  String z;
  String someVal;
  String estimatedHeadingAccuracy;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'X * Sin(\u{03b8}/2)': '${this.x}',
      'Y * Sin(\u{03b8}/2)': '${this.y}',
      'Z * Sin(\u{03b8}/2)': '${this.z}',
      'Cos(\u{03b8}/2)': '${this.someVal}',
      'Estimated Heading Accuracy': '${this.estimatedHeadingAccuracy} rad',
    }
    );
  }
}

class RelativeHumidity {
  // type 12
  RelativeHumidity(this.sensor, this.humidity);
  SensorInfoHolder sensor;
  String humidity;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Relative Air Humidity': '${this.humidity} %',
    }
    );
  }
}

class AmbientRoomTemperature {
  // type 13
  AmbientRoomTemperature(this.sensor, this.temperature);
  SensorInfoHolder sensor;
  String temperature;
  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Temperature': '${this.temperature} C',
    }
    );
  }
}

class LowLatencyOffBodyDetect {
  // type 34
  LowLatencyOffBodyDetect(this.sensor, this.offBodyState);
  SensorInfoHolder sensor;
  String offBodyState;

  String getStateText() {
    return this.offBodyState == '1.0' ? 'Device on-body' : 'Device off-body';
  }

  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Off Body State': '${getStateText()}',
    }
    );
  }
}

class MotionDetect {
  // type 30
  MotionDetect(this.sensor, this.isInMotion);
  SensorInfoHolder sensor;
  String isInMotion;

  String getStateText() {
    return this.isInMotion == '1.0'
        ? 'Device in Motion'
        : 'Device not in Motion';
  }

  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Motion Detection': '${getStateText()}',
    }
    );
  }
}

class StationaryDetect {
  // type 29
  StationaryDetect(this.sensor, this.isImmobile);
  SensorInfoHolder sensor;
  String isImmobile;

  String getStateText() {
    return this.isImmobile == '1.0'
        ? 'Device in Stationary State'
        : 'Device not in Stationary State';
  }

  Map<String, String> getMap() {
    return this.sensor.appendThem({
      'Motion Detection': '${getStateText()}',
    }
    );
  }
}

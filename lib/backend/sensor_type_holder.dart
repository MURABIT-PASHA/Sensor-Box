class SensorTypeHolder {
  final List<String> sensorName;

  SensorTypeHolder._(this.sensorName);

  factory SensorTypeHolder(String sensorName) {
    List<String> typesList = [];
    switch (sensorName) {
      case "Accelerometer":
        typesList = ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
        break;
      case "Gyroscope":
        typesList = [
          'Angular Speed around X',
          'Angular Speed around Y',
          'Angular Speed around Z'
        ];
        break;
      case "Magnetic Field":
        typesList = ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
        break;
      case "Orientation":
        typesList = [];
        break;
      case "Ambient Temperature":
        typesList = ['Temperature'];
        break;
      case "Proximity":
        typesList = ['Distance From Screen'];
        break;
      case "Light":
        typesList = ['Ambient Light Level'];
        break;
      case "Pressure":
        typesList = ['Atmospheric Pressure'];
        break;
      case "Humidity":
        typesList = ['Relative Air Humidity'];
        break;
      case "Uncalibrated Magnetic field":
        typesList = [];
        break;
      case "Uncalibrated Gyroscope":
        typesList = [
          'Angular Speed around X',
          'Angular Speed around Y',
          'Angular Speed around Z',
          'Estimated Drift around X',
          'Estimated Drift around Y',
          'Estimated Drift around Z'
        ];
        break;
      case "Heart Rate":
        typesList = ['Confidence'];
        break;
      case "Gesture":
        typesList = [];
        break;
      case "Game Rotation":
        typesList = [
          'X * Sin(\u{03b8}/2)',
          'Y * Sin(\u{03b8}/2)',
          'Z * Sin(\u{03b8}/2)'
        ];
        break;
      case "Geographic Magnetic Rotation":
        typesList = [
          'X * Sin(\u{03b8}/2)',
          'Y * Sin(\u{03b8}/2)',
          'Z * Sin(\u{03b8}/2)',
          'Cos(\u{03b8}/2)'
        ];
        break;
      case "Gravity":
        typesList = ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
        break;
      case "Linear Acceleration":
        typesList = ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
        break;
      case "Rotation":
        typesList = [
          'X * Sin(\u{03b8}/2)',
          'Y * Sin(\u{03b8}/2)',
          'Z * Sin(\u{03b8}/2)',
          'Cos(\u{03b8}/2)'
        ];
        break;
      default:
        typesList = [];
        break;
      }
      return SensorTypeHolder._(typesList);
    }

  }

import 'dart:io';
import 'package:path_provider/path_provider.dart';
class FileSaver{

  void deleteFilesInDirectory() async{
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }

  Future<void> send(String path) async{
    File file = File(path);
    //TODO: Send this file via firebase

  }

  Future<bool> sendFiles() async{
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        try{
          send(file.path);
        }catch(exception){
          return false;
        }
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  Future<bool> saveData(List<Map<String, String>> data, DateTime timestamp, DateTime firstTime) async {
    /// Saves the given data to CSV files with the given timestamps and headers.
    /// @param [data] - List of maps containing data to be saved to CSV files.
    /// Each map represents a CSV file and should have a "name" key
    /// for the name of the CSV file and other keys as headers for the CSV file.
    /// @param [timestamp] - Timestamp to be added to the end of each CSV file name.
    /// @param [firstTime] - Timestamp to be added to the beginning of each CSV file name.
    /// This is used to differentiate CSV files created at different times.
    /// Returns true if the data was successfully saved, false otherwise.
    List<Map<String, String>> tmpUI = [];
    tmpUI = data;
    if (tmpUI.isNotEmpty) {
      late String directory;
      await getApplicationDocumentsDirectory().then((value) =>
      directory = value.path);
      for (Map<String, String> sensor in tmpUI) {
        final String csvFile = "${sensor["name"]}${firstTime
            .millisecondsSinceEpoch}.csv";
        print(csvFile);
        final filePath = "$directory/$csvFile";
        print(filePath);
        final File file = File(filePath);
        // Open file if its not empty then just add row else add headers too
        if (await file.exists()) {
          print("Exist");
          // Read file content and print each line
          final content = await file.readAsLines();
          for (final line in content) {
            print(line);
          }
          // Add values row to the end of file
          final values = sensor.values.join(',') + ',${timestamp.millisecondsSinceEpoch}' + '\n';
          await file.writeAsString(values, mode: FileMode.append);
        }
        else {
          print("Not Exist");
          // Create headers
          final headers = sensor.keys.join(',') + ',timestamp' + '\n';
          // Create values row
          final values = sensor.values.join(',') + ',${timestamp.millisecondsSinceEpoch}' + '\n';
          // Write headers and values to file
          await file.writeAsString(headers + values);
        }
      }
      return true;
    }else {
      return false;
    }
  }
}
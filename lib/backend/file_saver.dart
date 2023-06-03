import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class FileSaver{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void deleteFilesInDirectory() async{
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }

  Future<void> send(String path, int deviceCode) async{
    try{
      print(path);
      File file = await File(path).create();
      final content = await file.readAsLines();
      for (final line in content) {
        print("Satır: $line");
      }
      try{
        final ref = _storage.ref().child('$deviceCode/$path');
        final uploadTask = ref.putFile(file);
        await uploadTask;
      }on FirebaseException catch(e){
        print(e);
      }
    }on OSError catch(e){
      print(e);
    }

  }
  Future<bool> getFiles(int deviceCode) async {
    final directory = await getExternalStorageDirectory();
    final ref = _storage.ref().child('$deviceCode');
    final ListResult result = await ref.listAll();
    if(result.items.isNotEmpty) {
      for (var fileRef in result.items) {
        var bytes = await fileRef.getData();
        List<int> intList = bytes?.toList() ?? [];
        final filePath = '${directory?.path}/Downloads/${fileRef.name}';
        await File(filePath).writeAsBytes(intList);
      }
    }else{
      return false;
    }
    return true;
  }

  Future<void> deleteFilesInStorage(int deviceCode) async{
    final storageRef = FirebaseStorage.instance.ref().child('$deviceCode');
    final ListResult result = await storageRef.listAll();
    final files = result.items;

    await Future.wait(
      files.map((file) => file.delete()),
    );

  }
  Future<bool> sendFiles(int deviceCode) async{
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = await directory.list().toList();
    for (FileSystemEntity file in files) {
      if (file.path.isNotEmpty) {
        try{
          String fileName = basename(file.path);
          send(file.path,deviceCode);
          print(file.path);
        }catch(exception){
          print(exception);
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
            .millisecondsSinceEpoch}.csv";;
        final filePath = "$directory/$csvFile";
        final File file = File(filePath);
        if (await file.exists()) {
          final values = '${sensor.values.join(',')},${timestamp.millisecondsSinceEpoch}\n';
          await file.writeAsString(values, mode: FileMode.append);
        }
        else {
          print("Not Exist");
          // Create headers
          final headers = '${sensor.keys.join(',')},timestamp\n';
          // Create values row
          final values = '${sensor.values.join(',')},${timestamp.millisecondsSinceEpoch}\n';
          // Write headers and values to file
          await file.writeAsString(headers + values);
        }
      }
      return true;
    }else {
      print("Sensor yazma hatası var");
      return false;
    }
  }
}
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
class FileSaver{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }
  Future<File> writeData(String row, String fileName) async {
    final file = await _localFile(fileName);
    return file.writeAsString(row, mode: FileMode.append);
  }
  Future<String> readData(fileName) async {
    try {
      final file = await _localFile(fileName);
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "";
    }
  }
  void deleteFilesInDirectory() async{
    Directory directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        file.deleteSync();
      }
    }
  }

  Future<void> send(String fileName, int deviceCode) async{
    try{
      final content = readData(fileName);
        print("Content: $content");
      try{
        final ref = _storage.ref().child('$deviceCode/$fileName');
        final uploadTask = ref.putFile(await _localFile(fileName));
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
    for (var file in files) {
      if (file is File) {
        print('Dosya: ${file.path}');
      } else if (file is Directory) {
        print('Klasör: ${file.path}');
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
      for (Map<String, String> sensor in tmpUI) {
        final String csvFile = "${sensor["name"]}${firstTime
            .millisecondsSinceEpoch}.csv";
        String readerData = await readData(csvFile);
        if (readerData!="") {
          final values = '${sensor.values.join(',')},${timestamp.millisecondsSinceEpoch}\n';
          await writeData(values, csvFile);
        }
        else {
          final headers = '${sensor.keys.join(',')},timestamp\n';
          final values = '${sensor.values.join(',')},${timestamp.millisecondsSinceEpoch}\n';
          await writeData(headers+values, csvFile);
        }
      }
      return true;
    }else {
      return false;
    }
  }
}
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
class FileSaver{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> get _storagePath async{
      return await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
  }

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
        final ref = _storage.ref().child('$deviceCode/$fileName');
        final uploadTask = ref.putFile(await _localFile(fileName));
        await uploadTask;
      }on FirebaseException catch(e){
        print(e);
      }
  }
  Future<bool> getFiles(int deviceCode) async {
    final ref = _storage.ref().child('$deviceCode');
    final ListResult result = await ref.listAll();
    if(result.items.isNotEmpty) {
      for (var fileRef in result.items) {
        final filePath = '${await _storagePath}/SensorBox/${fileRef.name}';
        File writtenFile = File(filePath);
        if(await writtenFile.exists()){
          await fileRef.writeToFile(writtenFile);
        }else{
          await writtenFile.create(recursive: true);
          await fileRef.writeToFile(writtenFile);
        }
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
    int flag = 0;
    for (var file in files) {
      if (file is File) {
        if(file.path.contains(".csv")){
          String fileName = file.path.split("/").last;
          await send(fileName, deviceCode);
          flag += 1;
        }
      }
    }
    if(flag!=0){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> saveData(List<Map<String, String>> data, DateTime timestamp, DateTime firstTime) async {

    List<Map<String, String>> tmpUI = [];
    tmpUI = data;
    if (tmpUI.isNotEmpty) {
      for (Map<String, String> sensor in tmpUI) {
        final String csvFile = "${sensor["Type"]}${firstTime
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
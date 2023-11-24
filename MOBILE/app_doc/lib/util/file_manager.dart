import 'dart:io';

class FileManager {
  static FileManager _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory directory = Directory('/storage/emulated/0/Download');
    return directory.path;
  }

  Future<File> _jsonFile(nomeArquivo) async {
    final path = await _directoryPath;
    File buscarArquivo = File('$path/$nomeArquivo.txt');
    if (buscarArquivo.existsSync()) {
      buscarArquivo.deleteSync();
    }
    return File('$path/$nomeArquivo.txt');
  }

  Future<void> writeJsonFile(strBody, nomeArquivo) async {
    File file = await _jsonFile(nomeArquivo);
    await file.writeAsString(strBody);
  }
}

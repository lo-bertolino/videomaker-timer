import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TextStorage {
  static TextStorage storage = TextStorage();

  Future<File> get _localFile =>
      getApplicationDocumentsDirectory().then((dir) => File(dir.path + '/text.txt'));

  Future<String> readFile() => _localFile.then(
        (file) => file.readAsString(),
        onError: (e) => '',
      );

  Future<File> writeFile(String text) => _localFile.then(
        (file) => file.writeAsString(text, mode: FileMode.append),
        onError: (e) => null,
      );

  Future<File> clearFile() => _localFile.then(
        (file) => file.writeAsString(''),
      );
}

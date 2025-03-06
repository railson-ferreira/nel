import 'dart:typed_data';

import 'package:archive/archive.dart';

class TarGzHelper {
  late final Archive _archive;

  void loadTarGz(Uint8List bytes) {
    final decompressedBytes = GZipDecoder().decodeBytes(bytes); // Decompress
    _archive = TarDecoder().decodeBytes(decompressedBytes);
  }

  Uint8List? readFile(String path) {
    final file = _archive.findFile(path);
    if (file == null) {
      return null;
    }
    return file.content;
  }
}

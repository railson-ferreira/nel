import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:nel/services/package_repository.dart';

class LocalFileSystemPackageRepository implements PackageRepository {
  @override
  Future<void> create(
      String name, String version, String pubspec, Uint8List package) async {
    await Directory("data/packages/$name/$version").create(recursive: true);
    await File("data/packages/$name/$version/pubspec.yaml")
        .writeAsString(pubspec);
    await File("data/packages/$name/$version/package.tar.gz.sha256")
        .writeAsString(sha256.convert(package).toString());
    await File("data/packages/$name/$version/package.tar.gz")
        .writeAsBytes(package);
  }
}

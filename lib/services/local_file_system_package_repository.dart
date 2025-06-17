import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:nel/services/package_repository.dart';
import 'package:pub_semver/pub_semver.dart';

class LocalFileSystemPackageRepository implements PackageRepository {
  @override
  Future<void> create(
      String name, String version, String pubspec, Uint8List package) async {
    await Directory("data/packages/$name/$version").create(recursive: true);
    await File("data/packages/$name/$version/pubspec.yaml")
        .writeAsString(pubspec);
    await File("data/packages/$name/$version/package.tar.gz.sha256")
        .writeAsString(crypto.sha256.convert(package).toString());
    await File("data/packages/$name/$version/package.tar.gz")
        .writeAsBytes(package);
  }

  @override
  Future<List<Version>> listVersions(String name) {
    // TODO: implement listVersions
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> pubspec(String name, Version version) {
    // TODO: implement pubspec
    throw UnimplementedError();
  }

  @override
  Future<Stream<List<int>>> read(String name, Version version) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<String> sha256(String name, Version version) {
    // TODO: implement sha256
    throw UnimplementedError();
  }

}

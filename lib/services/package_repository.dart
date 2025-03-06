import 'dart:typed_data';

abstract interface class PackageRepository {
  Future<void> create(
      String name, String version, String pubspec, Uint8List package);
}

import 'dart:ffi';
import 'dart:typed_data';

import 'package:pub_semver/pub_semver.dart';

abstract interface class PackageRepository {
  static PackageRepository Function() _concreteConstructor = () => _DefaultImplementation();
  factory PackageRepository.concrete() =>_concreteConstructor();
  static set concreteConstructor(PackageRepository Function() constructor){
    _concreteConstructor = constructor;
  }

  Future<void> create(
      String name, String version, String pubspec, Uint8List package);

  Future<List<Version>> listVersions(
      String name);

  Future<String> sha256(String name, Version version);

  Future<Map<String,Object?>> pubspec(String name, Version version);

  Future<Stream<List<int>>> read(String name, Version version);

}

class _DefaultImplementation implements PackageRepository {
  @override
  Future<void> create(
      String name, String version, String pubspec, Uint8List package) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Version>> listVersions(String name) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> pubspec(String name, Version version) {
    throw UnimplementedError();
  }

  @override
  Future<Stream<List<int>>> read(String name, Version version) {
    throw UnimplementedError();
  }

  @override
  Future<String> sha256(String name, Version version) {
    throw UnimplementedError();
  }
}

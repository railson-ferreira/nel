import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:azblob/azblob.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:nel/services/package_repository.dart';
import 'package:nel/utils/yaml_utils.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

class AzureBlobPackageRepository implements PackageRepository {
  static const connectionStringVarName = "MICROSOFT_BLOB_CONNECTION_STRING";
  late final String connectionString;

  AzureBlobPackageRepository() {
    final maybeConnectionString = Platform.environment[connectionStringVarName];
    assert(maybeConnectionString != null);
    connectionString = maybeConnectionString!;
  }

  Future<void> create(
      String name, String version, String pubspec, Uint8List package) async {
    var storage = AzureStorage.parse(connectionString);
    await storage.putBlob("/dart-repository/packages/$name/$version/pubspec.yaml", body: pubspec);
    await storage.putBlob("/dart-repository/packages/$name/$version/package.tar.gz.sha256", body: crypto.sha256.convert(package).toString());
    await storage.putBlob("/dart-repository/packages/$name/$version/package.tar.gz", bodyBytes: package);
  }

  Future<List<Version>> listVersions(String name) async {
    var storage = AzureStorage.parse(connectionString);
    final response = await storage.listBlobsRaw("/dart-repository/packages/$name/");
    if (response.statusCode != 200) {
      throw Exception("Failed to list versions of $name: ${response.statusCode}");
    }
    final xml = await response.stream.bytesToString();
    final regex = RegExp(name+r'/(\d+\.\d+\.\d+)/pubspec\.yaml');
    final versions = <Version>[];
    for (final match in regex.allMatches(xml)) {
      final versionString = match.group(1);
      if (versionString != null) {
        try {
          versions.add(Version.parse(versionString));
        } catch (e) {
          // Ignore invalid version formats
        }
      }
    }
    return versions;
  }

  @override
  Future<String> sha256(String name, Version version) async {
    var storage = AzureStorage.parse(connectionString);
    final response = await storage.getBlob("/dart-repository/packages/$name/$version/package.tar.gz.sha256");
    if (response.statusCode != 200) {
      throw Exception("Failed to read package $name: ${response.statusCode}");
    }
    final bytes = await response.stream.toBytes();
    final bodyString = utf8.decode(bytes);
    return bodyString.trim();
  }

  @override
  Future<Map<String, Object?>> pubspec(String name, Version version) async {
    var storage = AzureStorage.parse(connectionString);
    final response = await storage.getBlob("/dart-repository/packages/$name/$version/pubspec.yaml");
    if (response.statusCode != 200) {
      throw Exception("Failed to read package $name: ${response.statusCode}");
    }
    final bytes = await response.stream.toBytes();
    final yamlStr = utf8.decode(bytes);
    final yaml = loadYaml(yamlStr);
    final map = PubspecYamlUtils.convertYamlToMap(yaml);
    return (map as Map<Object?, Object?>).cast();
  }

  @override
  Future<Stream<List<int>>> read(String name, Version version) async {
    var storage = AzureStorage.parse(connectionString);
    final response = await storage.getBlob("/dart-repository/packages/$name/$version/package.tar.gz");
    if (response.statusCode != 200) {
      throw Exception("Failed to read package $name: ${response.statusCode}");
    }
    print("expanding response stream");
    return response.stream;
  }
}

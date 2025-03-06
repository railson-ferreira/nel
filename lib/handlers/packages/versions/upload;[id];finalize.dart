import 'dart:convert';
import 'dart:io';
import 'package:nel/debug_req.dart';
import 'package:nel/helpers/tar_gz_helper.dart';
import 'package:nel/services/azure_blob_package_repository.dart';
import 'package:nel/services/local_file_system_package_repository.dart';
import 'package:nel/services/package_repository.dart';
import 'package:nel/utils/yaml_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final PackageRepository packageRepository = LocalFileSystemPackageRepository();

Future<Response> packagesVersionsUpload_Finalize(Request request) async {
  final id = request.params["id"];
  print("finalizing id: $id");
  await request.debug();

  final packageDirectory = File("temp/upload/$id");
  final packageFile = File("temp/upload/$id/package.tar.gz");
  final packageBytes = await packageFile.readAsBytes();
  final pubspecBytes =
      (TarGzHelper()..loadTarGz(packageBytes)).readFile("pubspec.yaml");

  if (pubspecBytes == null) {
    return _badRequestResponse("pubspec.yaml not found in package");
  }

  final pubspecContent = utf8.decode(pubspecBytes);
  final name = PubspecYamlUtils.getName(pubspecContent);
  if (name == null) {
    return _badRequestResponse("name not found in pubspec.yaml");
  }
  final version = PubspecYamlUtils.getVersion(pubspecContent);
  if (version == null) {
    return _badRequestResponse("version not found in pubspec.yaml");
  }

  await packageRepository.create(name, version, pubspecContent, packageBytes);

  packageDirectory.delete(recursive: true);
  return Response.ok(jsonEncode({
    "success": {"message": "Upload completed successfully"}
  }));
}

Response _badRequestResponse(String message) {
  return Response.badRequest(
      body: jsonEncode({
    "error": {
      "code": "BadRequest",
      "message": message,
    },
  }));
}

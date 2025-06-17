import 'dart:io';

import 'package:nel/services/azure_blob_package_repository.dart';
import 'package:nel/services/local_file_system_package_repository.dart';
import 'package:nel/services/package_repository.dart';

import '../lib/router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  _registerImplementations();
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

void _registerImplementations(){
  if(Platform.environment[AzureBlobPackageRepository.connectionStringVarName] != null){
    PackageRepository.concreteConstructor = AzureBlobPackageRepository.new;
  } else {
    PackageRepository.concreteConstructor = LocalFileSystemPackageRepository.new;
  }
}
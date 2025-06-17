import 'dart:convert';

import 'package:nel/globals.dart';
import 'package:nel/utils/uri_extensions.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:yaml/yaml.dart';

Future<Response> packages_(Request request) async {
  final package = request.params["package"];
  if(package == null || package.isEmpty){
    return Response.badRequest(body:jsonEncode({
      "error": {
        "code": "BadRequest",
        "message": "package param is required",
      },
    }));
  }
  print("getting list of: $package");
  final versions = await packageRepository.listVersions(package);
  if(versions.isEmpty) {
    return Response.notFound(jsonEncode({
      "error": {
        "code": "NotFound",
        "message": "Package not found",
      },
    }));
  }
  final latest = versions.latest();
  final infosFutures = {
    for (final version in versions)
      version: _getVersionInfo(package, version, request.requestBaseUrl)
  };
  final latestInfo = await infosFutures[latest]!;
  final versionsInfo = await Future.wait(infosFutures.values);

  final responseBody = {
    "name": package,
    "latest": latestInfo,
    "versions": versionsInfo
  };
  return Response.ok(jsonEncode(responseBody),headers: {
    "Content-Type": "application/vnd.pub.v2+json"
  });
}

Future<Map<String,Object?>> _getVersionInfo(String package, Version version, Uri requestBaseUrl) async {
  final sha256 = await packageRepository.sha256(package,version);
  final pubspec = await packageRepository.pubspec(package,version);
  return {
    "version": version.toString(),
    // "retracted": true || false, // optional field, false if omitted
    "archive_url": requestBaseUrl.appendPath("/api/archives/$package-$version.tar.gz").toString(),
    "archive_sha256": sha256,
    "pubspec": pubspec,
  };
}



extension _ on List<Version>{
  Version latest() {
    return reduce((a, b) => a > b ? a : b);
  }
}
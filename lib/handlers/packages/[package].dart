import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

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
  final responseBody = {
    "name": package,
    "latest": {
      "version": "3.1.0",
      // "retracted": true || false, // optional field, false if omitted
      "archive_url": "http://localhost:8080/api/archives/archive2.tar.gz",
      "archive_sha256":
      "95cbaad58e2cf32d1aa852f20af1fcda1820ead92a4b1447ea7ba1ba18195d27",
      "pubspec": getPubspec(package,"3.1.0"),
    },
    "versions": [
      {
        "version": "2.2.0",
        // "retracted": true || false, // optional field, false if omitted
        "archive_url": "http://localhost:8080/api/archives/archive3.tar.gz",
        "archive_sha256":
        "95cbaad58e2cf32d1aa852f20af1fcda1820ead92a4b1447ea7ba1ba18195d27",
        "pubspec": getPubspec(package,"2.2.0"),
      },
      {
        "version": "2.3.0",
        // "retracted": true || false, // optional field, false if omitted
        "archive_url": "http://localhost:8080/api/archives/archive1.tar.gz",
        "archive_sha256":
        "95cbaad58e2cf32d1aa852f20af1fcda1820ead92a4b1447ea7ba1ba18195d27",
        "pubspec": getPubspec(package,"2.3.0"),
      },
    ]
  };
  return Response.ok(jsonEncode(responseBody),headers: {
    "Content-Type": "application/vnd.pub.v2+json"
  });
}


final getPubspec = (String name, String version)=>{
  "name": name,
  "description": "Dart Package",
  "version": version,
  "publish_to": "http://localhost:8080",
  "environment": {
    "sdk": "^3.3.0",
  },
  "dependencies": {
  },
  "dev_dependencies": {
  }
};


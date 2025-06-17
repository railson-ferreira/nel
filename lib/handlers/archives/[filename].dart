
import 'dart:convert';

import 'package:nel/globals.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> archives_(Request request) async {
  final filename = request.params["filename"];
  if (filename == null || filename.isEmpty) {
    return Response.badRequest(body: jsonEncode({
      "error": {
        "code": "BadRequest",
        "message": "archive filename is required",
      },
    }));
  }
  print("getting archive: $filename");
  final parts = filename.split("-");
  final package = parts.first;
  final version = parts.last.split(".tar.gz").first;
  final content = await packageRepository.read(package, Version.parse(version));
  print("responding");
  return Response.ok(
    content,
    headers: {
      "Content-Type": "application/octet-stream",
      "Content-Disposition": "attachment; filename=\"$filename\"",
    },
  );
}
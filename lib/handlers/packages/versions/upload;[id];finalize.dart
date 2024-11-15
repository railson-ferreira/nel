import 'dart:convert';
import 'package:nel/debug_req.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> packagesVersionsUpload_Finalize(Request request) async {
  final id = request.params["id"];
  print("finalizing id: $id");
  await request.debug();
  // TODO: open the archive, analyze pubspec.yaml and move to data folder, update the ./data/packages/package_name/index.json
  return Response.ok(jsonEncode({
    "success": {
      "message": "Upload completed successfully"
    }
  }));
}

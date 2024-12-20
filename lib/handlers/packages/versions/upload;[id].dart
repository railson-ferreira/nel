import 'dart:io';
import 'package:nel/utils/uri_extensions.dart';
import 'package:shelf_multipart/shelf_multipart.dart';
import 'package:nel/debug_req.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> packagesVersionsUpload_(Request request) async {
  final id = request.params["id"];
  await request.debug();
  final formDataRequest = request.formData();
  if (formDataRequest == null) {
    return Response.badRequest(body: "Expected multipart/form-data");
  }

  await for (final formData in formDataRequest.formData) {
    final FormData(:name, :filename) = formData;
    print("name: $name | filename: $filename | body:");
    if (filename != null && filename.isNotEmpty) {
      File("temp/upload/$id/$filename").create(recursive: true).then(
            (file) async => file.writeAsBytes(await formData.part.readBytes()),
          );
      continue;
    }
    print(await formData.part.readString());
  }
  return Response(204,headers: {
    "Location": "${request.requestBaseUrl.appendPath("/api/packages/versions/upload/$id/finalize")}"
  });
}

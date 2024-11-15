import 'dart:convert';

import 'package:nel/utils/uri_extensions.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

Future<Response> packagesVersionsNew(Request request) async {
  return Response.ok(jsonEncode({
    "url": "${request.requestBaseUrl.appendPath("/api/packages/versions/upload/${DateTime.now().toIso8601String()}_${Uuid().v4()}")}",
    "fields": {
      // "<field-1>": "<value-1>",
    },
  }));
}

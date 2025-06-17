import 'package:nel/debug_req.dart';
import 'package:nel/handlers/archives/%5Bfilename%5D.dart';
import 'package:nel/handlers/echo_handler.dart';
import 'package:nel/handlers/packages/[package].dart';
import 'package:nel/handlers/packages/versions/new.dart';
import 'package:nel/handlers/packages/versions/upload;[id].dart';
import 'package:nel/handlers/packages/versions/upload;[id];finalize.dart';
import 'package:nel/handlers/root_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final router = Router(
  notFoundHandler: (request) async {
    print("NOT FOUND");
    request.debug();
    return Response.notFound("");
  },
)
  ..get('/', rootHandler)
  ..get('/echo/<message>', echoHandler)
  ..get("/api/packages/versions/new", packagesVersionsNew)
  ..post("/api/packages/versions/upload/<id>", packagesVersionsUpload_)
  ..get("/api/packages/versions/upload/<id>/finalize", packagesVersionsUpload_Finalize)
  ..get("/api/packages/<package>", packages_)
  ..get("/api/archives/<filename>", archives_);

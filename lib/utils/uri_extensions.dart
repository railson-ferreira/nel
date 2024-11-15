import 'package:shelf/shelf.dart';

extension UriExtensions on Uri{
  Uri appendPath(String path){
    final uri = Uri(scheme: "http",host: "localhost",path:path );
    return Uri(
      scheme: scheme,
      host: host,
      fragment: fragment,
      userInfo: userInfo,
      queryParameters: queryParameters,
      port: port,
      pathSegments: [
        ...pathSegments,
        ...uri.pathSegments
      ]
    );
  }
}

extension RequestExtensions on Request{

  Uri get requestBaseUrl{
    return Uri(
      scheme: requestedUri.scheme,
      host: requestedUri.host,
      port: requestedUri.port,
    );
  }
}
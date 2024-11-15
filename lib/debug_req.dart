import 'package:shelf/shelf.dart';

extension DebugReq  on Request{
  Future<void> debug() async {
    var debugText = this.method;
    debugText+="\n${requestedUri}";
    // try{
    //   final body = await readAsString();
    //   debugText+="\n${body}";
    // }on FormatException catch (_){
    //   print("format exception on body");
    // }
    print("${DateTime.now().toIso8601String()}:\n${debugText}");
  }
}
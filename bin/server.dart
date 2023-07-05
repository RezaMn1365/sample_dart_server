// import 'dart:io';
// import 'package:http/http.dart';
// import 'package:test/expect.dart';

// void main() async {
//   print('request.response');
//   final server = await HttpServer.bind('192.168.1.6', 8080);
//   print('Listening on ${server.address}:${server.port}');

//   await for (HttpRequest request in server) {
//     handleRequest(request);
//   }
// }

// void handleRequest(HttpRequest request) async {
//   if (request.method == 'POST') {
//     final response = request.response;
//     print(request.method);
//     response.statusCode = HttpStatus.ok;
//     response.headers.contentType = ContentType.text;
//     response.write('Hello, Post!');
//     await response.close();
//   }
//   if (request.method == 'GET') {
//     final response = request.response;
//     print(request.method);
//     response.statusCode = HttpStatus.ok;
//     response.headers.contentType = ContentType.text;
//     response.write('Hello, Get!');
//     await response.close();
//   }
// }

import 'dart:io';
import 'package:shelf/shelf_io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() async {
  final server = await HttpServer.bind('192.168.1.6', 8080);
  print('WebSocket server listening on port ${server.port}');

  server.listen((req) async {
    if (req.uri.path == '/ws') {
      handleWebSocket(req);
      await server.close();
    } else {
      req.response.statusCode = HttpStatus.notFound;
      req.response.close();
    }
  });
}

void handleWebSocket(HttpRequest req) async {
  final socket = await WebSocketTransformer.upgrade(req);
  final channel = IOWebSocketChannel(socket);

  channel.stream.listen((message) {
    print('Received message: $message');
    channel.sink.add('Echo: $message');
  });

  channel.sink.add('Connected to server1.1');
}

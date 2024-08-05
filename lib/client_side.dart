import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

String ip = '26.212.49.229'; // '127.0.0.1'

Future<Map<String, dynamic>> toFromServer(var jsonIn) async {
  var responseCompleter = Completer<Map<String, dynamic>>();

  try {
    var socket = await Socket.connect(ip, 12345);

    var jsonStr = jsonEncode(jsonIn) + "\n";
    socket.write(jsonStr);

    var responseBuffer = StringBuffer();

    socket.listen((List<int> received) {
      var response = utf8.decode(received);

      responseBuffer.write(response);

      if (responseBuffer.toString().contains('\n')) { // verifica se a mensagem completa foi recebida
        var completeResponse = responseBuffer.toString().trim();
        var decodedResponse = jsonDecode(completeResponse);
        responseCompleter.complete(decodedResponse);
      }

    }, onDone: () {
      socket.destroy();
    }, onError: (error) {
      print("Erro na comunicação do socket: $error");
      responseCompleter.completeError({"error": "erro na comunicação do socket"});
      socket.destroy();
    });

  } catch (e) {
    print('Erro ao conectar com o servidor: $e');
    responseCompleter.completeError({"error": "erro ao conectar com o servidor"});
  }

  return responseCompleter.future;
}

Future<void> uploadFile(var payload, Function({bool isFile, String fileName}) lateCall) async{
  final result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final filePath = result.files.single.path;

    if (filePath != null) {
      final file = File(filePath);
      final fileName = file.uri.pathSegments.last;
      print(fileName);

      payload["file"] = fileName;

      var socket = await Socket.connect(ip, 12345);

      var jsonStr = jsonEncode(payload) + "\n";
      socket.write(jsonStr); // envia o payload sem awaits

      print("c");
      await Future.delayed(Duration(seconds: 1));
      print("d");
      await file.openRead().pipe(socket);
      print("e");
      await socket.close();
      lateCall(isFile: true, fileName: fileName);
    }
  }
}

Future<void> downloadFile(String userAtual, String fileName) async{
  var socket = await Socket.connect(ip, 12345);

  var payload = {
    "pedido" : "downloadFile",
    "email" : userAtual,
    "file" : fileName
  };

  var jsonStr = jsonEncode(payload) + "\n";
  socket.write(jsonStr);

  await Future.delayed(Duration(seconds: 1));

  Directory selfDir = Directory.current;
  final receivedFile = File('${selfDir.path}/$fileName'); //

  await receivedFile.openWrite().addStream(socket);
  await socket.close();
  print("arquivo recebido");
}
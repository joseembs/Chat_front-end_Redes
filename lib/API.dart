import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> toFromServer(var jsonIn) async {
  var responseCompleter = Completer<Map<String, dynamic>>();

  try {
    var socket = await Socket.connect('127.0.0.1', 12345);

    var jsonString = jsonEncode(jsonIn) + "\n";
    socket.write(jsonString);

    var responseBuffer = StringBuffer();

    socket.listen((List<int> received) {
      var response = utf8.decode(received);

      responseBuffer.write(response);

      if (responseBuffer.toString().contains('\n')) { // verifica se a mensagem completa foi recebida
        var completeResponse = responseBuffer.toString().trim();
        var decodedResponse = jsonDecode(completeResponse);
        responseCompleter.complete(decodedResponse);
        socket.destroy();
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

// var socket = await Socket.connect('127.0.0.1', sockNum);
//
//   var jsonString = jsonEncode(jsonIn);
//   socket.write(jsonString);
//
//   var responseCompleter = Completer<Map<String, dynamic>>();
//   socket.listen((List<int> received) {
//     var response = utf8.decode(received);
//     var decodedResponse = jsonDecode(response);
//     //print(decodedResponse);
//     responseCompleter.complete(decodedResponse);
//   }, onDone: () {
//     socket.destroy();
//   }, onError: (error) {
//     print("Erro: $error");
//     responseCompleter.completeError(error);
//   });
//
//     return responseCompleter.future;
// }


//   socket.listen((List<int> received) {
//     var response = utf8.decode(received);
//     var decodedResponse = jsonDecode(response);
//     print(decodedResponse);
//     print("a");
//     socket.destroy();
//     return decodedResponse;
//   });
//
//   return {"error": "erro"};
// }
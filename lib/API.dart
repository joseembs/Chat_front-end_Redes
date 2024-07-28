import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> toFromServer(var jsonIn, {int sockNum = 12345}) async {
  var socket = await Socket.connect('127.0.0.1', sockNum);

  var jsonString = jsonEncode(jsonIn);
  socket.write(jsonString);

  var responseCompleter = Completer<Map<String, dynamic>>();
  socket.listen((List<int> received) {
    var response = utf8.decode(received);
    var decodedResponse = jsonDecode(response);
    //print(decodedResponse);
    responseCompleter.complete(decodedResponse);
  }, onDone: () {
    socket.destroy();
  }, onError: (error) {
    print("Erro: $error");
    responseCompleter.completeError(error);
  });

    return responseCompleter.future;
}


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
import 'dart:convert';
import 'dart:io';

Future<Map<String, String>> toFromServer(var jsonIn, {int sockNum = 5000}) async {
  var socket = await Socket.connect('localhost', sockNum);

  var jsonString = jsonEncode(jsonIn);
  socket.write(jsonString);

  socket.listen((List<int> received) {
    var response = utf8.decode(received);
    var decodedResponse = jsonDecode(response);
    print(decodedResponse);
    return decodedResponse;
  });

  return {"error": "erro"};
}

//await Future.delayed(Duration(seconds: 2));
// socket.destroy();
/*
void sendTo() async {
  var socket = await Socket.connect('localhost', 4040);
  var jsonData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com'
  };
  var jsonString = jsonEncode(jsonData);
  socket.write(jsonString);
  socket.destroy();
  print('Data sent to server.');
}
 */

/*
import 'package:http/http.dart' as http;

Future GetData (url) async{
  // var uri = Uri.parse(url);
  // uri.queryParameters.forEach((k, v) {
  //   print('key: $k - value: $v');
  // });
  final response = await http.get(Uri.parse(url));

  //1º envia ip servidor, socket base -> recebe um socket específico
  //2º envia ip servidor, socket específico + pedido codificado

  return response.body;
}*/
import 'package:http/http.dart' as http;

Future GetData (url) async{
  // var uri = Uri.parse(url);
  // uri.queryParameters.forEach((k, v) {
  //   print('key: $k - value: $v');
  // });
  final response = await http.get(Uri.parse(url));

  return response.body;
}
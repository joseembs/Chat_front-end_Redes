import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Whatsapp 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String url;
  late var info;

  String nome = "";
  String email = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";
  String userCheck = "Entrar";

  void _setNome(userNome) {
    setState(() {
      nome = userNome;
      print(nome);
    });
  }

  void _setEmail(userEmail) {
    setState(() {
      email = userEmail;
      print(email);
    });
  }

  void _setMsg(userMsg) {
    setState(() {
      msg = userMsg;
      print(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: Icon(Icons.messenger),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            _Login(),
            SizedBox(height: 100),
            _buildChat(),
          ],
        ),
      ),
    );
  }

  Widget _Login() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Informe seu nome:',
        ),
        Container(
          width: 200,
          child: TextField(
            onChanged: (String newNome) async {
              _setNome(newNome);
            },
          ),
        ),
        SizedBox(height: 50),
        Text(
          'Informe seu email:',
        ),
        Container(
          width: 200,
          child: TextField(
            onChanged: (String newEmail) async {
              _setEmail(newEmail);
            },
          ),
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  url =
                      'http://127.0.0.1:5000/api?pedido=cadastro&email='+email;
                  print(url);

                  info = await GetData(url);
                  print(info);

                  // var responseInfo = jsonDecode(info);

                },
                child: Text("Cadastrar usuário")),
            TextButton(
                onPressed: () async {
                  url = 'http://127.0.0.1:5000/api?pedido=login&email='+email;
                  print(url);

                  info = await GetData(url);
                  print(info);

                  var responseInfo = jsonDecode(info);

                  setState(() {
                    if(responseInfo['cadastrado'] == true){
                      userCheck = "Usuário encontrado";
                      print("foi");
                    } else {
                      userCheck = "Usuário não existe";
                      print("não foi");
                    }
                  });
                },
                child: Text(userCheck)),
          ],
        ),
      ],
    );
  }

  Widget _buildChat() {
    return Column(
      children: [
        Text('Envie sua mensagem:'),
        Container(
          width: 400,
          child: TextField(
            onChanged: (String newMsg) async {
              _setMsg(newMsg);
            },
          ),
        ),
        SizedBox(height: 50),
        TextButton(
            onPressed: () async {
              url = 'http://127.0.0.1:5000/api?pedido=sendMsg&email=' + email + '&mensagem=' + msg;
              print(url);

              info = await GetData(url);
              print(info);

              var responseInfo = jsonDecode(info);

              setState(() {
                rcv = responseInfo['mensagem'];
              });

              print('enviou');
            },
            child: Text("Enviar mensagem")),
        SizedBox(height: 50),
        Text(rcv),
      ],
    );
  }

  // Widget _getChats() {
  //   return SizedBox();
  // }

  // _getResponseJson(String urlIn) async {
  //   info = await GetData(url);
  //   print(info);
  //   return jsonDecode(info);
  // }
}
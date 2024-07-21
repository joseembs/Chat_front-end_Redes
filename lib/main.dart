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

  List<Widget> chatList = [];

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 25),
              _Login(),
              Divider(height: 50),
              _buildChat(),
              Divider(height: 50),
              _contactList(),
            ],
          ),
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
        SizedBox(height: 25),
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
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  url = 'http://127.0.0.1:5000/api?pedido=cadastro&email=' +
                      email;
                  print(url);

                  info = await GetData(url);
                  print(info);

                  // var responseInfo = jsonDecode(info);
                },
                child: Text("Cadastrar usuário")),
            TextButton(
                onPressed: () async {
                  url = 'http://127.0.0.1:5000/api?pedido=login&email=' + email;
                  print(url);

                  info = await GetData(url);
                  print(info);

                  var responseInfo = jsonDecode(info);

                  setState(() {
                    if (responseInfo['cadastrado'] == true) {
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
        SizedBox(height: 25),
        TextButton(
            onPressed: () async {
              url = 'http://127.0.0.1:5000/api?pedido=sendMsg&email=' +
                  email +
                  '&mensagem=' +
                  msg;
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
        SizedBox(height: 25),
        Text(rcv),
      ],
    );
  }

  Widget _contactList() {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              url = 'http://127.0.0.1:5000/api?pedido=atualizar';
              print(url);

              info = await GetData(url);
              print(info);

              var decodedInfo = jsonDecode(info);

              chatList = [];

              for (email in decodedInfo['allUsers']) {
                setState(() {
                  chatList.add(Padding(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(170, 55),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.5),
                          side: BorderSide(color:Colors.black54, width: 2),
                        ),

                      ),
                      onPressed: () {
                        return;
                      },
                      child: Text(email),
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ));
                });
              }
            },
            child: Text("Atualizar contatos")),
        SizedBox(height: 25),
        Column(
          children: chatList,
        ),
      ],
    );
  }

  // _getResponseJson(String urlIn) async {
  //   info = await GetData(url);
  //   print(info);
  //   return jsonDecode(info);
  // }
}
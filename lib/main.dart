import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';
import 'dart:convert';

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

  String email = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            email == ""
                ? Text(
              'Informe seu email:',
            )
                : Text('Seu email é:'),
            Container(
              width: 200,
              child: TextField(
                onChanged: (String newEmail) async {
                  _setEmail(newEmail);
                },
              ),
            ),
            SizedBox(height: 100),
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

                  var decodedInfo = jsonDecode(info);

                  setState(() {
                    rcv = decodedInfo['mensagem'];
                  });

                  print('enviou');
                },
                child: Text("Enviar mensagem")),
            SizedBox(height: 50),
            Text(rcv),
          ],
        ),
      ),
    );
  }
}
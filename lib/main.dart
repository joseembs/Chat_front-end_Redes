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

  List<Widget> contactList = [];

  late Map<String, List>
      userHistory; // arquivo [email do usuario] terá vários maps, keys serão outros emails, levam a uma lista com 3 listas: quem enviou (true ou false), mensagem, se foi vista (true ou false)

  void _beginHistory() {
    userHistory["ogmailcom"]
        ?.add([false]); // who = true -> próprio usuário enviou
    userHistory["ogmailcom"]?.add(["oi"]);
    userHistory["ogmailcom"]?.add([false]);
  }

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
              _buildContactList(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          child: TextField(
            onChanged: (String newMsg) async {
              _setMsg(newMsg);
            },
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Digite sua mensagem",
            ),
          ),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.air),
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

            userHistory["ogmailcom"]?[0].add(true);
            userHistory["ogmailcom"]?[1].add(msg);
            userHistory["ogmailcom"]?[2].add(true);

            print('enviou');
          },
        ),
        SizedBox(width: 10),
        Text(rcv),
      ],
    );
  }

  Widget _buildContactList() {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              url = 'http://127.0.0.1:5000/api?pedido=atualizar';
              print(url);

              info = await GetData(url);
              print(info);

              var decodedInfo = jsonDecode(info);

              contactList = [];

              for (email in decodedInfo['allUsers']) {
                setState(() {
                  contactList.add(Padding(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(170, 55),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.5),
                          side: BorderSide(color: Colors.black54, width: 2),
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
          children: contactList,
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

class ToOther {
  late String other;
  List<bool> who = [];
  List<String> hist = [];
  List<bool> seen = [];

  String getJson(ToOther selfIn, String otherIn) {
    selfIn.other = otherIn;
    return jsonEncode(selfIn);
  }

  Map<String, dynamic> toJson() {
    return {
      other: {
        "self": who,
        "hist": hist,
        "seen": seen,
      }
    };
  }

  void sent(String msg){
    who.add(true);
    hist.add(msg);
    seen.add(true);
  }

  void rcvNotRead(String msg){
    who.add(false);
    hist.add(msg);
    seen.add(false);
  }

  void rcvRead(String msg){
    who.add(true);
    hist.add(msg);
    seen.add(true);
  }

  void read(int index){
    who[index] = true;
    seen[index] = true;
  }
}
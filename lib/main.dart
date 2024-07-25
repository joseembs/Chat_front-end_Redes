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
  String nome = "";
  String email = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";
  String userCheck = "Entrar";
  String emailUserAtual = "erro";
  late Chat usuarioAtual;

  List<Widget> contactList = [];
  List<Widget> msgBoxHistory = [];

  late Map<String, List>
      userHistory; // arquivo [email do usuario] terá vários maps, keys serão outros emails, levam a uma lista com 3 listas: quem enviou (true ou false), mensagem, se foi vista (true ou false)

  void _createUserVars() {
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
                  var payload = {"pedido": "cadastro", "email": email};

                  var info = await toFromServer(payload);
                  print(info);

                  if(info['cadastrado'] == true){
                    print("email já cadastrado");
                  } // TODO api tem que criar os arquivos com o email informado
                },
                child: Text("Cadastrar usuário")),
            TextButton(
                onPressed: () async {
                  var payload = {"pedido": "login", "email": email};

                  var info = await toFromServer(payload);
                  print(info);

                  setState(() {
                    if (info['cadastrado'] == true) {
                      userCheck = "Usuário encontrado";
                      emailUserAtual = email;
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
        _cascadingMsgs(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              child: TextField(
                onChanged: (String newMsg) async {
                  _setMsg(newMsg);
                },
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
                var payload = {
                  "pedido": "sendMsg",
                  "email": email, //TODO adicionar email para quem enviou
                  "mensagem": msg
                };

                var info = await toFromServer(payload);
                print(info);

                setState(() {
                  rcv = info['mensagem']!;
                });

                // userHistory["ogmailcom"]?[0].add(true);
                userHistory["ogmailcom"]?[1].add(msg);
                userHistory["ogmailcom"]?[2].add(true);

                print('enviou');
              },
            ),
            SizedBox(width: 10),
            Text(rcv),
          ],
        ),
      ],
    );
  }

  Widget _cascadingMsgs() {
    return Column(children: msgBoxHistory);
  }

  getMsgHist(String emailOutro) async {
    var payload = {
      "pedido": "getHistorico",
      "proprio": emailUserAtual,
      "outro": emailOutro
    };

    Map<String, String> info = await toFromServer(payload);

    setState(() {
      msgBoxHistory = [];
    });

    for (int i = 0; i < int.tryParse(info['quant']!)!; i++) {
      setState(() {
        if (info['who']?[i] == emailUserAtual) { //usuario atual mandou
          msgBoxHistory.add(
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                child: Text(
                    info['hist']![i]
                ),
                decoration: BoxDecoration(color: Colors.blue),
              ),
            ),
          );
        } else { // outro mandou
          msgBoxHistory.add(
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                child: Text(
                    info['who']![i] + ": " + info['hist']![i]
                ),
                decoration: BoxDecoration(color: Colors.green),
              ),
            ),
          );
        }
      });
    }
  }

  Widget _buildContactList() {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              var payload = {"pedido": "atualizar"};

              var info = await toFromServer(payload);

              contactList = [];

              for (String emailInfo in (info['allUsers'] as List<String>)) {
                setState(() {
                  contactList.add(Padding(
                    padding: EdgeInsets.only(bottom: 10),
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
                        getMsgHist(emailInfo);
                      },
                      child: Text(emailInfo),
                    ),
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
}

class Chat {
  late String other;
  int quant = 0;
  List<String> members = [];
  List<String> who = [];
  List<String> hist = [];
  List<bool> seen = [];

  String getJson(Chat selfIn, String otherIn) {
    selfIn.other = otherIn;
    return jsonEncode(selfIn);
  }

  Map<String, dynamic> toJson() {
    return {
      other: {
        "quant": quant,
        "members": members,
        "who": who,
        "hist": hist,
        "seen": seen,
      }
    };
  }

  void sent(String selfName, String msg) {
    who.add(selfName);
    hist.add(msg);
    seen.add(true);
  }

  void rcvNotRead(String other, String msg) {
    who.add(other);
    hist.add(msg);
    seen.add(false);
  }

  void rcvRead(String other, String msg) {
    who.add(other);
    hist.add(msg);
    seen.add(true);
  }

  void read(int index) {
    seen[index] = true;
  }
}
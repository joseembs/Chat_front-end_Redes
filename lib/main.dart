import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp2',
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
  String nomeSignIn = "";
  String emailSignIn = "";
  String localSignIn = "";
  String nomeLogin = "";
  String emailLogin = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";
  String emailUserAtual = "erro";
  String toName = "erro";

  bool isGroup = false;

  List<Widget> contactDmList = [];
  List<Widget> contactGrList = [];
  List<Widget> msgBoxHistory = [];

  late Map<String, List>
      userHistory; // arquivo [email do usuario] terá vários maps, keys serão outros emails, levam a uma lista com 3 listas: quem enviou (true ou false), mensagem, se foi vista (true ou false)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: Icon(Icons.messenger),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 25),
            _mainMenu(),
            Divider(height: 50),
            _contactList(),
            Divider(height: 50),
            _chatBox(),
          ],
        ),
      ),
    );
  }

  Widget _mainMenu() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [_cadastro(), _login()],
    );
  }

  Widget _cadastro() {
    return Container(
      width: 450,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: <Widget>[
          const Text(
            "Cadastro",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF337d07)),
          ),
          const SizedBox(height: 20),
          //Nome
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nome de usuário:',
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 270,
                child: TextField(
                  decoration: InputDecoration(isDense: true),
                  onChanged: (String newNome) async {
                    nomeSignIn = newNome;
                    print(nomeSignIn);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          //Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'E-mail:',
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 200,
                child: TextField(
                  decoration: InputDecoration(isDense: true),
                  onChanged: (String newEmail) async {
                    emailSignIn = newEmail;
                    print(emailSignIn);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          //Local
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Localização:',
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 240,
                child: TextField(
                  decoration: InputDecoration(isDense: true),
                  onChanged: (String newLocal) async {
                    localSignIn = newLocal;
                    print(localSignIn);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          //Botão
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Color(0x6099f57d),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey, width: 2))),
            onPressed: () async {
              var payload = {
                "pedido": "cadastro",
                "email": emailSignIn,
                "nome": nomeSignIn,
                "local": localSignIn
              };

              var info = await toFromServer(payload);
              //var info = {"cadastrado": true}; // teste
              print(info);

              if (info['cadastrado'] as bool == false) {
                print("email cadastrado com sucesso");
              } else {
                print("email inválido ou já cadastrado");
              }
            },
            child: Text(
              "Cadastrar-se",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _login() {
    return Container(
      width: 450,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: <Widget>[
          const Text(
            "Login",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF337d07)),
          ),
          const SizedBox(height: 20),
          //Nome
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nome de usuário:',
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 270,
                child: TextField(
                  decoration: InputDecoration(isDense: true),
                  onChanged: (String newNome) async {
                    nomeLogin = newNome;
                    print(nomeLogin);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          //Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'E-mail:',
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 200,
                child: TextField(
                  decoration: InputDecoration(isDense: true),
                  onChanged: (String newEmail) async {
                    emailLogin = newEmail;
                    // print(emailLogin);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0x6099f57d),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey, width: 2))),
                onPressed: () async {
                  var payload = {"pedido": "login", "email": emailLogin};

                  var info = await toFromServer(payload);
                  Future.delayed(Duration(seconds: 2));
                  print(info);

                  setState(() {
                    if (info['cadastrado'] as bool == true) {
                      emailUserAtual = emailLogin;
                      print("foi");
                    } else {
                      print("não foi");
                    }
                  });
                },
                child: Text("Entrar",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactList() {
    return Column(
      children: [
        _updateButton(),
        SizedBox(height: 25),
        Column(
          children: [
            const Text(
              "Mensagens diretas",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337d07)),
            ),
            Column(children: contactDmList)
          ],
        ),
        Container(
          child: Divider(height: 50),
          width: 500,
        ),
        Column(
          children: [
            const Text(
              "Grupos",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337d07)),
            ),
            Column(children: contactGrList)
          ],
        ),
      ],
    );
  }

  Widget _updateButton() {
    return IconButton(
      icon: const Icon(Icons.update, color: Color(0xFF337d07)),
      style: TextButton.styleFrom(
          //padding: EdgeInsets.all(15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
              side: BorderSide(color: Colors.grey, width: 3))),
      onPressed: () async {
        var payload = {"pedido": "atualizar"};

        var info = await toFromServer(payload);
        print(info);

        // var info = {
        //   "allUsers": ["j@gmail.com"],
        //   "allGroups": []
        // }; // teste 1

        // var info = {
        //   "allUsers": ["j@gmail.com", "o@gmail.com"],
        //   "allGroups": []
        // }; // teste 2

        contactDmList = [];

        if (info["allUsers"]!.length > 1) {
          for (String emailName in (info['allUsers'].cast<String>())) {
            if (emailName != emailUserAtual) {
              setState(() {
                contactDmList.add(_contactButton(emailName, false));
              });
            }
          }
        }
        contactGrList = [];

        if (info["allGroups"]!.isNotEmpty) {
          for (String groupName in (info['allGroups'] as List<String>)) {
            setState(() {
              contactGrList.add(_contactButton(groupName, true));
            });
          }
        }
      },
    );
  }

  Widget _contactButton(String chatName, bool clickGroup) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
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
          setState(() {
            getMsgHist(chatName);
            print("getMsgHist");
            toName = chatName;
            isGroup = clickGroup;
          });
        },
        child: Text(chatName),
      ),
    );
  }

  Widget _chatBox() {
    return Visibility(
      visible: toName == "erro" ? false : true,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        width: 500,
        height: 800,
        child: Column(
          children: [
            Text(toName),
            Container(
              width: 450,
              height: 700,
              child: _cascadingMsgs(),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _cascadingMsgs() {
    return Column(children: msgBoxHistory);
  }

  Widget _chatInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              child: TextField(
                onChanged: (String newMsg) async {
                  msg = newMsg;
                  print(msg);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Digite sua mensagem",
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.air, color: Color(0xFF337d07)),
              style: TextButton.styleFrom(
                  backgroundColor: Color(0x6099f57d),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                      side: BorderSide(color: Colors.grey, width: 3))),
              onPressed: () async {
                var payload = {
                  "pedido": "sendMsg",
                  "nome": toName,
                  "email": emailUserAtual,
                  "mensagem": msg,
                  "grupo" : isGroup
                };

                var info = await toFromServer(payload);

                //var info = {"quant": 1, "members": ["j@gmail.com", "o@gmail.com"], "who": ["j@gmail.com"], "hist": ["oi"]}; // teste
                print(info);

                print('enviou');
              },
            ),
            // SizedBox(width: 10),
            // Text(rcv),
          ],
        ),
      ],
    );
  }

  getMsgHist(String nomeOutro) async {
    print(nomeOutro);
    print(isGroup);
    Map<String, String> payload;
    if (isGroup) {
      payload = {
        "pedido": "getGrupo",
        "nome": nomeOutro,
      };
    } else {
      payload = {
        "pedido": "getDM",
        "email": emailUserAtual,
        "destinatario": nomeOutro
      };
    }
    print(payload);
    var info = await toFromServer(payload);
    print(payload);
    print(info);
    print("getMsgHist info");

    // var info = {
    //   "quant": 0,
    //   "members": ["j@gmail.com", "o@gmail.com"],
    //   "who": [],
    //   "hist": []
    // }; // teste 1

    // var info = {"quant": 1, "members": ["j@gmail.com", "o@gmail.com"], "who": ["j@gmail.com"], "hist": ["oi"]}; // teste 2

    // var info = {"quant": 2, "members": ["j@gmail.com", "o@gmail.com"], "who": ["j@gmail.com", "o@gmail.com"], "hist": ["oi", "eae"]}; // teste 3

    setState(() {
      msgBoxHistory = [];
    });

    for (int i = 0; i < (info['quant'] as int); i++) {
      setState(() {
        //usuario atual mandou
        if ((info['who'].cast<String>())[i] == emailUserAtual) {
          msgBoxHistory.add(
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                width: 400,
                decoration: BoxDecoration(color: Colors.blue),
                child: Text((info['hist'] as List<String>)[i]),
              ),
            ),
          );
        }
        // outro mandou
        else {
          msgBoxHistory.add(
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                width: 400,
                decoration: BoxDecoration(color: Colors.green),
                child: Text(
                    "${(info['who'] as List<String>)[i]}: ${(info['hist'] as List<String>)[i]}"),
              ),
            ),
          );
        }
      });
    }
  }
}

class Chat {
  late String other;
  int quant = 0;
  List<String> members = [];
  List<String> who = [];
  List<String> hist = [];

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
      }
    };
  }

  void sent(String selfName, String msg) {
    who.add(selfName);
    hist.add(msg);
  }

  void rcvNotRead(String other, String msg) {
    who.add(other);
    hist.add(msg);
  }

  void rcvRead(String other, String msg) {
    who.add(other);
    hist.add(msg);
  }
}
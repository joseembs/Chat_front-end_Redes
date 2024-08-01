import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'API.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.emailUserAtual});

  final String emailUserAtual;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return _chatBody();
  }

  late String userAtual = widget.emailUserAtual;

  String groupName = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";
  String toName = "erro";
  String txtGroupBtn = "Novo grupo";

  bool isGroup = false;

  List<Widget> contactDmList = [];
  List<Widget> contactGrList = [];
  List<Widget> contactsToGroup = [];
  List<Widget> msgBoxHistory = [];

  List<bool?> boolsToGroup = [];

  List<String> allUsersList = [];
  List<String> chosenUsers = [];

  Widget _chatBody() {
    return Center(
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _profileInfo(),
              SizedBox(width: 25),
              _contactList(),
              SizedBox(width: 25),
              _chatBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileInfo() {
    return Column(
      children: [
        const Text(
          "Seu perfil",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF337d07)),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: 2.0, color: Colors.grey),
                  bottom: BorderSide(width: 2.0, color: Colors.grey))),
          width: 200,
          height: 200,
          child: SingleChildScrollView(
            child: Column(children: [
              Text("Nome:"),
              Text(userAtual),
              SizedBox(
                height: 10
              ),
              Text("E-mail:"),
              Text(userAtual),
              SizedBox(
                height: 10
              ),
              Text("Localização:"),
              Text(userAtual)
            ]),
          ),
        ),
      ],
    );
  }

  Widget _contactList() {
    return Row(
      children: [
        //Botão de atualizar
        IconButton(
          icon: const Icon(Icons.update, color: Color(0xFF337d07)),
          style: TextButton.styleFrom(
              //padding: EdgeInsets.all(15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                  side: BorderSide(color: Colors.grey, width: 3))),
          onPressed: () async {
            getContactList(); ///////
          },
        ),
        SizedBox(width: 20),
        // Área de DMs
        Column(
          children: [
            const Text(
              "Mensagens diretas",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337d07)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 2.0, color: Colors.grey),
                      bottom: BorderSide(width: 2.0, color: Colors.grey))),
              width: 200,
              height: 400,
              child: SingleChildScrollView(
                child: Column(children: contactDmList),
              ),
            ),
          ],
        ),
        SizedBox(width: 25),
        // Área de Grupos
        Column(
          children: [
            SizedBox(height: 42),
            const Text(
              "Grupos",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337d07)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 2.0, color: Colors.grey),
                      bottom: BorderSide(width: 2.0, color: Colors.grey))),
              width: 200,
              height: 400,
              child: SingleChildScrollView(
                child: Column(children: contactGrList),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text(
                txtGroupBtn,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                  //padding: EdgeInsets.all(15),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                      side: BorderSide(color: Colors.grey, width: 3))),
              onPressed: () {
                showNewGroupMenu();
              },
            ),
          ],
        ),
      ],
    );
  }

  getContactList() async {
    var payload = {"pedido": "atualizar"};

    var info = await toFromServer(payload);
    print(info);

    contactDmList = [];
    contactsToGroup = [];
    boolsToGroup = [];

    int index = 0;

    // Prepara a lista de DMs e de CheckBoxes dos membros inicias de um grupo
    if (info["allUsers"]!.length > 1) {
      allUsersList = info["allUsers"].cast<String>();
      for (String emailName in allUsersList) {
        if (emailName != userAtual) {
          setState(() {
            // Prepara a lista de DMs
            contactDmList.add(_contactButton(emailName, false));
            // Já prepara a lista de CheckBoxes
            boolsToGroup.add(false);
            contactsToGroup.add(_checkBoxAddToGroup(emailName, index));
            index++;
          });
        }
      }
    }
    contactGrList = [];

    // Prepara a lista de grupos
    if (info["allGroups"]!.isNotEmpty) {
      for (groupName in (info['allGroups'].cast<String>())) {
        setState(() {
          contactGrList.add(_contactButton(groupName, true));
        });
      }
    }
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
            isGroup = clickGroup;
            toName = chatName;
            getMsgHist(chatName);
            print("getMsgHist");
          });
        },
        child: Text(chatName),
      ),
    );
  }

  getMsgHist(String nomeOutro) async {
    Map<String, String> payload;
    if (isGroup) {
      payload = {
        "pedido": "getGrupo",
        "nome": nomeOutro,
      };
    } else {
      payload = {"pedido": "getDM", "email": userAtual, "nome": nomeOutro};
    }

    print(payload);
    var info = await toFromServer(payload);
    print(info);

    setState(() {
      msgBoxHistory = [];
    });

    for (int i = 0; i < (info['quant'] as int); i++) {
      setState(() {
        //usuario atual mandou
        if ((info['who'].cast<String>())[i] == userAtual) {
          msgBoxHistory.add(
            Padding(
                //alignment: Alignment.centerRight,
                padding: EdgeInsets.only(top: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 50),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text((info['hist'].cast<String>())[i],
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                )),
          );
        }
        // outro mandou
        else {
          msgBoxHistory.add(
            Padding(
              //alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 5, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.green),
                        child: Text(
                            isGroup
                                ? "${(info['who'].cast<String>())[i]}: ${(info['hist'].cast<String>())[i]}"
                                : (info['hist'].cast<String>())[i],
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14))),
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          );
        }
      });
    }
  }

  Widget _checkBoxAddToGroup(String emailName, int index) {
    return Container(
        child: Column(
      children: [
        Container(
          width: 200,
          padding: EdgeInsets.all(0),
          child: Row(children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Checkbox(
                  value: boolsToGroup[index],
                  activeColor: Colors.green,
                  onChanged: (value) {
                    if (value == true) {
                      chosenUsers.add(emailName);
                    } else {
                      chosenUsers.remove(emailName);
                    }

                    setState(() {
                      boolsToGroup[index] = value!;
                    });
                  },
                );
              },
            ),
            Text(emailName),
          ]),
        ),
      ],
    ));
  }

  showNewGroupMenu() {
    chosenUsers = []; // esvazia a lista de usuários que vão ser adicionados
    for (int i = 0; i < boolsToGroup.length; i++) {
      boolsToGroup[i] = false;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: const Text(
            "Novo grupo",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF337d07)),
          ),
          titlePadding: EdgeInsets.all(10),
          actions: [
            Column(
              children: [
                _setGroupName(),
                SizedBox(height: 15),
                _setGroupInitMembers(),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0x6099f57d),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey, width: 2))),
                  onPressed: () async {
                    var payload = {
                      "pedido": "criaGrupo",
                      "email": userAtual,
                      "nome": groupName,
                      "membros": chosenUsers
                    };

                    print(chosenUsers);
                    print(groupName);

                    var info = await toFromServer(payload);
                    print(info);
                  },
                  child: Text("Criar grupo"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _setGroupName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Nome do grupo:',
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          width: 150,
          child: TextField(
            decoration: InputDecoration(isDense: true),
            onChanged: (String newGrupo) async {
              groupName = newGrupo;
              print(groupName);
            },
          ),
        ),
      ],
    );
  }

  Widget _setGroupInitMembers() {
    return Column(
      children: [
        Text(
          "Convidar usuários",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF337d07)),
        ),
        SizedBox(height: 10),
        // Coluna de CheckBoxes
        Column(children: contactsToGroup),
      ],
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
        width: 400,
        height: 560,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, top: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                toName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF337d07)),
              ),
            ),
            Divider(height: 20, thickness: 2.5),
            Container(
              height: 425,
              child: _cascadingMsgs(),
            ),
            Divider(height: 20, thickness: 2.5),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _cascadingMsgs() {
    return SingleChildScrollView(
      child: Column(children: msgBoxHistory),
    );
  }

  Widget _chatInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 320,
              child: TextField(
                style: TextStyle(fontSize: 14),
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
                  "email": userAtual,
                  "mensagem": msg,
                  "grupo": isGroup
                };

                var info = await toFromServer(payload);

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
}
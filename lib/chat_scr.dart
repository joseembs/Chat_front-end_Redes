import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  String groupNameInit = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";
  String toName = "erro";
  String txtGroupBtn = "Novo grupo";
  String txtInviteStatus = "Pedir para entrar";
  String chatDet1 = "";
  String chatDet2 = "";

  bool isGroup = false;
  bool inGroup = false;
  bool isAdmin = false;

  List<Widget> contactDmList = [];
  List<Widget> contactGrList = [];
  List<Widget> initGroupUserBoxes = [];
  List<Widget> oldGroupUserBoxes = [];
  List<Widget> newGroupUserBoxes = [];
  List<Widget> lateAddGroup = [];
  List<Widget> msgBoxHistory = [];
  List<Widget> notifList = [];

  List<bool?> boolsToGroupInit = [];
  List<bool?> boolsToGroup = [];

  List<String> allUsersList = [];
  List<String> chosenAddUsers = [];
  List<String> chosenDelUsers = [];
  List<String> membersGrupoAtual = [];

  Widget _chatBody() {
    return Center(
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Column(
                children: [
                  _profileInfo(),
                  SizedBox(height: 21),
                  _notifications()
                ],
              ),
              SizedBox(width: 25),
              _contactList(),
              SizedBox(width: 25),
              Visibility(
                  visible: toName == "erro" ? false : true,
                  child: inGroup ? _chatBox() : _askEnterBox()),
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
          height: 170,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(children: [
                Text("Nome:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userAtual), // temp
                SizedBox(height: 10),
                Text("E-mail:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userAtual),
                SizedBox(height: 10),
                Text("Localização:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userAtual) // temp
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _notifications() {
    return Column(
      children: [
        const Text(
          "Notificações",
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
          height: 170,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(children: notifList),
            ),
          ),
        ),
      ],
    );
  }

  getNotifList() {
    for (int temp = 0; temp < 1; temp++) {}
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
    initGroupUserBoxes = [];
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
            initGroupUserBoxes.add(_checkBoxToGroup(emailName, index, "add"));
            index++;
          });
        }
      }
    }
    contactGrList = [];

    String tempGroupName;
    // Prepara a lista de grupos
    if (info["allGroups"]!.isNotEmpty) {
      for (tempGroupName in (info['allGroups'].cast<String>())) {
        setState(() {
          contactGrList.add(_contactButton(tempGroupName, true));
        });
      }
    }
  }

  Widget _contactButton(String chatName, bool clickGroup) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(180, 55),
          maximumSize: const Size(180, 110),
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

    if (isGroup) {
      chatDet1 = "Admin: ";
      chatDet2 = "Membros: ";
      chatDet1 += info['members'].cast<String>()[0];

      for (int i = 1; i < info['members'].length; i++) {
        chatDet2 += info['members'].cast<String>()[i];
        if (i < info['members'].length - 1) {
          chatDet2 += ", ";
        }
      }

      if (!(info['members'].cast<String>()).contains(userAtual)) {
        inGroup = false;

        // if(!(info['invites'].cast<String>()).contains(userAtual)) { // temp
        //   txtInviteStatus = "Pedido enviado";
        // } else {
        //   txtInviteStatus = "Pedir para entrar";
        // }
      } else {
        inGroup = true;

        if (userAtual == info['members'].cast<String>()[0]) {
          membersGrupoAtual = info['members'].cast<String>();
          isAdmin = true;
        } else {
          isAdmin = false;
        }
      }
    } else {
      inGroup = true;
      isAdmin = false;
      chatDet1 = "Local: $nomeOutro"; // temp
      chatDet2 = "E-mail: $nomeOutro"; // temp
    }

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
                        padding: EdgeInsets.all(6),
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
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.green),
                      child: Column(
                        children: [
                          isGroup
                              ? Text("${(info['who'].cast<String>())[i]}:",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600 ))
                              : const SizedBox(),
                          Text(
                            (info['hist'].cast<String>())[i],
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
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

  Widget _checkBoxToGroup(String emailName, int index, String order) {
    return Column(
      children: [
        Row(children: [
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Checkbox(
                value: boolsToGroup[index],
                activeColor: Colors.green,
                onChanged: (value) {
                  if (value == true && order == "add") {
                    chosenAddUsers.add(emailName);
                  } else {
                    chosenAddUsers.remove(emailName);
                  }

                  if (value == true && order == "remove") {
                    chosenDelUsers.add(emailName);
                  } else {
                    chosenDelUsers.remove(emailName);
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
      ],
    );
  }

  showNewGroupMenu() {
    chosenAddUsers = []; // esvazia a lista de usuários que vão ser adicionados
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey, width: 2))),
                      onPressed: () async {
                        Navigator.pop(context, true);
                      },
                      child: Text("Cancelar"),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0x6099f57d),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey, width: 2))),
                      onPressed: () async {
                        if (groupNameInit == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Necessário informar o nome do grupo")));
                        } else {
                          var payload = {
                            "pedido": "criaGrupo",
                            "email": userAtual,
                            "nome": groupNameInit,
                            "membros": chosenAddUsers
                          };

                          print(chosenAddUsers);
                          print(groupNameInit);

                          var info = await toFromServer(payload);
                          print(info);

                          Navigator.pop(context, true);
                        }
                      },
                      child: Text("Criar grupo"),
                    ),
                  ],
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
              groupNameInit = newGrupo;
              print(groupNameInit);
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
          "Adicionar membros",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF337d07)),
        ),
        SizedBox(height: 10),
        // Coluna de CheckBoxes
        Column(children: initGroupUserBoxes),
      ],
    );
  }

  Widget _setGroupOldMembers() {
    return Column(
      children: [
        Text(
          "Remover membros",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF337d07)),
        ),
        SizedBox(height: 10),
        // Coluna de CheckBoxes
        Column(children: oldGroupUserBoxes),
      ],
    );
  }

  Widget _setGroupNewMembers() {
    return Column(
      children: [
        Text(
          "Adicionar membros",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF337d07)),
        ),
        SizedBox(height: 10),
        // Coluna de CheckBoxes
        Column(children: newGroupUserBoxes),
      ],
    );
  }

  Widget _askEnterBox() {
    return Container(
      margin: const EdgeInsets.only(top: 42),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      width: 400,
      constraints: BoxConstraints(minHeight: 150),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 20, top: 10),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toName,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF337d07)),
                  ),
                  Text(
                    chatDet1, // temp
                    style: TextStyle(fontSize: 12, color: Color(0xFF337d07)),
                  ),
                ],
              )),
          Divider(height: 20, thickness: 2.5),
          Text("Você não é um membro deste grupo."),
          SizedBox(height: 10),
          TextButton(
            child: Text(
              txtInviteStatus,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
                backgroundColor: txtInviteStatus == "Pedir para entrar"
                    ? Color(0x6099f57d)
                    : Color(0x1a000000),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                    side: BorderSide(color: Colors.grey, width: 3))),
            onPressed: txtInviteStatus == "Pedir para entrar"
                ? () {
                    sendInvite();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  sendInvite() async {
    var payload = {"pedido": "pedirEntrada", "nome": toName};

    var info = await toFromServer(payload);

    print(info);

    setState(() {
      txtInviteStatus = "Pedido enviado";
    });
  }

  Widget _chatBox() {
    return Container(
      margin: const EdgeInsets.only(top: 42),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      width: 400,
      constraints: BoxConstraints(minHeight: 580),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      toName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF337d07)),
                    ),
                    isAdmin
                        ? Visibility(
                            visible: isGroup,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Color(0x6099f57d),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                          color: Colors.grey, width: 2))),
                              onPressed: () {
                                showAdminPopup();
                              },
                              child: Text("Gerenciar grupo",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )
                        : Visibility(
                            visible: isGroup && !isAdmin,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                          color: Colors.grey, width: 2))),
                              onPressed: () {
                                //showAdminPopup();
                              },
                              child: Text("Sair do grupo",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "${chatDet1} \n${chatDet2}", // temp
                  style: TextStyle(fontSize: 12, color: Color(0xFF337d07)),
                ),
              ],
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
    );
  }

  showAdminPopup() async {
    var payload = {"pedido": "atualizar"};

    var info = await toFromServer(payload);
    print(info);

    newGroupUserBoxes = [];
    oldGroupUserBoxes = [];
    boolsToGroup = [];

    int index = 0;

    if (info["allUsers"]!.length > 1) {
      allUsersList = info["allUsers"].cast<String>();
      for (String emailName in allUsersList) {
        if (emailName != userAtual && !membersGrupoAtual.contains(emailName)) {
          setState(() {
            // Lista de CheckBoxes
            boolsToGroup.add(false);
            newGroupUserBoxes.add(_checkBoxToGroup(emailName, index, "add"));
            index++;
          });
        } else if (emailName != userAtual) {
          setState(() {
            // Lista de CheckBoxes
            boolsToGroup.add(false);
            oldGroupUserBoxes.add(_checkBoxToGroup(emailName, index, "remove"));
            index++;
          });
        }
      }
    }

    chosenAddUsers = [];
    chosenDelUsers = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: const Text(
            "Gerenciar grupo",
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
                _setGroupOldMembers(),
                SizedBox(height: 10),
                _setGroupNewMembers(),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0x6099f57d),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey, width: 2))),
                  onPressed: () async {
                    var payload = {
                      "pedido": "addGrupo",
                      "nome": toName,
                      "membros": chosenAddUsers
                    };

                    print(chosenAddUsers);

                    var info = await toFromServer(payload);
                    print(info);

                    payload = {
                      "pedido": "sairGrupo",
                      "nome": toName,
                      "membros": chosenDelUsers
                    };

                    print(chosenDelUsers);
                    print(toName);

                    info = await toFromServer(payload);
                    print(info);

                    Navigator.pop(context, true);
                  },
                  child: Text("Confirmar"),
                ),
              ],
            ),
          ],
        );
      },
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
              padding: EdgeInsets.only(bottom: 10),
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

                var info;

                info = await toFromServer(payload);

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
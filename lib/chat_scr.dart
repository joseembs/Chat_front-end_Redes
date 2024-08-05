import 'package:flutter/material.dart';

import 'client_side.dart';
import 'main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.nomeUserAtual,
      required this.emailUserAtual,
      required this.localUserAtual});

  final String nomeUserAtual;
  final String emailUserAtual;
  final String localUserAtual;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return _chatBody();
  }

  autoRefresh() async {
    print("autoRefresh: ${refreshCount}");
    refreshCount++;
    getContactList();
    getNotifs();
    if (toName != "erro") {
      callContactBtn(isGroup, toName, toEmail);
    }
    await Future.delayed(Duration(seconds: 1));
    if (emailAtual != "" && isAuto) {
      autoRefresh();
    }
  }

  int refreshCount = 1;

  late String nomeAtual = widget.nomeUserAtual;
  late String emailAtual = widget.emailUserAtual;
  late String localAtual = widget.localUserAtual;

  String groupNameInit = "";
  String msg = "";
  String rcv = "Aguardando mensagem...";
  String toName = "erro";
  String toEmail = "erro";
  String txtInviteStatus = "Pedir para entrar";
  String chatDet1 = "";
  String chatDet2 = "";

  bool isGroup = false;
  bool inGroup = false;
  bool isAdmin = false;
  bool isAuto = false;

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

  Map<String, String> allUsersMap = {};
  List<String> chosenAddUsers = [];
  List<String> chosenDelUsers = [];
  List<String> membersGrupoAtual = [];

  var msgController = TextEditingController();

  lastPage(BuildContext contextIn) {
    Navigator.push(
      contextIn,
      MaterialPageRoute(builder: (context) => const ChatAppStart()),
    );
  }

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
                  _notifications(),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text(
                      "Sair",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                        //padding: EdgeInsets.all(15),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                            side: BorderSide(color: Colors.grey, width: 3))),
                    onPressed: () {
                      nomeAtual = "";
                      emailAtual = "";
                      localAtual = "";
                      lastPage(context);
                    },
                  ),
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
                Text(nomeAtual),
                SizedBox(height: 10),
                Text("E-mail:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(emailAtual),
                SizedBox(height: 10),
                Text("Localização:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(localAtual)
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

  getNotifs() async {
    var payload = {"pedido": "getPerfil", "email": emailAtual};

    var info = await toFromServer(payload);
    // print(info);

    notifList = [];
    var tempInvite;
    for (tempInvite in info["notifs"]) {
      List<String> invite = tempInvite.cast<String>();
      notifList.add(Container(
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(children: [Flexible(
              child: Container(
                width: 200,
                child: Text('"${invite[1]}" quer entrar em "${invite[2]}"',
                    textAlign: TextAlign.center),
              ),
            ),],

            ),

            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Color(0xFF337d07)),
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0x6099f57d),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 3))),
                  onPressed: () async {
                    var payload = {
                      "pedido": "respostaConvite",
                      "admin": emailAtual,
                      "nome": invite[2],
                      "email": invite[0],
                      "resposta": true
                    };

                    var info = await toFromServer(payload);
                  },
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 3))),
                  onPressed: () async {
                    var payload = {
                      "pedido": "respostaConvite",
                      "admin": emailAtual,
                      "nome": invite[2],
                      "email": invite[0],
                      "resposta": false
                    };

                    var info = await toFromServer(payload);
                  },
                ),
              ],
            )
          ]),
        ),
      ));
    }
  }

  Widget _contactList() {
    return Row(
      children: [
        // Área de DMs
        Column(
          children: [
            SizedBox(height: 40),
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
            SizedBox(height: 10),
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
                autoRefresh();
                //getContactList();
              },
            ),
            Row(
              children: [
                Checkbox(
                  value: isAuto,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isAuto = value!;
                    });
                    if (isAuto) {
                      autoRefresh();
                    }
                  },
                ),
                Text("Automático"),
              ],
            ),
          ],
        ),
        SizedBox(width: 25),
        // Área de Grupos
        Column(
          children: [
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
                "Novo grupo",
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
    // print(info);

    contactDmList = [];
    initGroupUserBoxes = [];
    boolsToGroup = [];

    int index = 0;

    // Prepara a lista de DMs e de CheckBoxes dos membros inicias de um grupo
    if (info["allUsers"]!.length > 1) {
      allUsersMap = info["allUsers"].cast<String, String>();
      for (String emailTemp in allUsersMap.keys) {
        if (emailTemp != emailAtual) {
          setState(() {
            // Prepara a lista de DMs
            contactDmList
                .add(_contactButton(allUsersMap[emailTemp]!, emailTemp, false));
            // Já prepara a lista de CheckBoxes
            boolsToGroup.add(false);
            initGroupUserBoxes.add(_checkBoxToGroup(emailTemp, index, "add"));
            index++;
          });
        }
      }
    }
    contactGrList = [];

    String tempGroupName;
    // Prepara a lista de grupos
    if (info["allGroups"]!.isNotEmpty) {
      for (tempGroupName in (info["allGroups"].cast<String>())) {
        setState(() {
          contactGrList.add(_contactButton(tempGroupName, tempGroupName,
              true)); // nome do grupo é considerado email por praticidade
        });
      }
    }
  }

  Widget _contactButton(String chatName, String chatEmail, bool clickGroup) {
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
          msgController.clear();
          callContactBtn(clickGroup, chatName, chatEmail);
        },
        child: Text(chatName),
      ),
    );
  }

  callContactBtn(bool clickGroup, String chatName, String chatEmail) {
    setState(() {
      isGroup = clickGroup;
      toName = chatName;
      toEmail = chatEmail;
      getMsgHist(chatEmail);
      // print("getMsgHist");
    });
  }

  getMsgHist(String emailOutro) async {
    Map<String, String> payload;
    if (isGroup) {
      payload = {
        "pedido": "getGrupo",
        "nome": emailOutro,
      };
    } else {
      payload = {"pedido": "getDM", "email": emailAtual, "nome": emailOutro};
    }

    // print(payload);
    var info = await toFromServer(payload);
    // print(info);

    if (info['members'].length > 0) {
      if (isGroup) {
        chatDet1 = "Admin: ";
        chatDet2 = "Membros: ";
        chatDet1 += info['members'][0].cast<String>()[1];

        for (int i = 1; i < info['members'].length; i++) {
          chatDet2 += info['members'][i][1];
          if (i < info['members'].length - 1) {
            chatDet2 += ", ";
          }
        }

        bool inGroupCheck = false;
        var member;
        for (member in info['members']) {
          if (emailAtual == member[0]) {
            inGroupCheck = true;
          }
        }

        if (!inGroupCheck) {
          inGroup = false;

          if ((info['convites'].cast<String>()).contains(emailAtual)) {
            // temp
            txtInviteStatus = "Pedido enviado";
          } else {
            txtInviteStatus = "Pedir para entrar";
          }
        } else {
          inGroup = true;

          if (emailAtual == info['members'][0][0]) {
            membersGrupoAtual = [];
            for (int i = 1; i < info['members'].length; i++) {
              membersGrupoAtual.add(info['members'][i][0]);
            }
            isAdmin = true;
          } else {
            isAdmin = false;
          }
        }
      } else {
        inGroup = true;
        isAdmin = false;
        chatDet1 = "Local: ${info['dados']['local']}"; // temp
        chatDet2 = "E-mail: $emailOutro"; // temp
      }

      setState(() {
        msgBoxHistory = [];
      });
      for (int i = 0; i < (info['quant'] as int); i++) {
        setState(() {
          var whoList = info['who'][i];
          //usuario atual mandou
          if ((whoList.cast<String>())[0] == emailAtual) {
            String tempMsg = (info['hist'].cast<String>())[i];
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
                          decoration: BoxDecoration(color: Colors.blue.shade300,
                                borderRadius: const BorderRadius.all(Radius.circular(7))),
                          child: !tempMsg.contains("Qm90w6NvQXJxdWl2bw==")
                              ? Text(tempMsg,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 14))
                              : _fileMsg(tempMsg),
                        ),
                      ),
                    ],
                  )),
            );
          }
          // outro mandou
          else {
            String tempMsg = (info['hist'].cast<String>())[i];
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
                        decoration: BoxDecoration(color: Colors.green.shade300,
                            borderRadius: const BorderRadius.all(Radius.circular(7)),),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isGroup
                                ? Text("${(whoList.cast<String>())[1]}:",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))
                                : const SizedBox(),
                            !tempMsg.contains("Qm90w6NvQXJxdWl2bw==")
                                ? Text(
                                    (info['hist'].cast<String>())[i],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 14),
                                  )
                                : _fileMsg(tempMsg),
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
    } else {
      txtInviteStatus = "Grupo sem membros";
      inGroup = false;
      isAdmin = false;
      chatDet1 = "";
      chatDet2 = "";
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
                            "email": emailAtual,
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
              // print(groupNameInit);
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
    var payload = {
      "pedido": "enviaConvite",
      "nome": toEmail,
      "email": emailAtual
    };

    var info = await toFromServer(payload);

    print(info);

    setState(() {
      txtInviteStatus = "Pedido enviado";
    });
  }

  Widget _chatBox() {
    return Container(
      // margin: const EdgeInsets.only(top: 42),
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
                    Flexible(child: Text(
                      toName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF337d07)),
                    )) ,
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
                              onPressed: () async {
                                var payload = {
                                  "pedido": "sairGrupo",
                                  "nome": toName,
                                  "membros": [emailAtual]
                                };

                                var info = await toFromServer(payload);
                                print(info);
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
      allUsersMap = info["allUsers"].cast<String, String>();
      for (String emailTemp in allUsersMap.keys) {
        if (emailTemp != emailAtual && !membersGrupoAtual.contains(emailTemp)) {
          //
          setState(() {
            // Lista de CheckBoxes
            boolsToGroup.add(false);
            newGroupUserBoxes.add(_checkBoxToGroup(emailTemp, index, "add"));
            index++;
          });
        } else if (emailTemp != emailAtual) {
          setState(() {
            // Lista de CheckBoxes
            boolsToGroup.add(false);
            oldGroupUserBoxes.add(_checkBoxToGroup(emailTemp, index, "remove"));
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
                TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey, width: 2))),
                  onPressed: () async {
                    var payload = {
                      "pedido": "sairGrupo",
                      "nome": toName,
                      "membros": [emailAtual]
                    };

                    var info = await toFromServer(payload);
                    print(info);
                    Navigator.pop(context, true);
                  },
                  child: Text("Sair do grupo",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
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
                      "nome": toEmail,
                      "membros": chosenAddUsers
                    };

                    print(chosenAddUsers);

                    var info = await toFromServer(payload);
                    print(info);

                    payload = {
                      "pedido": "sairGrupo",
                      "nome": toEmail,
                      "membros": chosenDelUsers
                    };

                    print(chosenDelUsers);
                    print(toEmail);

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
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 270,
                child: TextField(
                  controller: msgController,
                  style: TextStyle(fontSize: 14),
                  onChanged: (String newMsg) async {
                    msg = newMsg;
                    // print(msg);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Digite sua mensagem",
                  ),
                ),
              ),
              SizedBox(width: 10),
              _fileBtn(),
              SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Color(0xFF337d07)),
                style: TextButton.styleFrom(
                    backgroundColor: Color(0x6099f57d),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                        side: BorderSide(color: Colors.grey, width: 3))),
                onPressed: () async {
                  msgController.clear();
                  callSendMsg();
                },
              ),
              // SizedBox(width: 10),
              // Text(rcv),
            ],
          ),
        ),
      ],
    );
  }

  void callSendMsg({isFile = false, String fileName = "erro"}) async {
    var payload;
    if (isFile) {
      payload = {
        "pedido": "sendMsg",
        "nome": toEmail,
        "email": emailAtual,
        "mensagem": fileName + "Qm90w6NvQXJxdWl2bw==",
        "grupo": isGroup
      };
    } else {
      payload = {
        "pedido": "sendMsg",
        "nome": toEmail,
        "email": emailAtual,
        "mensagem": msg,
        "grupo": isGroup
      };
    }

    var info = await toFromServer(payload);

    print(info);

    print('enviou');
  }

  Widget _fileMsg(String fileName) {
    fileName = fileName.replaceAll("Qm90w6NvQXJxdWl2bw==", "");
    return TextButton.icon(
      icon: Icon(Icons.download),
      label: Text(
        fileName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 10),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black54, width: 3))),
      onPressed: () {
        downloadFile(emailAtual, fileName);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Arquivo salvo na pasta do executável")));
      },
    );
  }

  Widget _fileBtn() {
    return IconButton(
      icon: const Icon(Icons.file_open, color: Color(0xFF337d07)),
      style: TextButton.styleFrom(
          backgroundColor: Color(0x6099f57d),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
              side: BorderSide(color: Colors.grey, width: 3))),
      onPressed: () async {
        var payload = {
          "pedido": "uploadFile",
          "nome": toEmail,
          "email": emailAtual,
          "mensagem": msg,
          "grupo": isGroup
        };

        uploadFile(payload, callSendMsg);
      },
    );
  }
}
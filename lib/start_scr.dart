import 'main2.dart';
import 'package:flutter/material.dart';

import 'API.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _mainMenu(context);
  }
}

Widget _mainMenu(BuildContext contextIn) {
  return Center(
    child: SingleChildScrollView(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [_cadastro(contextIn), _login(contextIn)],
      ),
    ),
  );
}

nextPage(BuildContext contextIn, String emailLogin) {
  Navigator.push(
    contextIn,
    MaterialPageRoute(
        builder: (context) => ChatAppMain(userLogin: emailLogin)),
  );
}

Widget _cadastro(BuildContext contextIn) {
  String nomeSignIn = "";
  String emailSignIn = "";
  String localSignIn = "";

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
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Color(0x6099f57d),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey, width: 2))),
          onPressed: () async {
            if (emailSignIn == "" || nomeSignIn == "" || localSignIn == "") {
              ScaffoldMessenger.of(contextIn).showSnackBar(SnackBar(
                  content: Text("Preencha todos os campos para se cadastrar")));
            } else {
              var payload = {
                "pedido": "cadastro",
                "email": emailSignIn,
                "nome": nomeSignIn,
                "local": localSignIn
              };

              var info = await toFromServer(payload);
              //var info = {"cadastrado": true}; // teste
              print(info);

              if (info['cadastrado'] as bool == true) {
                print("email cadastrado com sucesso");
                nextPage(contextIn, emailSignIn);
              } else {
                print("email inválido ou já cadastrado");
                ScaffoldMessenger.of(contextIn).showSnackBar(SnackBar(
                    content: Text("E-mail inválido ou já cadastrado")));
              }
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

Widget _login(BuildContext contextIn) {
  String nomeLogin = "";
  String emailLogin = "";

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
                if(emailLogin == ""){
                  ScaffoldMessenger.of(contextIn).showSnackBar(SnackBar(
                      content: Text("Informe um e-mail para realizar login")));
                }
                var payload = {"pedido": "login", "email": emailLogin};

                var info = await toFromServer(payload);
                Future.delayed(Duration(seconds: 2));
                print(info);

                if (info['cadastrado'] as bool == true) {
                  print("foi");
                  nextPage(contextIn, emailLogin);
                } else {
                  print("não foi");
                  ScaffoldMessenger.of(contextIn).showSnackBar(SnackBar(
                      content: Text("E-mail não encontrado")));
                }
              },
              child:
                  Text("Entrar", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    ),
  );
}
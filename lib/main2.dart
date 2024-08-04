import 'package:flutter/material.dart';

import 'chat_scr.dart';

class ChatAppMain extends StatefulWidget {
  const ChatAppMain({super.key, required this.userNome, required this.userEmail, required this.userLocal});

  final String userNome;
  final String userEmail;
  final String userLocal;

  @override
  State<ChatAppMain> createState() => _ChatAppMainState();
}

class _ChatAppMainState extends State<ChatAppMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat em grupo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomePage2(title: 'Chat em grupo', nomeUserAtual: widget.userNome, emailUserAtual: widget.userEmail, localUserAtual: widget.userLocal),

    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key, required this.title, required this.nomeUserAtual, required this.emailUserAtual, required this.localUserAtual});

  final String title;
  final String nomeUserAtual;
  final String emailUserAtual;
  final String localUserAtual;

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
        leading: Icon(Icons.textsms_outlined),
        actions: [
          Padding(padding: EdgeInsets.only(left:20, right: 20), child: Text("Feito por: Elis R. B. - Henrique C. R. S. - José Edson M. B. S."),),
        ],
      ),
      body: ChatScreen(nomeUserAtual: widget.nomeUserAtual, emailUserAtual: widget.emailUserAtual, localUserAtual: widget.localUserAtual),
    );
  }
}
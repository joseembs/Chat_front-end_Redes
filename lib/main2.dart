import 'package:flutter/material.dart';

import 'chat_scr.dart';

class ChatAppMain extends StatefulWidget {
  const ChatAppMain({super.key, required this.userLogin});

  final String userLogin;

  @override
  State<ChatAppMain> createState() => _ChatAppMainState();
}

class _ChatAppMainState extends State<ChatAppMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomePage2(title: 'Whatsapp 2', emailUserAtual: widget.userLogin),
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key, required this.title, required this.emailUserAtual});

  final String title;
  final String emailUserAtual;

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
        leading: Icon(Icons.messenger),
      ),
      body: ChatScreen(emailUserAtual: widget.emailUserAtual),
    );
  }
}
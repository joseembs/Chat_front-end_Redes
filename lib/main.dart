import 'package:flutter/material.dart';

import 'start_scr.dart';

void main() {
  runApp(const ChatAppStart());
}

class ChatAppStart extends StatefulWidget {
  const ChatAppStart({super.key});

  @override
  State<ChatAppStart> createState() => _ChatAppStartState();
}

class _ChatAppStartState extends State<ChatAppStart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage1(title: 'Whatsapp 2'),
    );
  }
}

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key, required this.title});

  final String title;

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: Icon(Icons.messenger),
      ),
      body: const StartScreen(),
    );
  }
}
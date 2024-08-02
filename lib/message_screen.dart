
import 'package:flutter/material.dart';

class messageScreen extends StatefulWidget {
  String id;
  messageScreen({super.key, required this.id});

  @override
  State<messageScreen> createState() => _messageScreenState();
}

class _messageScreenState extends State<messageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Screen"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(widget.id),
      ),
    );
  }
}

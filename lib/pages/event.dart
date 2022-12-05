import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  var event;
  Event({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event["eventName"])),
      body: ListView(
        children: [
          Image.network(event["imageUrl"]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(event["eventDescription"]),
          ),
        ],
      ),
    );
  }
}

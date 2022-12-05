import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event["eventName"]),
      trailing: const Icon(Icons.chevron_right_sharp),
    );
  }
}

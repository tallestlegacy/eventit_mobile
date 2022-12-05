import 'package:eventit_mobile/utils/network.dart';
import 'package:eventit_mobile/widgets/event_card.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _events = {};

  Future<void> updateEvents() async {
    var events = await fetchEvents();

    if (mounted) {
      _events = events;
    }
  }

  @override
  void initState() {
    super.initState();
    updateEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: RefreshIndicator(
          onRefresh: updateEvents,
          child: ListView(
            children: [
              for (var event in _events.values) EventCard(event: event)
            ],
          )),
    );
  }
}

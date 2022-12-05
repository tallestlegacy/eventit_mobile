import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/retry.dart';

String eventsUrl =
    "https://event-it-6c16f-default-rtdb.firebaseio.com/events.json";

Future fetchEvents() async {
  final client = RetryClient(Client());
  try {
    Uri uri = Uri.parse(eventsUrl);
    String res = await client.read(uri);

    return jsonDecode(res);
  } finally {
    client.close();
  }
}

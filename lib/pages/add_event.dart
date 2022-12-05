import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  PlatformFile? imageFile;
  UploadTask? imageUploadTask;

  // State Variables
  String _firebaseImageUrl = "";
  String _eventName = "";
  String _eventDescription = "";
  String _lon = "";
  String _lat = "";

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null) return;

    setState(() {
      imageFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final date = new DateTime.now();
    final path = "files/$date-${imageFile!.name}.jpg";
    final file = File(imageFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    imageUploadTask = ref.putFile(file);

    final snapshot = await imageUploadTask!.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      _firebaseImageUrl = imageUrl;
    });
  }

  Future saveData() async {
    await uploadFile();

    final database = FirebaseDatabase.instance.ref();
    final eventsRef = database.child("/events");

    var newRef = eventsRef.push();
    var eventItem = {
      "id": newRef.key,
      "imageUrl": _firebaseImageUrl,
      "eventName": _eventName,
      "eventDescription": _eventDescription,
    };

    newRef.set(eventItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AddEvent"),
      ),
      body: ListView(
        children: [
          if (imageFile != null) Image.file(File(imageFile!.path!)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: selectFile,
                  child: imageFile == null
                      ? const Text("Pick Image")
                      : const Text("Change Image"),
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Event Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _eventName = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                      _eventDescription = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageFile = null;
                          _eventDescription = "";
                          _eventName = "";
                        });
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      child: const Text("CLEAR"),
                    ),
                    ElevatedButton(
                      onPressed: saveData,
                      child: const Text("SAVE"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

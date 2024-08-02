// ignore_for_file: use_build_context_synchronously, avoid_print, camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

User? signedinuser;

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController messagetextcontroller = TextEditingController();
  String? messagetext;
  File? file;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photocamera = await picker.pickImage(source: ImageSource.camera);
    if (photocamera != null) {
      setState(() {
        file = File(photocamera.path);
      });
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          signedinuser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      final fileName = path.basename(file.path);
      final storageReference = FirebaseStorage.instance.ref().child('chat_images/$fileName');
      final uploadTask = storageReference.putFile(file);
      await uploadTask;
      return await storageReference.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  void sendMessage() async {
    String? imageUrl;
    if (file != null) {
      imageUrl = await uploadFile(file!);
    }

    if (messagetext != null || imageUrl != null) {
      messagetextcontroller.clear();
      await _firestore.collection('messages').add({
        'text': messagetext,
        'sender': signedinuser?.email,
        'time': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      });
      setState(() {
        file = null; // Reset the file after sending the message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('Images/logo.png', height: 25),
            const SizedBox(width: 10),
            const Text('7OS'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessageStreamBuilder(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: getimage,
                    icon: const Icon(Icons.camera_alt),
                  ),
                  TextButton(
                    onPressed: sendMessage,
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<Widget> messageWidgets = [];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data!.docs;
        for (var message in messages) {
          final data = message.data() as Map<String, dynamic>;
          final messagetext = data['text'];
          final messagesender = data['sender'];
          final messageImageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : null;
          final currentUser = signedinuser?.email;
          final messageId = message.id;

          final messageWidget = messageLine(
            sender: messagesender,
            text: messagetext,
            imageUrl: messageImageUrl,
            isme: currentUser == messagesender,
            messageId: messageId,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class messageLine extends StatelessWidget {
  const messageLine({this.text, this.sender, this.imageUrl, required this.isme, required this.messageId, super.key});
  final String? text;
  final String? sender;
  final String? imageUrl;
  final bool isme;
  final String messageId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onLongPress: () {
          isme
              ? showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('Are you sure to delete this message'),
                    actions: [
                      MaterialButton(
                        onPressed: () async {
                          await _firestore.collection('messages').doc(messageId).delete();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('You cannot delete others\' messages'),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
        },
        child: Column(
          crossAxisAlignment: isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text('$sender'),
            Material(
              elevation: 5,
              borderRadius: isme
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              color: isme ? Colors.blue[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.network(imageUrl!),
                      ),
                    if (text != null)
                      Text(
                        text!,
                        style: TextStyle(color: isme ? Colors.white : Colors.black),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

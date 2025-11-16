import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMassage extends StatefulWidget {
  const NewMassage({super.key});

  @override
  State<NewMassage> createState() => _NewMassageState();
}

class _NewMassageState extends State<NewMassage> {
  final massageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    massageController.dispose();
  }

  sentNewMassage() async {
    final text = massageController.text;
    if (text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    massageController.clear();
    final User user = FirebaseAuth.instance.currentUser!;

    final userDate = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    await FirebaseFirestore.instance.collection('chats').add({
      'user': user.uid,
      'text': text,
      'username': userDate.data()!['username'],
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'send Massage ...'),
              controller: massageController,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(onPressed: sentNewMassage, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMassage extends StatefulWidget {
  const ChatMassage({super.key});

  @override
  State<ChatMassage> createState() => _ChatMassageState();
}

class _ChatMassageState extends State<ChatMassage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('SomeThing was Wrong please try agine later'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final massage = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: massage.length,
          itemBuilder: (ctx, index) => Card.outlined(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10, left: 15),
              child: Text(massage[index].data()['text']),
            ),
          ),
        );
      },
    );
  }
}

import 'package:chat_app/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMassage extends StatefulWidget {
  const ChatMassage({super.key});

  @override
  State<ChatMassage> createState() => _ChatMassageState();
}

class _ChatMassageState extends State<ChatMassage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Loading your chats...'),
              ],
            ),
          );
        }

        final massage = snapshot.data!.docs;
        return ListView.builder(
          itemCount: massage.length,
          reverse: true,
          padding: const EdgeInsetsGeometry.only(top: 8, bottom: 8, left: 13),
          itemBuilder: (ctx, index) {
            final chatMassage = massage[index].data();
            final nextMassage = index + 1 < massage.length
                ? massage[index + 1].data()
                : null;
            final currentMassageUserId = chatMassage['user'];
            final nextMassageUserId = nextMassage != null
                ? chatMassage['user']
                : null;

            final bool nextMassageIsSame =
                nextMassageUserId == currentMassageUserId;

            if (nextMassageIsSame) {
              return MessageBubble.next(
                message: chatMassage['text'],
                isMe: currentUser == currentMassageUserId,
              );
            } else {
              return MessageBubble.first(
                username: chatMassage['username'],
                message: chatMassage['text'],
                isMe: currentUser == currentMassageUserId,
              );
            }
          },
        );
      },
    );
  }
}

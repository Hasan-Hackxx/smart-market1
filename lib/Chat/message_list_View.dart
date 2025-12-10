import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:smartmarket1/Chat/chatBubble.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageListView extends StatelessWidget {
  final QuerySnapshot messages;
  const MessageListView({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.docs.length,
      itemBuilder: (context, index) {
        final message = messages.docs[index];
        final bool iscurrentuser =
            message['custId'] == Supabase.instance.client.auth.currentUser!.id;

        final messageId = message.id;

        var alignment = iscurrentuser
            ? Alignment.centerRight
            : Alignment.centerLeft;

        return Container(
          alignment: alignment,
          child: Column(
            crossAxisAlignment: iscurrentuser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Chatbubble(
                message: message['message'],
                iscurrentuser: iscurrentuser,
                userId: message['custId'],
                otheruserId: message['sallerId'],
                messageId: messageId,
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smartmarket1/Chat/message_list_View.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/mytextfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chatpage extends StatefulWidget {
  final String email;
  final String otheruserId;
  final String otheruserEmail;
  const Chatpage({
    super.key,
    required this.email,
    required this.otheruserId,
    required this.otheruserEmail,
  });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late final TextEditingController message;

  final userId = Supabase.instance.client.auth.currentUser!.id;
  final email = Supabase.instance.client.auth.currentUser!.email;

  @override
  void initState() {
    message = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  void sendmessage() async {
    if (message.text.isNotEmpty) {
      await CloudService().sendMessage(widget.otheruserId, message.text);
      await CloudService().storePeoplewhotextme(
        userId,
        email!,
        widget.otheruserEmail,
        widget.otheruserId,
      );
    }
    message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.email),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: CloudService().getMessage(userId, widget.otheruserId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final messages = snapshot.data!;

                      return MessageListView(messages: messages);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }

                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          _buildmessageinput(),
        ],
      ),
    );
  }

  Widget _buildmessageinput() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Mytextfield(
              controller: message,
              hintText: 'Type a message',
              obscureText: false,
            ),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: IconButton(onPressed: sendmessage, icon: Icon(Icons.send)),
          ),
        ],
      ),
    );
  }
}

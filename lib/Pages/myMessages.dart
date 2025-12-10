import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartmarket1/Chat/chatPage.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/email_message_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Mymessages extends StatefulWidget {
  const Mymessages({super.key});

  @override
  State<Mymessages> createState() => _MymessagesState();
}

class _MymessagesState extends State<Mymessages> {
  final userId = Supabase.instance.client.auth.currentUser!.id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: CloudService().getinfochats(userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final email = snapshot.data!;

                      return EmailMessageListView(
                        email: email,
                        onTap: (email) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chatpage(
                                email: email['otheruserEmail'],
                                otheruserId: email['otheruserId'],
                                otheruserEmail: email['otheruserEmail'],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: const CircularProgressIndicator());
                    }
                  default:
                    return Center(child: const CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

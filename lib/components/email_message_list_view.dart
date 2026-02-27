import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';

typedef OnTapCallBack =
    void Function(QueryDocumentSnapshot<Map<String, dynamic>> email);

class EmailMessageListView extends StatelessWidget {
  final QuerySnapshot<Map<String, dynamic>> email;
  final OnTapCallBack onTap;

  const EmailMessageListView({
    super.key,
    required this.email,
    required this.onTap,
  });

  void showmenuoption(BuildContext context, String userId, String otheruserId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () async {
                  await CloudService().deleteChatPage(userId, otheruserId);
                  await CloudService().deletechatroom(userId, otheruserId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: email.docs.length,
      itemBuilder: (context, index) {
        final emails = email.docs[index];

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black),
            child: GestureDetector(
              onLongPress: () {
                showmenuoption(
                  context,
                  emails['userId'],
                  emails['otheruserId'],
                );
              },
              child: ListTile(
                onTap: () {
                  onTap(emails);
                },
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  emails['otheruserEmail'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

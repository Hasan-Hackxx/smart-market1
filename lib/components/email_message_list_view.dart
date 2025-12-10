import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: email.docs.length,
      itemBuilder: (context, index) {
        final emails = email.docs[index];

        return ListTile(
          onTap: () {
            onTap(emails);
          },
          leading: Icon(Icons.person),
          title: Text(emails['otheruserEmail']),
        );
      },
    );
  }
}

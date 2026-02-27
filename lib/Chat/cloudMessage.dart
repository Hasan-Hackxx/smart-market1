import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

@immutable
class Cloudmessage {
  final String message;
  final String custEmail;
  final String sallerId;
  final String custId;
  final Timestamp timestamp;
  final String chatroomId;

  const Cloudmessage({
    required this.message,
    required this.custEmail,
    required this.sallerId,
    required this.custId,
    required this.timestamp,
    required this.chatroomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'custEmail': custEmail,
      'sallerId': sallerId,
      'custId': custId,
      'timestamp': timestamp,
      'chatroomId': chatroomId,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {
  //instance of cloud firestore

  final info = FirebaseFirestore.instance.collection('info');

  Future<void> storeinfoForUser(String userId, String? imageUrl) async {
    try {
      await info.doc(userId).set({
        'imageUrl': imageUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      print('hasan hasan hasan hasan hasan hasan :$e');
    }
  }
}

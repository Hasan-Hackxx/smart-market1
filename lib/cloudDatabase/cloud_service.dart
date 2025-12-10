import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:smartmarket1/Chat/cloudMessage.dart';
import 'package:smartmarket1/cloudDatabase/UserInfo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CloudService extends ChangeNotifier {
  //instance of cloud firestore

  final info = FirebaseFirestore.instance.collection('info');
  final userInfo = FirebaseFirestore.instance.collection('userInfo');

  String? productid;

  Future<void> storeinfoForUser(String userId, String? imageUrl) async {
    try {
      await info.doc(userId).set({
        'imageUrl': imageUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      print('hasan hasan hasan hasan hasan hasan :$e');
    }
  }

  Future<String> saveUserInfo(
    String productName,
    String productdisc,

    String? imageUrl,
    String productprice,
    String userId,
    bool clothes,
    bool food,
    String email,
  ) async {
    final String productid =
        '${DateTime.now().millisecondsSinceEpoch}_${userId.substring(0, 5)}';
    final user = Userinfo(
      productName: productName,
      productdisc: productdisc,
      productprice: productprice,
      imageUrl: imageUrl!,
      clothes: clothes,
      food: food,
      email: email,
      id: productid,
    );

    final doc = await userInfo.add({...user.toMap(), "ownerId": userId});

    await userInfo.doc(doc.id).update({'id': doc.id});

    return doc.id;
  }

  Future<void> saveAddonUser(
    String addonName,
    String productId,
    String addonprice,
  ) async {
    await userInfo.doc(productId).collection('addons').add({
      'name': addonName,
      'price': addonprice,
    });
  }

  Future<void> deleteallinfo(String userId) async {
    final subcolRef = CloudService().userInfo;

    final snapshot = await subcolRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<Map<String, dynamic>>> getallusersproductExcloth(String userId) {
    return userInfo.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['food'] == true)
          .map((doc) => doc.data())
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getallusersproductExfood(String userId) {
    return userInfo.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['clothes'] == true)
          .map((doc) => doc.data())
          .toList();
    });
  }

  Future<void> deletefood(String? email, String productId) async {
    try {
      final infodoc = CloudService().userInfo.doc(productId);

      final doc = await infodoc.get();

      if (doc.exists) {
        final data = doc.data();

        if (data?['email'] == email) {
          ///*************** */
          await infodoc.delete();
        }
      }
    } catch (e) {
      print('error : $e');
    }
  }

  // futures for chat saler with costumer

  Future<void> sendMessage(String custId, String message) async {
    final currentuserId = Supabase.instance.client.auth.currentUser!.id;
    final currentuserEmail = Supabase.instance.client.auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Cloudmessage newMessage = Cloudmessage(
      message: message,
      custEmail: currentuserEmail,
      sallerId: custId,
      custId: currentuserId,
      timestamp: timestamp,
    );

    List<String> ids = [currentuserId, custId];
    ids.sort();
    final chatroomId = ids.join('_');

    await FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatroomId)
        .collection('Messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userId, otheruserId) {
    List<String> ids = [userId, otheruserId];
    ids.sort();
    final chatroomId = ids.join('_');

    return FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatroomId)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> storePeoplewhotextme(
    String userId,
    String email,
    String otheruserEmail,
    String otheruserId,
  ) async {
    List<String> ids = [userId, otheruserId];
    ids.sort();
    final chatroomId = ids.join('_');

    await FirebaseFirestore.instance
        .collection('people')
        .doc('$userId-$otheruserId')
        .set({
          'userId': userId,
          'otheruserId': otheruserId,
          'myEmail': email,
          'otheruserEmail': otheruserEmail,
          'chatroomId': chatroomId,
          'timestamp': Timestamp.now(),
        });

    await FirebaseFirestore.instance
        .collection('people')
        .doc('$otheruserId-$userId')
        .set({
          'userId': otheruserId,
          'otheruserId': userId,
          'myEmail': otheruserEmail,
          'otheruserEmail': email,
          'chatroomId': chatroomId,
          'timestamp': Timestamp.now(),
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getinfochats(String userId) {
    return FirebaseFirestore.instance
        .collection('people')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

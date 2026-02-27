import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:smartmarket1/Chat/cloudMessage.dart';
import 'package:smartmarket1/cloudDatabase/UserInfo.dart';
import 'package:smartmarket1/components/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class CloudService extends ChangeNotifier {
  final info = FirebaseFirestore.instance.collection('info');
  final userInfo = FirebaseFirestore.instance.collection('userInfo');
  final adjustments = FirebaseFirestore.instance.collection('adjustments');
  final orders = FirebaseFirestore.instance.collection('orders');

  String? productid;

  // ---------- USER INFO ----------

  Future<void> storeinfoForUser(String userId, String? imageUrl) async {
    await info.doc(userId).set({'imageUrl': imageUrl}, SetOptions(merge: true));
  }

  Future<void> storeinfoForUser2(String userId, String? imageUrl) async {
    await adjustments.doc(userId).set({
      'imageUrl': imageUrl,
    }, SetOptions(merge: true));
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
    final subcolRef = userInfo;
    final snapshot = await subcolRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // ---------- STREAMS ----------

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

  Stream<List<Map<String, dynamic>>> getmyproducts(String ownerId) {
    return userInfo.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['ownerId'] == ownerId)
          .map((doc) => doc.data())
          .toList();
    });
  }

  Future<void> deletefood(String? email, String productId) async {
    final infodoc = userInfo.doc(productId);
    final infodoc2 = userInfo.doc(productId).collection('addons');

    final doc = await infodoc.get();
    final snapshot = await infodoc2.get();

    if (doc.exists) {
      final data = doc.data();
      if (data?['email'] == email) {
        await infodoc.delete();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }
    }
  }

  // ---------- CHAT ----------

  Future<void> sendMessage(
    String custId,
    String message,
    String otheruserEmail,
  ) async {
    final currentuserId = Supabase.instance.client.auth.currentUser!.id;
    final currentuserEmail = Supabase.instance.client.auth.currentUser!.email!;
    final timestamp = Timestamp.now();

    final ids = [currentuserId, custId]..sort();
    final chatroomId = ids.join('_');

    final chatroomRef = FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatroomId);

    await chatroomRef.set({
      'parteners': ids,
      'lastTimestamp': timestamp,
    }, SetOptions(merge: true));

    final msg = Cloudmessage(
      message: message,
      custEmail: currentuserEmail,
      sallerId: custId,
      custId: currentuserId,
      chatroomId: chatroomId,
      timestamp: timestamp,
    );

    await chatroomRef.collection('Messages').add(msg.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userId, String otheruserId) {
    final ids = [userId, otheruserId]..sort();
    return FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(ids.join('_'))
        .collection('Messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> storePeoplewhotextme(
    String userId,
    String email,
    String otheruserEmail,
    String otheruserId,
  ) async {
    final ids = [userId, otheruserId]..sort();
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
          'deletefor': [],
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getinfochats(String userId) {
    return FirebaseFirestore.instance
        .collection('people')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> editInfo(
    String productId,
    String name,
    String price,
    String desc,
    String image,
  ) async {
    await userInfo.doc(productId).update({
      'productName': name,
      'productprice': price,
      'productdisc': desc,
      'imageUrl': image,
    });
  }

  Future<void> editAddons(
    String productid,
    String id,
    String addonname,
    String addonprice,
  ) async {
    await userInfo.doc(productid).collection('addons').doc(id).update({
      'name': addonname,
      'price': addonprice,
    });
  }

  Future<void> deleteChatPage(String userId, String otheruserId) async {
    await FirebaseFirestore.instance
        .collection('people')
        .doc('$userId-$otheruserId')
        .delete();
  }

  Future<void> deletechatroom(String userId, String otheruserId) async {
    final ids = [userId, otheruserId]..sort();
    final chatroomId = ids.join('_');

    await FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatroomId)
        .update({
          'deletefor': FieldValue.arrayUnion([userId]),
          'timestampfordelete': Timestamp.now(),
        });
  }

  // ---------- CART ----------

  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  void addTocart(
    Map<String, dynamic> product,
    List<Map<String, dynamic>> selectAddon,
  ) {
    final cartitem = _cart.firstWhereOrNull(
      (item) =>
          item.product == product &&
          const ListEquality().equals(item.selectAddon, selectAddon),
    );

    if (cartitem != null) {
      cartitem.quaintity++;
    } else {
      _cart.add(CartItem(product: product, selectAddon: selectAddon));
    }
    notifyListeners();
  }

  void removeItemformCart(CartItem cartitem) {
    if (!_cart.contains(cartitem)) return;
    if (cartitem.quaintity > 1) {
      cartitem.quaintity--;
    } else {
      _cart.remove(cartitem);
    }
    notifyListeners();
  }

  double gettotalprice() {
    double total = 0;
    for (final item in _cart) {
      double price =
          double.tryParse(item.product['productprice'].toString()) ?? 0;
      for (final addon in item.selectAddon) {
        price += double.tryParse(addon['price'].toString()) ?? 0;
      }
      total += price * item.quaintity;
    }
    return total;
  }

  int getcountitem() => _cart.fold(0, (sum, item) => sum + item.quaintity);

  void clearcart() {
    _cart.clear();
    notifyListeners();
  }

  String displaycartResciept() {
    final b = StringBuffer();
    b.writeln(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
    b.writeln('------------');
    for (final item in _cart) {
      b.writeln(
        '${item.quaintity} x ${item.product['productName']} - \$${item.product['productprice']}',
      );
      if (item.selectAddon.isNotEmpty) {
        b.writeln(
          "addons: ${item.selectAddon.map((a) => "${a['name']} (\$${a['price']})").join(", ")}",
        );
      }
    }
    b.writeln('------------');
    b.writeln('total-Items: ${getcountitem()}');
    b.writeln('total-Price: \$${gettotalprice()}');
    return b.toString();
  }

  Future<void> saveorder(String reciept) async {
    await orders.add({'date': DateTime.now(), 'order': reciept});
  }
}

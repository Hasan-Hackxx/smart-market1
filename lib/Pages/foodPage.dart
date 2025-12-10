import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartmarket1/Chat/chatPage.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Foodpage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Map<String, bool> selectAddon = {};

  Foodpage({super.key, required this.product});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  //final Getproducid controller = Get.find();

  final email = Supabase.instance.client.auth.currentUser!.email;

  @override
  void initState() {
    super.initState();
    widget.selectAddon.clear();
  }

  @override
  Widget build(BuildContext context) {
    //final productId = controller.productId.value;

    // print('productid: $productId');

    final item = widget.product;
    final bool isowner = (item['email'] == email);
    return Stack(
      children: [
        //scaffald
        Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //food image
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: Image.network(item['imageUrl'], width: 420, height: 300),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //name owner food
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Text(
                            'the owner:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['email'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),
                    //button to contact with owner
                    if (isowner)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: IconButton(
                          onPressed: () async {
                            await CloudService().deletefood(email, item['id']);
                            // await Supabase.instance.client.storage
                            //     .from('profiles')
                            //     .remove([widget.imagepath]);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),

                    if (!isowner)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chatpage(
                                  email: item['email'],
                                  otheruserId: item['ownerId'],
                                  otheruserEmail: item['email'],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.message),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(color: Colors.grey),

              SizedBox(width: 50),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['productName'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //food description
                    Row(
                      children: [
                        Text(
                          item['productdisc'],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(255, 138, 137, 137),
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),

                    Text(
                      item['productprice'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(color: Colors.grey),

                    SizedBox(height: 12),

                    Text(
                      'Add-ons',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('userInfo')
                          .doc(item['id'])
                          .collection('addons')
                          .snapshots(),

                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        final docs = snapshot.data!.docs;

                        for (var doc in docs) {
                          final id = doc.id;
                          widget.selectAddon[id] ??= false;
                        }

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 124, 123, 123),
                            ),
                          ),

                          padding: EdgeInsets.zero,
                          child: docs.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: docs.length,
                                  itemBuilder: (context, index) {
                                    final addon = docs[index];
                                    final id = addon.id;

                                    return CheckboxListTile(
                                      title: Text(
                                        addon['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '\$' + addon['price'].toString(),
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900,
                                          color: const Color.fromARGB(
                                            255,
                                            160,
                                            159,
                                            159,
                                          ),
                                        ),
                                      ),
                                      value: widget.selectAddon[id],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (!isowner) {
                                            widget.selectAddon[id] = value!;
                                          }
                                        });
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'no addon exist',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                        );
                      },
                    ),

                    //food addons
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: !isowner
                        ? TextButton(
                            onPressed: () {},
                            child: Text(
                              'Send to Cart',
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 5),
              //food name
            ],
          ),
        ),

        //back button
        SafeArea(
          child: Opacity(
            opacity: 0.7,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 104, 103, 103),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

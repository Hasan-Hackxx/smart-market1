import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartmarket1/Chat/chatPage.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/main.dart' show HomePage;
import 'package:supabase_flutter/supabase_flutter.dart';

class Foodpage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic> selectAddon = {};

  Foodpage({super.key, required this.product});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  //final Getproducid controller = Get.find();
  final email = Supabase.instance.client.auth.currentUser!.email;
  final userId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    widget.selectAddon.clear();
  }

  void addTocart(
    Map<String, dynamic> product,
    Map<String, dynamic> selectedAddon,
  ) {
    List<Map<String, dynamic>> currentselectedAddon = [];
    for (var entry in widget.selectAddon.entries) {
      if (entry.value['selected'] == true) {
        currentselectedAddon.add({
          'name': entry.value['name'],
          'price': entry.value['price'],
        });
      }
    }

    context.read<CloudService>().addTocart(product, currentselectedAddon);
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //food image
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: Image.network(
                    item['imageUrl'],
                    width: 420.w,
                    height: 300.h,
                  ),
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
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item['email'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15.sp,
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
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text(
                                    'Are you sure you want to delete this product!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await CloudService().deletefood(
                                          email,
                                          item['id'],
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
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
                                    userId: userId,
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

                SizedBox(width: 50.w),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['productName'],
                        style: TextStyle(
                          fontSize: 20.sp,
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
                              fontSize: 18.sp,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),

                      Text(
                        item['productprice'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                      const Divider(color: Colors.grey),

                      SizedBox(height: 12.h),

                      Text(
                        'Add-ons',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15.h),

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
                            widget.selectAddon[id] ??= {
                              'selected': false,
                              'name': doc['name'],
                              'price': doc['price'],
                            };
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                            fontSize: 19.sp,
                                            fontWeight: FontWeight.w900,
                                            color: const Color.fromARGB(
                                              255,
                                              160,
                                              159,
                                              159,
                                            ),
                                          ),
                                        ),
                                        value:
                                            widget.selectAddon[id]['selected'],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (!isowner) {
                                              widget.selectAddon[id]['selected'] =
                                                  value!;
                                            }
                                          });
                                        },
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'no addon exist',
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                  ),
                          );
                        },
                      ),

                      //food addons
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
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
                              onPressed: () {
                                addTocart(widget.product, widget.selectAddon);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'item was added to cart successfully!',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Send to Cart',
                                style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                //food name
              ],
            ),
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

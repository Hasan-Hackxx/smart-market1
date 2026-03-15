import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartmarket1/Chat/chatPage.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Productpage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic> selectAddon = {};

  Productpage({super.key, required this.product});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
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
    final item = widget.product;
    final bool owner = (item['email'] == email);
    return Stack(
      children: [
        //scaffald
        Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //product image
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
                    Text(
                      item['email'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.sp,
                      ),
                    ),
                    Spacer(),
                    if (owner)
                      IconButton(
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
                    //button to contact with owner
                    if (!owner)
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatpage(
                              email: item['email'],
                              otheruserId: item['ownerId'],
                              otheruserEmail: item['email'],
                              userId: userId,
                            ),
                          ),
                        ),
                        icon: Icon(Icons.message, size: 30),
                      ),
                  ],
                ),
              ),
              const Divider(color: Colors.grey),

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

                    //product price
                    Text(
                      '\$' + item['productprice'].toString(),
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 160, 159, 159),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    //product description
                    Text(
                      item['productdisc'],
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 138, 137, 137),
                        fontSize: 18.sp,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    SizedBox(height: 12.h),

                    //product addons
                  ],
                ),
              ),
              Spacer(),
              if (!owner)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: !owner
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

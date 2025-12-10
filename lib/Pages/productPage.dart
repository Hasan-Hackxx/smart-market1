import 'package:flutter/material.dart';
import 'package:smartmarket1/Chat/chatPage.dart';

class Productpage extends StatefulWidget {
  final Map<String, dynamic> product;
  const Productpage({super.key, required this.product});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  @override
  Widget build(BuildContext context) {
    final item = widget.product;
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
                child: Image.network(item['imageUrl'], width: 420, height: 300),
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
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    //button to contact with owner
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chatpage(
                            email: item['email'],
                            otheruserId: item['ownerId'],
                            otheruserEmail: item['email'],
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
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //product price
                    Text(
                      '\$' + item['productprice'].toString(),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 160, 159, 159),
                      ),
                    ),
                    SizedBox(height: 15),
                    //product description
                    Text(
                      item['productdisc'],
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 138, 137, 137),
                        fontSize: 18,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    SizedBox(height: 12),

                    //product addons
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
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Send to Cart',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
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

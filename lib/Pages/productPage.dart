import 'package:flutter/material.dart';
import 'package:smartmarket1/models/product.dart';

class Productpage extends StatefulWidget {
  final Product product;
  const Productpage({super.key, required this.product});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(
                  widget.product.imagePath,
                  width: 420,
                  height: 300,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //name owner food
                    Text(
                      'Hasan badour',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    //button to contact with owner
                    Icon(Icons.message),
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
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //product price
                    Text(
                      '\$' + widget.product.price.toString(),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(255, 160, 159, 159),
                      ),
                    ),
                    SizedBox(height: 15),
                    //product description
                    Text(
                      widget.product.description,
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

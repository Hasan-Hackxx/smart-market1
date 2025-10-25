import 'package:flutter/material.dart';
import 'package:smartmarket1/models/food.dart';

class Foodpage extends StatefulWidget {
  final Food food;
  const Foodpage({super.key, required this.food});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //food image
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            child: Image.asset(widget.food.imagePath, width: 420, height: 300),
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //food description
                Text(
                  widget.food.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: const Color.fromARGB(255, 138, 137, 137),
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Add-ons',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                //food addons
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.food.selectedaddon.length,
                    itemBuilder: (context, index) {
                      final addon = widget.food.selectedaddon[index];
                      return CheckboxListTile(
                        title: Text(
                          addon.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '\$' + addon.price.toString(),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(255, 160, 159, 159),
                          ),
                        ),
                        value: false,
                        onChanged: (value) {},
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
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
                SizedBox(height: 5),
              ],
            ),
          ),

          //food name
        ],
      ),
    );
  }
}

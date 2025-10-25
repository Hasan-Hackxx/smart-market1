import 'package:flutter/material.dart';
import 'package:smartmarket1/models/food.dart';

class Foodtile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const Foodtile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //food Name
                      Text(
                        food.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      //food price
                      Text(
                        '\$' + food.price.toString(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 160, 159, 159),
                        ),
                      ),
                      SizedBox(height: 10),
                      // food description
                      Text(
                        food.description,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                // food image,
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(food.imagePath, height: 100, width: 150),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

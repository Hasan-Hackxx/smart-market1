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
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  //food Name
                  Text(food.name),
                  //food price
                  Text('\$' + food.price.toString()),
                  // food description
                  Text(food.description),
                ],
              ),
            ),
            // food image
            Image.asset(food.imagePath),
          ],
        ),
      ],
    );
  }
}

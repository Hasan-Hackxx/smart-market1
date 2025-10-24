import 'package:flutter/material.dart';
import 'package:smartmarket1/models/product.dart';

class Producttile extends StatelessWidget {
  final Product product;
  final void Function()? onTap;
  const Producttile({super.key, required this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  //product name
                  Text(product.name),
                  //product price
                  Text('\$' + product.price.toString()),
                  //product description
                  Text(product.description),
                ],
              ),
            ),
            Image.asset(product.imagePath),
          ],
        ),
      ],
    );
  }
}

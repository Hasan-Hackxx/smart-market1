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
                      //product name
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      //product price
                      Text(
                        '\$' + product.price.toString(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 160, 159, 159),
                        ),
                      ),
                      SizedBox(height: 10),
                      //product description
                      Text(
                        product.description,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    product.imagePath,
                    height: 100,
                    width: 150,
                  ),
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

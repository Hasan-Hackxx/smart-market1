import 'package:flutter/material.dart';
import 'package:smartmarket1/cloudDatabase/createproduct2title.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef OnTapCallBack = void Function(Map<String, dynamic> products2);

class Product2ListView extends StatefulWidget {
  final List<Map<String, dynamic>> product;
  final OnTapCallBack onTap;
  const Product2ListView({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<Product2ListView> createState() => _Product2ListViewState();
}

class _Product2ListViewState extends State<Product2ListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.product.length,
      itemBuilder: (context, index) {
        final product = widget.product[index];

        final userId = Supabase.instance.client.auth.currentUser!.id;

        return ListTile(
          onTap: () {
            widget.onTap(product);
          },
          title: Createproduct2title(
            productName: product['productName'] ?? '',
            productdisc: product['productdisc'] ?? '',
            productprice: product['productprice'] ?? '',
            userId: userId,
            clothes: product['clothes'] ?? false,
            food: product['food'] ?? false,
            imageUrl: product['imageUrl'] ?? '',
            messageId: product['messageId'] ?? '',
          ),
        );
      },
    );
  }
}

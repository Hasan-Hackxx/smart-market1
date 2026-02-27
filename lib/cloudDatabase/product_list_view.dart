import 'package:flutter/material.dart';
import 'package:smartmarket1/components/createdproductTitle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef OnTapCallBack = void Function(Map<String, dynamic> products);

class ProductListView extends StatefulWidget {
  final List<Map<String, dynamic>> produucts;

  final OnTapCallBack onTap;

  const ProductListView({
    super.key,
    required this.produucts,
    required this.onTap,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.produucts.length,
      itemBuilder: (context, index) {
        final product = widget.produucts[index];
        final userId = Supabase.instance.client.auth.currentUser!.id;

        return ListTile(
          onTap: () {
            widget.onTap(product);
          },
          title: Createdproducttitle(
            productName: product['productName'],
            productdisc: product['productdisc'],
            productprice: product['productprice'],
            userId: userId,
            clothes: product['clothes'],
            food: product['food'],
            imageUrl: product['imageUrl'],
            messageId: product['messageId'],
          ),
        );
      },
    );
  }
}

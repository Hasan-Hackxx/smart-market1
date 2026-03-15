import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartmarket1/components/myproducttitle.dart';

class MyProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> myproducts;
  const MyProductsListView({super.key, required this.myproducts});

  @override
  Widget build(BuildContext context) {
    if (myproducts.isEmpty) {
      return Center(
        child: Text(
          'Thers is no products yet!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: myproducts.length,
      itemBuilder: (context, index) {
        final products = myproducts[index];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 200.w,

            child: Myproducttitle(
              image: products['imageUrl'],
              productName: products['productName'],
              productPrice: products['productprice'],
              productdisc: products['productdisc'],
              productId: products['id'],
            ),
          ),
        );
      },
    );
  }
}

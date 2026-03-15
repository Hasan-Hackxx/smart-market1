import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartmarket1/Pages/payment_page.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/cartTitle.dart';
import 'package:smartmarket1/components/mybutton.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CloudService>().cart;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My cart'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(child: Text('cart is empty..'))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final cartitem = cart[index];
                      return Carttitle(cartitem: cartitem);
                    },
                  ),
          ),
          Mybutton(
            text: 'Go to checkout',
            onPressed: () {
              final cart = context.read<CloudService>().cart;
              if (cart.isEmpty) return;

              final firstproduct = cart.first.product;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    otheruserEmail: firstproduct['email'],
                    otheruserId: firstproduct['ownerId'],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}

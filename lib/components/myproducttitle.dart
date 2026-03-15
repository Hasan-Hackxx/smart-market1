import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartmarket1/Pages/EditmyinfoproductsPagert.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Myproducttitle extends StatelessWidget {
  final String? image;
  final String productName;
  final String productPrice;
  final String productdisc;
  final String productId;

  const Myproducttitle({
    super.key,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.productdisc,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser!.email;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: Column(
          children: [
            Image.network(image!, height: 150, width: 150.w),

            Text(
              'name: $productName',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 25.h),

            Text(
              'price: $productPrice',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 25.h),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'description:  $productdisc',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Editmyinfoproductspagert(
                        productId: productId,
                        imageUrl: image!,
                        nametxt: productName,
                        pricetxt: productPrice,
                        desctxt: productdisc,
                      ),
                    ),
                  ),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          'Are you sure you want to delete this product!',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await CloudService().deletefood(email, productId);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

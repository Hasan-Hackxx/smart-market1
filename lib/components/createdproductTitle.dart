import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Createdproducttitle extends StatelessWidget {
  final String productName;
  final String productdisc;

  final String imageUrl;
  final String productprice;
  final String userId;
  final bool clothes;
  final bool food;
  final String messageId;
  const Createdproducttitle({
    super.key,
    required this.productName,
    required this.productdisc,
    required this.imageUrl,
    required this.productprice,
    required this.userId,
    required this.clothes,
    required this.food,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //food Name
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      //food price
                      Text(
                        '\$' + productprice.toString(),
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 160, 159, 159),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // food description
                      Text(
                        productdisc,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                // food image,
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(imageUrl, height: 100.h, width: 150.w),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartmarket1/models/food.dart';

class Myquainityselector extends StatelessWidget {
  final int quaintity;
  final Map<String, dynamic> food;
  final VoidCallback onIncrement;
  final VoidCallback onDecement;
  const Myquainityselector({
    super.key,
    required this.quaintity,
    required this.onIncrement,
    required this.onDecement,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onIncrement,
            child: Icon(Icons.remove, size: 20, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),

            child: SizedBox(
              width: 20.w,
              child: Center(child: Text(quaintity.toString())),
            ),
          ),
          GestureDetector(
            onTap: onDecement,
            child: Icon(Icons.add, size: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

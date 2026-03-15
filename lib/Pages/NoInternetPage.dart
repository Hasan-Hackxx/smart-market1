import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Nointernetpage extends StatefulWidget {
  const Nointernetpage({super.key});

  @override
  State<Nointernetpage> createState() => _NointernetpageState();
}

class _NointernetpageState extends State<Nointernetpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80.w),
            SizedBox(height: 16.h),
            Text('No Internet connextion'),
          ],
        ),
      ),
    );
  }
}

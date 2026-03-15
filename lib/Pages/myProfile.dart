import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/my_products_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  final userId = Supabase.instance.client.auth.currentUser!.id;
  final userEmail = Supabase.instance.client.auth.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My profile'),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 50.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Column(children: [Icon(Icons.person, size: 150)]),
          ),
          SizedBox(height: 50.h),
          Text(
            'My Name: $userEmail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
          ),

          SizedBox(height: 30.h),

          Divider(),

          Text(
            'My prdoucts:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
          ),
          StreamBuilder(
            stream: CloudService().getmyproducts(userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final product = snapshot.data!;

                    return Expanded(
                      child: MyProductsListView(myproducts: product),
                    );
                  } else {
                    return Center(child: const CircularProgressIndicator());
                  }
                default:
                  return Center(child: const CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

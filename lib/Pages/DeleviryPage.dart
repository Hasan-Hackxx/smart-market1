import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartmarket1/Chat/chatPage.dart';
import 'package:smartmarket1/Pages/MyRecipet.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/cart_item.dart';
import 'package:smartmarket1/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Delevirypage extends StatefulWidget {
  final String otheruserEmail;
  final String otheruserId;
  final CartItem cartItem;
  const Delevirypage({
    super.key,
    required this.otheruserEmail,
    required this.otheruserId,
    required this.cartItem,
  });

  @override
  State<Delevirypage> createState() => _DelevirypageState();
}

class _DelevirypageState extends State<Delevirypage> {
  bool? _svedorder;
  @override
  void initState() {
    super.initState();

    String reciept = context.read<CloudService>().displaycartResciept();
    CloudService().saveorder(reciept);
    setState(() {
      _svedorder = true;
    });

    if (_svedorder == true) {
      context.read<CloudService>().clearcart();
    }
  }

  final email = Supabase.instance.client.auth.currentUser!.email;
  final userId = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Delivery in Progress'),
        backgroundColor: const Color.fromARGB(255, 196, 195, 195),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
            icon: Icon(Icons.home, size: 30),
          ),
        ],
      ),
      bottomNavigationBar: _buildbottomNavigator(context),
      body: Column(children: [MyRecipet()]),
    );
  }

  Widget _buildbottomNavigator(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 190, 190, 190),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 👤 avatar
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ),

          SizedBox(width: 10.w),

          // 🧠 النص المرن (الحل هنا)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.otheruserEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'owner',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp, // ❗ كان 48 وهذا سبب المصيبة
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 129, 129, 129),
                  ),
                ),
              ],
            ),
          ),

          // 💬 📞 الأزرار
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chatpage(
                        email: widget.otheruserEmail,
                        otheruserId: widget.otheruserId,
                        otheruserEmail: widget.otheruserEmail,
                        userId: userId,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.message),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Color.fromARGB(255, 70, 168, 73),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smartmarket1/Pages/cart_page.dart';
import 'package:smartmarket1/Pages/createproductPage.dart';
import 'package:smartmarket1/Pages/myMessages.dart';

class MySilverAppBar extends StatelessWidget {
  final Widget title;
  final Widget child;
  const MySilverAppBar({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      title: Padding(
        padding: const EdgeInsets.only(left: 75),
        child: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 20,
            color: const Color.fromARGB(255, 255, 63, 127),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      expandedHeight: 130,
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Mymessages()),
          ),
          icon: Icon(Icons.message_sharp, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Createproductpage()),
            );
          },
          icon: Icon(Icons.create, color: Colors.white),
        ),
      ],

      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        background: child,
        title: title,
        titlePadding: EdgeInsets.only(bottom: 0, top: 20),
      ),
    );
  }
}

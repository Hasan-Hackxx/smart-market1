import 'package:flutter/material.dart';

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

import 'package:flutter/material.dart';

class Mytabbar extends StatelessWidget {
  final TabController tabController;
  const Mytabbar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: tabController,
        tabs: [
          //1tab
          Icon(Icons.person),

          //2tab
          Icon(Icons.settings),
        ],
      ),
    );
  }
}

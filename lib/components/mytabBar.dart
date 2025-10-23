import 'package:flutter/material.dart';
import 'package:smartmarket1/models/product.dart';

class Mytabbar extends StatelessWidget {
  final TabController tabController;
  const Mytabbar({super.key, required this.tabController});

  List<Tab> _buildertabs() {
    return Types.values.map((gategory) {
      return Tab(text: gategory.toString().split('.').last);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: tabController,
        tabs: _buildertabs(),
        labelColor: Colors.white,
      ),
    );
  }
}

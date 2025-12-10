import 'package:flutter/material.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/mybutton.dart';
import 'package:smartmarket1/components/mytextfield.dart';
import 'package:smartmarket1/main.dart';

class Moreioptions extends StatefulWidget {
  final Map<String, dynamic> product;
  final String imagepath;

  const Moreioptions({
    super.key,
    required this.product,
    required this.imagepath,
  });

  @override
  State<Moreioptions> createState() => _MoreioptionsState();
}

class _MoreioptionsState extends State<Moreioptions> {
  late final TextEditingController addons;
  late final TextEditingController price;

  @override
  void initState() {
    super.initState();
    addons = TextEditingController();
    price = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    addons.dispose();
    price.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.product;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('More options'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Addons:',
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Mytextfield(
              controller: addons,
              hintText: 'Your Addons:',
              obscureText: false,
            ),

            SizedBox(height: 20),
            Mytextfield(
              controller: price,
              hintText: 'Price',
              obscureText: false,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Mybutton(
                  text: 'Add',
                  onPressed: () async {
                    if (addons.text.isNotEmpty || price.text.isNotEmpty) {
                      await CloudService().saveAddonUser(
                        addons.text,
                        item['id'],
                        price.text,
                      );

                      addons.clear();
                      price.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('addon saves successfully!')),
                      );
                    }
                  },
                ),

                Spacer(),

                Mybutton(
                  text: 'Finish',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

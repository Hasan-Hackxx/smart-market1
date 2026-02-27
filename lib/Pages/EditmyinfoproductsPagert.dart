import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/mybutton.dart';
import 'package:smartmarket1/components/mytextfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Editmyinfoproductspagert extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String nametxt;
  final String pricetxt;
  final String desctxt;

  const Editmyinfoproductspagert({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.nametxt,
    required this.pricetxt,
    required this.desctxt,
  });

  @override
  State<Editmyinfoproductspagert> createState() =>
      _EditmyinfoproductspagertState();
}

class _EditmyinfoproductspagertState extends State<Editmyinfoproductspagert> {
  late final TextEditingController name;
  late final TextEditingController price;
  late final TextEditingController desc;

  List<TextEditingController> addonsNameControllers = [];
  List<TextEditingController> addonspiceControllers = [];
  List<String> addonids = [];

  String? _imageUrl;
  bool addoninitlized = false;
  @override
  void initState() {
    name = TextEditingController(text: widget.nametxt);
    price = TextEditingController(text: widget.pricetxt);
    desc = TextEditingController(text: widget.desctxt);
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    desc.dispose();
    for (var c in addonsNameControllers) {
      c.dispose();
    }

    for (var c in addonspiceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    final imageBinary = await image.readAsBytes();

    final userId = Supabase.instance.client.auth.currentUser!.id;

    final fileName = DateTime.now().microsecondsSinceEpoch.toString();

    final imagePath = '$userId/$fileName';

    final imageExtention = image.path.split('.').last.toLowerCase();

    await Supabase.instance.client.storage
        .from('adjustments')
        .uploadBinary(
          imagePath,
          imageBinary,
          fileOptions: FileOptions(contentType: 'image/$imageExtention'),
        );

    String url = Supabase.instance.client.storage
        .from('adjustments')
        .getPublicUrl(imagePath);

    url = Uri.parse(url)
        .replace(
          queryParameters: {
            't': DateTime.now().microsecondsSinceEpoch.toString(),
          },
        )
        .toString();

    setState(() {
      _imageUrl = url;
    });

    await CloudService().storeinfoForUser2(userId, _imageUrl);
  }

  Future<void> loadImage() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final response = await CloudService().adjustments.doc(userId).get();
    if (response.exists) {
      setState(() {
        _imageUrl = response['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit'),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,

                  child: _imageUrl != null
                      ? Image.network(_imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey,
                          child: Image.network(widget.imageUrl),
                        ),
                ),
                Spacer(),
                Mybutton(
                  onPressed: () async {
                    await uploadImage();
                    await loadImage();
                  },
                  text: 'Edit image',
                ),
              ],
            ),

            SizedBox(height: 30),
            Mytextfield(controller: name, hintText: 'Name', obscureText: false),

            SizedBox(height: 15),

            Mytextfield(
              controller: price,
              hintText: 'Price',
              obscureText: false,
            ),
            SizedBox(height: 15),

            Mytextfield(
              controller: desc,
              hintText: 'Description',
              obscureText: false,
            ),
            SizedBox(height: 15),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'addons:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),

            StreamBuilder(
              stream: CloudService().userInfo
                  .doc(widget.productId)
                  .collection('addons')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('No addons'));
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Text('No addons');
                }
                addonsNameControllers.clear();
                addonspiceControllers.clear();
                addonids.clear();
                for (var doc in docs) {
                  addonids.add(doc.id);

                  addonsNameControllers.add(
                    TextEditingController(text: doc['name']),
                  );
                  addonspiceControllers.add(
                    TextEditingController(text: doc['price']),
                  );
                }
                return Column(
                  children: List.generate(docs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Mytextfield(
                              controller: addonsNameControllers[index],
                              hintText: 'Name',
                              obscureText: false,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Mytextfield(
                              controller: addonspiceControllers[index],
                              hintText: 'Price',
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );

                return CircularProgressIndicator();
              },
            ),
            Spacer(),
            Mybutton(
              text: 'Save',
              onPressed: () async {
                Navigator.pop(context);
                await CloudService().editInfo(
                  widget.productId,
                  name.text.isNotEmpty ? name.text : widget.nametxt,
                  price.text.isNotEmpty ? price.text : widget.pricetxt,
                  desc.text.isNotEmpty ? desc.text : widget.desctxt,
                  _imageUrl ?? widget.imageUrl,
                );
                for (int i = 0; i < addonids.length; i++) {
                  await CloudService().editAddons(
                    widget.productId,
                    addonids[i],
                    addonsNameControllers[i].text,
                    addonspiceControllers[i].text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

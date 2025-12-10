import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/components/moreioptions.dart';
import 'package:smartmarket1/components/mytextfield.dart';
import 'package:smartmarket1/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Createproductpage extends StatefulWidget {
  const Createproductpage({super.key});

  @override
  State<Createproductpage> createState() => _CreateproductpageState();
}

class _CreateproductpageState extends State<Createproductpage> {
  String? _imageUrl;

  bool isproductsaved = false;

  bool clothes = false;
  bool food = false;
  String? _imagepath2;

  late final TextEditingController productName;
  late final TextEditingController productprice;
  late final TextEditingController productDiscrp;

  @override
  void initState() {
    super.initState();
    loadimage();
    productName = TextEditingController();
    productDiscrp = TextEditingController();
    productprice = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    productName.dispose();
    productDiscrp.dispose();
    productprice.dispose();
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final imageBinary = await image.readAsBytes();

    final fileName = DateTime.now().microsecondsSinceEpoch.toString();

    final imagepath = '$userId/$fileName';

    _imagepath2 = imagepath;

    final imageExtention = image.path.split('.').last.toLowerCase();

    await Supabase.instance.client.storage
        .from('profiles')
        .uploadBinary(
          imagepath,
          imageBinary,
          fileOptions: FileOptions(contentType: 'image/$imageExtention'),
        );

    String url = Supabase.instance.client.storage
        .from('profiles')
        .getPublicUrl(imagepath);
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

    await CloudService().storeinfoForUser(userId, _imageUrl);
  }

  Future<void> loadimage() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final response = await CloudService().info.doc(userId).get();
      if (response.exists) {
        setState(() {
          _imageUrl = response['imageUrl'];
        });
      }
    } catch (e) {
      print('Error loading image');
    } finally {
      setState(() {});
    }
  }

  void showUserInfoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'create your product',
      pageBuilder: (context, anmi1, anmi2) {
        return Center(
          child: Material(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Container(
                  width: 300,
                  height: 800,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Your Information',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        Column(
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,

                              child: _imageUrl != null
                                  ? Image.network(_imageUrl!, fit: BoxFit.cover)
                                  : Container(
                                      color: Colors.grey,
                                      child: Center(
                                        child: Text('No upload image'),
                                      ),
                                    ),
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 0,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      await uploadImage();
                                      await loadimage();

                                      Navigator.pop(context);

                                      Future.delayed(
                                        Duration(milliseconds: 100),
                                        () => showUserInfoDialog(context),
                                      );
                                    },
                                    child: Text(
                                      'upload Image',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 20),

                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 0,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      try {
                                        setState(() {
                                          _imageUrl = null;
                                        });

                                        Navigator.pop(context);

                                        Future.delayed(
                                          Duration(milliseconds: 100),
                                          () => showUserInfoDialog(context),
                                        );
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text(
                                      'Delete image',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),

                            Mytextfield(
                              controller: productName,
                              hintText: 'Product Name',
                              obscureText: false,
                            ),
                            SizedBox(height: 15),
                            Mytextfield(
                              controller: productDiscrp,
                              hintText: 'Description',
                              obscureText: false,
                            ),
                            SizedBox(height: 15),

                            Mytextfield(
                              controller: productprice,
                              hintText: 'Price',
                              obscureText: false,
                            ),
                            SizedBox(height: 10),
                            const Text(
                              'choose one type of your product!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                CheckboxListTile(
                                  title: Text('Food'),
                                  value: food,
                                  onChanged: (newValue) {
                                    setDialogState(() {
                                      food = newValue!;
                                    });
                                  },
                                ),

                                CheckboxListTile(
                                  title: Text('Clothes'),
                                  value: clothes,
                                  onChanged: (newValue) {
                                    setDialogState(() {
                                      clothes = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),

                            // TextButton(
                            //   onPressed: isproductsaved
                            //       ? () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => Moreioptions(
                            //                 productId: _productId1!,
                            //               ),
                            //             ),
                            //           );
                            //         }
                            //       : null,

                            //   child: Text('Next'),
                            // ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    if (clothes && food) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Erorr'),
                                          content: Text(
                                            'must choose one type not both...!',
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (clothes == false &&
                                        food == false) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Erorr'),
                                          content: Text(
                                            'must choose one type at least',
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      final userId = Supabase
                                          .instance
                                          .client
                                          .auth
                                          .currentUser!
                                          .id;
                                      final email = Supabase
                                          .instance
                                          .client
                                          .auth
                                          .currentUser!
                                          .email;
                                      final productid = await CloudService()
                                          .saveUserInfo(
                                            productName.text,
                                            productDiscrp.text,

                                            _imageUrl,
                                            productprice.text,
                                            userId,
                                            clothes,
                                            food,
                                            email!,
                                          );

                                      // _productId1 = productId;

                                      // setDialogState(() {
                                      //   isproductsaved = true;
                                      // });

                                      final product = {
                                        'productName': productName.text,
                                        'productdisc': productDiscrp.text,
                                        'productprice': productprice.text,
                                        'email': email,
                                        'imageUrl': _imageUrl,
                                        'food': food,
                                        'clothes': clothes,
                                        'id': productid,
                                      };

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Moreioptions(
                                            product: product,
                                            imagepath: _imagepath2!,
                                          ),
                                        ),
                                      );
                                    }

                                    // Future.delayed(
                                    //   Duration(milliseconds: 300),
                                    //   () => Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => HomePage(),
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Text('Next'),
                                ),
                                SizedBox(width: 100),
                                TextButton(
                                  onPressed: () async {
                                    final userId = Supabase
                                        .instance
                                        .client
                                        .auth
                                        .currentUser!
                                        .id;
                                    await CloudService().deleteallinfo(userId);
                                    setState(() {
                                      _imageUrl = null;
                                    });
                                    productName.clear();
                                    productDiscrp.clear();
                                    productprice.clear();

                                    Navigator.pop(context);

                                    Future.delayed(
                                      Duration(milliseconds: 100),
                                      () => showUserInfoDialog(context),
                                    );
                                  },
                                  child: Text('Delete All'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Product'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'W',
                style: TextStyle(
                  fontSize: 50,
                  color: const Color.fromARGB(255, 251, 255, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),

              Text(
                'E',
                style: TextStyle(
                  fontSize: 50,
                  color: const Color.fromARGB(255, 255, 17, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),

              Text(
                'L',
                style: TextStyle(
                  fontSize: 50,
                  color: const Color.fromARGB(255, 255, 0, 200),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),

              Text(
                'C',
                style: TextStyle(
                  fontSize: 50,
                  color: const Color.fromARGB(255, 17, 0, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),

              Text(
                'O',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),

              Text(
                'M',
                style: TextStyle(
                  fontSize: 50,
                  color: const Color.fromARGB(255, 51, 255, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),

              Text(
                'E',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 200),
          const Text(
            'Please choose how do you want to use App ...!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 90, 240),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    showUserInfoDialog(context);
                  },
                  child: Text(
                    'Seller',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 100),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 90, 240),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ),
                  child: Text(
                    'Customer',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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

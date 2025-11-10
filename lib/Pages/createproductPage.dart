import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Createproductpage extends StatefulWidget {
  const Createproductpage({super.key});

  @override
  State<Createproductpage> createState() => _CreateproductpageState();
}

class _CreateproductpageState extends State<Createproductpage> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadimage();
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final imageBinary = await image.readAsBytes();

    final imagepath = '$userId/profile';

    final imageExtention = image.path.split('.').last.toLowerCase();

    await Supabase.instance.client.storage
        .from('profiles')
        .uploadBinary(
          '/$userId/profile',
          imageBinary,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$imageExtention',
          ),
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Product'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_imageUrl != null)
              Image.network(_imageUrl!)
            else
              const Text('No upload image'),
            TextButton(
              onPressed: () async {
                await uploadImage();
                await loadimage();
              },
              child: Text('upload image'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final userId = Supabase.instance.client.auth.currentUser!.id;
                  await Supabase.instance.client.storage
                      .from('profiles')
                      .remove(['$userId/profile']);
                  setState(() {
                    _imageUrl = null;
                  });
                  await CloudService().info.doc(userId).delete();
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Delete image'),
            ),
          ],
        ),
      ),
    );
  }
}

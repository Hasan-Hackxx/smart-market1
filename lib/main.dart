import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartmarket1/Pages/foodPage.dart';
import 'package:smartmarket1/Pages/productPage.dart';
import 'package:smartmarket1/cloudDatabase/cloud_service.dart';
import 'package:smartmarket1/cloudDatabase/product2_list_View.dart';
import 'package:smartmarket1/cloudDatabase/product_list_view.dart';
import 'package:smartmarket1/components/appGate.dart';
import 'package:smartmarket1/components/my_silver_app_bar.dart';
import 'package:smartmarket1/components/mydrawer.dart';
import 'package:smartmarket1/components/mytabBar.dart';
import 'package:smartmarket1/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://rdivizzeucrabgzyisxv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJkaXZpenpldWNyYWJnenlpc3h2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NDMxNzQsImV4cCI6MjA3NzMxOTE3NH0.gFOB_G05nIeAEKxk4Wxx5FnZNcjTivlmXxgiXdRRY7Y',
  );
  // await GetStorage.init();
  // Get.put(Getproducid(), permanent: true);
  //Get.put(Getproducid());
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) => ChangeNotifierProvider(
        create: (context) => CloudService(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Appgate(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  final userId = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    final clouservice = context.read<CloudService>();
    return Scaffold(
      drawer: Mydrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxisSoterde) => [
          MySilverAppBar(
            title: Mytabbar(tabController: tabController),
            child: Column(
              children: [
                //my location

                //my fee
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            StreamBuilder(
              stream: clouservice.getallusersproductExcloth(userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final product = snapshot.data!;

                      return ProductListView(
                        produucts: product,

                        onTap: (product) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Foodpage(product: product),
                            ),
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
            StreamBuilder(
              stream: clouservice.getallusersproductExfood(userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final product2 = snapshot.data!;

                      return Product2ListView(
                        product: product2,
                        onTap: (product2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Productpage(product: product2),
                            ),
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

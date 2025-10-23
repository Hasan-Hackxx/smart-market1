import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartmarket1/Pages/getGate.dart';
import 'package:smartmarket1/components/my_silver_app_bar.dart';
import 'package:smartmarket1/components/mydrawer.dart';
import 'package:smartmarket1/components/mytabBar.dart';
import 'package:smartmarket1/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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
      home: const Getgate(),
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

  @override
  Widget build(BuildContext context) {
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
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, data) => Text('hasan badour'),
            ),
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, data) => Text('hasan badour'),
            ),
          ],
        ),
      ),
    );
  }
}

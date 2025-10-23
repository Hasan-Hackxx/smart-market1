import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartmarket1/Pages/loginorRegisterPage.dart';
import 'package:smartmarket1/main.dart';

class Getgate extends StatefulWidget {
  const Getgate({super.key});

  @override
  State<Getgate> createState() => _GetgateState();
}

class _GetgateState extends State<Getgate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, data) {
        if (data.hasData) {
          return HomePage();
        } else {
          return Loginorregisterpage();
        }
      },
    );
  }
}

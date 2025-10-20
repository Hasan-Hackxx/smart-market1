import 'package:flutter/material.dart';
import 'package:smartmarket1/Pages/loginPage.dart';
import 'package:smartmarket1/Pages/registerPage.dart';

class Loginorregisterpage extends StatefulWidget {
  const Loginorregisterpage({super.key});

  @override
  State<Loginorregisterpage> createState() => _LoginorregisterpageState();
}

class _LoginorregisterpageState extends State<Loginorregisterpage> {
  bool switchPages = true;

  void togglePages() {
    setState(() {
      switchPages = !switchPages;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (switchPages) {
      return Loginpage(onTap: togglePages);
    } else {
      return Registerpage(onTap: togglePages);
    }
  }
}

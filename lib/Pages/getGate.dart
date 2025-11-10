import 'package:flutter/material.dart';
import 'package:smartmarket1/Pages/loginorRegisterPage.dart';
import 'package:smartmarket1/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Getgate extends StatefulWidget {
  const Getgate({super.key});

  @override
  State<Getgate> createState() => _GetgateState();
}

class _GetgateState extends State<Getgate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return HomePage();
        } else {
          return Loginorregisterpage();
        }
      },
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartmarket1/Pages/BlockedPage.dart';
import 'package:smartmarket1/Pages/getGate.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Appgate extends StatefulWidget {
  const Appgate({super.key});

  @override
  State<Appgate> createState() => _AppgateState();
}

enum GateStatus { loading, blocked, allowed }

class _AppgateState extends State<Appgate> {
  GateStatus _status = GateStatus.loading;

  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  Future<void> checkAccess() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'checkAccess',
      );

      print('status: ${response.status}');
      print('status: ${response.data}');

      if (!mounted) return;

      if (response.status == 403) {
        setState(() => _status = GateStatus.blocked);
      } else {
        setState(() => _status = GateStatus.allowed);
      }
    } catch (e) {
      print('error checking access: $e');
      if (!mounted) return;
      setState(() => _status = GateStatus.blocked);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case GateStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      case GateStatus.blocked:
        return const BlockedPage();

      case GateStatus.allowed:
        return const Getgate();
    }
  }
}

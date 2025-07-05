import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'session_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _load() async {
    final email = await getSession();
    if (email != null) {
      return DashboardPage(email: email);
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Crypto Login',
      home: FutureBuilder<Widget>(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}

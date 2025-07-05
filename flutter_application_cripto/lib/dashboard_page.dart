import 'package:flutter/material.dart';
import 'login_page.dart';
import 'session_helper.dart';

class DashboardPage extends StatelessWidget {
  final String email;

  const DashboardPage({super.key, required this.email});

  void logout(BuildContext context) async {
    await clearSession();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout(context))
        ],
      ),
      body: Center(child: Text("Selamat datang, $email!", style: TextStyle(fontSize: 18))),
    );
  }
}

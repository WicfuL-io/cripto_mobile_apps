import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'crypto_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = "";
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://localhost/projectcripto/register.php"); // ganti IP jika perlu
    final hashed = hashPassword(passwordController.text);

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": emailController.text,
              "password": hashed,
            }),
          )
          .timeout(const Duration(seconds: 5));

      final result = jsonDecode(response.body);
      setState(() => isLoading = false);

      if (result['success'] == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      } else {
        setState(() => message = "Registrasi gagal. Email mungkin sudah terdaftar.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Gagal terhubung ke server.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading ? null : registerUser,
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Daftar"),
            ),
            if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'crypto_helper.dart';
import 'dashboard_page.dart';
import 'register_page.dart';
import 'session_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = "";
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://localhost/projectcripto/login.php"); // ganti IP jika perlu
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
        await saveSession(emailController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage(email: emailController.text)),
        );
      } else {
        setState(() => error = "Login gagal. Cek email atau password.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = "Terjadi kesalahan koneksi.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading ? null : loginUser,
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Login"),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text("Belum punya akun? ==Daftar di sini."),
            ),
            if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

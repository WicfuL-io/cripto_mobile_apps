import 'sha256_manual.dart';

String hashPassword(String password) {
  final digest = SHA256.hash(password);
  return digest.toString();
}

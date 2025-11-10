import 'package:smartmarket1/Auth/auth_Exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  //login method

  Future<AuthResponse> login(String email, String password) async {
    try {
      final authResponse = await Supabase.instance.client.auth
          .signInWithPassword(password: password, email: email);
      return authResponse;
    } on AuthException catch (e) {
      final message = e.message.toLowerCase();
      if (message.contains('invalid login credential')) {
        throw InvalidCredentialException();
      } else if (message.contains('email')) {
        throw InvalidEmailException();
      } else {
        throw GerneralException();
      }
    }
  }

  //sign up method
  Future<AuthResponse> signup(String email, String password) async {
    try {
      final authResponse = await Supabase.instance.client.auth.signUp(
        password: password,
        email: email,
      );
      return authResponse;
    } on AuthException catch (e) {
      print('supabase error: ${e.message}');
      final message = e.message.toLowerCase();
      if (message.contains('already registered')) {
        throw EmailAlreadyInuseException();
      } else if (message.contains('password')) {
        throw WeakPasswordException();
      } else if (message.contains('email')) {
        throw InvalidEmailException();
      } else {
        throw GerneralException();
      }
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartmarket1/Auth/auth_Exceptions.dart';

class AuthService {
  //login method

  Future<UserCredential> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        throw InvalidCredentialException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailException();
      } else {
        throw GerneralException();
      }
    }
  }

  //sign up method
  Future<UserCredential> signup(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInuseException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordException();
      } else {
        throw GerneralException();
      }
    }
  }

  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw CouldntLogoutException();
    }
  }
}

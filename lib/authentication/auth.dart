import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStatechanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmainAndpassword(
      {required String id, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: id, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> createUserIDandpassword(
      {required String id, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: id, password: password);
  }
}

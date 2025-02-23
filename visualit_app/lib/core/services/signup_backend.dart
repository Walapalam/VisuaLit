import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupBackend {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleSignupError(e);
    }
  }

  Future<UserCredential> signUpWithGoogle() async {
    try {
      // Google Sign In implementation
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      return await _auth.signInWithPopup(googleProvider);
    } on FirebaseAuthException catch (e) {
      throw _handleSignupError(e);
    }
  }

  String _handleSignupError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password must be at least 6 characters long.';
      case 'email-already-in-use':
        return 'This email is already registered. Please try logging in.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'An error occurred during signup.';
    }
  }
}
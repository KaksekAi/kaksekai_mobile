import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String fullName) async {
    try {
      // Create the user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore with additional fields
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
        'photoURL': null, // For future profile photo implementation
        'isActive': true,
      });

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String fullName) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': fullName,
          'updatedAt': Timestamp.now(),
        });
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.data();
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Helper method to handle Firebase Auth exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('អ៊ីមែលមិនត្រឹមត្រូវ');
        case 'wrong-password':
          return Exception('លេខសម្ងាត់មិនត្រឹមត្រូវ');
        case 'email-already-in-use':
          return Exception('អ៊ីមែលនេះត្រូវបានប្រើរួចហើយ');
        case 'weak-password':
          return Exception(
              'លេខសម្ងាត់ខ្សោយពេក សូមប្រើលេខសម្ងាត់ដែលមានសុវត្ថិភាពជាងនេះ');
        case 'invalid-email':
          return Exception('អ៊ីមែលមិនត្រឹមត្រូវ');
        case 'operation-not-allowed':
          return Exception('ការចុះឈ្មោះមិនត្រូវបានអនុញ្ញាត');
        default:
          return Exception('មានបញ្ហាកើតឡើង សូមព្យាយាមម្តងទៀត');
      }
    }
    return Exception('មានបញ្ហាកើតឡើង សូមព្យាយាមម្តងទៀត');
  }
}

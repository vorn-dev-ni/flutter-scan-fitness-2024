import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  FirebaseAuth? get getAuth => _auth;
  Stream<User?> get userStateChanges => _auth.userChanges();
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      // print("Email is ${email} password ${password}");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('Failed with error code: ${e}');
      }

      rethrow; // Handle specific exceptions in your UI layer
    }
  }

  Future logoutWithFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      debugPrint('User logged out from Facebook');
    } catch (e) {
      debugPrint('Error logging out from Facebook: $e');
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    await logoutWithFacebook();
    final facebookProvider = FacebookAuthProvider();
    // Set custom OAuth parameters if needed
    facebookProvider.setCustomParameters({"consent": "select_account"});

    final LoginResult loginResult = await FacebookAuth.instance.login();

    debugPrint("Login result is ${loginResult.message}");
    if (loginResult.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      throw Exception('User has cancelled');
    }

    return null;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In was canceled');
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    await reloadUser();
    return userCredential;
  }

  Future signOutWithGoogle() async {
    try {
      await GoogleSignIn().signOut();

      return true;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future syncUsertoFirestore(
      String fullName, String email, String provider) async {
    debugPrint("Receive ${fullName} ${email} ${provider}");
    FirestoreService firestoreService =
        FirestoreService(firebaseAuthService: this);

    await firestoreService.addUserToFirestore(fullName, email, provider);
  }

  Future reloadUser() async {
    await _auth.currentUser?.reload();
  }

  Future resetPasswordWithEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> createUser({String? email, String? password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email ?? "", password: password ?? "");

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');

      throw handleFirebaseErrorResponse(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Register a new user
  // Future<User?> registerWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   try {
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     return userCredential.user;
  //   } catch (e) {
  //     rethrow; // Handle specific exceptions in your UI layer
  //   }
  // }

  // // Reset Password (for forgot password scenario)
  // Future<void> resetPassword({required String email}) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //   } catch (e) {
  //     rethrow; // Handle specific exceptions in your UI layer
  //   }
  // }
}

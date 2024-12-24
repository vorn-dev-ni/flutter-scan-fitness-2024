// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isDisposed = false;

  late FirebaseAuthService firebaseAuthService;
  FirestoreService({
    required this.firebaseAuthService,
  });
  void dispose() {
    _isDisposed = true;
  }

  Stream<QuerySnapshot> getAllByUserId(String collectionName,
      {int limit = 0, String? sortBy}) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream<QuerySnapshot<Object?>>.empty();
    }
    Query queryDoc = _firestore
        .collection(collectionName)
        .where("userId", isEqualTo: firebaseAuthService.currentUser?.uid);

    if (limit > 0) {
      queryDoc = queryDoc.limit(limit);
      ;
    }
    if (sortBy == 'desc') {
      debugPrint("Called ${sortBy}");
      return queryDoc.orderBy("created_at", descending: true).snapshots();
    }

    debugPrint("Called ${sortBy}");
    return queryDoc.orderBy("created_at", descending: false).snapshots();
  }

  Future addDocument(String collection, Map<String, dynamic> values) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream<QuerySnapshot<Object?>>.empty();
    }
    if (_isDisposed == true) {
      return;
    }

    final response = await _firestore.collection(collection).add(values);
    return await response.get();
  }

  Future<AuthModel?> addUserToFirestore(String fullName, String email) async {
    final FirebaseAuth? auth = firebaseAuthService?.getAuth;

    if (auth != null) {
      try {
        String userId = auth.currentUser!.uid;
        if (_isDisposed) {
          return null;
        }
        await _firestore.collection('users').doc(userId).set({
          'fullName': fullName,
          'email': email,
        }, SetOptions(merge: true));
        return AuthModel(fullname: fullName, email: email);
      } on FirebaseException catch (e) {
        throw handleFirebaseErrorResponse(e);
      }
    } else {
      print('FirebaseAuth is not initialized.');
      throw UnknownException(
          message: "Oops", title: "'FirebaseAuth is not initialized.");
    }
  }

  Future<bool?> checkUserImage() async {
    try {
      CollectionReference users = _firestore.collection('users');
      DocumentSnapshot userDoc =
          await users.doc(firebaseAuthService.currentUser?.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        String? currentAvatarUrl = data['avatarImage'];
        if (kDebugMode) {
          print("Current avatar URL: $currentAvatarUrl");
        }

        if (currentAvatarUrl != null &&
            currentAvatarUrl != "" &&
            currentAvatarUrl!.isNotEmpty) {
          final Reference oldImageRef =
              FirebaseStorage.instance.refFromURL(currentAvatarUrl!);
          await oldImageRef.delete();

          if (kDebugMode) {
            print("Old image deleted successfully.");
          }
          return true;
        }
      } else {
        print("User document does not exist.");
        return true;
      }
    } on FirebaseException catch (e) {
      // Handle Firebase related errors (e.g., Firestore or Firebase Storage issues)
      if (kDebugMode) {
        print("Firebase error: ${e.code}");
      }
    } catch (e) {
      // Handle any other exceptions that may occur
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      if (e is FirebaseException) {
        if (e.code == 'firebase_storage/unknown') {
          return true;
        }
        throw AppException(title: e.code, message: e.message ?? "");
      }
      rethrow;
    }
  }

  Future<void> deleteAllDocument(String name) async {
    QuerySnapshot querySnapshot = await _firestore.collection(name).get();
    print("Document starting");

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      try {
        await doc.reference.delete();
        kDebugMode ? print("Document ${doc.id} deleted") : null;
      } catch (e) {
        kDebugMode ? print("Failed to delete document ${doc.id}: $e") : null;
      }
    }
  }

  Future<Map<String, dynamic>?> getUserAvatar(String docId) async {
    CollectionReference users = _firestore.collection('users');
    try {
      DocumentSnapshot docSnapshot = await users.doc(docId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        print("No document found for the given docId.");
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving avatar URL: $e");
      }
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getUserWorkoutGoal(String docId) {
    try {
      return _firestore.collection('goals').doc(docId).snapshots();
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving workout goal: $e");
      }
      rethrow;
    }
  }

  Future<void> updateUser(String email, String fullName, String? imageUrl,
      {String? gender, String? dob}) async {
    CollectionReference users = _firestore.collection('users');

    print("Update user receive ${imageUrl}");
    try {
      String docId = firebaseAuthService.currentUser?.uid ?? "";
      print("Update user id ${docId}");

      if (docId.isNotEmpty && docId != "") {
        await users.doc(docId).update({
          'fullName': fullName,
          'avatarImage': imageUrl,
          'dob': dob,
          'gender': gender
        });
        await firebaseAuthService.currentUser
            ?.updateProfile(displayName: fullName);
        print("Update success fully");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> updateUserTarget(
      {required String type, required String value}) async {
    CollectionReference users = _firestore.collection('goals');

    try {
      String docId = firebaseAuthService.currentUser?.uid ?? "";
      print("Update user id ${docId}");
      Map<String, dynamic> payload = {};
      if (type == 'Steps') {
        payload = {
          'steps': value,
        };
      }
      if (type == 'Active Calories') {
        payload = {
          'calories': value,
        };
      }

      if (type == 'Sleep') {
        payload = {
          'sleeps': value,
        };
      }
      print("Update successful for type: $type with value: $value");

      if (docId.isNotEmpty && docId != "") {
        await users.doc("VeUtIDdNqsMVGknkbeBeBQhcT7S2").update(payload);
        print("Update successful for type: $type with value: $value");
        print("Update success fully");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<AuthModel> getEmail(String uid) async {
    final FirebaseAuth? auth = firebaseAuthService?.getAuth;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (auth != null) {
      try {
        String userId = auth.currentUser!.uid;

        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(uid).get();

        if (snapshot.exists) {
          String email = snapshot['email'];
          String fullname = snapshot['fullName'];

          print('User email: $email, Fullname: $fullname');

          return AuthModel(fullname: fullname, email: email);
        } else {
          throw Exception("User not found in Firestore.");
        }
      } on FirebaseException catch (e) {
        // Handle Firestore specific errors
        throw handleFirebaseErrorResponse(e);
      }
    } else {
      print('FirebaseAuth is not initialized.');
      throw UnknownException(
          message: "Oops", title: "'FirebaseAuth is not initialized.");
    }
  }
}

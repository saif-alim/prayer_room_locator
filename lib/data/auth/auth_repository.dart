import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/firebase_providers.dart';
import 'package:prayer_room_locator/utils/error-handling/type_defs.dart';
import 'package:prayer_room_locator/data/auth/user_model.dart';

// Provider for AuthRepository
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  ),
);

// Repository class that handles authentication and user management
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;

  // Gets access to the users collection in Firestore
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  // Stream that notifies auth state changes
  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Handles sign up of the user and user creation
  FutureEither<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      // Ensures that no fields are left empty
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return left(Failure('Fields must not be empty'));
      }
      // register user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel; // Initialise data class

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: name,
          email: email,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(Failure('Email is already in use'));
      } else if (e.code == 'invalid-email') {
        return left(Failure('Email is invalid'));
      } else if (e.code == 'weak-password') {
        return left(Failure('Password must be at least 6 characters'));
      }
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Handles login of the user
  FutureEither<UserModel> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return left(Failure('Fields must not be empty'));
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return left(Failure('Email or password is invalid'));
      } else if (e.code == 'wrong-password') {
        return left(Failure('Password is incorrect'));
      } else if (e.code == 'user-not-found') {
        return left(Failure('User Not Found'));
      }
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Method to log out the current user
  void logOut() async {
    await _auth.signOut();
  }

  // Retrieve user's data by UID
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  // Retrieve user's data by email
  Stream<UserModel?> getUserByEmail(String email) {
    return _users
        .where('email', isEqualTo: email.toLowerCase())
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Retrieve authenticated users' data from Firestore
  Stream<List<UserModel>> getUsers() {
    return _users
        .where('isAuthenticated', isEqualTo: true)
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var doc in event.docs) {
        users.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return users;
    });
  }

  FutureVoid editUser(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

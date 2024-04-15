import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/utils/error-handling/failure.dart';
import 'package:prayer_room_locator/data/firebase_providers.dart';
import 'package:prayer_room_locator/utils/error-handling/type_defs.dart';
import 'package:prayer_room_locator/data/auth/user_model.dart';

// Provider for AuthRepository
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

// Repository class that handles authentication and user management
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  // Gets access to the users collection in Firestore
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  // Stream that notifies auth state changes
  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Handles Google Sign-In and user creation/updating
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          email: userCredential.user!.email ?? 'No Email',
          uid: userCredential.user!.uid,
          isAuthenticated: true,
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Handles sign up of the user and user creation
  FutureEither<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw 'Fields must not be empty';
      }
      // register user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel;

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
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  // Method to log out the current user
  void logOut() async {
    await _googleSignIn.signOut();
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
}

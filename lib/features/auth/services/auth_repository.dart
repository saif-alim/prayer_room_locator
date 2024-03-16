// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/core/constants/firebase_constants.dart';
import 'package:prayer_room_locator/core/failure.dart';
import 'package:prayer_room_locator/core/providers/firebase_providers.dart';
import 'package:prayer_room_locator/core/type_defs.dart';
import 'package:prayer_room_locator/models/user_model.dart';
import 'package:prayer_room_locator/utils/show_snack_bar.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

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

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Google Sign In
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
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
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

  // Email Login
  FutureEither<UserModel> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      debugPrint('Email from repository: $email');
      debugPrint('Email from repository: $email');
      debugPrint('Email from repository: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel userModel;
      userModel = await getUserData(userCredential.user!.uid).first;

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Email Sign Up
  FutureEither<UserModel> signupWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      debugPrint('Email from repostory: $email');
      debugPrint('Email from repostory: $email');
      debugPrint('Email from repostory: $email');
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await sendEmailVerification(context);

      UserModel userModel;

      userModel = UserModel(
        name: userCredential.user!.displayName ?? 'No Name',
        email: userCredential.user!.email ?? 'No Email',
        profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: true,
      );

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!; // error display
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Email Verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // displays error message on screen
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}

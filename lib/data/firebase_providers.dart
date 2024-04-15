import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Firebase related providers

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider.autoDispose((ref) => FirebaseAuth.instance);
final storageProvider = Provider.autoDispose((ref) => FirebaseStorage.instance);
final googleSignInProvider = Provider.autoDispose((ref) => GoogleSignIn());

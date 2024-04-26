import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/auth/auth_repository.dart';
import 'package:prayer_room_locator/data/auth/user_model.dart';
import 'package:prayer_room_locator/utils/common/utils.dart';
import 'package:routemaster/routemaster.dart';

// Provider to manage user information globally
final userProvider = StateProvider<UserModel?>((ref) => null);

// Provider to manage authentication state
final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

// Provider to listen to auth state changes
final authStateChangeProvider = StreamProvider.autoDispose<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// Provider to retrieve user data based on UID
final getUserDataProvider =
    StreamProvider.autoDispose.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// Provider to retrieve user data based on email
final getUserByEmailProvider =
    StreamProvider.autoDispose.family((ref, String email) {
  return ref.watch(authControllerProvider.notifier).getUserByEmail(email);
});

// AuthController class for managing authentication logic
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // Initializes with 'false' indicating not loading

  // Stream to get auth state changes
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    final user = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      context: context,
    );
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      Routemaster.of(context).replace('/');
    });
  }

  void loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final user = await _authRepository.loginWithEmail(
      email: email,
      password: password,
      context: context,
    );
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      Routemaster.of(context).replace('/');
    });
  }

  // Method to handle user log out
  void logOut() async {
    _authRepository.logOut();
  }

  // Get user data by UID
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  // Get user data by email
  Stream<UserModel?> getUserByEmail(String email) {
    return _authRepository.getUserByEmail(email);
  }

  // Get all users data
  Stream<List<UserModel>> getUsers() {
    return _authRepository.getUsers();
  }

  // Method to edit user details
  void editLocation({
    required String newDisplayName,
    required UserModel user,
    required BuildContext context,
  }) async {
    user = user.copyWith(name: newDisplayName);
    final result = await _authRepository.editUser(user);

    result.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Success!'));
  }
}

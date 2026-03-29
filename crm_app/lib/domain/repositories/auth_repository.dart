import 'package:supabase_flutter/supabase_flutter.dart' show AuthResponse, User;

abstract class AuthRepository {
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  User? get currentUser;
  Stream<User?> get authStateChanges;
}

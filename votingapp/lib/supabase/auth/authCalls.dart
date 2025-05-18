import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> insertUserDetails({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    await supabase.from('users').insert({...userData, 'user_id': userId});
  }
}

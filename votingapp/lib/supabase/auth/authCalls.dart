import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  Future<void> insertVoterDetails({
    required String userId,
    required Map<String, dynamic> voterData,
  }) async {
    await supabase.from('voters').insert({...voterData, 'id': userId});
  }
}

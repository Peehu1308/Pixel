import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      final userId = currentUser.id;
      final userEmail = currentUser.email;


      final byId = await supabase
          .from('Users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (byId != null) return byId;


      if (userEmail != null) {
        final byEmail = await supabase
            .from('Users')
            .select()
            .eq('Email', userEmail)
            .maybeSingle();

        return byEmail;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}

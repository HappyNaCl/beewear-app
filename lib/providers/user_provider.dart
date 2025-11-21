import 'package:beewear_app/domain/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateUser(User user) {
    state = user;
  }
}

final currentUserProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

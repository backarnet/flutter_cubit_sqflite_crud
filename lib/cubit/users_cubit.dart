import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/data/user_repository.dart';

import '../models/user.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState([]));
  final UserRepository _userRepository = UserRepository();

  Future<void> refresh() async {
    state.users = await _userRepository.getAllUsers();
    emit(UsersState(state.users));
  }

  Future<void> addUser(User user) async {
    _userRepository.addUser(user);
    refresh();
  }

  Future<void> delUser(int id) async {
    _userRepository.deleteUser(id);
    refresh();
  }

  Future<void> editUser(User user) async {
    _userRepository.updateUser(user);
    refresh();
  }
}

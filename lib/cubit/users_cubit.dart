import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState([]));

  void refresh() => emit(UsersState(state.users));

  void addUser(User user) {
    state.users.add(user);
    refresh();
  }

  void delUser(User user) {
    state.users.remove(user);
    refresh();
  }
}

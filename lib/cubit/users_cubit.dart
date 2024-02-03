import 'package:flutter_bloc/flutter_bloc.dart';

import '../data.dart';
import '../models/user.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState(users));

  void refresh() => emit(UsersState(state.usersCubitList));

  void addUser(User user) {
    state.usersCubitList.add(user);
    refresh();
  }
}

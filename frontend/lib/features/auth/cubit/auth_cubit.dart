import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/models/user_model.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  AuthRemoteRepository authRemoteRepository = AuthRemoteRepository();
  void singUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthInitial());
      await authRemoteRepository.signUp(
          name: name, email: email, password: password);
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthInitial());
      UserModel userModel =
          await authRemoteRepository.login(email: email, password: password);
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

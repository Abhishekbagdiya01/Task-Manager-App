import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/shared_pref.dart';
import 'package:frontend/features/auth/models/user_model.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthRemoteRepository authRemoteRepository = AuthRemoteRepository();
  final AuthLocalRepository authLocalRepository = AuthLocalRepository();
  SharedPref pref = SharedPref();
  void singUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
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
      emit(AuthLoading());
      UserModel userModel =
          await authRemoteRepository.login(email: email, password: password);

      if (userModel.token.isNotEmpty) {
        await pref.setToken(userModel.token);
      }

      authLocalRepository.insertUser(userModel);
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void getUserData() async {
    try {
      emit(AuthLoading());
      UserModel? userModel = await authRemoteRepository.getUserData();
      authLocalRepository.insertUser(userModel!);
      emit(AuthLoggedIn(userModel));
    } catch (e) {
      UserModel? userModel = await authLocalRepository.getUser();
      if (userModel != null) {
        emit(AuthLoggedIn(userModel));
      }
      emit(AuthError(e.toString()));
    }
  }
}

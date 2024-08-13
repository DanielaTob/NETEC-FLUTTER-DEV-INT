import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/auth_service.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;
  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final isSuccess =
            await authService.login(event.username, event.password);
        if (isSuccess) {
          emit(LoginSuccess());
        } else {
          emit(const LoginFailure(error: "Invalid username or password"));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import './authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
    if (event is LoginButtonPressed) {
      yield AuthenticationLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if (token == null) {
          yield AuthenticationFailure(error: 'Incorrect Credentials');
        } else {
          await userRepository.persistToken(token);
          yield AuthenticationAuthenticated();
        }
        //yield AuthenticationFailure(error: "test");
      } catch (error) {
        yield AuthenticationFailure(error: error.toString());
      }
    }
  }
}

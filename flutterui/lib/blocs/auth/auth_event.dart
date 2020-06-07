part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AppStarted extends AuthEvent{
  @override
  List<Object> get props => [];

}
class LoggedIn extends AuthEvent{
  @override
  List<Object> get props => [];

}

class LogedOut extends AuthEvent{
  @override
  List<Object> get props => [];

}

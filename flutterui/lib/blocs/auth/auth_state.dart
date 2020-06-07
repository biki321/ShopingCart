part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class Authenticated extends AuthState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
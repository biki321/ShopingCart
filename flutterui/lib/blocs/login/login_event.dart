part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

//to add this event when user is editing email
class ChangeingEmail extends LoginEvent{
  String _email;
  ChangeingEmail(this._email);
  @override
  List<Object> get props => [];

}
//to add this event when user is editing password
class ChangeingPassword extends LoginEvent{
  String _password;
  ChangeingPassword(this._password);
  @override
  List<Object> get props => [];

}

class Submitting extends LoginEvent{
  String _email;
  String _password;

  Submitting( this._email, this._password );
  @override
  List<Object> get props => [];


}

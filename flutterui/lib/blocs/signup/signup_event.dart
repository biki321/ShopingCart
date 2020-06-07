part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

//to add this event when user is editing email
class ChangeingEmail extends SignupEvent{
  String _email;
  ChangeingEmail(this._email);
  @override
  List<Object> get props => [_email];

}
//to add this event when user is editing username
class ChangeingUserName extends SignupEvent{
  String _userName;
  ChangeingUserName(this._userName);
  @override
  List<Object> get props => [_userName];

}

//to add this event when user is editing password
class ChangeingPassword extends SignupEvent{
  String _password;
  ChangeingPassword(this._password);
  @override
  List<Object> get props => [_password];

}

class Submitting extends SignupEvent{
  String _userName;
  String _email;
  String _password;

  Submitting( this._userName, this._email, this._password );
  @override
  List<Object> get props => [_userName, _email, _password];


}

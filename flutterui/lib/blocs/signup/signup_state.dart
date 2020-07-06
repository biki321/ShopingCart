part of 'signup_bloc.dart';

class SignupState {
  bool isvalidUserName;
  bool isvalidEmail;
  bool isvalidPassword;
  bool isTryingToSignup;
  //this error will contains information about the error(if any)
  //after submitting the login details
  String error;
  String success;

  bool get isFormValid => isvalidEmail && isvalidPassword && isvalidUserName;

  SignupState({
    @required this.isvalidUserName,
    @required this.isvalidEmail,
    @required this.isvalidPassword,
    @required this.isTryingToSignup,
    this.error,
    this.success,
  });

  factory SignupState.empty() {
    return SignupState(
      isvalidEmail: true,
      isvalidPassword: true,
      isvalidUserName: true,
      isTryingToSignup: false,
      error: '',
      success: '',
    );
  }

  SignupState update({
    bool isvalidUserName,
    bool isvalidEmail,
    bool isvalidPassword,
    bool isTryingToSignup,
    String error,
    String success,
  }) {
    return SignupState(
      isvalidEmail: isvalidEmail ?? this.isvalidEmail,
      isvalidPassword: isvalidPassword ?? this.isvalidPassword,
      isvalidUserName: isvalidUserName ?? this.isvalidUserName,
      error: error ?? this.error,
      success: success ?? this.success,
      isTryingToSignup: isTryingToSignup ?? this.isTryingToSignup,
    );
  }

  @override
  String toString() {
    return '''
    isvalidEmail: $isvalidEmail,
    isvallidPassword: $isvalidPassword,
    isvalidUserName: $isvalidUserName,
    isvalidForm: $isFormValid,
    isTryingToSignup: $isTryingToSignup,
     error: $error,
    success: $success,
    ''';
  }
}

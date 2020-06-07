part of 'login_bloc.dart';

class LoginState {
  bool isvalidEmail;
  bool isvalidPassword;
  bool istryingToLogIn;
  //this error will contains information about the error(if any)
  //after submitting the login details
  String error;
  String success;

  bool get isFormValid => isvalidEmail && isvalidPassword;

  LoginState({
    this.isvalidEmail,
    this.isvalidPassword,
    this.istryingToLogIn,
    this.error,
    this.success,
  });

  factory LoginState.empty() {
    return LoginState(
      isvalidEmail: true,
      isvalidPassword: true,
      istryingToLogIn: false,
      error: '',
      success: '',
    );
  }

  LoginState update({
    bool isvalidEmail,
    bool isvalidPassword,
    bool istryingToLogIn,
    String error,
    String success,
  }) {
    return LoginState(
      isvalidEmail: isvalidEmail ?? this.isvalidEmail,
      isvalidPassword: isvalidPassword ?? this.isvalidPassword,
      istryingToLogIn: istryingToLogIn ?? this.istryingToLogIn,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  // LoginState tryingToLogIn({bool istryingToLogIn}) {
  //   return LoginState(
  //     istryingToLogIn: istryingToLogIn ?? this.istryingToLogIn,
  //   );
  // }

  @override
  String toString() {
    return '''
    isvalidEmail: $isvalidEmail,
    isvallidPassword: $isvalidPassword,
    isvalidForm: $isFormValid,
    istryingToLogIn: $istryingToLogIn,
    error: $error,
    success: $success,
    ''';
  }
}

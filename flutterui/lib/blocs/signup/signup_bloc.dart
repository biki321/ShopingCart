//import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterui/services/authentication.dart';
import 'package:flutterui/services/validation.dart';
import 'package:http/http.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  @override
  SignupState get initialState => SignupState.empty();

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is ChangeingUserName) {
      bool u = isValidUserName(event._userName);

      yield state.update(isvalidUserName: u, error: '');
      print(state);
    } else if (event is ChangeingEmail) {
      bool e = isValidEmail(event._email);

      yield state.update(isvalidEmail: e, error: '');
    } else if (event is ChangeingPassword) {
      bool p = isValidPassword(event._password);
      yield state.update(isvalidPassword: p, error: '');
    } else if (event is Submitting) {
      yield state.update(success: '', error: '', isTryingToSignup: true);      
      print('subitting');
      Response res =
          await attemptSignUp(event._userName, event._email, event._password);
      print(jsonDecode(res.body));
      if (res.statusCode == 400) {
        print(" 400: ${res.statusCode}");
        var err = jsonDecode(res.body)['err'];
        yield state.update(error: err, success: '', isTryingToSignup: false);
      } else if (res.statusCode == 200) {
        var success = jsonDecode(res.body)['success'];
        yield state.update(
            success: success, error: '', isTryingToSignup: false);
      }
    }
  }
}

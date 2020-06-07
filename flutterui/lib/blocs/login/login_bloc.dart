//import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterui/services/validation.dart';
import 'package:flutterui/services/authentication.dart';
import 'package:http/http.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is ChangeingEmail) {
      bool e = isValidEmail(event._email);

      yield state.update(isvalidEmail: e, error: '');
      print(state);
    } else if (event is ChangeingPassword) {
      bool p = isValidPassword(event._password);
      yield state.update(isvalidPassword: p, error: '');
    } else if (event is Submitting) {
      print('subitting');

      //yield state.update( istryingToLogIn: true );

      Response res = await attemptLogIn(event._email, event._password);
      print(res);
      if (res.statusCode == 400) {
        var err = jsonDecode(res.body)['err'];
        yield state.update(error: err, istryingToLogIn: false);
      } else if (res.statusCode == 200) {
        storejwt(res.headers['jwt']);
        var success = jsonDecode(res.body)['success'];
        yield state.update(success: success, error: '', istryingToLogIn: false);
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/login/login_bloc.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  LoginBloc _loginBloc;
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailEditingController.addListener(_onEmailChanged);
    _passwordEditingController.addListener(_onPasswordChanged);
  }

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.error != '') {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ));
          } else if (state.success != '') {
            Navigator.pushNamed(context, '/homePage');
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.blue),
                            errorText:
                                !state.isvalidEmail ? 'Invalid Email' : null,
                            labelText: 'email',
                            hintText: 'test@test.com'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordEditingController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorText: !state.isvalidPassword
                              ? 'Invalid Password'
                              : null,
                          labelText: 'password',
                          labelStyle: TextStyle(color: Colors.blue),
                          hintText: '8-20 char long(@, _ , - can be included)',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        onPressed: isLoginButtonEnabled(state)
                            ? () {
                                //to hide the keyboard after hitting login
                                FocusScope.of(context).unfocus();
                                _loginBloc.add(Submitting(
                                    _emailEditingController.text,
                                    _passwordEditingController.text));
                              }
                            : null,
                        child: Text('LogIn'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signupPage');
                        },
                        child: Text('Create Account'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

                //this is for circularprogressbar indicator during authenticaitng
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state.istryingToLogIn) {
                    return Stack(
                      children: [
                        new Opacity(
                          opacity: 0.3,
                          child: const ModalBarrier(
                              dismissible: false, color: Colors.grey),
                        ),
                        new Center(
                          child: new CircularProgressIndicator(),
                        ),
                      ],
                    );
                  } else
                    return Container(width: 0.0, height: 0.0,);
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(ChangeingEmail(_emailEditingController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(ChangeingPassword(_passwordEditingController.text));
  }
}

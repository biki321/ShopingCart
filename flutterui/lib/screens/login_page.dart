import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/login/login_bloc.dart';
import 'package:flutterui/components/cardCircularLoader.dart';
import 'package:flutterui/components/snackBar.dart';

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
    return new Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.error != '') {
          Scaffold.of(context).showSnackBar(snackBar('', state.error));
        } else if (state.success != '') {
          Navigator.pushNamed(context, '/homePage');
        }
      },
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text('Hey',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 180.0, 0.0, 0.0),
                        child: Text('There',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(230.0, 175.0, 0.0, 0.0),
                        child: Text('.',
                            style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 245, 82, 21),
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (BuildContext context, LoginState state) {
                        return Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monterrat'),
                                  errorText: !state.isvalidEmail
                                      ? 'Invalid Email'
                                      : null,
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
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Monterrat'),
                                hintText:
                                    '8-20 char long(@, _ , - can be included)',
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              child: InkWell(
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 245, 82, 21),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.greenAccent,
                                color: Color.fromARGB(255, 245, 82, 21),
                                elevation: 7.0,
                                child: GestureDetector(
                                  onTap: isLoginButtonEnabled(state)
                                      ? () {
                                          //to hide the keyboard after hitting login
                                          FocusScope.of(context).unfocus();
                                          _loginBloc.add(Submitting(
                                              _emailEditingController.text,
                                              _passwordEditingController.text));
                                        }
                                      : null,
                                  child: Center(
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to Sports ?',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/signupPage');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 82, 21),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25.0),
              ],
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state.istryingToLogIn) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ModalBarrier(
                      dismissible: false,
                    ),
                  );
                } else
                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );
              },
            ),
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              if (state.istryingToLogIn) {
                return cardCircularLoader();
              } else
                return Container(
                  width: 0.0,
                  height: 0.0,
                );
            }),
          ],
        ),
      ),
    ));
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

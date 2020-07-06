import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/signup/signup_bloc.dart' as signup;
import 'package:flutterui/components/cardCircularLoader.dart';
import 'package:flutterui/components/snackBar.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _userNameEditingController =
      TextEditingController();

  signup.SignupBloc _signupBloc;

  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<signup.SignupBloc>(context);
    _userNameEditingController.addListener(_onUserNameChanged);
    _emailEditingController.addListener(_onEmailChanged);
    _passwordEditingController.addListener(_onPasswordChanged);
  }

  bool isSignupButtonEnabled(signup.SignupState state) {
    return state.isFormValid;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: BlocListener<signup.SignupBloc, signup.SignupState>(
      listener: (context, state) {
        if (state.error != '') {
          Scaffold.of(context).showSnackBar(snackBar('', state.error));
        } else if (state.success != '') {
          Navigator.pushReplacementNamed(context, '/loginPage');
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
                        child: Text('SignUp',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(270.0, 110.0, 0.0, 0.0),
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
                    child: BlocBuilder<signup.SignupBloc, signup.SignupState>(
                      builder:
                          (BuildContext context, signup.SignupState state) {
                        return Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _userNameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.blue),
                                  errorText: !state.isvalidUserName
                                      ? 'Invalid Username'
                                      : null,
                                  labelText: 'username',
                                  hintText: 'biki123'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.blue),
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
                                labelStyle: TextStyle(color: Colors.blue),
                                hintText:
                                    '8-20 char long(@,_,- can be included)',
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
                                  onTap: isSignupButtonEnabled(state)
                                      ? () {
                                          FocusScope.of(context).unfocus();
                                          _signupBloc.add(signup.Submitting(
                                              _userNameEditingController.text,
                                              _emailEditingController.text,
                                              _passwordEditingController.text));
                                        }
                                      : null,
                                  child: Center(
                                    child: Text(
                                      'SIGNUP',
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
              ],
            ),
            BlocBuilder<signup.SignupBloc, signup.SignupState>(
              builder: (context, state) {
                if (state.isTryingToSignup) {
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
            BlocBuilder<signup.SignupBloc, signup.SignupState>(
                builder: (context, state) {
              if (state.isTryingToSignup) {
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
    _userNameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  void _onUserNameChanged() {
    _signupBloc.add(signup.ChangeingUserName(_userNameEditingController.text));
  }

  void _onEmailChanged() {
    _signupBloc.add(signup.ChangeingEmail(_emailEditingController.text));
  }

  void _onPasswordChanged() {
    _signupBloc.add(signup.ChangeingPassword(_passwordEditingController.text));
  }

  void _onPressed() {
    _signupBloc.add(signup.Submitting(_userNameEditingController.text,
        _emailEditingController.text, _passwordEditingController.text));
  }
}

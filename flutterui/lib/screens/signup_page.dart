import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/signup/signup_bloc.dart' as signup;

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
    return Scaffold(
        body: BlocListener<signup.SignupBloc, signup.SignupState>(
      listener: (context, state) {
        if (state.error != '') {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
          ));
        } else if (state.success != '') {
          Navigator.pushReplacementNamed(context, '/loginPage');
        }
      },
      child: BlocBuilder<signup.SignupBloc, signup.SignupState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _userNameEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blue),
                      errorText:
                          !state.isvalidUserName ? 'Invalid Username' : null,
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
                      errorText: !state.isvalidEmail ? 'Invalid Email' : null,
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
                    errorText:
                        !state.isvalidPassword ? 'Invalid Password' : null,
                    labelText: 'password',
                    labelStyle: TextStyle(color: Colors.blue),
                    hintText: '8-20 char long(@,_,- can be included)',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: isSignupButtonEnabled(state)
                      ? () {
                          FocusScope.of(context).unfocus();
                          _signupBloc.add(signup.Submitting(
                              _userNameEditingController.text,
                              _emailEditingController.text,
                              _passwordEditingController.text));
                        }
                      : null,
                  // onPressed: (){
                  //   Navigator.pop(context);
                  // },
                  child: Text('SignUp'),
                ),
              ],
            ),
          );
        },
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

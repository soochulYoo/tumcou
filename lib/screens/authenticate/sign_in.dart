import 'package:flutter/material.dart';
import 'package:tumcou1/main.dart';
import 'package:tumcou1/screens/authenticate/forgot_passsword.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/shared/constants.dart';
import 'package:tumcou1/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text fields state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.green[50],
            resizeToAvoidBottomPadding: false,
            body: Column(children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'TumCou',
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.blueGrey[700],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                      letterSpacing: 6.5,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Row(children: <Widget>[
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                    flex: 6,
                    child: Column(
                      children: <Widget>[
                        Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 0.0),
                                TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                      ),
                                      hintText: 'Email',
                                    ),
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    }),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                  ),
                                  validator: (val) => val.length < 6
                                      ? '6자 이상의 비밀번호를 입력하세요'
                                      : null,
//obscure password
                                  obscureText: true,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Column(children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword()),
                                      );
                                    },
                                    child: Text('Forgot Password'),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          color:
                                              Color.fromRGBO(182, 194, 183, 50),
                                          child: Text('Sign in',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() => loading = true);
                                              dynamic result = await _auth
                                                  .signInWithEmailPassword(
                                                      email, password);
                                              if (result == null) {
                                                setState(() => [
                                                      error =
                                                          'could not sign in with those credentials',
                                                      loading = false
                                                    ]);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          color: Color.fromRGBO(
                                              182, 194, 183, 100),
                                          child: Text(
                                            'Register',
                                          ),
                                          onPressed: () {
                                            widget.toggleView();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  Flexible(flex: 1, child: Container()),
                ]),
              ),
              Flexible(flex: 1, child: Container()),
            ]));
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(
        Radius.circular(50.0) //         <--- border radius here
        ),
    color: Colors.white,
    boxShadow: [BoxShadow(color: Colors.white, blurRadius: 5)],
  );
}

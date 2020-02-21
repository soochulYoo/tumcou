import 'package:flutter/material.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text fields state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        resizeToAvoidBottomPadding: false,
        body: Column(children: <Widget>[
          Flexible(flex: 1, child: Container()),
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
            flex: 5,
            child: Row(children: <Widget>[
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 6,
                child: Column(children: <Widget>[
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                              decoration: textInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.account_circle),
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
                            validator: (val) =>
                                val.length < 6 ? '6자 이상의 비밀번호를 입력하세요' : null,
                            //obscure password
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color.fromRGBO(182, 194, 183, 50),
                                  child: Text('Register',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      dynamic result =
                                          await _auth.registerWithEmailPassword(
                                              email, password);

                                      if (result == null) {
                                        setState(() => error =
                                            'please supply a valid email');
                                      }
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FlatButton.icon(
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  icon: Icon(Icons.backspace),
                                  label: Text('Back'),
                                ),
                              )
                            ],
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      )),
                ]),
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

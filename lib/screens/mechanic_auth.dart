import 'package:flutter/material.dart';
import 'package:vehicle_service_provider/screens/user_auth.dart';

class MechanicAuth extends StatelessWidget {
  static const routeName="/mechanic";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: Image.asset(
                "assets/v2.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: ()=>Navigator.of(context).pushReplacementNamed(UserAuth.routeName),
              child: Text("Login as a User"),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).accentColor),
                // shadowColor: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            AuthCard(),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isSignInMode = true;
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };
  final _passwordController = TextEditingController();

  void _submit() {
    _formKey.currentState.save(); // this triggers onSaved(){} of all fields
    if (_isSignInMode) {
      //Sign In
    } else {
      //..Sign Up
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignInMode = !_isSignInMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("AuthCard Building...");
    return Form(
      key: _formKey,
      child: Container(
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "E-mail"),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                print("OnSaved triggered in Email");
                _authData['email'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              onSaved: (value) {
                print("OnSaved triggered in Password");
                _authData['password'] = value;
              },
            ),
            if (!_isSignInMode)
              TextFormField(
                enabled: !_isSignInMode,
                decoration: InputDecoration(labelText: "Confirm password"),
                obscureText: false,
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text(_isSignInMode ? 'LOGIN' : 'SIGN UP'),
                onPressed: _submit,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
            FlatButton(
              child: Text('${_isSignInMode ? 'SIGN UP' : 'LOGIN'} Instead'),
              onPressed: _toggleAuthMode,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textColor: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

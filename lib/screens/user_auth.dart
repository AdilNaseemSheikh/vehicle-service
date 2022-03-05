import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/models/http_exception.dart';
import 'package:vehicle_service_provider/provider/auth.dart';
import 'package:vehicle_service_provider/screens/mechanic_auth.dart';

class UserAuth extends StatelessWidget {
  static const routeName = "/user";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              height: 15,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  "Vehicle Service Provider",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
              width: 300,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 9.0,
                  ),
                ],
                color: Color.fromRGBO(74, 78, 248, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
            ),
            SizedBox(
              height: 20,
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

  void showErrorDialogue(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text("Something went Wrong"),
                content: Text(msg),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"))
                ]));
  }

  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.save(); // this triggers onSaved(){} of all fields
    try {
      if (_isSignInMode) {
        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (e) {
      var errorMsg = "Something";
      if (e.toString().contains("EMAIL_EXISTS")) {
        errorMsg = "Email already exists. Try Signing-In";
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMsg = "Invalid email";
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMsg = "Password is too weak";
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMsg = "Email not found. Try signing-Up";
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMsg = "Invalid Password";
      }
      showErrorDialogue(errorMsg);
    } catch (e) {
      var errorMsg = "Authentication failed.";
      showErrorDialogue(errorMsg);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignInMode = !_isSignInMode;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _authData['email'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
            if (!_isSignInMode)
              TextFormField(
                enabled: !_isSignInMode,
                decoration: InputDecoration(labelText: "Confirm password"),
                obscureText: true,
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RaisedButton(
                      child: Text(_isSignInMode ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
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

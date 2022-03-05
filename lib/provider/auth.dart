import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vehicle_service_provider/models/http_exception.dart';

class Auth with ChangeNotifier {
  String token;
  String userId;
  DateTime expiry;

  bool get isAuth {
    return getToken != null;
  }

  String get getToken {
    if (expiry!=null && token != null && expiry.isAfter(DateTime.now())) return token;
    return null;
  }

  String get getUserId {
    return userId;
  }

  void get logout{
    token=null;
    expiry=null;
    userId=null;
    notifyListeners();
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    String myUrl =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC6Amaf7JaiVI6LggxqJOKaol4n9DI0sPY";
    try {
      final response = await http.post(
        myUrl,
        body: json.encode(
          {"email": email, "password": password, "returnSecureToken": true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      token=responseData['idToken'];
      userId=responseData['localId'];
      expiry=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String mail, String pass) async {
    return authenticate(mail, pass, "signUp");
  }

  Future<void> signIn(String mail, String pass) async {
    return authenticate(mail, pass, "signInWithPassword");
  }
}

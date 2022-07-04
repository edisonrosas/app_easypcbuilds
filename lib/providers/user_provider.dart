import 'package:flutter/widgets.dart';
import 'package:turismoapp/models/user.dart';
import 'package:turismoapp/resources/auth_methods.dart';

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}

class UserProvider extends DisposableProvider {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  @override
  void disposeValues() {
    _user = null;
  }
}
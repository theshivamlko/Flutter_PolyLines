

class UserModel {
  String uuid;



  String _username;

  String _password;
  bool _isAdmin;
  String googleToken;
  bool txtFieldValue;
  String source;
  String email;

  UserModel();

  // UserModel(this._username, this._email, this._password,this._isAdmin);

  String get password => _password;


  String get username => _username;

  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) {
    _isAdmin = value;
  }


  set username(String value) {
    _username = value;
  }
}

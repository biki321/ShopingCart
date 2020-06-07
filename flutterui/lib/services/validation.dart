
RegExp  reEmail = RegExp(r"^([a-z\d\.-]+)@([a-z\d-]+)\.([a-z]{2,8})(\.[a-z]{2,8})?$");
RegExp  reUserName = RegExp(r"^[a-zA-Z\d]{4,30}$");
RegExp  rePassword = RegExp(r"^[\d\w@-]{6,20}$");

bool isValidEmail(String email) => reEmail.hasMatch(email);
bool isValidUserName(String name) => reUserName.hasMatch(name);
bool isValidPassword(String password) => rePassword.hasMatch(password);

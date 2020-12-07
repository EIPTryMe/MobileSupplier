class Validator {
  static String nameValidator(String name) {
    return (null);
  }

  static String phoneValidator(String phone) {
    return (null);
  }

  static String emailValidator(String email) {
    if (email.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email))
      return ("Adresse mail invalide");
    return (null);
  }
}
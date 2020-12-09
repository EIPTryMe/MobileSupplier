class Validator {
  static String nameValidator(String name) {
    return (null);
  }

  static String phoneValidator(String phone) {
    if (phone.isNotEmpty && !RegExp(r"^[0-9]{10}$").hasMatch(phone))
      return ("Téléphone invalide");
    return (null);
  }

  static String emailValidator(String email) {
    if (email.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email))
      return ("Adresse mail invalide");
    return (null);
  }

  static String siretValidator(String siret) {
    if (siret.isNotEmpty && !RegExp(r"^[0-9]{14}$").hasMatch(siret))
      return ("Siret invalide");
    return (null);
  }

  static String sirenValidator(String siren) {
    if (siren.isNotEmpty && !RegExp(r"^[0-9]{9}$").hasMatch(siren))
      return ("Siren invalide");
    return (null);
  }
}
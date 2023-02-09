class Validator {
  static String? validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    Pattern pattern = r'^.{4,}$';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 4 characters.';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String value1, String value2) {
    if (value1 != value2) {
      return 'Those passwords didn’t match. Try again.';
    } else {
      return null;
    }
  }

  static String? validateForm(String value) {
    if (value.isEmpty) {
      return 'This field is mandatory';
    } else {
      return null;
    }
  }
}

abstract class ValidateFunction {
  //? Validate Email

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Please Enter Right Email';
    }
    return null;
  }
  //? Validate Password

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';

    // Minimum length
    if (value.length < 8) return 'Password must be at least 8 characters long';

    // At least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // At least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // At least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }
}

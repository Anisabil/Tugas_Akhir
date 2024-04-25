class FVValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName diperlukan';
    }

    return null;
  }

  // Username validation
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }

    // Define a regular expression pattern for the username
    const pattern = r"^[a-zA-Z0-9_-]{3,20}$";

    // Create a RegExp instance from the pattern
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the username matches the pattern
    bool isValid = regex.hasMatch(username);

    // Check if the username doesn't start or end with an underscore or hyphen
    if (isValid) {
      isValid = !username.startsWith('_') &&
          !username.startsWith('-') &&
          !username.endsWith('_') &&
          !username.endsWith('-');
    }

    if (isValid) {
      return 'Username is not valid';
    }

    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email diperlukan';
    }

    //Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Alamat email salah';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi diperlukan';
    }

    if (value.length < 6) {
      return 'Kata sandi minimal 6 karakter';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Kata sandi memiliki minimal satu huruf besar';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Kata sandi memiliki setidaknya satu nomor';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Kata sandi memiliki setidaknya satu karakter khusus';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon diperlukan';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (phoneRegExp.hasMatch(value)) {
      return 'Format nomor telepon tidak valid (diperlukan 10 digit)';
    }

    return null;
  }
}

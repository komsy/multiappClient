
class MValidator {
  //Empty text validation
  static String? validateEmptyText(String? fieldName, String? value){
    if(value == null || value.isEmpty){
      return '$fieldName is required.';
    }
    return null;
  }
  //Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

// Add more custom validators as needed for your specific requirements.
  static String? validateAppKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'App Key is required.';
    }

    // Check for minimum App Key length
    if (value.length < 5) {
      return 'App Key must be at least 6 characters long.';
    }
    return null;
  }


  //Customer pin validator
 static String? validatePinNo(String? value) {
  if (value == null || value.isEmpty) {
    return 'Pin No is required.';
  }

  // Ensure the first character is an uppercase letter
  if (!RegExp(r'^[A-Z]').hasMatch(value[0])) {
    return 'The first character must be an uppercase letter.';
  }


  // Ensure the middle characters are all digits
  if (!RegExp(r'^[A-Z][0-9]{9}[A-Z]$').hasMatch(value)) {
    return 'The middle 9 characters must be numbers.';
  }

  // Ensure the last character is an uppercase letter
  if (!RegExp(r'[A-Z]$').hasMatch(value[value.length - 1])) {
    return 'The last character must be an uppercase letter.';
  }
  // Check for exact Pin No length
  if (value.length != 11) {
    return 'Pin No must be exactly 11 characters long.';
  }
  
  return null; // Validation passed
}

}

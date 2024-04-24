// ignore_for_file: constant_identifier_names

enum AlphabetCase {
  LOWER,
  UPPER,
  BOTH,
}

/// Created on 18 August 2022 By Anmol Limje
class Validator {
  ///Return false if value is not 0-9 and length not having 10 digit Start with 6/7/8/9
  static bool isValidMobileNumber(String? value) {
    if (value!.isNotEmpty) {
      return RegExp(r"^[6789]{1}([0-9]{9})+$", unicode: true).hasMatch(value);
    }
    return false;
  }

  static bool isValidEmailId(String? email) {
    if (email!.isNotEmpty) {
      return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
    }
    return false;
  }

  ///Return false if value is not 0-9 and length not having 6 digit
  static bool isValidPincode(String? value) {
    if (value == null) {
      return false;
    }
    if (RegExp(r"^([0-9]{6})+$", unicode: true).hasMatch(value)) {
      return true;
    }
    return false;
  }

  ///Return true if address contains alphanumeric with (,)(.)(whitespace)
  static bool isValidAddress(String? value) {
    if (value!.isNotEmpty) {
      if (RegExp(r"^[a-zA-Z0-9 &.,!?]+$", unicode: true)
          .hasMatch(value.trim())) {
        return true;
      }
    }
    return false;
  }

  static bool isValidUrl(String? value) {
    if (value!.isNotEmpty) {
      // return Uri.parse(value).isAbsolute;
      return RegExp(
              r"^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$")
          .hasMatch(value);
    }
    return false;
  }

  static bool isValidUrlWithoutHttp(String? value) {
    if (value!.isNotEmpty) {
      // return Uri.parse(value).isAbsolute;
      return RegExp(r"^[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$")
          .hasMatch(value);
    }
    return false;
  }

  ///Return false if value is not 0-9
  static bool isValidNumericValue(String? value) {
    if (value!.isNotEmpty) {
      if (RegExp(r"^([0-9])+$", unicode: true).hasMatch(value)) {
        return true;
      }
    }
    return false;
  }

  ///Return false if value is not 0-9 or (.)
  static bool isValidAmount(String? value) {
    if (value!.isNotEmpty) {
      if (RegExp(r"^([0-9.])+$", unicode: true).hasMatch(value)) {
        return true;
      }
    }
    return false;
  }

  ///Return true if address contains alphanumeric with (whitespace)
  static bool isValidAlphanumeric(String? value) {
    if (value!.isNotEmpty) {
      if (RegExp(r"^[a-zA-Z0-9 &.,'!?%]+$", unicode: true)
          .hasMatch(value.trim())) {
        return true;
      }
    }
    return false;
  }

  ///Return boolean, Only Alphabets check based on the AlphabetCase Enum having default options of both
  static bool isValidAlphabets(String? value,
      {AlphabetCase alphabetCase = AlphabetCase.BOTH}) {
    if (value!.isNotEmpty) {
      if (alphabetCase == AlphabetCase.LOWER) {
        if (RegExp(r"^[a-z]+$", unicode: true).hasMatch(value.trim())) {
          return true;
        }
      } else if (alphabetCase == AlphabetCase.UPPER) {
        if (RegExp(r"^[A-Z]+$", unicode: true).hasMatch(value.trim())) {
          return true;
        }
      } else {
        if (RegExp(r"^[a-zA-Z]+$", unicode: true).hasMatch(value.trim())) {
          return true;
        }
      }
    }
    return false;
  }

  ///Only alphabets with whitespace and .dot is allowed
  static bool isValidAlphabetsWithBlankDotSymbol(String? value,
      {bool isWhitespaceAllowed = true, bool isDotAllowed = true}) {
    if (value!.isNotEmpty) {
      if (isWhitespaceAllowed && isDotAllowed) {
        // ignore: prefer_interpolation_to_compose_strings
        if (RegExp(r"^[a-zA-Z &.,'!?}]+$", unicode: true).hasMatch(value)) {
          return true;
        }
      } else if (isWhitespaceAllowed) {
        if (RegExp(r"^[a-zA-Z &.,'!?}]+$", unicode: true).hasMatch(value)) {
          return true;
        }
      } else {
        if (RegExp(r"^[a-zA-Z&.,'!?}]+$", unicode: true).hasMatch(value)) {
          return true;
        }
      }
    }
    return false;
  }

  static bool isValidDescription(String? value) {
    if (value!.isNotEmpty) {
      // ignore: prefer_interpolation_to_compose_strings
      if (RegExp(r"^[a-zA-Z0-9 &.,'!?%}]+$", unicode: true).hasMatch(value)) {
        return true;
      }
    }
    return false;
  }
}

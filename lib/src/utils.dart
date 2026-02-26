import 'constants.dart';

/// Bias adaptation function as defined in RFC 3492 Section 6.1.
int adapt(int delta, int numPoints, {required bool firstTime}) {
  var d = firstTime ? delta ~/ damp : delta ~/ 2;
  d += d ~/ numPoints;

  var k = 0;
  while (d > (base - tmin) * tmax ~/ 2) {
    d ~/= base - tmin;
    k += base;
  }

  return k + (base - tmin + 1) * d ~/ (d + skew);
}

/// Decodes a basic code point to a digit value in the range 0 to [base]-1.
/// Returns -1 if the code point is not a valid digit.
int decodeDigit(int cp) {
  if (cp >= 48 && cp <= 57) {
    // 0-9
    return cp - 48 + 26;
  } else if (cp >= 65 && cp <= 90) {
    // A-Z
    return cp - 65;
  } else if (cp >= 97 && cp <= 122) {
    // a-z
    return cp - 97;
  }
  return -1;
}

/// Encodes a digit value in the range 0 to [base]-1 to a basic code point.
/// If [upperCase] is true, returns the uppercase form (for A-Z).
int encodeDigit(int digit, {required bool upperCase}) {
  if (digit < 26) {
    return upperCase ? digit + 65 : digit + 97;
  } else if (digit < 36) {
    return digit - 26 + 48;
  }
  throw ArgumentError('Invalid digit: $digit');
}

/// Returns true if [cp] is a basic code point (ASCII < 128).
bool isBasic(int cp) => cp < 128;

/// Returns true if [cp] is a delimiter (usually '-').
bool isDelimiter(int cp) => cp == delimiter;

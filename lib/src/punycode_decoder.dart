import 'dart:convert';
import 'constants.dart';
import 'utils.dart';

/// Punycode decoder as defined in RFC 3492 Section 6.2.
class PunycodeDecoder extends Converter<String, String> {
  /// Creates a new [PunycodeDecoder].
  const PunycodeDecoder();

  @override
  String convert(String input) {
    final inputLen = input.length;
    final inputRunes = input.runes.toList();

    var n = initialN;
    var i = 0;
    var bias = initialBias;

    // Handle the basic code points:
    // Find the last delimiter
    var b = 0;
    for (var j = 0; j < inputLen; j++) {
      if (isDelimiter(inputRunes[j])) b = j;
    }

    final output = <int>[];
    final caseFlags = <bool>[];

    for (var j = 0; j < b; j++) {
      final cp = inputRunes[j];
      if (!isBasic(cp)) {
        throw FormatException(
          'Invalid input: non-basic code point in literal portion',
        );
      }
      output.add(cp);
      caseFlags.add(_isUpperCaseCodePoint(cp));
    }

    // Main decoding loop:
    var index = b > 0 ? b + 1 : 0;
    while (index < inputLen) {
      final oldi = i;
      var w = 1;
      for (var k = base; ; k += base) {
        if (index >= inputLen) {
          throw FormatException('Invalid input: unexpected end of input');
        }
        final digit = decodeDigit(inputRunes[index++]);
        if (digit == -1) {
          throw FormatException('Invalid input: not a valid digit');
        }

        if (digit > (dartMaxInt - i) ~/ w) {
          throw FormatException('Punycode overflow');
        }
        i += digit * w;

        final t = k <= bias ? tmin : (k >= bias + tmax ? tmax : k - bias);
        if (digit < t) {
          final isUpper = _isUpperCaseCodePoint(inputRunes[index - 1]);

          bias = adapt(i - oldi, output.length + 1, firstTime: oldi == 0);

          if (i ~/ (output.length + 1) > dartMaxInt - n) {
            throw FormatException('Punycode overflow');
          }
          n += i ~/ (output.length + 1);
          i %= output.length + 1;

          caseFlags.insert(i, isUpper);
          output.insert(i, n);
          i++;
          break;
        }

        if (w > dartMaxInt ~/ (base - t)) {
          throw FormatException('Punycode overflow');
        }
        w *= base - t;
      }
    }

    // Apply case flags for mixed-case annotation
    final result = StringBuffer();
    for (var j = 0; j < output.length; j++) {
      result.writeCharCode(_applyCase(output[j], caseFlags[j]));
    }

    return result.toString();
  }

  bool _isUpperCaseCodePoint(int cp) {
    if (cp >= 65 && cp <= 90) return true; // A-Z
    final s = String.fromCharCode(cp);
    return s.toUpperCase() == s && s.toLowerCase() != s;
  }

  int _applyCase(int cp, bool upperCase) {
    final s = String.fromCharCode(cp);
    return (upperCase ? s.toUpperCase() : s.toLowerCase()).runes.first;
  }
}

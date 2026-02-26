import 'dart:convert';
import 'constants.dart';
import 'utils.dart';

/// Punycode encoder as defined in RFC 3492 Section 6.3.
class PunycodeEncoder extends Converter<String, String> {
  /// Creates a new [PunycodeEncoder].
  const PunycodeEncoder();

  @override
  String convert(String input) {
    final output = StringBuffer();

    // Appendix A: Mixed-case annotation
    // The encoder expects case-folded input. We normalize it but keep track of the original case.
    final originalRunes = input.runes.toList();
    final inputLen = originalRunes.length;
    final caseFlags = originalRunes.map(_isUpperCaseCodePoint).toList();
    final inputRunes = input.toLowerCase().runes.toList();

    var n = initialN;
    var delta = 0;
    var bias = initialBias;

    // Handle the basic code points:
    for (var i = 0; i < inputLen; i++) {
      if (isBasic(inputRunes[i])) {
        output.writeCharCode(
          encodeBasic(inputRunes[i], upperCase: caseFlags[i]),
        );
      }
    }

    final b = output.length;
    if (b > 0) {
      output.writeCharCode(delimiter);
    }

    var h = b;
    while (h < inputLen) {
      // Find the next smallest non-basic code point >= n
      var m = dartMaxInt;
      for (final cp in inputRunes) {
        if (cp >= n && cp < m) {
          m = cp;
        }
      }

      // Increase delta enough to advance the decoder's <n,i> state to <m,0>
      if (m - n > (dartMaxInt - delta) ~/ (h + 1)) {
        throw Exception('Punycode overflow');
      }
      delta += (m - n) * (h + 1);
      n = m;

      for (var j = 0; j < inputLen; j++) {
        final c = inputRunes[j];
        if (c < n) {
          delta++;
          if (delta == 0 || delta > dartMaxInt) {
            throw Exception('Punycode overflow');
          }
        }

        if (c == n) {
          var q = delta;
          for (var k = base; ; k += base) {
            final t = k <= bias ? tmin : (k >= bias + tmax ? tmax : k - bias);
            if (q < t) break;

            final digit = t + ((q - t) % (base - t));
            output.writeCharCode(encodeDigit(digit, upperCase: false));
            q = (q - t) ~/ (base - t);
          }

          output.writeCharCode(encodeDigit(q, upperCase: caseFlags[j]));

          bias = adapt(delta, h + 1, firstTime: h == b);
          delta = 0;
          h++;
        }
      }
      delta++;
      n++;
    }

    return output.toString();
  }

  bool _isUpperCaseCodePoint(int cp) {
    final s = String.fromCharCode(cp);
    return s.toUpperCase() == s && s.toLowerCase() != s;
  }

  /// Forces a basic code point to lowercase if [upperCase] is false,
  /// uppercase if [upperCase] is true.
  int encodeBasic(int bcp, {required bool upperCase}) {
    final s = String.fromCharCode(bcp);
    return (upperCase ? s.toUpperCase() : s.toLowerCase()).codeUnitAt(0);
  }
}

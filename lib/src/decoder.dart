// SPDX-License-Identifier: MIT
//
// This code is partially based on the Punycode.js library by Mathias Bynens.
// Original library: https://github.com/mathiasbynens/punycode.js/
// Original library license: MIT

import 'dart:convert';

import 'package:punycoder/src/punycode_helper.dart';

/// Converts a Punycode string of ASCII-only symbols to a string of
/// Unicode symbols.
class PunycodeDecoder extends Converter<String, String> {
  final bool _simpleMode;
  
  /// Creates a Punycode Decoder designed to work with the nuances
  /// of how Punycode encodes domains and emails
  const PunycodeDecoder() : _simpleMode = false;
  
  /// Creates a Punycode Decoder which just works with simple 
  /// strings and doesn't attempt to account for nuances in 
  /// how Punycode encodes domains and emails
  const PunycodeDecoder.simple() : _simpleMode = true;

  @override
  String convert(String input) {
    if (_simpleMode) {
      return _decodeString(input);
    } else {
      return _decodeDomain(input);
    }
  }

  String _decodeDomain(String input) {
    var result = '';
    final parts = input.split('@');

    if (parts.length > 1) {
      // In email addresses, only the domain name should be punycoded. Leave
      // the local part (i.e., everything up to `@`) intact.
      result = '${parts[0]}@';
      input = parts[1];
    }

    final labels = punycodeHelper.getLabelsFromString(input);
    final encodedLabels = labels.map(_encodeLabel).toList();
    final encoded = encodedLabels.join('.');
    return result + encoded;
  }

  String _encodeLabel(String label) {
    if (punycodeHelper.isPunycodeDomain(label)) {
      return _decodeString(label.substring(4).toLowerCase());
    } else {
      return label;
    }
  }

  String _decodeString(String input) {
    final output = <int>[];
    final inputLength = input.length;
    var i = 0;
    var n = bootstrapValues.initialN;
    var bias = bootstrapValues.initialBias;

    // Handle the basic code points: let `basic` be the number of input code
    // points before the last delimiter, or `0` if there is none, then copy
    // the first basic code points to the output.

    var basic = input.lastIndexOf(bootstrapValues.delimiter);
    if (basic < 0) {
      basic = 0;
    }

    for (var j = 0; j < basic; ++j) {
      // if it's not a basic code point
      if (input.codeUnitAt(j) >= 0x80) {
        throw RangeError.value(
          input.codeUnitAt(j),
          'input',
          'Illegal input >= 0x80 (not a basic code point)',
        );
      }
      output.add(input.codeUnitAt(j));
    }

    // Main decoding loop: start just after the last delimiter if any basic code
    // points were copied; start at the beginning otherwise.

    for (var index = basic > 0 ? basic + 1 : 0; index < inputLength;) {
      // `index` is the index of the next character to be consumed.
      // Decode a generalized variable-length integer into `delta`,
      // which gets added to `i`. The overflow checking is easier
      // if we increase `i` as we go, then subtract off its starting
      // value at the end to obtain `delta`.
      final oldi = i;

      for (var w = 1, k = bootstrapValues.base; ; k += bootstrapValues.base) {
        if (index >= inputLength) {
          throw FormatException('Invalid input: Incomplete Punycode sequence');
        }

        final digit = punycodeHelper.basicToDigit(input.codeUnitAt(index++));

        if (digit >= bootstrapValues.base) {
          throw FormatException(
            'Invalid input: Invalid base-36 digit: ${input[index - 1]}',
          );
        }

        if (digit > ((punycodeHelper.maxInt - i) ~/ w)) {
          throw FormatException(
            'Overflow: input needs wider integers to process',
          );
        }

        i += digit * w;
        final t =
            k <= bias
                ? bootstrapValues.tMin
                : (k >= bias + bootstrapValues.tMax
                    ? bootstrapValues.tMax
                    : k - bias);

        if (digit < t) {
          break;
        }

        final baseMinusT = bootstrapValues.base - t;

        if (w > (punycodeHelper.maxInt ~/ baseMinusT)) {
          throw FormatException(
            'Overflow: input needs wider integers to process',
          );
        }

        w = w * baseMinusT; // Multiply within integer limits
      }

      final out = output.length + 1;
      bias = punycodeHelper.adapt(
        delta: i - oldi,
        numPoints: out,
        firstTime: oldi == 0,
      );

      // `i` was supposed to wrap around from `out` to `0`,
      // incrementing `n` each time, so we'll fix that now:
      if ((i ~/ out) > (punycodeHelper.maxInt - n)) {
        throw FormatException(
          'Overflow: input needs wider integers to process',
        );
      }

      n += i ~/ out;
      i %= out;

      // Insert `n` at position `i` of the output.
      output.insert(i, n);
      i++;
    }

    return String.fromCharCodes(output);
  }
}

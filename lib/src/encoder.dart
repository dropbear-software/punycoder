// SPDX-License-Identifier: MIT
//
// This code is partially based on the Punycode.js library by Mathias Bynens.
// Original library: https://github.com/mathiasbynens/punycode.js/
// Original library license: MIT

import 'dart:convert';

import 'package:punycoder/src/punycode_helper.dart';

/// Converts a string of Unicode symbols to a Punycode
/// string of ASCII-only symbols
final class PunycodeEncoder extends Converter<String, String> {
  final bool _simpleMode;

  /// Creates a Punycode Encoder designed to work with the nuances
  /// of how Punycode encodes domains and emails
  const PunycodeEncoder() : _simpleMode = false;

  /// Creates a Punycode Encoder which just works with simple
  /// strings and doesn't attempt to account for nuances in
  /// how Punycode encodes domains and emails
  const PunycodeEncoder.simple() : _simpleMode = true;

  @override
  String convert(String input) {
    if (_simpleMode) {
      return _encodeString(input);
    } else {
      return _encodeDomain(input);
    }
  }

  String _encodeDomain(String input) {
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

  String _encodeLabel(String input) {
    if (punycodeHelper.isNonAscii(input)) {
      return 'xn--${_encodeString(input)}';
    } else {
      return input;
    }
  }

  String _encodeString(String input) {
    final output = <int>[];

    // Convert the input to an array of Unicode code points.
    final decodedInput = input.runes.toList();

    // Cache the length.
    final inputLength = decodedInput.length;

    // Initialize the state.
    var n = bootstrapValues.initialN;
    var delta = 0;
    var bias = bootstrapValues.initialBias;

    // Handle the basic code points.
    for (final currentValue in decodedInput) {
      if (currentValue < 0x80) {
        output.add(currentValue); // Add the code point directly
      }
    }

    final basicLength = output.length;
    var handledCPCount = basicLength;

    // `handledCPCount` is the number of code points that have been handled;
    // `basicLength` is the number of basic code points.

    // Finish the basic string with a delimiter unless it's empty.
    if (basicLength > 0) {
      output.add(
        bootstrapValues.delimiter.codeUnitAt(0),
      ); // Add delimiter code point
    }

    // Main encoding loop:
    while (handledCPCount < inputLength) {
      // All non-basic code points < n have been handled already. Find the next
      // larger one:
      var m = punycodeHelper.maxInt;

      for (final currentValue in decodedInput) {
        if (currentValue >= n && currentValue < m) {
          m = currentValue;
        }
      }

      // Increase `delta` enough to advance the decoder's <n,i> state to <m,0>,
      // but guard against overflow.
      final handledCPCountPlusOne = handledCPCount + 1;

      if (m - n >
          ((punycodeHelper.maxInt - delta) / handledCPCountPlusOne).floor()) {
        throw FormatException(
          'Overflow: input needs wider integers to process',
        );
      }

      delta = delta + ((m - n) * handledCPCountPlusOne);
      n = m;

      for (final currentValue in decodedInput) {
        if (currentValue < n) {
          delta++;
          if (delta > punycodeHelper.maxInt) {
            throw FormatException(
              'Overflow: input needs wider integers to process',
            );
          }
        }

        if (currentValue == n) {
          // Represent delta as a generalized variable-length integer.
          var q = delta;

          for (var k = bootstrapValues.base; ; k += bootstrapValues.base) {
            final t =
                k <= bias
                    ? bootstrapValues.tMin
                    : (k >= bias + bootstrapValues.tMax
                        ? bootstrapValues.tMax
                        : k - bias);

            if (q < t) {
              break;
            }

            final qMinusT = q - t;
            final baseMinusT = bootstrapValues.base - t;
            output.add(
              punycodeHelper.digitToBasic(t + (qMinusT % baseMinusT), 0),
            );
            q = qMinusT ~/ baseMinusT;
          }

          output.add(punycodeHelper.digitToBasic(q, 0));
          bias = punycodeHelper.adapt(
            delta: delta,
            numPoints: handledCPCountPlusOne,
            firstTime: handledCPCount == basicLength,
          );
          delta = 0;
          ++handledCPCount;
        }
      }
      ++delta;
      ++n;
    }
    return String.fromCharCodes(output);
  }
}

import 'dart:convert';

import 'package:punycoder/src/decoder.dart' show PunycodeDecoder;
import 'package:punycoder/src/encoder.dart';

/// A codec for encoding and decoding strings using the Punycode algorithm.
///
/// Punycode is a character encoding scheme used to represent Unicode
/// characters in ASCII strings. It is commonly used for Internationalized
/// Domain Names (IDNs).
///
/// This codec provides methods to convert between Unicode strings and their
/// Punycode representations.
///
/// Example:
/// ```dart
/// import 'package:punycoder/punycoder.dart';
///
/// void main() {
///  // Can account for what parts of a domain or email should be encoded
///  const domainCodec = PunycodeCodec();
///  // Makes no distinction based on the input content
///  const simpleCodec = PunycodeCodec.simple();
///
///  final encodedString = simpleCodec.encode('münchen');
///  final encodedDomain = domainCodec.encode('münchen.com');
///  final encodedEmail = domainCodec.encode('münchen@münchen.com');
///
///  print(encodedString); // Output: mnchen-3ya
///  // Uses the correct prefix for the domain
///  print(encodedDomain); // Output: xn--mnchen-3ya.com
///  // Only the domain should be encoded
///  print(encodedEmail); // Output: münchen@xn--mnchen-3ya.com
///
///  final decodedString = simpleCodec.decode('mnchen-3ya');
///  final decodecDomain = domainCodec.decode('xn--mnchen-3ya.com');
///  final decodedEmail = domainCodec.decode('münchen@xn--mnchen-3ya.com');
///
///  print(decodedString); // Output: münchen
///  print(decodecDomain); // Output: münchen.com
///  print(decodedEmail); // Output: münchen@münchen.com
/// }
/// ```
class PunycodeCodec extends Codec<String, String> {
  final Converter<String, String> _encoder;
  final Converter<String, String> _decoder;

  /// Creates a new instance of the Punycode codec designed
  /// for working with domains and email addresses where
  /// additional rules apply about what needs to be converted
  const PunycodeCodec()
    : _encoder = const PunycodeEncoder(),
      _decoder = const PunycodeDecoder();

  /// Creates a new instance of the Punycode codec just designed
  /// for working with simple strings
  const PunycodeCodec.simple()
    : _encoder = const PunycodeEncoder.simple(),
      _decoder = const PunycodeDecoder.simple();

  @override
  Converter<String, String> get decoder => _decoder;

  @override
  Converter<String, String> get encoder => _encoder;
}

/// Provides a Dart implementation of the Punycode encoding algorithm
/// specified in RFC 3492.
///
/// Punycode is a simple and efficient transfer encoding syntax designed
/// for use with Internationalized Domain Names in Applications (IDNA).
/// It uniquely and reversibly transforms a Unicode string into an ASCII
/// string suitable for host name labels, using only letters, digits,
/// and hyphens. This library allows encoding Unicode strings to Punycode
/// ASCII strings and decoding them back to Unicode.
///
/// This library exports the main [PunycodeCodec] which follows the 
/// standard codec interface from `dart:convert` to help ensure a 
/// smooth and idomatic Dart experience when encoding and decoding.
///
/// ## Usage
///
/// ```dart
/// import 'package:punycoder/punycoder.dart';
///
/// void main() {
///   final codec = PunycodeCodec();
///
///   // Encode a Unicode string (e.g., a domain label)
///   final encoded = codec.encode('bücher');
///   print(encoded); // Output: bcher-kva
///
///   // Decode a Punycode string
///   final decoded = codec.decode('egbpdaj6bu4bxfgehfvwxn');
///   print(decoded); // Output: ليهماابتكلموشعربي؟
/// }
/// ```
///
/// See also:
/// * [RFC 3492: Punycode](https://www.rfc-editor.org/rfc/rfc3492.html)
/// * [PunycodeCodec], the main codec combining encoder and decoder.
library;

export 'src/codec.dart';

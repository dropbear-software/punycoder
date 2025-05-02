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
/// This library exports the main [PunycodeCodec] which provides convenient
/// access to both the [PunycodeEncoder] and [PunycodeDecoder]. You can
/// use the codec directly or instantiate the encoder/decoder separately.
///
/// ## Usage
///
/// ```dart
/// import 'package:punycoder/punycoder.dart';
///
/// void main() {
///   // 1. Use the codec directly
///   final codec = PunycodeCodec();
///
///   // Encode a Unicode string (e.g., a domain label)
///   final encoded = codec.encode('bücher');
///   print(encoded); // Output: bcher-kva
///
///   // Decode a Punycode string (typically prefixed with 'xn--' in IDNA)
///   // Note: The decoder itself expects the raw Punycode without the prefix.
///   final decoded = codec.decode('egbpdaj6bu4bxfgehfvwxn');
///   print(decoded); // Output: ليهماابتكلموشعربي؟
///
///   // 2. Use the encoder/decoder individually
///   const encoder = punycodeEncoder; // Access the singleton instance
///   const decoder = punycodeDecoder; // Access the singleton instance
///
///   // The encoder/decoder also provide helpers for domain/email processing
///   // These handle the 'xn--' prefix and apply encoding/decoding only where needed.
///   final encodedDomain = encoder.toAscii('mañana.com');
///   print(encodedDomain); // Output: xn--maana-pta.com
///
///   final decodedDomain = decoder.toUnicode('xn--ls8h.la');
///   print(decodedDomain); // Output: 💩.la
///
///   final email = 'bücher@xn--bcher-kva.com';
///   final decodedEmail = decoder.toUnicode(email);
///   print(decodedEmail); // Output: bücher@bücher.com
/// }
/// ```
///
/// See also:
/// * [RFC 3492: Punycode](https://www.rfc-editor.org/rfc/rfc3492.html)
/// * [PunycodeCodec], the main codec combining encoder and decoder.
/// * [PunycodeEncoder], for encoding Unicode to Punycode.
/// * [PunycodeDecoder], for decoding Punycode to Unicode.
library;

export 'src/decoder.dart';
export 'src/encoder.dart';
export 'src/punycoder_base.dart';

/// A pure Dart implementation of Punycode (RFC 3492) with support for
/// mixed-case annotation and errata.
library;

import 'dart:convert';

import 'src/punycode_decoder.dart';
import 'src/punycode_encoder.dart';

export 'src/idna.dart'
    show domainToAscii, domainToUnicode, emailToAscii, emailToUnicode;
export 'src/punycode_decoder.dart' show PunycodeDecoder;
export 'src/punycode_encoder.dart' show PunycodeEncoder;

/// A [Codec] that converts Unicode strings to Punycode ASCII strings.
///
/// This implementation supports the mixed-case annotation described in
/// RFC 3492 Appendix A.
class PunycodeCodec extends Codec<String, String> {
  /// Creates a new [PunycodeCodec].
  const PunycodeCodec();

  @override
  Converter<String, String> get decoder => const PunycodeDecoder();

  @override
  Converter<String, String> get encoder => const PunycodeEncoder();
}

/// The default instance of [PunycodeCodec].
const PunycodeCodec punycode = PunycodeCodec();

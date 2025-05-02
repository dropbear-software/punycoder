
import 'dart:io';

import 'package:punycoder/punycoder.dart';

void main() {
  // Use the singleton encoder/decoder for common IDNA tasks
  const encoder = punycodeEncoder;
  const decoder = punycodeDecoder;

  // --- Convert domains/emails TO ASCII (ACE format) ---
  final domainsToEncode = ['bücher.example', 'example.com', '你好.test'];
  stdout.writeln('Encoding to ASCII:');
  for (final domain in domainsToEncode) {
    final asciiVersion = encoder.toAscii(domain);
    // toAscii adds 'xn--' prefix only if encoding actually happens
    stdout.writeln('"$domain"  ->  "$asciiVersion"');
    // Output:
    // "bücher.example"  ->  "xn--bcher-kva.example"
    // "example.com"  ->  "example.com"
    // "你好.test"  ->  "xn--6qq79v.test"
  }

  // --- Convert domains/emails FROM ASCII (ACE format) ---
  final domainsToDecode = ['xn--bcher-kva.example', 'example.com', 'xn--6qq79v.test'];
   stdout.writeln('\nDecoding from ASCII:');
  for (final domain in domainsToDecode) {
    final unicodeVersion = decoder.toUnicode(domain);
    // toUnicode decodes labels starting with 'xn--'
    stdout.writeln('"$domain"  ->  "$unicodeVersion"');
    // Output:
    // "xn--bcher-kva.example"  ->  "bücher.example"
    // "example.com"  ->  "example.com"
    // "xn--6qq79v.test"  ->  "你好.test"
  }

  // --- Raw Encoding/Decoding (Advanced) ---
  // For direct encoding/decoding without automatic prefix handling or domain splitting:
  final codec = PunycodeCodec();
  final rawEncoded = codec.encode('bücher'); // -> 'bcher-kva' (no prefix)
  final rawDecoded = codec.decode('bcher-kva'); // -> 'bücher'
  stdout.writeln('\nRaw codec example (Decoded): "$rawDecoded"');
  stdout.writeln('Raw codec example (Encoded): "$rawEncoded"');
}
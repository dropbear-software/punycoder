// Printing is appropriate for a demonstration script.
// ignore_for_file: avoid_print
import 'package:punycoder/punycoder.dart';

void main() {
  // 1. Simple encoding
  // "münchen" contains a non-ASCII character 'ü'.
  const simpleInput = 'münchen';
  final simpleEncoded = punycode.encode(simpleInput);
  print('Simple Input:   $simpleInput');
  print('Simple Encoded: $simpleEncoded'); // mnchen-3ya

  // 2. Simple decoding
  final simpleDecoded = punycode.decode(simpleEncoded);
  print('Simple Decoded: $simpleDecoded');
  print('');

  // 3. Mixed-case preservation (Appendix A)
  // Punycoder preserves case information using the optional mixed-case annotation.
  const mixedInput = 'MÜnchen';
  final mixedEncoded = punycode.encode(mixedInput);
  print('Mixed Input:    $mixedInput');
  print('Mixed Encoded:  $mixedEncoded'); // Mnchen-3yA (Note the uppercase 'A')

  final mixedDecoded = punycode.decode(mixedEncoded);
  print('Mixed Decoded:  $mixedDecoded'); // MÜnchen
  print('');

  // 4. Using the Codec interface
  // You can also use the PunycodeEncoder and PunycodeDecoder classes directly.
  const encoder = PunycodeEncoder();
  const decoder = PunycodeDecoder();

  final result = encoder.convert('Dart-Language');
  final original = decoder.convert(result);
  print('Codec round-trip: $original');
}

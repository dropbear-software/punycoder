import 'package:punycoder/punycoder.dart';
import 'package:test/test.dart';

void main() {
  group('PunycodeCodec Integration', () {
    test('encode/decode round-trip (lowercase)', () {
      const input = 'münchen';
      final encoded = punycode.encode(input);
      final decoded = punycode.decode(encoded);
      expect(decoded, input);
    });

    test('encode/decode round-trip (mixed-case)', () {
      const input = 'MÜnchen';
      final encoded = punycode.encode(input);
      final decoded = punycode.decode(encoded);
      expect(decoded, input);
    });

    test('encode/decode round-trip (complex mixed-case)', () {
      const input = 'AbC-mÜnchen-XYZ';
      final encoded = punycode.encode(input);
      final decoded = punycode.decode(encoded);
      expect(decoded, input);
    });

    test('RFC 3492 Examples', () {
      // (A) Arabic
      final arabic =
          '\u0644\u064A\u0647\u0645\u0627\u0628\u062A\u0643\u0644'
          '\u0645\u0648\u0634\u0639\u0631\u0628\u064A\u061F';
      expect(punycode.decode(punycode.encode(arabic)), arabic);

      // (B) Chinese
      final chinese = '\u4ED6\u4EEC\u4E3A\u4EC0\u4E48\u4E0D\u8BF4\u4E2D\u6587';
      expect(punycode.decode(punycode.encode(chinese)), chinese);
    });
  });
}

import 'package:punycoder/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Utils', () {
    test('adapt', () {
      // Trace B: adapt(19853, 1, true) -> 21
      expect(adapt(19853, 1, firstTime: true), 21);

      // Trace L: adapt(62042, 3, true) -> 27
      expect(adapt(62042, 3, firstTime: true), 27);
    });

    test('decodeDigit', () {
      expect(decodeDigit('a'.codeUnitAt(0)), 0);
      expect(decodeDigit('z'.codeUnitAt(0)), 25);
      expect(decodeDigit('A'.codeUnitAt(0)), 0);
      expect(decodeDigit('Z'.codeUnitAt(0)), 25);
      expect(decodeDigit('0'.codeUnitAt(0)), 26);
      expect(decodeDigit('9'.codeUnitAt(0)), 35);
      expect(decodeDigit('-'.codeUnitAt(0)), -1);
    });

    test('encodeDigit', () {
      expect(encodeDigit(0, upperCase: false), 'a'.codeUnitAt(0));
      expect(encodeDigit(0, upperCase: true), 'A'.codeUnitAt(0));
      expect(encodeDigit(25, upperCase: false), 'z'.codeUnitAt(0));
      expect(encodeDigit(26, upperCase: false), '0'.codeUnitAt(0));
      expect(encodeDigit(35, upperCase: false), '9'.codeUnitAt(0));
      expect(() => encodeDigit(36, upperCase: false), throwsArgumentError);
    });

    test('isBasic', () {
      expect(isBasic('a'.codeUnitAt(0)), true);
      expect(isBasic(0x80), false);
    });

    test('isDelimiter', () {
      expect(isDelimiter('-'.codeUnitAt(0)), true);
      expect(isDelimiter('a'.codeUnitAt(0)), false);
    });
  });
}

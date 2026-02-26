import 'package:punycoder/src/punycode_encoder.dart';
import 'package:test/test.dart';

void main() {
  const encoder = PunycodeEncoder();

  group('PunycodeEncoder RFC 3492 Section 7.1 Examples', () {
    test('(A) Arabic (Egyptian)', () {
      expect(
        encoder.convert(
          '\u0644\u064A\u0647\u0645\u0627\u0628\u062A\u0643\u0644'
          '\u0645\u0648\u0634\u0639\u0631\u0628\u064A\u061F',
        ),
        'egbpdaj6bu4bxfgehfvwxn',
      );
    });

    test('(B) Chinese (simplified)', () {
      expect(
        encoder.convert(
          '\u4ED6\u4EEC\u4E3A\u4EC0\u4E48\u4E0D\u8BF4\u4E2D\u6587',
        ),
        'ihqwcrb4cv8a8dqg056pqjye',
      );
    });

    test('(C) Chinese (traditional)', () {
      expect(
        encoder.convert(
          '\u4ED6\u5011\u7232\u4EC0\u9EBD\u4E0D\u8AAA\u4E2D\u6587',
        ),
        'ihqwctvzc91f659drss3x8bo0yb',
      );
    });

    test('(D) Czech: Pro<ccaron>prost<ecaron>nemluv<iacute><ccaron>esky', () {
      expect(
        encoder.convert(
          'Pr\u006F\u010Dp\u0072\u006F\u0073\u0074\u011Bn\u0065\u006D\u006C\u0075\u0076\u00ED\u010D\u0065\u0073\u006B\u0079',
        ),
        'Proprostnemluvesky-uyb24dma41a',
      );
    });

    test('(E) Hebrew', () {
      expect(
        encoder.convert(
          '\u05DC\u05DE\u05D4\u05D4\u05DD\u05E4\u05E9\u05D5\u05D8'
          '\u05DC\u05D0\u05DE\u05D3\u05D1\u05E8\u05D9\u05DD\u05E2'
          '\u05D1\u05E8\u05D9\u05EA',
        ),
        '4dbcagdahymbxekheh6e0a7fei0b',
      );
    });

    test('(F) Hindi (Devanagari)', () {
      expect(
        encoder.convert(
          '\u092F\u0939\u0932\u094B\u0917\u0939\u093F\u0928\u094D'
          '\u0926\u0940\u0915\u094D\u092F\u094B\u0902\u0928\u0939'
          '\u0940\u0902\u092C\u094B\u0932\u0938\u0915\u0924\u0947'
          '\u0939\u0948\u0902',
        ),
        'i1baa7eci9glrd9b2ae1bj0hfcgg6iyaf8o0a1dig0cd',
      );
    });

    test('(G) Japanese (kanji and hiragana)', () {
      expect(
        encoder.convert(
          '\u306A\u305C\u307F\u3093\u306A\u65E5\u672C\u8A9E\u3092'
          '\u8A71\u3057\u3066\u304F\u308C\u306A\u3044\u306E\u304B',
        ),
        'n8jok5ay5dzabd5bym9f0cm5685rrjetr6pdxa',
      );
    });

    test('(H) Korean (Hangul syllables)', () {
      expect(
        encoder.convert(
          '\uC138\uACC4\uC758\uBAA8\uB4E0\uC0AC\uB78C\uB4E4\uC774'
          '\uD55C\uAD6D\uC5B4\uB97C\uC774\uD574\uD55C\uB2E4\uBA74'
          '\uC5BC\uB9C8\uB098\uC88B\uC744\uAE4C',
        ),
        '989aomsvi5e83db1d2a355cv1e0vak1dwrv93d5xbh15a0dt30a5jpsd879ccm6fea98c',
      );
    });

    test('(I) Russian (Cyrillic)', () {
      // Note Errata 3026: The original example had an uppercase 'D' by mistake.
      // With Appendix A implemented, an uppercase letter in the Punycode
      // indicates an uppercase character in the original string.
      // Since the input below is entirely lowercase, the output should
      // also be entirely lowercase (fixing the 'D' to 'd').
      expect(
        encoder.convert(
          '\u043F\u043E\u0447\u0435\u043C\u0443\u0436\u0435\u043E'
          '\u043D\u0438\u043D\u0435\u0433\u043E\u0432\u043E\u0440'
          '\u044F\u0442\u043F\u043E\u0440\u0443\u0441\u0441\u043A\u0438',
        ),
        'b1abfaaepdrnnbgefbadotcwatmq2g4l',
      );
    });

    test('(J) Spanish', () {
      expect(
        encoder.convert('Porqu\u00E9nopuedensimplementehablarenEspa\u00F1ol'),
        'PorqunopuedensimplementehablarenEspaol-fmd56a',
      );
    });

    test('(K) Vietnamese', () {
      expect(
        encoder.convert(
          'T\u1EA1isaoh\u1ECDkh\u00F4ngth\u1EC3ch\u1EC9n\u00F3iti\u1EBFngVi\u1EC7t',
        ),
        'TisaohkhngthchnitingVit-kjcr8268qyxafd2f1b9g',
      );
    });

    test('(L) 3<nen>B<gumi><kinpachi><sensei>', () {
      expect(
        encoder.convert('3\u5E74B\u7D44\u91D1\u516B\u5148\u751F'),
        '3B-ww4c5e180e575a65lsy2b',
      );
    });

    test('(M) <amuro><namie>-with-SUPER-MONKEYS', () {
      expect(
        encoder.convert('\u5B89\u5BA4\u5948\u7F8E\u6075-with-SUPER-MONKEYS'),
        '-with-SUPER-MONKEYS-pc58ag80a8qai00g7n9n',
      );
    });

    test('(N) Hello-Another-Way-<sorezore><no><basho>', () {
      expect(
        encoder.convert(
          'Hello-Another-Way-\u305D\u308C\u305E\u308C\u306E\u5834\u6240',
        ),
        'Hello-Another-Way--fc4qua05auwb3674vfr0b',
      );
    });

    test('(O) <hitotsu><yane><no><shita>2', () {
      expect(
        encoder.convert('\u3072\u3068\u3064\u5C4B\u6839\u306E\u4E0B2'),
        '2-u9tlzr9756bt3uc0v',
      );
    });

    test('(P) Maji<de>Koi<suru>5<byou><mae>', () {
      expect(
        encoder.convert('Maji\u3067Koi\u3059\u308B5\u79D2\u524D'),
        'MajiKoi5-783gue6qz075azm5e',
      );
    });

    test('(Q) <pafii>de<runba>', () {
      expect(
        encoder.convert('\u30D1\u30D5\u30A3\u30FCde\u30EB\u30F3\u30D0'),
        'de-jg4avhby1noc0d',
      );
    });

    test('(R) <sono><supiido><de>', () {
      expect(
        encoder.convert('\u305D\u306E\u30B9\u30D4\u30FC\u30C9\u3067'),
        'd9juau41awczczp',
      );
    });

    test(r'(S) -> $1.00 <-', () {
      expect(encoder.convert(r'-> $1.00 <-'), r'-> $1.00 <--');
    });
  });

  group('Mixed-case annotation (Appendix A)', () {
    test('Russian with one uppercase character', () {
      // Per Appendix A, the encoder outputs an uppercase digit for the last
      // digit of a delta if the original character was uppercase.
      final input =
          '\u043F\u043E\u0447\u0435\u043C\u0443\u0436\u0435\u043E'
          '\u043D\u0438\u043D\u0435\u0433\u043E\u0432\u043E\u0440'
          '\u044F\u0442\u041F\u043E\u0440\u0443\u0441\u0441\u043A\u0438';
      final result = encoder.convert(input);
      // Verify that at least one uppercase letter (A-Z) is present in the output.
      expect(result, matches(RegExp('[A-Z]')));
    });

    test('Basic string with mixed case', () {
      expect(encoder.convert('AbC-DeF'), 'AbC-DeF-');
    });
  });
}

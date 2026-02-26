import 'package:punycoder/punycoder.dart';
import 'package:test/test.dart';

void main() {
  group('domainToAscii', () {
    test('simple domain', () {
      expect(domainToAscii('example.com'), 'example.com');
    });

    test('international domain', () {
      expect(domainToAscii('mañana.com'), 'xn--maana-pta.com');
      expect(domainToAscii('bücher.com'), 'xn--bcher-kva.com');
      expect(domainToAscii('café.com'), 'xn--caf-dma.com');
    });

    test('Emoji domain', () {
      expect(domainToAscii('💩.la'), 'xn--ls8h.la');
    });

    test('Complex IDN', () {
      expect(domainToAscii('☃-⌘.com'), 'xn----dqo34k.com');
    });

    test('Separators (IDNA2003)', () {
      expect(domainToAscii('mañana\u3002com'), 'xn--maana-pta.com');
      expect(domainToAscii('mañana\uFF0Ecom'), 'xn--maana-pta.com');
      expect(domainToAscii('mañana\uFF61com'), 'xn--maana-pta.com');
    });

    test('Trailing dot', () {
      expect(domainToAscii('example.com.'), 'example.com.');
    });

    group('Validation', () {
      test('label too long', () {
        final longLabel = 'a' * 64;
        expect(
          () => domainToAscii('$longLabel.com'),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Label too long'),
            ),
          ),
        );
      });

      test('domain too long', () {
        final longDomain = ('a' * 60 + '.') * 5; // > 253
        expect(
          () => domainToAscii(longDomain),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Domain too long'),
            ),
          ),
        );
      });

      test('leading/trailing hyphen', () {
        expect(() => domainToAscii('-example.com'), throwsFormatException);
        expect(() => domainToAscii('example-.com'), throwsFormatException);
      });

      test('hyphens in 3rd and 4th position', () {
        expect(() => domainToAscii('ab--c.com'), throwsFormatException);
        // Should NOT throw for xn--
        expect(domainToAscii('xn--maana-pta.com'), 'xn--maana-pta.com');
      });

      test('invalid characters', () {
        expect(() => domainToAscii(r'abc$.com'), throwsFormatException);
        expect(() => domainToAscii('abc .com'), throwsFormatException);
      });

      test('empty labels', () {
        expect(() => domainToAscii('example..com'), throwsFormatException);
      });

      test('disable validation', () {
        expect(domainToAscii('ab--c.com', validate: false), 'ab--c.com');
      });
    });
  });

  group('domainToUnicode', () {
    test('simple domain', () {
      expect(domainToUnicode('example.com'), 'example.com');
    });

    test('international domain', () {
      expect(domainToUnicode('xn--maana-pta.com'), 'mañana.com');
      expect(domainToUnicode('xn--bcher-kva.com'), 'bücher.com');
      expect(domainToUnicode('xn--caf-dma.com'), 'café.com');
    });

    test('Emoji domain', () {
      expect(domainToUnicode('xn--ls8h.la'), '💩.la');
    });

    test('Round-trip', () {
      const input = 'mañana.com';
      expect(domainToUnicode(domainToAscii(input)), input);
    });
  });

  group('emailToAscii', () {
    test('simple email', () {
      expect(emailToAscii('test@example.com'), 'test@example.com');
    });

    test('international email', () {
      expect(
        emailToAscii('джумла@джpумлатест.bрфa'),
        'джумла@xn--p-8sbkgc5ag7bhce.xn--ba-lmcq',
      );
    });

    test('invalid email format', () {
      expect(() => emailToAscii('test'), throwsFormatException);
      expect(() => emailToAscii('test@foo@bar'), throwsFormatException);
    });
  });

  group('emailToUnicode', () {
    test('simple email', () {
      expect(emailToUnicode('test@example.com'), 'test@example.com');
    });

    test('international email', () {
      expect(
        emailToUnicode('джумла@xn--p-8sbkgc5ag7bhce.xn--ba-lmcq'),
        'джумла@джpумлатест.bрфa',
      );
    });

    test('Round-trip', () {
      const input = 'user@mañana.com';
      expect(emailToUnicode(emailToAscii(input)), input);
    });
  });
}

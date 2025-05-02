import 'package:punycoder/punycoder.dart';
import 'package:test/test.dart';

void main() {
  group('PunycodeDecoder', () {
    late PunycodeCodec codec;
    late PunycodeCodec simpleCodec;

    setUp(() {
      codec = PunycodeCodec();
      simpleCodec = PunycodeCodec.simple();
    });

    test('multiple non-ASCII characters', () {
      expect(simpleCodec.decode('4can8av2009b'), 'üëäö♥');
    });

    test('a single non-ASCII character', () {
      expect(simpleCodec.decode('tda'), 'ü');
    });

    test('a single basic code point', () {
      expect(simpleCodec.decode('Bach-'), 'Bach');
    });

    test('mix of ASCII and non-ASCII characters', () {
      expect(simpleCodec.decode('bcher-kva'), 'bücher');
    });

    test('long string with both ASCII and non-ASCII characters', () {
      expect(
        simpleCodec.decode(
          'Willst du die Blthe des frhen, die Frchte des spteren Jahres-x9e96lkal',
        ),
        'Willst du die Blüthe des frühen, die Früchte des späteren Jahres',
      );
    });

    // https://datatracker.ietf.org/doc/html/rfc3492#section-7.1
    group('Official RFC examples', () {
      test('Arabic (Egyptian)', () {
        expect(
          simpleCodec.decode('egbpdaj6bu4bxfgehfvwxn'),
          'ليهمابتكلموشعربي؟',
        );
      });

      test('Chinese (simplified)', () {
        expect(simpleCodec.decode('ihqwcrb4cv8a8dqg056pqjye'), '他们为什么不说中文');
      });

      test('Chinese (traditional)', () {
        expect(
          simpleCodec.decode('ihqwctvzc91f659drss3x8bo0yb'),
          '他們爲什麽不說中文',
        );
      });

      test('Czech', () {
        expect(
          simpleCodec.decode('Proprostnemluvesky-uyb24dma41a'),
          'Pročprostěnemluvíčesky',
        );
      });

      test('Hebrew', () {
        expect(
          simpleCodec.decode('4dbcagdahymbxekheh6e0a7fei0b'),
          'למההםפשוטלאמדבריםעברית',
        );
      });

      test('Hindi (Devanagari)', () {
        expect(
         simpleCodec.decode('i1baa7eci9glrd9b2ae1bj0hfcgg6iyaf8o0a1dig0cd'),
          'यहलोगहिन्दीक्योंनहींबोलसकतेहैं',
        );
      });

      test('Japanese (kanji and hiragana)', () {
        expect(
          simpleCodec.decode('n8jok5ay5dzabd5bym9f0cm5685rrjetr6pdxa'),
          'なぜみんな日本語を話してくれないのか',
        );
      });

      test('Korean (Hangul syllables)', () {
        expect(
          simpleCodec.decode(
            '989aomsvi5e83db1d2a355cv1e0vak1dwrv93d5xbh15a0dt30a5jpsd879ccm6fea98c',
          ),
          '세계의모든사람들이한국어를이해한다면얼마나좋을까',
        );
      });

      test('Russian (Cyrillic)', () {
        expect(
          simpleCodec.decode('b1abfaaepdrnnbgefbadotcwatmq2g4l'),
          'почемужеонинеговорятпорусски',
        );
      });

      test('Spanish', () {
        expect(
          simpleCodec.decode(
            'PorqunopuedensimplementehablarenEspaol-fmd56a',
          ),
          'PorquénopuedensimplementehablarenEspañol',
        );
      });

      test('Vietnamese', () {
        expect(
          simpleCodec.decode('TisaohkhngthchnitingVit-kjcr8268qyxafd2f1b9g'),
          'TạisaohọkhôngthểchỉnóitiếngViệt',
        );
      });

      test('3年B組金八先生', () {
        expect(
          simpleCodec.decode('3B-ww4c5e180e575a65lsy2b'),
          '3\u5E74B\u7D44\u91D1\u516B\u5148\u751F',
        );
      });

      test('安室奈美恵-with-SUPER-MONKEYS', () {
        expect(
          simpleCodec.decode('-with-SUPER-MONKEYS-pc58ag80a8qai00g7n9n'),
          '\u5B89\u5BA4\u5948\u7F8E\u6075-with-SUPER-MONKEYS',
        );
      });

      test('Hello-Another-Way-それぞれの場所', () {
        expect(
          simpleCodec.decode('Hello-Another-Way--fc4qua05auwb3674vfr0b'),
          'Hello-Another-Way-\u305D\u308C\u305E\u308C\u306E\u5834\u6240',
        );
      });

      test('ひとつ屋根の下2', () {
        expect(
          simpleCodec.decode('2-u9tlzr9756bt3uc0v'),
          '\u3072\u3068\u3064\u5C4B\u6839\u306E\u4E0B2',
        );
      });

      test('MajiでKoiする5秒前', () {
        expect(
          simpleCodec.decode('MajiKoi5-783gue6qz075azm5e'),
          'Maji\u3067Koi\u3059\u308B5\u79D2\u524D',
        );
      });

      test('パフィーdeルンバ', () {
        expect(
          simpleCodec.decode('de-jg4avhby1noc0d'),
          '\u30D1\u30D5\u30A3\u30FCde\u30EB\u30F3\u30D0',
        );
      });

      test('そのスピードで', () {
        expect(
          simpleCodec.decode('d9juau41awczczp'),
          '\u305D\u306E\u30B9\u30D4\u30FC\u30C9\u3067',
        );
      });
    });

    group('domains and emails', () {
      test('With IRI domain', () {
        expect(codec.decode('xn--maana-pta.com'), 'mañana.com');
        expect(codec.decode('xn--bcher-kva.com'), 'bücher.com');
        expect(codec.decode('xn--caf-dma.com'), 'café.com');
        expect(codec.decode('xn----dqo34k.com'), '☃-⌘.com');
        expect(codec.decode('xn----dqo34kn65z.com'), '퐀☃-⌘.com');
        expect(codec.decode('foo\x7F.example'), 'foo\x7F.example');
      });

      test('With non-IRI domain', () {
        expect(codec.decode('example.com.'), 'example.com.');
      });

      test('With emoji', () {
        expect(codec.decode('xn--ls8h.la'), '💩.la');
      });

      test('with non-printable ASCII', () {
        expect(
          codec.decode('0\x01\x02foo.bar'),
          '0\x01\x02foo.bar',
        );
      });

      test('with email address', () {
        expect(
          codec.decode(
            '\u0434\u0436\u0443\u043C\u043B\u0430@xn--p-8sbkgc5ag7bhce.xn--ba-lmcq',
          ),
          '\u0434\u0436\u0443\u043C\u043B\u0430@\u0434\u0436p\u0443\u043C\u043B\u0430\u0442\u0435\u0441\u0442.b\u0440\u0444a',
        );
      });
    });
  });
}
[![pub package](https://img.shields.io/pub/v/punycoder.svg)](https://pub.dev/packages/punycoder)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Open in Firebase Studio](https://cdn.firebasestudio.dev/btn/open_light_20.svg)](https://studio.firebase.google.com/import?url=https%3A%2F%2Fgithub.com%2Fdropbear-software%2Fpunycoder)
# Punycoder

A pure Dart implementation of Punycode ([RFC 3492](https://tools.ietf.org/html/rfc3492)) with support for mixed-case annotation and technical errata.

Punycoder provides an idiomatic and high-performance way to encode and decode Punycode strings, which are essential for Internationalized Domain Names in Applications (IDNA).

## Features

- **Standard Compliant**: Faithful implementation of the Bootstring algorithm specifically for Punycode.
- **Mixed-Case Annotation**: Full support for Appendix A, preserving original character casing during the encoding process.
- **Cross-Platform**: Fully compatible with both the Dart VM and Web (transpiled via dart2js or ddc).
- **Native Performance**: Uses `StringBuffer` and Unicode-aware `Runes` for efficient processing.
- **Idiomatic API**: Implements `Codec<String, String>` for seamless integration with `dart:convert`.

## Getting started

Add `punycoder` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  punycoder: ^0.3.0
```

Then, import the library in your Dart code:

```dart
import 'package:punycoder/punycoder.dart';
```

## Usage

### Basic Encoding and Decoding

```dart
// Encode a Unicode string to Punycode
final encoded = punycode.encode('münchen'); // mnchen-3ya

// Decode a Punycode string back to Unicode
final decoded = punycode.decode('mnchen-3ya'); // münchen
```

### IDNA Helpers (Domains and Emails)

Punycoder provides high-level helpers for handling Internationalized Domain Names (IDN) and email addresses.

```dart
// Convert a Unicode domain to ASCII (Punycode)
final domainAscii = domainToAscii('mañana.com'); // xn--maana-pta.com

// Convert back to Unicode
final domainUnicode = domainToUnicode('xn--maana-pta.com'); // mañana.com

// Supports IDNA2003 separators (。 ． ｡)
final alternative = domainToAscii('mañana\u3002com'); // xn--maana-pta.com

// Convert an email address
final emailAscii = emailToAscii('джумла@джpумлатест.bрфa'); 
// джумла@xn--p-8sbkgc5ag7bhce.xn--ba-lmcq
```

By default, `domainToAscii` and `emailToAscii` perform validation (label length, domain length, invalid characters). You can disable this if needed:

```dart
final raw = domainToAscii('ab--c.com', validate: false);
```

### Preserving Mixed Case

By default, Punycoder uses Appendix A annotations to preserve casing:

```dart
final encoded = punycode.encode('MÜnchen'); // Mnchen-3yA
final decoded = punycode.decode('Mnchen-3yA'); // MÜnchen
```

## Additional information

### Contributions

Contributions are welcome! Please feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/dropbear-software/punycoder).

### Reporting Issues

If you encounter any bugs or have feature requests, please file them through the [issue tracker](https://github.com/dropbear-software/punycoder/issues).

### License

This project is licensed under the MIT License - see the LICENSE file for details.

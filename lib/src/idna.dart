import '../punycoder.dart';

/// Converts a domain name to its Punycode-encoded ASCII representation.
///
/// If [validate] is true (default), the function enforces RFC 1034 and
/// RFC 5890 rules:
/// - Label length between 1 and 63 characters.
/// - Total domain length not exceeding 253 characters.
/// - Labels must not start or end with a hyphen.
/// - Labels must not have hyphens in 3rd and 4th positions unless starting with 'xn--'.
/// - Labels must only contain LDH (Letter-Digit-Hyphen) characters.
String domainToAscii(String domain, {bool validate = true}) {
  final labels = _splitBySeparators(domain);
  final encodedLabels = <String>[];

  for (final label in labels) {
    if (_isAscii(label)) {
      encodedLabels.add(label.toLowerCase());
    } else {
      final encoded = punycode.encode(label.toLowerCase());
      encodedLabels.add('xn--$encoded');
    }
  }

  final result = encodedLabels.join('.');

  if (validate) {
    _validateDomain(result, encodedLabels);
  }

  return result;
}

/// Converts a domain name from Punycode-encoded ASCII to Unicode.
String domainToUnicode(String domain) {
  final labels = domain.split('.');
  final decodedLabels = labels.map((label) {
    if (label.toLowerCase().startsWith('xn--')) {
      return punycode.decode(label.substring(4));
    }
    return label;
  });

  return decodedLabels.join('.');
}

/// Converts the domain part of an email address to Punycode-encoded ASCII.
///
/// Only the domain part (after the '@') is transformed. The local part is
/// preserved as-is.
String emailToAscii(String email, {bool validate = true}) {
  final parts = email.split('@');
  if (parts.length != 2) {
    throw FormatException('Invalid email format: $email');
  }
  final localPart = parts[0];
  final domainPart = parts[1];

  return '$localPart@${domainToAscii(domainPart, validate: validate)}';
}

/// Converts the domain part of an email address from Punycode-encoded ASCII to Unicode.
String emailToUnicode(String email) {
  final parts = email.split('@');
  if (parts.length != 2) {
    throw FormatException('Invalid email format: $email');
  }
  final localPart = parts[0];
  final domainPart = parts[1];

  return '$localPart@${domainToUnicode(domainPart)}';
}

List<String> _splitBySeparators(String domain) {
  // This RegExp matches any of the IDNA2003 separators.
  return domain.split(RegExp(r'[.\u3002\uFF0E\uFF61]'));
}

bool _isAscii(String s) {
  for (var i = 0; i < s.length; i++) {
    if (s.codeUnitAt(i) > 127) return false;
  }
  return true;
}

void _validateDomain(String domain, List<String> labels) {
  if (domain.length > 253) {
    throw FormatException(
      'Domain too long: ${domain.length} characters (max 253)',
    );
  }

  for (var i = 0; i < labels.length; i++) {
    final label = labels[i];
    if (label.isEmpty) {
      // An empty label is only valid if it's the last one, which represents
      // a trailing dot in the original domain.
      if (i < labels.length - 1) {
        throw FormatException('Domain name cannot contain empty labels.');
      }
      continue;
    }

    if (label.length > 63) {
      throw FormatException(
        'Label too long: ${label.length} characters (max 63)',
      );
    }

    if (label.startsWith('-') || label.endsWith('-')) {
      throw FormatException('Label cannot start or end with a hyphen: $label');
    }

    if (label.length >= 4 &&
        label[2] == '-' &&
        label[3] == '-' &&
        !label.startsWith('xn--')) {
      throw FormatException(
        'Label cannot have hyphens in 3rd and 4th positions: $label',
      );
    }

    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(label)) {
      throw FormatException('Label contains invalid characters: $label');
    }
  }
}

import 'dart:io';

import 'package:punycoder/punycoder.dart';

void main() {
  // Designed to be used with domains and emails which have special rules
  const domainCodec = PunycodeCodec();
  // Designed to work with simple strings
  const simpleCodec = PunycodeCodec.simple();

  final encodedString = simpleCodec.encode('münchen');
  final encodedDomain = domainCodec.encode('münchen.com');
  final encodedEmail = domainCodec.encode('münchen@münchen.com');

  stdout.writeln(encodedString); // Output: mnchen-3ya
  // Uses the correct prefix for the domain
  stdout.writeln(encodedDomain); // Output: xn--mnchen-3ya.com
  // Only the domain should be encoded
  stdout.writeln(encodedEmail); // Output: münchen@xn--mnchen-3ya.com

  final decodedString = simpleCodec.decode('mnchen-3ya');
  final decodecDomain = domainCodec.decode('xn--mnchen-3ya.com');
  final decodedEmail = domainCodec.decode('münchen@xn--mnchen-3ya.com');

  stdout.writeln(decodedString); // Output: münchen
  stdout.writeln(decodecDomain); // Output: münchen.com
  stdout.writeln(decodedEmail); // Output: münchen@münchen.com
}

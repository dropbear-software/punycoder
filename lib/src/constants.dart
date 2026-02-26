/// Punycode parameters from RFC 3492.
const int base = 36;

/// Minimum threshold for generalized variable-length integers.
const int tmin = 1;

/// Maximum threshold for generalized variable-length integers.
const int tmax = 26;

/// Skew parameter for bias adaptation.
const int skew = 38;

/// Damp parameter for bias adaptation.
const int damp = 700;

/// Initial bias value.
const int initialBias = 72;

/// Initial value of n (128).
const int initialN = 128; // 0x80

/// Punycode delimiter code point ('-').
const int delimiter = 45; // 0x2D '-'

/// The maximum value of a Dart integer, platform-aware.
///
/// In Dart, this is 2^63 - 1 on VM/Native, but 2^53 - 1 on Web.
final int dartMaxInt =
    identical(0, 0.0)
        ? 9007199254740991 // JS safe integer (2^53 - 1)
        : int.parse('9223372036854775807'); // 64-bit signed max (2^63 - 1)

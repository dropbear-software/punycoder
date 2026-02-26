## 0.3.0

This release is a complete, ground-up rewrite of the package. It provides a fully compliant, strictly validated, and idiomatic Dart implementation of the Punycode standard.

### 🚨 Breaking Changes
* **Separation of IDNA and Raw Punycode:** The default `PunycodeCodec` no longer attempts to automatically parse and encode/decode full domains or email addresses. It now acts purely on raw strings.
* **Removed `PunycodeCodec.simple()`:** Because the default codec now handles raw strings exclusively, the `.simple()` constructor has been removed. A new global `punycode` instance is provided for convenience.
* **Extracted Domain & Email Handling:** Domain and email conversions are now handled by dedicated top-level functions (`domainToAscii`, `domainToUnicode`, `emailToAscii`, and `emailToUnicode`).
* **Strict (but Configurable) IDNA Validation:** IDNA processing now strictly enforces formatting rules by default. Inputs with labels exceeding 63 characters, domains exceeding 253 characters, or invalid hyphen placements will actively throw a `FormatException`. You can bypass this by passing `validate: false`.

### ✨ New Features & Improvements
* **Full RFC 3492 Compliance:** Rigorous implementation of the complete Punycode specification.
* **Mixed-Case Support (RFC 3429 Appendix A):** Added support for Appendix A mixed-case annotations, properly preserving casing during encoding and decoding.
* **Official Errata Fixes:** Implemented technical corrections for RFC 3492 Errata IDs 265 and 3026.
* **IDNA2003 Separator Support:** `domainToAscii` now recognizes and properly splits labels using standard IDNA2003 separators (`.`, `\u3002`, `\uFF0E`, `\uFF61`).
* **Platform Parity:** Added a comprehensive suite of unit and integration tests to guarantee identical behavior across both Dart VM and Web platforms.

## 0.2.2

- Fix code formatting and ensure README is up to date.

## 0.2.1

- Fix code formatting and ensure README is up to date.

## 0.2.0

- Refactor the package to strictly follow the `Converter<S, T>` interface established in `dart:convert` and clean up the API as a result.

## 0.1.0

- Initial version.

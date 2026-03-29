/// Formats an Argentine phone number for WhatsApp deep links.
///
/// Handles common formats:
/// - +54 9 11 1234-5678 → 5491112345678
/// - 011 15 1234-5678 → 5491112345678
/// - 15 1234-5678 (assumes Buenos Aires) → 5491112345678
/// - Already international: +5491112345678 → 5491112345678
String formatArgPhone(String raw) {
  // Strip all non-digit characters
  String digits = raw.replaceAll(RegExp(r'[^\d]'), '');

  // Remove leading zeros
  digits = digits.replaceFirst(RegExp(r'^0+'), '');

  if (digits.startsWith('54')) {
    // Already has country code
    digits = digits.substring(2);
  }

  // Remove trunk prefix "15" when preceded by area code
  // e.g. 11 15 12345678 → 11 12345678
  if (digits.length >= 10) {
    final areaAndRest = digits;
    // Check for 2-digit area code + 15 + 8 digits
    if (areaAndRest.length == 12 &&
        areaAndRest.substring(2, 4) == '15') {
      digits = areaAndRest.substring(0, 2) + areaAndRest.substring(4);
    }
    // Check for 3-digit area code + 15 + 7 digits
    else if (areaAndRest.length == 13 &&
        areaAndRest.substring(3, 5) == '15') {
      digits = areaAndRest.substring(0, 3) + areaAndRest.substring(5);
    }
  }

  // If starts with 15 and is 10 digits, assume Buenos Aires mobile
  if (digits.startsWith('15') && digits.length == 10) {
    digits = '11${digits.substring(2)}';
  }

  // Ensure 9 is inserted for mobile (WhatsApp requirement for AR)
  if (digits.length == 10 && !digits.startsWith('9')) {
    digits = '9$digits';
  }

  return '54$digits';
}

/// Returns a formatted `wa.me` URL for the given phone number.
Uri whatsAppUri(String phone) {
  return Uri.parse('https://wa.me/${formatArgPhone(phone)}');
}

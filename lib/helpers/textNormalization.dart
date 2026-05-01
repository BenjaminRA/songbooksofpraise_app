/// Normalizes text for search by removing accents, special characters,
/// and converting to lowercase. This enables accent-insensitive search
/// (e.g., "Ave" will match "Avé María").
String normalizeText(String text) {
  String normalized = text;

  // Map of accented characters to their unaccented equivalents
  const Map<String, String> accentMap = {
    // Lowercase vowels with accents
    'á': 'a', 'à': 'a', 'ä': 'a', 'â': 'a', 'ã': 'a', 'å': 'a', 'ā': 'a',
    'é': 'e', 'è': 'e', 'ë': 'e', 'ê': 'e', 'ē': 'e', 'ė': 'e', 'ę': 'e',
    'í': 'i', 'ì': 'i', 'ï': 'i', 'î': 'i', 'ī': 'i', 'į': 'i',
    'ó': 'o', 'ò': 'o', 'ö': 'o', 'ô': 'o', 'õ': 'o', 'ō': 'o', 'ø': 'o',
    'ú': 'u', 'ù': 'u', 'ü': 'u', 'û': 'u', 'ū': 'u', 'ų': 'u',
    'ý': 'y', 'ÿ': 'y',

    // Uppercase vowels with accents
    'Á': 'A', 'À': 'A', 'Ä': 'A', 'Â': 'A', 'Ã': 'A', 'Å': 'A', 'Ā': 'A',
    'É': 'E', 'È': 'E', 'Ë': 'E', 'Ê': 'E', 'Ē': 'E', 'Ė': 'E', 'Ę': 'E',
    'Í': 'I', 'Ì': 'I', 'Ï': 'I', 'Î': 'I', 'Ī': 'I', 'Į': 'I',
    'Ó': 'O', 'Ò': 'O', 'Ö': 'O', 'Ô': 'O', 'Õ': 'O', 'Ō': 'O', 'Ø': 'O',
    'Ú': 'U', 'Ù': 'U', 'Ü': 'U', 'Û': 'U', 'Ū': 'U', 'Ų': 'U',
    'Ý': 'Y', 'Ÿ': 'Y',

    // Special consonants
    'ñ': 'n', 'Ñ': 'N',
    'ç': 'c', 'Ç': 'C',
    'ß': 'ss',
    'æ': 'ae', 'Æ': 'AE',
    'œ': 'oe', 'Œ': 'OE',
    'ł': 'l', 'Ł': 'L',
    'ś': 's', 'Ś': 'S',
    'ź': 'z', 'Ź': 'Z',
    'ż': 'z', 'Ż': 'Z',
    'ń': 'n', 'Ń': 'N',
  };

  // Replace accented characters
  accentMap.forEach((accented, plain) {
    normalized = normalized.replaceAll(accented, plain);
  });

  // Normalize smart quotes to straight quotes
  normalized = normalized.replaceAll('"', '"');
  normalized = normalized.replaceAll('"', '"');
  normalized = normalized.replaceAll(''', "'");
  normalized = normalized.replaceAll(''', "'");
  normalized = normalized.replaceAll('«', '"');
  normalized = normalized.replaceAll('»', '"');

  // Normalize various types of hyphens and dashes
  normalized = normalized.replaceAll('–', '-'); // en dash
  normalized = normalized.replaceAll('—', '-'); // em dash
  normalized = normalized.replaceAll('−', '-'); // minus sign
  normalized = normalized.replaceAll('‐', '-'); // hyphen
  normalized = normalized.replaceAll('‑', '-'); // non-breaking hyphen

  // Normalize ellipsis
  normalized = normalized.replaceAll('…', '...');

  // Convert to lowercase
  normalized = normalized.toLowerCase();

  // Remove all non-alphanumeric characters except spaces
  normalized = normalized.replaceAll(RegExp(r'[^a-z0-9\s]'), '');

  // Collapse multiple spaces into a single space
  normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

  // Trim leading and trailing spaces
  normalized = normalized.trim();

  return normalized;
}

///|
// Licence-plate letter alphabet. Ambiguous characters are omitted to mirror
// style plate data.
fn licence_chars() -> Array[Char] {
  [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R',
    'S', 'T', 'V', 'W', 'X', 'Y', 'Z',
  ]
}

// Render plate patterns where `$` is a plate letter and `#` is a digit.

///|
fn numerify_licence_plate(
  pattern : String,
  rng : @random.Rand,
) -> String raise @core.DummyError {
  let out = StringBuilder::new(size_hint=pattern.length())
  for ch in pattern {
    match ch {
      '$' => out.write_char(@core.pick(licence_chars(), rng))
      '#' => out.write_string(rng.int(limit=10).to_string())
      _ => out.write_char(ch)
    }
  }
  out.to_string()
}

///|
/// Generate a locale-shaped vehicle licence plate.
pub fn licence_plate(
  locale? : @locales.Locale = @locales.FR_FR,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let formats = @data.licence_plate_formats(locale)
    if formats.is_empty() {
      raise @core.DummyError::UnsupportedLocale(locale.code())
    } else {
      let pattern = @core.pick_string(formats, rng)
      numerify_licence_plate(pattern, rng)
    }
  })
}

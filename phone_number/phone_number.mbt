///|
/// Generate a locale-shaped phone number.
pub fn phone_number(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let pattern = @core.pick_string(@data.phone_number_formats(locale), rng)
    @core.numerify(pattern, rng)
  })
}

///|
/// Generate a locale-shaped mobile or cell phone number.
pub fn cell_number(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let pattern = @core.pick_string(@data.cell_number_formats(locale), rng)
    @core.numerify(pattern, rng)
  })
}

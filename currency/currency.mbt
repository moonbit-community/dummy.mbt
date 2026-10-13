///|
/// Generate an ISO-style currency code.
pub fn currency_code(
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.currency_codes(locale~), rng))
}

///|
/// Generate a currency display name.
pub fn currency_name(
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.currency_names(locale~), rng))
}

///|
/// Generate a currency symbol.
pub fn currency_symbol(
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.currency_symbols(locale~), rng))
}

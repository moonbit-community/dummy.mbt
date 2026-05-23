///|
/// Generate a first/given name for `locale`.
pub fn first_name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.name_first_names(locale), rng))
}

///|
/// Generate a last/family name for `locale`.
pub fn last_name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.name_last_names(locale), rng))
}

///|
/// Generate a name title or honorific for `locale`.
pub fn title(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.name_titles(locale), rng))
}

///|
/// Generate a name suffix for `locale`.
pub fn suffix(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.name_suffixes(locale), rng))
}

///|
/// Generate a full name using the selected locale template.
pub fn name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let first = first_name(locale~).dummy(rng)
    let last = last_name(locale~).dummy(rng)
    @core.render_template(@data.name_template(locale), [
      ("{FirstName}", first),
      ("{LastName}", last),
    ])
  })
}

///|
/// Generate a full name with a title using the selected locale template.
pub fn name_with_title(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let first = first_name(locale~).dummy(rng)
    let last = last_name(locale~).dummy(rng)
    let title = title(locale~).dummy(rng)
    @core.render_template(@data.name_with_title_template(locale), [
      ("{FirstName}", first),
      ("{LastName}", last),
      ("{Title}", title),
    ])
  })
}

///|
/// Generate a city prefix for `locale`.
pub fn city_prefix(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.city_prefixes(locale), rng))
}

///|
/// Generate a city suffix for `locale`.
pub fn city_suffix(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.city_suffixes(locale), rng))
}

///|
// Render a city stem from first/last name tables for templates that need a full
// name-shaped city component.
fn city_full_name(
  locale : @locales.Locale,
  rng : @random.Rand,
) -> String raise @core.DummyError {
  let first = @core.pick_string(@data.name_first_names(locale), rng)
  let last = @core.pick_string(@data.name_last_names(locale), rng)
  @core.render_template(@data.name_template(locale), [
    ("{FirstName}", first),
    ("{LastName}", last),
  ])
}

///|
// German and Dutch data has several city-name templates, including
// prefix and river variants, so it needs template-specific rendering.
fn special_city_name(
  locale : @locales.Locale,
  rng : @random.Rand,
) -> String raise @core.DummyError {
  let variant = rng.int(limit=5)
  let template = @data.city_name_templates(locale)[variant]
  match variant {
    0 =>
      @core.render_template(template, [
        ("{CityPrefix}", city_prefix(locale~).dummy(rng)),
        (
          "{CityName}",
          @core.pick_string(@data.city_names(locale), rng).to_lower(),
        ),
        ("{CitySuffix}", city_suffix(locale~).dummy(rng)),
      ])
    1 =>
      @core.render_template(template, [
        ("{CityPrefix}", city_prefix(locale~).dummy(rng)),
        ("{CityName}", @core.pick_string(@data.city_names(locale), rng)),
        ("{CitySuffix}", city_suffix(locale~).dummy(rng)),
      ])
    2 =>
      @core.render_template(template, [
        ("{CityPrefix}", city_prefix(locale~).dummy(rng)),
        ("{CityName}", city_full_name(locale, rng)),
        ("{CitySuffix}", city_suffix(locale~).dummy(rng)),
      ])
    3 =>
      @core.render_template(template, [
        ("{CityPrefix}", city_prefix(locale~).dummy(rng)),
        ("{CityName}", city_full_name(locale, rng)),
        ("{CitySuffix}", city_suffix(locale~).dummy(rng)),
        ("{River}", @core.pick_string(@data.city_rivers(locale), rng)),
      ])
    _ =>
      @core.render_template(template, [
        ("{CityName}", city_full_name(locale, rng)),
        ("{CitySuffix}", city_suffix(locale~).dummy(rng)),
      ])
  }
}

///|
/// Generate a city name using locale-specific templates.
pub fn city_name(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    match locale {
      DE_DE | NL_NL => return special_city_name(locale, rng)
      _ => ()
    }
    let base = @core.pick_string(@data.city_names(locale), rng)
    let suffix = city_suffix(locale~).dummy(rng)
    if rng.int(limit=5) == 0 {
      let prefix = city_prefix(locale~).dummy(rng)
      @core.render_template(@data.city_with_prefix_template(locale), [
        ("{CityPrefix}", prefix),
        ("{CityName}", base),
        ("{CitySuffix}", suffix),
      ])
    } else {
      @core.render_template(@data.city_template(locale), [
        ("{CityName}", base),
        ("{CitySuffix}", suffix),
      ])
    }
  })
}

///|
/// Generate a country name.
pub fn country_name(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.country_names(locale), rng))
}

///|
/// Generate a country code from the shared country-code table.
pub fn country_code() -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.country_codes(), rng))
}

///|
/// Generate a street suffix.
pub fn street_suffix(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.street_suffixes(locale), rng))
}

///|
/// Generate a full street name.
pub fn street_name(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let base = @core.pick_string(@data.street_names(locale), rng)
    let suffix = street_suffix(locale~).dummy(rng)
    @core.render_template(@data.street_template(locale), [
      ("{StreetName}", base),
      ("{StreetSuffix}", suffix),
    ])
  })
}

///|
/// Generate a time zone string.
pub fn time_zone(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.time_zones(locale~), rng))
}

///|
/// Generate a state, province, or region name.
pub fn state_name(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick(@data.states(locale), rng).0)
}

///|
/// Generate a state, province, or region abbreviation.
pub fn state_abbr(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick(@data.states(locale), rng).1)
}

///|
/// Generate a secondary address type such as `Apt.` or `Suite`.
pub fn secondary_address_type(
  locale~ : @locales.Locale = EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    @core.pick_string(@data.secondary_address_types(locale), rng)
  })
}

///|
/// Generate a secondary address designator with a unit number.
pub fn secondary_address(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let ty = secondary_address_type(locale~).dummy(rng)
    let n = rng.int(limit=900) + 100
    @core.render_template(@data.secondary_address_template(locale), [
      ("{SecondaryAddrType}", ty),
      ("{Number}", n.to_string()),
    ])
  })
}

///|
// Letter alphabet used by ZIP/post-code patterns. Ambiguous characters
// such as `I`, `O`, and `U` are intentionally omitted.
fn zip_code_letters() -> Array[String] {
  [
    "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R",
    "S", "T", "V", "W", "X", "Y", "Z",
  ]
}

///|
// Render locale-specific postal patterns. `#` is 0-9, `^` is 1-9, and `$` is a
// letter from `zip_code_letters`.
fn render_zip_format(
  pattern : String,
  rng : @random.Rand,
) -> String raise @core.DummyError {
  let out = StringBuilder(size_hint=pattern.length())
  for ch in pattern {
    match ch {
      '#' => out.write_string(rng.int(limit=10).to_string())
      '^' => out.write_string((rng.int(limit=9) + 1).to_string())
      '$' => out.write_string(@core.pick_string(zip_code_letters(), rng))
      _ => out.write_char(ch)
    }
  }
  out.to_string()
}

///|
/// Generate a ZIP-code-shaped string for `locale`.
pub fn zip_code(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let fmt = @core.pick_string(@data.zip_formats(locale), rng)
    render_zip_format(fmt, rng)
  })
}

///|
/// Generate a postal-code-shaped string for `locale`.
pub fn post_code(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let fmt = @core.pick_string(@data.post_code_formats(locale), rng)
    render_zip_format(fmt, rng)
  })
}

///|
/// Generate a building number from locale-specific numeric patterns.
pub fn building_number(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let fmt = @core.pick_string(@data.building_number_formats(locale), rng)
    @core.numerify(fmt, rng)
  })
}

///|
/// Generate a decimal latitude string.
pub fn latitude() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let sign = if rng.boolean() { "" } else { "-" }
    sign +
    rng.int(limit=90).to_string() +
    "." +
    @core.random_digit_string(6, rng)
  })
}

///|
/// Generate a decimal longitude string.
pub fn longitude() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let sign = if rng.boolean() { "" } else { "-" }
    sign +
    rng.int(limit=180).to_string() +
    "." +
    @core.random_digit_string(6, rng)
  })
}

///|
/// Generate a geohash-like string with `precision` base32 characters.
pub fn geohash(precision~ : Int32 = 8) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    if precision <= 0 {
      raise InvalidCount(precision)
    }
    let chars = @data.geohash_chars()
    let out = StringBuilder(size_hint=precision)
    for _ in 0..<precision {
      out.write_string(@core.pick_string(chars, rng))
    }
    out.to_string()
  })
}

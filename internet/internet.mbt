///|
/// Generate a free email provider domain.
pub fn free_email_provider(
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.email_providers(locale~), rng))
}

///|
/// Generate a domain suffix such as `com` or a locale-specific TLD.
pub fn domain_suffix(
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.domain_suffixes(locale~), rng))
}

///|
/// Generate a lowercase username from names, words, and digits.
pub fn username(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    match rng.int(limit=256) {
      0 => @core.pick_string(@data.name_first_names(locale), rng).to_lower()
      1 | 2 =>
        @core.pick_string(@data.lorem_words(locale), rng) +
        "." +
        @core.pick_string(@data.name_first_names(locale), rng).to_lower()
      3 | 4 =>
        @core.pick_string(@data.name_first_names(locale), rng).to_lower() +
        rng.int(limit=256).to_string()
      _ =>
        @core.pick_string(@data.name_first_names(locale), rng).to_lower() +
        "_" +
        @core.pick_string(@data.lorem_words(locale), rng)
    }
  })
}

///|
/// Generate an email address at a free provider.
pub fn free_email(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    username(locale~).dummy(rng) + "@" + free_email_provider(locale~).dummy(rng)
  })
}

///|
/// Generate an email address under documentation-safe `example.*` domains.
pub fn safe_email(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let domain = @core.pick_string(["com", "net", "org"], rng)
    @core.pick_string(@data.name_first_names(locale), rng).to_lower() +
    "@example." +
    domain
  })
}

///|
/// Generate a password whose length is sampled from `len_range`.
pub fn password(
  len_range~ : @core.CountRange = @core.count_range(8, 16),
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let len = len_range.sample(rng)
    let chars = @data.password_chars()
    let out = StringBuilder::new(size_hint=len)
    for _ in 0..<len {
      out.write_string(@core.pick_string(chars, rng))
    }
    out.to_string()
  })
}

///|
/// Generate a dotted IPv4 address string.
pub fn ipv4() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    "\{rng.int(limit=256)}.\{rng.int(limit=256)}.\{rng.int(limit=256)}.\{rng.int(limit=256)}"
  })
}

///|
/// Generate an IPv6 address string.
pub fn ipv6() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let parts : Array[String] = []
    for _ in 0..<8 {
      parts.push(rng.int(limit=65536).to_string(radix=16).to_upper())
    }
    parts.join(":")
  })
}

///|
/// Generate an IP address string.
///
/// Currently this uses the package's IPv4 generator.
pub fn ip() -> @core.Gen[String] {
  ipv4()
}

///|
/// Generate a colon-separated MAC address string.
pub fn mac_address() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let parts : Array[String] = []
    for _ in 0..<6 {
      parts.push(@core.hex_byte(rng.int(limit=256)))
    }
    parts.join(":")
  })
}

///|
/// Generate a user-agent string from the table.
pub fn user_agent() -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.user_agents(), rng))
}

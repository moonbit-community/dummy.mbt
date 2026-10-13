///|
fn is_decimal_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn all_decimal_digits(s : String) -> Bool {
  for ch in s {
    if !is_decimal_digit(ch) {
      return false
    }
  }
  true
}

///|
fn sample_contains(items : ArrayView[String], needle : String) -> Bool {
  for item in items {
    if item.contains(needle) {
      return true
    }
  }
  false
}

///|
fn is_zip_letter(ch : Char) -> Bool {
  match ch {
    'A'
    | 'B'
    | 'C'
    | 'D'
    | 'E'
    | 'F'
    | 'G'
    | 'H'
    | 'J'
    | 'K'
    | 'L'
    | 'M'
    | 'N'
    | 'P'
    | 'Q'
    | 'R'
    | 'S'
    | 'T'
    | 'V'
    | 'W'
    | 'X'
    | 'Y'
    | 'Z' => true
    _ => false
  }
}

///|
fn is_nl_postcode(s : String) -> Bool {
  if s.length() != 7 || s.get_char(4) != Some(' ') {
    false
  } else {
    match
      (
        s.get_char(0),
        s.get_char(1),
        s.get_char(2),
        s.get_char(3),
        s.get_char(5),
        s.get_char(6),
      ) {
      (Some(a), Some(b), Some(c), Some(d), Some(e), Some(f)) =>
        is_decimal_digit(a) &&
        is_decimal_digit(b) &&
        is_decimal_digit(c) &&
        is_decimal_digit(d) &&
        is_zip_letter(e) &&
        is_zip_letter(f)
      _ => false
    }
  }
}

///|
fn is_geohash_char(ch : Char) -> Bool {
  match ch {
    '0'..<='9'
    | 'b'
    | 'c'
    | 'd'
    | 'e'
    | 'f'
    | 'g'
    | 'h'
    | 'j'
    | 'k'
    | 'm'
    | 'n'
    | 'p'
    | 'q'
    | 'r'
    | 's'
    | 't'
    | 'u'
    | 'v'
    | 'w'
    | 'x'
    | 'y'
    | 'z' => true
    _ => false
  }
}

///|
test "city and street names follow locale shape" {
  let rng = @core.seed(b"address-locale")
  let en_street = @address.street_name(locale=EN).dummy(rng)
  assert_true(en_street.contains(" "))
  let zh_city = @address.city_name(locale=ZH_CN).dummy(rng)
  assert_true(
    zh_city.has_suffix("城") ||
    zh_city.has_suffix("镇") ||
    zh_city.has_suffix("乡") ||
    zh_city.has_suffix("市"),
  )
  let zh_street = @address.street_name(locale=ZH_CN).dummy(rng)
  assert_true(
    zh_street.has_suffix("路") ||
    zh_street.has_suffix("街") ||
    zh_street.has_suffix("道") ||
    zh_street.has_suffix("巷") ||
    zh_street.has_suffix("桥"),
  )
}

///|
test "country state timezone and secondary address are non-empty" {
  let rng = @core.seed(b"address-shared")
  assert_true(!@address.country_name(locale=FR_FR).dummy(rng).is_empty())
  @test.assert_eq(@address.country_code().dummy(rng).length(), 2)
  assert_true(!@address.state_name().dummy(rng).is_empty())
  assert_true(!@address.state_abbr().dummy(rng).is_empty())
  assert_true(@address.time_zone().dummy(rng).contains("/"))
  assert_true(!@address.secondary_address().dummy(rng).is_empty())
}

///|
test "address non-first-wave locales use data where available" {
  let rng = @core.seed(b"address-extra-locales")
  let fr_street = @address.street_name(locale=FR_FR).dummy(rng)
  assert_true(fr_street.contains(" "))
  @test.assert_eq(@address.zip_code(locale=FR_FR).dummy(rng).length(), 5)
  @test.assert_eq(@address.post_code(locale=PT_BR).dummy(rng).length(), 9)
  let nl_zip = @address.zip_code(locale=NL_NL).dummy(rng)
  assert_true(is_nl_postcode(nl_zip))
  assert_true(!@address.state_name(locale=PT_BR).dummy(rng).is_empty())
  @test.assert_eq(@address.state_abbr(locale=PT_BR).dummy(rng).length(), 2)
  @test.assert_eq(@address.time_zone(locale=FR_FR).dummy(rng), "Europe/Paris")
}

///|
test "de and nl city names use special templates" {
  let de = @address.city_name(locale=DE_DE).sample(
    count=64,
    @core.seed(b"address-city-de-special"),
  )
  assert_true(sample_contains(de, "-"))
  assert_true(sample_contains(de, "("))
  assert_true(!sample_contains(de, "{River}"))
  let nl = @address.city_name(locale=NL_NL).sample(
    count=64,
    @core.seed(b"address-city-nl-special"),
  )
  assert_true(sample_contains(nl, "-"))
  assert_true(sample_contains(nl, "{River}"))
}

///|
test "zip code formats are locale-specific" {
  let rng = @core.seed(b"address-zip")
  let en = @address.zip_code(locale=EN).dummy(rng)
  assert_true(en.length() == 5 || en.length() == 10)
  let zh_cn = @address.zip_code(locale=ZH_CN).dummy(rng)
  @test.assert_eq(zh_cn.length(), 6)
  assert_true(all_decimal_digits(zh_cn))
  let zh_tw = @address.zip_code(locale=ZH_TW).dummy(rng)
  assert_true(!zh_tw.is_empty())
  let tw_fallback_seed = b"address-zip-tw-fallback"
  @test.assert_eq(
    @address.zip_code(locale=ZH_TW).dummy(@core.seed(tw_fallback_seed)),
    @address.zip_code(locale=EN).dummy(@core.seed(tw_fallback_seed)),
  )
}

///|
test "coordinate and geohash strings have expected shape" {
  let rng = @core.seed(b"address-geo")
  assert_true(@address.latitude().dummy(rng).contains("."))
  assert_true(@address.longitude().dummy(rng).contains("."))
  let geohash = @address.geohash(precision=12).dummy(rng)
  @test.assert_eq(geohash.length(), 12)
  for ch in geohash {
    assert_true(is_geohash_char(ch))
  }
  try @address.geohash(precision=0).dummy(@core.seed(b"bad-geohash")) catch {
    error => assert_true(error is InvalidCount(_))
  } noraise {
    _ => fail("expected InvalidCount to be raised")
  }
}

///|
test "address fixed seed locale golden outputs" {
  let en_city = @address.city_name(locale=EN).dummy(
    @core.seed(b"address-city-en"),
  )
  let en_street = @address.street_name(locale=EN).dummy(
    @core.seed(b"address-street-en"),
  )
  let en_zip = @address.zip_code(locale=EN).dummy(@core.seed(b"address-zip-en"))
  let zh_cn_city = @address.city_name(locale=ZH_CN).dummy(
    @core.seed(b"address-city-cn"),
  )
  let zh_cn_street = @address.street_name(locale=ZH_CN).dummy(
    @core.seed(b"address-street-cn"),
  )
  let zh_cn_zip = @address.zip_code(locale=ZH_CN).dummy(
    @core.seed(b"address-zip-cn"),
  )
  let zh_tw_zip_seed = b"address-zip-tw"
  let zh_tw_zip = @address.zip_code(locale=ZH_TW).dummy(
    @core.seed(zh_tw_zip_seed),
  )
  let zh_tw_secondary = @address.secondary_address(locale=ZH_TW).dummy(
    @core.seed(b"address-secondary-tw"),
  )
  assert_true(!en_city.is_empty())
  assert_true(en_street.contains(" "))
  assert_true(en_zip.length() == 5 || en_zip.length() == 10)
  assert_true(!zh_cn_city.contains(" "))
  assert_true(!zh_cn_street.contains(" "))
  @test.assert_eq(zh_cn_zip.length(), 6)
  assert_true(all_decimal_digits(zh_cn_zip))
  assert_true(!zh_tw_zip.is_empty())
  @test.assert_eq(
    zh_tw_zip,
    @address.zip_code(locale=EN).dummy(@core.seed(zh_tw_zip_seed)),
  )
  assert_true(!zh_tw_secondary.is_empty())
}

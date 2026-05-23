///|
fn is_upper_letter(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
fn is_decimal_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn is_upper_alnum(ch : Char) -> Bool {
  is_upper_letter(ch) || is_decimal_digit(ch)
}

///|
fn is_vowel(ch : Char) -> Bool {
  ch == 'A' || ch == 'E' || ch == 'I' || ch == 'O' || ch == 'U'
}

///|
fn compat_finance_iso3166_codes() -> Array[String] {
  [
    "AC", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AN", "AO", "AQ", "AR", "AS",
    "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI",
    "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BU", "BV", "BW", "BY",
    "BZ", "CA", "CC", "CD", "CE", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN",
    "CO", "CP", "CR", "CS", "CS", "CU", "CV", "CW", "CX", "CY", "CZ", "DD", "DE",
    "DG", "DJ", "DK", "DM", "DO", "DZ", "EA", "EC", "EE", "EG", "EH", "ER", "ES",
    "ET", "EU", "FI", "FJ", "FK", "FM", "FO", "FR", "FX", "GA", "GB", "GD", "GE",
    "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU",
    "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "IC", "ID", "IE", "IL", "IM",
    "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH",
    "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK",
    "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH",
    "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW",
    "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR",
    "NT", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN",
    "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB",
    "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR",
    "SS", "ST", "SU", "SV", "SX", "SY", "SZ", "TA", "TC", "TD", "TF", "TG", "TH",
    "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG",
    "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS",
    "YE", "YT", "YU", "ZA", "ZM", "ZR", "ZW",
  ]
}

///|
fn compat_finance_only_iso3166_codes() -> Array[String] {
  [
    "AC", "AN", "BU", "CE", "CP", "CS", "DD", "DG", "EA", "EU", "FX", "IC", "NT",
    "SU", "TA", "YU", "ZR",
  ]
}

///|
fn contains_string(items : ArrayView[String], value : String) -> Bool {
  for item in items {
    if item == value {
      return true
    }
  }
  false
}

///|
fn char_at_is(s : String, i : Int, pred : (Char) -> Bool) -> Bool {
  match s.get_char(i) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn two_chars_at(s : String, i : Int) -> String? {
  guard s.get_char(i) is Some(a) else { return None }
  guard s.get_char(i + 1) is Some(b) else { return None }
  let out = StringBuilder::new(size_hint=2)
  out.write_char(a)
  out.write_char(b)
  Some(out.to_string())
}

///|
fn bic_suffix_is_compat_shape(s : String) -> Bool {
  guard s.get_char(8) is Some(a) else { return false }
  guard s.get_char(9) is Some(b) else { return false }
  guard s.get_char(10) is Some(c) else { return false }
  (is_decimal_digit(a) && is_decimal_digit(b) && is_decimal_digit(c)) ||
  (is_upper_letter(a) && is_vowel(b) && is_upper_letter(c))
}

///|
fn expanded_isin_digits(s : String) -> Array[Int]? {
  let digits : Array[Int] = []
  for ch in s {
    let code = ch.to_int()
    if code >= '0'.to_int() && code <= '9'.to_int() {
      digits.push(code - '0'.to_int())
    } else if code >= 'A'.to_int() && code <= 'Z'.to_int() {
      let value = code - 'A'.to_int() + 10
      digits.push(value / 10)
      digits.push(value % 10)
    } else {
      return None
    }
  }
  Some(digits)
}

///|
fn isin_luhn_valid(s : String) -> Bool {
  guard expanded_isin_digits(s) is Some(digits) else { return false }
  let mut sum = 0
  for i in 0..<digits.length() {
    let from_right = digits.length() - 1 - i
    let mut value = digits[from_right]
    if i % 2 == 1 {
      value *= 2
      if value > 9 {
        value = value / 10 + value % 10
      }
    }
    sum += value
  }
  sum % 10 == 0
}

///|
test "bic follows finance ISO and suffix rules" {
  let values = @finance.bic().sample(count=256, @core.seed(b"bic"))
  let mut saw_eight_char_bic = false
  let mut saw_digit_suffix = false
  let mut saw_letter_suffix = false
  for value in values {
    assert_true(value.length() == 8 || value.length() == 11)
    assert_true(all_chars_match(value, is_upper_alnum))
    for i in 0..<6 {
      assert_true(char_at_is(value, i, is_upper_letter))
    }
    assert_true(char_at_is(value, 3, is_vowel))
    guard two_chars_at(value, 4) is Some(country) else {
      fail("missing BIC country code")
    }
    assert_true(contains_string(compat_finance_iso3166_codes(), country))
    assert_true(char_at_is(value, 6, is_upper_letter))
    assert_true(char_at_is(value, 7, ch => ch == '1'))
    if value.length() == 8 {
      saw_eight_char_bic = true
    } else {
      assert_true(bic_suffix_is_compat_shape(value))
      if char_at_is(value, 8, is_decimal_digit) {
        saw_digit_suffix = true
      } else {
        saw_letter_suffix = true
      }
    }
  }
  assert_true(saw_eight_char_bic)
  assert_true(saw_digit_suffix)
  assert_true(saw_letter_suffix)
}

///|
test "isin has the standard length, country table, and checksum" {
  let values = @finance.isin().sample(count=32, @core.seed(b"isin"))
  for value in values {
    @test.assert_eq(value.length(), 12)
    guard two_chars_at(value, 0) is Some(country) else {
      fail("missing ISIN country code")
    }
    assert_true(contains_string(compat_finance_iso3166_codes(), country))
    assert_true(char_at_is(value, 0, is_upper_letter))
    assert_true(char_at_is(value, 1, is_upper_letter))
    for i in 2..<11 {
      assert_true(char_at_is(value, i, is_upper_alnum))
    }
    assert_true(char_at_is(value, 11, is_decimal_digit))
    assert_true(isin_luhn_valid(value))
  }
}

///|
test "finance generators can draw finance-only ISO codes" {
  let mut saw_bic_finance_only_iso = false
  for
    value in @finance.bic().sample(
      count=512,
      @core.seed(b"bic-finance-only-iso"),
    ) {
    guard two_chars_at(value, 4) is Some(country) else {
      fail("missing BIC country code")
    }
    if contains_string(compat_finance_only_iso3166_codes(), country) {
      saw_bic_finance_only_iso = true
    }
  }
  let mut saw_isin_finance_only_iso = false
  for
    value in @finance.isin().sample(
      count=512,
      @core.seed(b"isin-finance-only-iso"),
    ) {
    guard two_chars_at(value, 0) is Some(country) else {
      fail("missing ISIN country code")
    }
    if contains_string(compat_finance_only_iso3166_codes(), country) {
      saw_isin_finance_only_iso = true
    }
  }
  assert_true(saw_bic_finance_only_iso)
  assert_true(saw_isin_finance_only_iso)
}

///|
test "finance generators are deterministic for the same seed" {
  let a = @finance.bic().sample(count=8, @core.seed(b"finance-determinism"))
  let b = @finance.bic().sample(count=8, @core.seed(b"finance-determinism"))
  @test.assert_eq(a, b)
  let c = @finance.isin().sample(count=8, @core.seed(b"isin-determinism"))
  let d = @finance.isin().sample(count=8, @core.seed(b"isin-determinism"))
  @test.assert_eq(c, d)
}

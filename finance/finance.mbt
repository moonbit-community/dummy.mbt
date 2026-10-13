///|
// One uppercase ASCII letter used by BIC and ISIN stems.
fn upper_letter(rng : @random.Rand) -> String raise @core.DummyError {
  let letters : Array[String] = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
  ]
  @core.pick_string(letters, rng)
}

///|
// One uppercase ASCII letter or decimal digit used by ISIN stems.
fn upper_alphanumeric(rng : @random.Rand) -> String raise @core.DummyError {
  let chars : Array[String] = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5",
    "6", "7", "8", "9",
  ]
  @core.pick_string(chars, rng)
}

///|
// BIC location code in this package's generated shape uses an uppercase vowel.
fn upper_vowel(rng : @random.Rand) -> String raise @core.DummyError {
  @core.pick_string(["A", "E", "I", "O", "U"], rng)
}

///|
// ISO-3166-like country code table copied from finance data.
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
// Pick the two-letter country prefix for BIC/ISIN generation.
fn iso3166_code(rng : @random.Rand) -> String raise @core.DummyError {
  @core.pick_string(compat_finance_iso3166_codes(), rng)
}

///|
// Expand ISIN letters into decimal digits (`A` -> 10, ..., `Z` -> 35) before
// applying the Luhn check.
fn expanded_isin_digits(s : String) -> Array[Int32] {
  let digits : Array[Int32] = []
  for ch in s {
    let code = ch.to_int()
    if code >= '0'.to_int() && code <= '9'.to_int() {
      digits.push(code - '0'.to_int())
    } else {
      let value = code - 'A'.to_int() + 10
      digits.push(value / 10)
      digits.push(value % 10)
    }
  }
  digits
}

///|
// Compute the final ISIN check digit from the 11-character stem.
fn isin_check_digit(stem : String) -> String {
  let digits = expanded_isin_digits(stem)
  let mut sum = 0
  for i in 0..<digits.length() {
    let from_right = digits.length() - 1 - i
    let mut value = digits[from_right]
    if i % 2 == 0 {
      value *= 2
      if value > 9 {
        value = value / 10 + value % 10
      }
    }
    sum += value
  }
  ((10 - sum % 10) % 10).to_string()
}

///|
/// Generate a Bank Identifier Code.
///
/// The output follows the shape: bank code, country code, location code,
/// and an optional branch suffix.
pub fn bic() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let out = StringBuilder::new(size_hint=11)
    for _ in 0..<3 {
      out.write_string(upper_letter(rng))
    }
    out.write_string(upper_vowel(rng))
    out.write_string(iso3166_code(rng))
    out.write_string(upper_letter(rng))
    out.write_string("1")
    let suffix_kind = rng.int(limit=100)
    if suffix_kind >= 50 && suffix_kind < 90 {
      for _ in 0..<3 {
        out.write_string(rng.int(limit=10).to_string())
      }
    } else if suffix_kind >= 90 {
      out.write_string(upper_letter(rng))
      out.write_string(upper_vowel(rng))
      out.write_string(upper_letter(rng))
    }
    out.to_string()
  })
}

///|
/// Generate an International Securities Identification Number.
///
/// The final character is a Luhn-style check digit computed from the generated
/// country prefix and nine-character body.
pub fn isin() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let country = iso3166_code(rng)
    let body = StringBuilder::new(size_hint=9)
    for _ in 0..<9 {
      body.write_string(upper_alphanumeric(rng))
    }
    let stem = country + body.to_string()
    stem + isin_check_digit(stem)
  })
}

///|
fn port_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn port_digit_value(ch : Char) -> Int32 {
  ch.to_int() - '0'.to_int()
}

///|
fn port_is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  port_is_digit(ch) || (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn port_is_lower_ascii(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'a'.to_int() && code <= 'z'.to_int()
}

///|
fn port_char_at_eq(s : String, i : Int32, expected : Char) -> Bool {
  s.get_char(i) == Some(expected)
}

///|
fn port_char_at_is(s : String, i : Int32, pred : (Char) -> Bool) -> Bool {
  match s.get_char(i) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn port_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn port_is_uuid_variant(ch : Char) -> Bool {
  ch == '8' || ch == '9' || ch == 'a' || ch == 'b'
}

///|
fn port_valid_uuid_string(s : String, version : Char?) -> Bool {
  if s.length() != 36 ||
    !port_char_at_eq(s, 8, '-') ||
    !port_char_at_eq(s, 13, '-') ||
    !port_char_at_eq(s, 18, '-') ||
    !port_char_at_eq(s, 23, '-') ||
    !port_char_at_is(s, 19, port_is_uuid_variant) {
    return false
  }
  match version {
    Some(ch) => if !port_char_at_eq(s, 14, ch) { return false }
    None => ()
  }
  for i in 0..<36 {
    if i != 8 && i != 13 && i != 18 && i != 23 {
      if !port_char_at_is(s, i, port_is_lower_hex) {
        return false
      }
    }
  }
  true
}

///|
fn port_is_ulid_char(ch : Char) -> Bool {
  for
    candidate in [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
      'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X',
      'Y', 'Z',
    ] {
    if ch == candidate {
      return true
    }
  }
  false
}

///|
fn port_valid_ulid_string(s : String) -> Bool {
  s.length() == 26 &&
  port_char_at_is(s, 0, ch => ch >= '0' && ch <= '7') &&
  port_all_chars_match(s, port_is_ulid_char)
}

///|
fn port_is_standard_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  port_is_digit(ch) ||
  ch == '+' ||
  ch == '/'
}

///|
fn port_is_url_safe_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  port_is_digit(ch) ||
  ch == '-' ||
  ch == '_'
}

///|
fn port_valid_base64_string(
  s : String,
  url_safe : Bool,
  allow_padding : Bool,
) -> Bool {
  let mut seen_padding = false
  let mut padding_count = 0
  for ch in s {
    if ch == '=' {
      if !allow_padding {
        return false
      }
      seen_padding = true
      padding_count += 1
      if padding_count > 2 {
        return false
      }
    } else {
      if seen_padding {
        return false
      }
      if url_safe {
        if !port_is_url_safe_base64_char(ch) {
          return false
        }
      } else if !port_is_standard_base64_char(ch) {
        return false
      }
    }
  }
  if padding_count > 0 {
    s.length() % 4 == 0
  } else {
    s.length() % 4 != 1
  }
}

///|
fn port_digit_at(s : String, i : Int32) -> Int32? {
  match s.get_char(i) {
    Some(ch) =>
      if port_is_digit(ch) {
        Some(port_digit_value(ch))
      } else {
        None
      }
    None => None
  }
}

///|
fn port_two_digits_at(s : String, i : Int32) -> Int32? {
  match (port_digit_at(s, i), port_digit_at(s, i + 1)) {
    (Some(a), Some(b)) => Some(a * 10 + b)
    _ => None
  }
}

///|
fn port_all_digits_between(s : String, start : Int32, end : Int32) -> Bool {
  for i in start..<end {
    if !port_char_at_is(s, i, port_is_digit) {
      return false
    }
  }
  true
}

///|
fn port_valid_hms_at(s : String, start : Int32) -> Bool {
  guard port_two_digits_at(s, start) is Some(hour) else { return false }
  guard port_two_digits_at(s, start + 3) is Some(minute) else { return false }
  guard port_two_digits_at(s, start + 6) is Some(second) else { return false }
  port_char_at_eq(s, start + 2, ':') &&
  port_char_at_eq(s, start + 5, ':') &&
  hour >= 0 &&
  hour < 24 &&
  minute >= 0 &&
  minute < 60 &&
  second >= 0 &&
  second < 60
}

///|
fn port_valid_ymd_date(s : String, sep : Char) -> Bool {
  guard port_two_digits_at(s, 5) is Some(month) else { return false }
  guard port_two_digits_at(s, 8) is Some(day) else { return false }
  s.length() == 10 &&
  port_all_digits_between(s, 0, 4) &&
  port_char_at_eq(s, 4, sep) &&
  port_char_at_eq(s, 7, sep) &&
  month >= 1 &&
  month <= 12 &&
  day >= 1 &&
  day <= 31
}

///|
fn port_valid_dmy_date(s : String, sep : Char) -> Bool {
  guard port_two_digits_at(s, 0) is Some(day) else { return false }
  guard port_two_digits_at(s, 3) is Some(month) else { return false }
  s.length() == 10 &&
  port_char_at_eq(s, 2, sep) &&
  port_char_at_eq(s, 5, sep) &&
  port_all_digits_between(s, 6, 10) &&
  month >= 1 &&
  month <= 12 &&
  day >= 1 &&
  day <= 31
}

///|
fn port_valid_time_with_frac(s : String) -> Bool {
  s.length() == 18 &&
  port_valid_hms_at(s, 0) &&
  port_char_at_eq(s, 8, '.') &&
  port_all_digits_between(s, 9, 18)
}

///|
fn port_valid_chrono_en_datetime(s : String) -> Bool {
  s.length() == 25 &&
  port_valid_ymd_date(s[0:10].to_owned(), '-') &&
  port_char_at_eq(s, 10, 'T') &&
  port_valid_hms_at(s, 11) &&
  s.has_suffix("+00:00")
}

///|
fn port_valid_time_en_datetime(s : String) -> Bool {
  s.length() == 24 &&
  port_valid_ymd_date(s[0:10].to_owned(), '-') &&
  port_char_at_eq(s, 10, 'T') &&
  port_valid_hms_at(s, 11) &&
  s.has_suffix("+0000")
}

///|
fn[T : @core.DummyDefault] port_dummy_default_sequence(
  seed_bytes : Bytes,
  count : Int32,
) -> Array[T] raise @core.DummyError {
  let rng = @dummy.seed(seed_bytes)
  Array::makei(count, _ => T::dummy_default(rng))
}

///|
test "impls identifier string formats are ported" {
  let rng = @dummy.seed(b"impls-port-identifiers")
  for value in @dummy.uuid().sample(count=24, rng) {
    assert_true(port_valid_uuid_string(value, None))
  }
  for
    item in [
      (@dummy.uuid_v1(), '1'),
      (@dummy.uuid_v3(), '3'),
      (@dummy.uuid_v4(), '4'),
      (@dummy.uuid_v5(), '5'),
      (@dummy.uuid_v6(), '6'),
      (@dummy.uuid_v7(), '7'),
      (@dummy.uuid_v8(), '8'),
    ] {
    let (gen, version) = item
    for value in gen.sample(count=8, rng) {
      assert_true(port_valid_uuid_string(value, Some(version)))
    }
  }
  for value in @dummy.ulid().sample(count=24, rng) {
    assert_true(port_valid_ulid_string(value))
  }
  for value in @dummy.bson_object_id().sample(count=24, rng) {
    assert_true(value.length() == 24)
    assert_true(port_all_chars_match(value, port_is_lower_hex))
  }
  @test.assert_eq(
    @dummy.bson_object_id().sample(
      count=12,
      @dummy.seed(b"impls-port-bson-alias"),
    ),
    @dummy.bson_oid().sample(count=12, @dummy.seed(b"impls-port-bson-alias")),
  )
}

///|
test "impls base64 string formats are ported" {
  let rng = @dummy.seed(b"impls-port-base64")
  for value in @dummy.base64().sample(count=64, rng) {
    assert_true(port_valid_base64_string(value, false, true))
  }
  for value in @dummy.base64_padded().sample(count=64, rng) {
    assert_true(value.length() % 4 == 0)
    assert_true(port_valid_base64_string(value, false, true))
  }
  for value in @dummy.base64_no_pad().sample(count=64, rng) {
    assert_true(!value.contains("="))
    assert_true(port_valid_base64_string(value, false, false))
  }
  for value in @dummy.url_safe_base64().sample(count=64, rng) {
    assert_true(!value.contains("+"))
    assert_true(!value.contains("/"))
    assert_true(port_valid_base64_string(value, true, true))
  }
  for value in @dummy.url_safe_base64_padded().sample(count=64, rng) {
    assert_true(value.length() % 4 == 0)
    assert_true(port_valid_base64_string(value, true, true))
  }
  for value in @dummy.url_safe_base64_no_pad().sample(count=64, rng) {
    assert_true(!value.contains("="))
    assert_true(port_valid_base64_string(value, true, false))
  }
}

///|
test "impls chrono and time string component ranges are ported" {
  let rng = @dummy.seed(b"impls-port-time")
  for value in @dummy.chrono_time().sample(count=24, rng) {
    assert_true(port_valid_time_with_frac(value))
  }
  for value in @dummy.chrono_time(locale=@dummy.it_it).sample(count=12, rng) {
    assert_true(value.length() == 8)
    assert_true(port_valid_hms_at(value, 0))
  }
  for value in @dummy.chrono_date().sample(count=24, rng) {
    assert_true(port_valid_ymd_date(value, '-'))
  }
  for value in @dummy.chrono_date(locale=@dummy.fa_ir).sample(count=12, rng) {
    assert_true(port_valid_ymd_date(value, '/'))
  }
  for value in @dummy.chrono_date(locale=@dummy.pt_pt).sample(count=12, rng) {
    assert_true(port_valid_dmy_date(value, '-'))
  }
  for value in @dummy.chrono_date(locale=@dummy.tr_tr).sample(count=12, rng) {
    assert_true(port_valid_dmy_date(value, '.'))
  }
  for value in @dummy.chrono_date_time().sample(count=24, rng) {
    assert_true(port_valid_chrono_en_datetime(value))
  }
  for value in @dummy.time_time().sample(count=24, rng) {
    assert_true(port_valid_time_with_frac(value))
  }
  for value in @dummy.time_date_time().sample(count=24, rng) {
    assert_true(port_valid_time_en_datetime(value))
  }
  for minutes in @dummy.time_duration().sample(count=48, rng) {
    assert_true(minutes >= 0 && minutes <= 366 * 1440)
  }
  for minutes in @dummy.chrono_duration().sample(count=48, rng) {
    assert_true(minutes >= 0 && minutes < 366 * 1440)
  }
}

///|
test "impls primitive and collection-compatible defaults are ported" {
  let ranged = @dummy.int(range=@dummy.int_range(-25, 25)).sample(
    count=64,
    @dummy.seed(b"impls-port-int-range"),
  )
  for value in ranged {
    assert_true(value >= -25 && value < 25)
  }
  for value in @dummy.digit().sample(count=64, @dummy.seed(b"impls-port-digit")) {
    assert_true(value >= 0 && value <= 9)
  }
  for
    value in @dummy.boolean(ratio=0).sample(
      count=24,
      @dummy.seed(b"impls-port-bool-zero"),
    ) {
    assert_true(!value)
  }
  for
    value in @dummy.boolean(ratio=100).sample(
      count=24,
      @dummy.seed(b"impls-port-bool-one-hundred"),
    ) {
    assert_true(value)
  }
  let strings : Array[String] = port_dummy_default_sequence(
    b"impls-port-default-string", 32,
  )
  @test.assert_eq(
    strings,
    port_dummy_default_sequence(b"impls-port-default-string", 32),
  )
  for value in strings {
    assert_true(value.length() >= 4 && value.length() <= 10)
    assert_true(port_all_chars_match(value, port_is_lower_ascii))
  }
  let arrays : Array[Array[Int32]] = port_dummy_default_sequence(
    b"impls-port-default-array", 16,
  )
  @test.assert_eq(
    arrays,
    port_dummy_default_sequence(b"impls-port-default-array", 16),
  )
  for values in arrays {
    assert_true(values.length() >= 0 && values.length() <= 4)
  }
  let options : Array[Int32?] = port_dummy_default_sequence(
    b"impls-port-default-option", 32,
  )
  @test.assert_eq(
    options,
    port_dummy_default_sequence(b"impls-port-default-option", 32),
  )
  let results : Array[Result[Int32, String]] = port_dummy_default_sequence(
    b"impls-port-default-result", 32,
  )
  @test.assert_eq(
    results,
    port_dummy_default_sequence(b"impls-port-default-result", 32),
  )
  let tuples : Array[(Bool, Int32, String, Int32?)] = port_dummy_default_sequence(
    b"impls-port-default-tuple", 16,
  )
  @test.assert_eq(
    tuples,
    port_dummy_default_sequence(b"impls-port-default-tuple", 16),
  )
}

///|
fn extra_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn extra_is_upper_letter(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
fn extra_digit_value(ch : Char) -> Int32 {
  ch.to_int() - '0'.to_int()
}

///|
fn extra_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn extra_count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn extra_decimal_string_to_int(s : String) -> Int32 {
  let mut value = 0
  for ch in s {
    value = value * 10 + extra_digit_value(ch)
  }
  value
}

///|
fn extra_decimal_mod_97(digits : String) -> Int32 {
  let mut rem = 0
  for ch in digits {
    rem = (rem * 10 + extra_digit_value(ch)) % 97
  }
  rem
}

///|
fn extra_parse_unsigned_decimal(s : String) -> Int32? {
  if s.is_empty() {
    return None
  }
  let mut value = 0
  for ch in s {
    if !extra_is_digit(ch) {
      return None
    }
    value = value * 10 + extra_digit_value(ch)
  }
  Some(value)
}

///|
fn extra_has_single_slash_with_parts(s : String) -> Bool {
  let parts = s.split("/").map(part => part.to_owned()).to_array()
  parts.length() == 2 && !parts[0].is_empty() && !parts[1].is_empty()
}

///|
fn extra_is_compat_zip_letter(ch : Char) -> Bool {
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
fn extra_valid_nl_postcode(s : String) -> Bool {
  s.length() == 7 &&
  s.get_char(4) == Some(' ') &&
  extra_all_chars_match(s[0:4].to_owned(), extra_is_digit) &&
  extra_all_chars_match(s[5:7].to_owned(), extra_is_compat_zip_letter)
}

///|
fn extra_valid_coordinate(s : String, whole_limit : Int32) -> Bool {
  if s.is_empty() {
    return false
  }
  let mut seen_digit_before_dot = false
  let mut seen_dot = false
  let mut seen_digit_after_dot = false
  let mut whole = 0
  for i, ch in s {
    if i == 0 && ch == '-' {
      if s.length() == 1 {
        return false
      }
    } else if ch == '.' {
      if seen_dot || !seen_digit_before_dot {
        return false
      }
      seen_dot = true
    } else if extra_is_digit(ch) {
      if seen_dot {
        seen_digit_after_dot = true
      } else {
        seen_digit_before_dot = true
        whole = whole * 10 + extra_digit_value(ch)
      }
    } else {
      return false
    }
  }
  seen_digit_before_dot &&
  seen_dot &&
  seen_digit_after_dot &&
  whole < whole_limit
}

///|
fn extra_health_department_is_compat_fr(department : String) -> Bool {
  for
    candidate in [
      "01", "02", "03", "04", "05", "06", "07", "08", "09", "11", "12", "13", "14",
      "15", "16", "17", "18", "19", "2A", "2B", "21", "22", "23", "24", "25", "26",
      "27", "28", "29", "31", "32", "33", "34", "35", "36", "37", "38", "39", "41",
      "42", "43", "44", "45", "46", "47", "48", "49", "51", "52", "53", "54", "55",
      "56", "57", "58", "59", "61", "62", "63", "64", "65", "66", "67", "68", "69",
      "71", "72", "73", "74", "75", "76", "77", "78", "79", "81", "82", "83", "84",
      "85", "86", "87", "88", "89", "91", "92", "93", "94", "95", "971", "972", "973",
      "974", "975", "976", "977", "978", "984", "986", "987", "988", "989",
    ] {
    if candidate == department {
      return true
    }
  }
  false
}

///|
fn extra_health_department_key_code(department : String) -> String {
  match department {
    "2A" => "19"
    "2B" => "18"
    _ => extra_decimal_string_to_int(department).to_string()
  }
}

///|
fn extra_valid_health_insurance_code(s : String) -> Bool {
  let parts = s.split(" ").map(part => part.to_owned()).to_array()
  if parts.length() != 7 {
    return false
  }
  let sex = parts[0]
  let year = parts[1]
  let month = parts[2]
  let department = parts[3]
  let town = parts[4]
  let order = parts[5]
  let key = parts[6]
  if !(sex == "1" || sex == "2") ||
    year.length() != 2 ||
    !extra_all_chars_match(year, extra_is_digit) ||
    month.length() != 2 ||
    !extra_all_chars_match(month, extra_is_digit) ||
    !extra_health_department_is_compat_fr(department) ||
    town.length() != 3 ||
    !extra_all_chars_match(town, extra_is_digit) ||
    order.length() != 3 ||
    !extra_all_chars_match(order, extra_is_digit) ||
    key.is_empty() ||
    !extra_all_chars_match(key, extra_is_digit) {
    return false
  }
  let month_value = extra_decimal_string_to_int(month)
  if month_value < 1 || month_value > 12 {
    return false
  }
  let expected_key = 97 -
    extra_decimal_mod_97(
      sex +
      year +
      month +
      extra_health_department_key_code(department) +
      town +
      order,
    )
  extra_decimal_string_to_int(key) == expected_key
}

///|
fn extra_picsum_clean_path(url : String) -> String {
  match url.split_once("?") {
    Some((path, _query)) => path.to_owned()
    None => url
  }
}

///|
fn extra_picsum_dimensions_in_range(url : String) -> Bool {
  let parts = extra_picsum_clean_path(url)
    .split("/")
    .map(part => part.to_owned())
    .to_array()
  if parts.length() < 5 {
    return false
  }
  guard extra_parse_unsigned_decimal(parts[parts.length() - 2]) is Some(width) else {
    return false
  }
  guard extra_parse_unsigned_decimal(parts[parts.length() - 1]) is Some(height) else {
    return false
  }
  width >= 100 && width <= 800 && height >= 100 && height <= 800
}

///|
fn extra_picsum_seed_is_decimal(url : String) -> Bool {
  let prefix = "https://picsum.photos/seed/"
  guard url.strip_prefix(prefix) is Some(rest) else { return false }
  guard rest.split_once("/") is Some((seed, _tail)) else { return false }
  let seed = seed.to_owned()
  !seed.is_empty() && extra_all_chars_match(seed, extra_is_digit)
}

///|
fn extra_blur_value_in_range(url : String) -> Bool {
  guard url.split_once("blur=") is Some((_head, tail)) else { return false }
  guard extra_parse_unsigned_decimal(tail.to_owned()) is Some(value) else {
    return false
  }
  value >= 1 && value <= 10
}

///|
fn extra_lines(s : String) -> Array[String] {
  s.split("\n").map(line => line.to_owned()).to_array()
}

///|
fn extra_every_line_has_prefix(s : String, prefix : String) -> Bool {
  for line in extra_lines(s) {
    if !line.has_prefix(prefix) {
      return false
    }
  }
  true
}

///|
fn extra_known_http_method(http_method_name : String) -> Bool {
  match http_method_name {
    "GET"
    | "POST"
    | "PUT"
    | "PATCH"
    | "DELETE"
    | "HEAD"
    | "OPTIONS"
    | "CONNECT"
    | "TRACE" => true
    _ => false
  }
}

///|
fn extra_credit_card_known_issuer_length(card : String) -> Bool {
  if card.has_prefix("34") || card.has_prefix("37") {
    card.length() == 15
  } else if card.has_prefix("4") {
    card.length() == 13 || card.length() == 16
  } else if card.has_prefix("51") ||
    card.has_prefix("52") ||
    card.has_prefix("53") ||
    card.has_prefix("54") ||
    card.has_prefix("55") {
    card.length() == 16
  } else {
    false
  }
}

///|
test "impls extra facade address and administrative contracts" {
  let health_seed = b"impls-extra-health-default"
  @test.assert_eq(
    @dummy.health_insurance_code().sample(count=16, @dummy.seed(health_seed)),
    @dummy.health_insurance_code(locale=@dummy.fr_fr).sample(
      count=16,
      @dummy.seed(health_seed),
    ),
  )
  for
    value in @dummy.health_insurance_code().sample(
      count=32,
      @dummy.seed(b"impls-extra-health-shape"),
    ) {
    assert_true(extra_valid_health_insurance_code(value))
  }
  let unsupported : Result[String, @core.DummyError] = try? @dummy.health_insurance_code(
    locale=@dummy.en,
  ).dummy(@dummy.seed(b"impls-extra-health-unsupported"))
  assert_true(unsupported is Err(@core.DummyError::UnsupportedLocale(_)))
  for
    value in @dummy.country_code().sample(
      count=24,
      @dummy.seed(b"impls-extra-country"),
    ) {
    @test.assert_eq(value.length(), 2)
    assert_true(extra_all_chars_match(value, extra_is_upper_letter))
  }
  for
    value in @dummy.zip_code(locale=@dummy.nl_nl).sample(
      count=24,
      @dummy.seed(b"impls-extra-nl-postcode"),
    ) {
    assert_true(extra_valid_nl_postcode(value))
  }
  for
    value in @dummy.latitude().sample(
      count=32,
      @dummy.seed(b"impls-extra-latitude"),
    ) {
    assert_true(extra_valid_coordinate(value, 90))
  }
  for
    value in @dummy.longitude().sample(
      count=32,
      @dummy.seed(b"impls-extra-longitude"),
    ) {
    assert_true(extra_valid_coordinate(value, 180))
  }
  @test.assert_eq(
    @dummy.geohash(precision=1)
    .dummy(@dummy.seed(b"impls-extra-geohash-1"))
    .length(),
    1,
  )
  @test.assert_eq(
    @dummy.geohash(precision=32)
    .dummy(@dummy.seed(b"impls-extra-geohash-32"))
    .length(),
    32,
  )
}

///|
test "impls extra facade picsum variants and option contracts" {
  let opts = @dummy.image_options()
  @test.assert_eq(opts.width, 640)
  @test.assert_eq(opts.height, 480)
  assert_true(!opts.grayscale)
  assert_true(opts.blur is None)
  assert_true(opts.seed is None)
  @test.assert_eq(
    @dummy.picsum_image_custom(opts).dummy(
      @dummy.seed(b"impls-extra-picsum-default"),
    ),
    "https://picsum.photos/640/480",
  )
  let rng = @dummy.seed(b"impls-extra-picsum-variants")
  let seeded = @dummy.picsum_image_with_seed().dummy(rng)
  assert_true(seeded.has_prefix("https://picsum.photos/seed/"))
  assert_true(extra_picsum_seed_is_decimal(seeded))
  assert_true(extra_picsum_dimensions_in_range(seeded))
  let grayscale = @dummy.picsum_image_grayscale().dummy(rng)
  assert_true(grayscale.has_suffix("?grayscale"))
  assert_true(extra_picsum_dimensions_in_range(grayscale))
  let blur = @dummy.picsum_image_blur().dummy(rng)
  assert_true(blur.contains("?blur="))
  assert_true(extra_picsum_dimensions_in_range(blur))
  assert_true(extra_blur_value_in_range(blur))
  @test.assert_eq(
    @dummy.picsum_image_custom(
      @dummy.image_options(width=200, height=300, blur=1),
    ).dummy(@dummy.seed(b"impls-extra-picsum-blur-only")),
    "https://picsum.photos/200/300?blur=1",
  )
  @test.assert_eq(
    @dummy.picsum_image_custom(
      @dummy.image_options(width=201, height=301, seed="seed-only"),
    ).dummy(@dummy.seed(b"impls-extra-picsum-seed-only")),
    "https://picsum.photos/seed/seed-only/201/301",
  )
  let bad_width : Result[String, @core.DummyError] = try? @dummy.picsum_image_custom(
    @dummy.image_options(width=0),
  ).dummy(@dummy.seed(b"impls-extra-picsum-bad-width"))
  assert_true(bad_width is Err(@core.DummyError::InvalidRange(_)))
  let bad_blur : Result[String, @core.DummyError] = try? @dummy.picsum_image_custom(
    @dummy.image_options(blur=11),
  ).dummy(@dummy.seed(b"impls-extra-picsum-bad-blur"))
  assert_true(bad_blur is Err(@core.DummyError::InvalidRange(_)))
}

///|
test "impls extra facade markdown constructors" {
  let rng = @dummy.seed(b"impls-extra-markdown")
  let italic = @dummy.italic_word().dummy(rng)
  assert_true(italic.has_prefix("*"))
  assert_true(italic.has_suffix("*"))
  assert_true(!italic.has_prefix("**"))
  @test.assert_eq(extra_count_char(italic, '*'), 2)
  let bold = @dummy.bold_word().dummy(rng)
  assert_true(bold.has_prefix("**"))
  assert_true(bold.has_suffix("**"))
  @test.assert_eq(extra_count_char(bold, '*'), 4)
  let link = @dummy.markdown_link().dummy(rng)
  assert_true(link.has_prefix("["))
  assert_true(link.contains("](https://"))
  assert_true(link.has_suffix(")"))
  @test.assert_eq(extra_count_char(link, '['), 1)
  @test.assert_eq(extra_count_char(link, ']'), 1)
  @test.assert_eq(extra_count_char(link, '('), 1)
  @test.assert_eq(extra_count_char(link, ')'), 1)
  let bullets = @dummy.bullet_points(count=@dummy.count_range(3, 3)).dummy(rng)
  @test.assert_eq(extra_lines(bullets).length(), 3)
  assert_true(extra_every_line_has_prefix(bullets, "- "))
  let items = @dummy.list_items(count=@dummy.count_range(4, 4)).dummy(rng)
  @test.assert_eq(items.length(), 4)
  for i, item in items {
    assert_true(item.has_prefix("\{i + 1}. "))
  }
  let quote = @dummy.block_quote_multi_line(count=@dummy.count_range(3, 3)).dummy(
    rng,
  )
  @test.assert_eq(extra_lines(quote).length(), 3)
  assert_true(extra_every_line_has_prefix(quote, "> "))
  let code = @dummy.markdown_code(count=@dummy.count_range(2, 2)).dummy(rng)
  assert_true(code.has_prefix("```\n"))
  assert_true(code.has_suffix("\n```"))
  @test.assert_eq(extra_lines(code).length(), 4)
}

///|
test "impls extra facade filesystem http currency and card tables" {
  let rng = @dummy.seed(b"impls-extra-tables")
  for extension in @dummy.file_extension().sample(count=24, rng) {
    assert_true(!extension.is_empty())
    assert_true(!extension.contains("."))
    assert_true(!extension.contains("/"))
  }
  for filename in @dummy.file_name().sample(count=24, rng) {
    assert_true(!filename.contains("/"))
    assert_true(!filename.has_prefix("."))
    assert_true(!filename.has_suffix("."))
    assert_true(filename.contains("."))
  }
  for dir in @dummy.dir_path().sample(count=24, rng) {
    assert_true(dir.has_prefix("/"))
    assert_true(!dir.contains("//"))
    assert_true(dir == "/" || !dir.has_suffix("/"))
  }
  for path in @dummy.file_path().sample(count=24, rng) {
    assert_true(path.has_prefix("/"))
    assert_true(path.contains("."))
    assert_true(!path.contains("//"))
    assert_true(!path.has_suffix("/"))
  }
  for mime in @dummy.mime_type().sample(count=24, rng) {
    assert_true(extra_has_single_slash_with_parts(mime))
  }
  for http_method_name in @dummy.http_method().sample(count=32, rng) {
    assert_true(extra_known_http_method(http_method_name))
    assert_true(extra_all_chars_match(http_method_name, extra_is_upper_letter))
  }
  for code in @dummy.currency_code().sample(count=24, rng) {
    @test.assert_eq(code.length(), 3)
    assert_true(extra_all_chars_match(code, extra_is_upper_letter))
  }
  for card in @dummy.credit_card_number().sample(count=48, rng) {
    assert_true(extra_all_chars_match(card, extra_is_digit))
    assert_true(extra_credit_card_known_issuer_length(card))
  }
}

///|
fn deep_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn deep_digit_value(ch : Char) -> Int32 {
  ch.to_int() - '0'.to_int()
}

///|
fn deep_is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  deep_is_digit(ch) || (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn deep_is_upper_ascii(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
fn deep_char_at_eq(s : String, i : Int32, expected : Char) -> Bool {
  s.get_char(i) == Some(expected)
}

///|
fn deep_char_at_is(s : String, i : Int32, pred : (Char) -> Bool) -> Bool {
  match s.get_char(i) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn deep_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn deep_parse_uint(s : String) -> Int32? {
  if s.is_empty() {
    return None
  }
  let mut value = 0
  for ch in s {
    if !deep_is_digit(ch) {
      return None
    }
    value = value * 10 + deep_digit_value(ch)
  }
  Some(value)
}

///|
fn deep_digit_at(s : String, i : Int32) -> Int32? {
  match s.get_char(i) {
    Some(ch) =>
      if deep_is_digit(ch) {
        Some(deep_digit_value(ch))
      } else {
        None
      }
    None => None
  }
}

///|
fn deep_two_digits_at(s : String, i : Int32) -> Int32? {
  match (deep_digit_at(s, i), deep_digit_at(s, i + 1)) {
    (Some(a), Some(b)) => Some(a * 10 + b)
    _ => None
  }
}

///|
fn deep_all_digits_between(s : String, start : Int32, end : Int32) -> Bool {
  for i in start..<end {
    if !deep_char_at_is(s, i, deep_is_digit) {
      return false
    }
  }
  true
}

///|
fn deep_uuid_variant_char(ch : Char) -> Bool {
  ch == '8' || ch == '9' || ch == 'a' || ch == 'b'
}

///|
fn deep_valid_uuid(s : String, version : Char) -> Bool {
  if s.length() != 36 ||
    !deep_char_at_eq(s, 8, '-') ||
    !deep_char_at_eq(s, 13, '-') ||
    !deep_char_at_eq(s, 18, '-') ||
    !deep_char_at_eq(s, 23, '-') ||
    !deep_char_at_eq(s, 14, version) ||
    !deep_char_at_is(s, 19, deep_uuid_variant_char) {
    return false
  }
  for i in 0..<36 {
    if i != 8 && i != 13 && i != 18 && i != 23 {
      if !deep_char_at_is(s, i, deep_is_lower_hex) {
        return false
      }
    }
  }
  true
}

///|
fn deep_is_ulid_char(ch : Char) -> Bool {
  match ch {
    '0'
    | '1'
    | '2'
    | '3'
    | '4'
    | '5'
    | '6'
    | '7'
    | '8'
    | '9'
    | 'A'
    | 'B'
    | 'C'
    | 'D'
    | 'E'
    | 'F'
    | 'G'
    | 'H'
    | 'J'
    | 'K'
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
fn deep_valid_ulid(s : String) -> Bool {
  s.length() == 26 &&
  deep_char_at_is(s, 0, ch => ch >= '0' && ch <= '7') &&
  deep_all_chars_match(s, deep_is_ulid_char)
}

///|
fn deep_is_standard_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  deep_is_digit(ch) ||
  ch == '+' ||
  ch == '/'
}

///|
fn deep_is_url_safe_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  deep_is_digit(ch) ||
  ch == '-' ||
  ch == '_'
}

///|
fn deep_valid_base64(
  s : String,
  url_safe : Bool,
  allow_padding : Bool,
  padded_form : Bool,
) -> Bool {
  let mut seen_padding = false
  let mut padding_count = 0
  for ch in s {
    if ch == '=' {
      if !allow_padding {
        return false
      }
      seen_padding = true
      padding_count += 1
      if padding_count > 2 {
        return false
      }
    } else {
      if seen_padding {
        return false
      }
      if url_safe {
        if !deep_is_url_safe_base64_char(ch) {
          return false
        }
      } else if !deep_is_standard_base64_char(ch) {
        return false
      }
    }
  }
  if padded_form && s.length() % 4 != 0 {
    return false
  }
  if padding_count == 2 && !s.has_suffix("==") {
    return false
  }
  if padding_count == 1 && !s.has_suffix("=") {
    return false
  }
  if padding_count > 0 {
    s.length() % 4 == 0
  } else {
    s.length() % 4 != 1
  }
}

///|
fn deep_http_methods() -> Array[String] {
  [
    "GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS", "CONNECT", "TRACE",
  ]
}

///|
fn deep_is_http_method(value : String) -> Bool {
  for method_name in deep_http_methods() {
    if value == method_name {
      return true
    }
  }
  false
}

///|
fn deep_rfc_status_codes() -> Array[Int32] {
  [
    100, 101, 102, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302,
    303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410,
    411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 426, 428, 429, 431,
    451, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511,
  ]
}

///|
fn deep_contains_string(items : ArrayView[String], target : String) -> Bool {
  for item in items {
    if item == target {
      return true
    }
  }
  false
}

///|
fn deep_contains_int(items : ArrayView[Int32], target : Int32) -> Bool {
  for item in items {
    if item == target {
      return true
    }
  }
  false
}

///|
fn deep_is_rfc_status_code(value : Int32) -> Bool {
  deep_contains_int(deep_rfc_status_codes(), value)
}

///|
fn deep_valid_hms_at(s : String, start : Int32) -> Bool {
  guard deep_two_digits_at(s, start) is Some(hour) else { return false }
  guard deep_two_digits_at(s, start + 3) is Some(minute) else { return false }
  guard deep_two_digits_at(s, start + 6) is Some(second) else { return false }
  deep_char_at_eq(s, start + 2, ':') &&
  deep_char_at_eq(s, start + 5, ':') &&
  hour >= 0 &&
  hour < 24 &&
  minute >= 0 &&
  minute < 60 &&
  second >= 0 &&
  second < 60
}

///|
fn deep_valid_hms(s : String) -> Bool {
  s.length() == 8 && deep_valid_hms_at(s, 0)
}

///|
fn deep_valid_hms_with_fraction(s : String) -> Bool {
  s.length() == 18 &&
  deep_valid_hms_at(s, 0) &&
  deep_char_at_eq(s, 8, '.') &&
  deep_all_digits_between(s, 9, 18)
}

///|
fn deep_valid_ymd_date(s : String, sep : Char) -> Bool {
  guard deep_two_digits_at(s, 5) is Some(month) else { return false }
  guard deep_two_digits_at(s, 8) is Some(day) else { return false }
  s.length() == 10 &&
  deep_all_digits_between(s, 0, 4) &&
  deep_char_at_eq(s, 4, sep) &&
  deep_char_at_eq(s, 7, sep) &&
  month >= 1 &&
  month <= 12 &&
  day >= 1 &&
  day <= 31
}

///|
fn deep_valid_dmy_date(s : String, sep : Char) -> Bool {
  guard deep_two_digits_at(s, 0) is Some(day) else { return false }
  guard deep_two_digits_at(s, 3) is Some(month) else { return false }
  s.length() == 10 &&
  deep_char_at_eq(s, 2, sep) &&
  deep_char_at_eq(s, 5, sep) &&
  deep_all_digits_between(s, 6, 10) &&
  month >= 1 &&
  month <= 12 &&
  day >= 1 &&
  day <= 31
}

///|
fn deep_valid_ymd_space_datetime(s : String, sep : Char) -> Bool {
  s.length() == 19 &&
  deep_valid_ymd_date(s[0:10].to_owned(), sep) &&
  deep_char_at_eq(s, 10, ' ') &&
  deep_valid_hms_at(s, 11)
}

///|
fn deep_valid_dmy_space_datetime(s : String, sep : Char) -> Bool {
  s.length() == 19 &&
  deep_valid_dmy_date(s[0:10].to_owned(), sep) &&
  deep_char_at_eq(s, 10, ' ') &&
  deep_valid_hms_at(s, 11)
}

///|
fn deep_valid_chrono_iso_datetime(s : String) -> Bool {
  s.length() == 25 &&
  deep_valid_ymd_date(s[0:10].to_owned(), '-') &&
  deep_char_at_eq(s, 10, 'T') &&
  deep_valid_hms_at(s, 11) &&
  s.has_suffix("+00:00")
}

///|
fn deep_valid_stable_semver(s : String) -> Bool {
  let parts = s.split(".").map(part => part.to_owned()).to_array()
  if parts.length() != 3 {
    return false
  }
  match
    (
      deep_parse_uint(parts[0]),
      deep_parse_uint(parts[1]),
      deep_parse_uint(parts[2]),
    ) {
    (Some(major), Some(minor), Some(patch)) =>
      major >= 0 &&
      major <= 8 &&
      minor >= 0 &&
      minor <= 19 &&
      patch >= 0 &&
      patch <= 19
    _ => false
  }
}

///|
fn deep_valid_prerelease_semver(s : String) -> Bool {
  guard s.split_once("-") is Some((stable, suffix)) else { return false }
  if !deep_valid_stable_semver(stable.to_owned()) {
    return false
  }
  let parts = suffix
    .to_owned()
    .split(".")
    .map(part => part.to_owned())
    .to_array()
  if parts.length() != 2 {
    return false
  }
  let tag_ok = parts[0] == "alpha" || parts[0] == "beta" || parts[0] == "rc"
  match deep_parse_uint(parts[1]) {
    Some(number) =>
      tag_ok && parts[1].length() == 1 && number >= 0 && number <= 8
    None => false
  }
}

///|
fn deep_valid_any_semver(s : String) -> Bool {
  if s.contains("-") {
    deep_valid_prerelease_semver(s)
  } else {
    deep_valid_stable_semver(s)
  }
}

///|
fn deep_assert_string_samples(
  gen : @core.Gen[String],
  seed_bytes : Bytes,
  count : Int32,
  valid : (String) -> Bool,
) -> Unit raise {
  for value in gen.sample(count~, @dummy.seed(seed_bytes)) {
    assert_true(valid(value))
  }
}

///|
fn deep_assert_uuid_samples(
  gen : @core.Gen[String],
  version : Char,
  seed_bytes : Bytes,
) -> Unit raise {
  deep_assert_string_samples(gen, seed_bytes, 48, value => {
    deep_valid_uuid(value, version)
  })
}

///|
fn deep_assert_object_id_samples(
  gen : @core.Gen[String],
  seed_bytes : Bytes,
) -> Unit raise {
  deep_assert_string_samples(gen, seed_bytes, 48, value => {
    value.length() == 24 && deep_all_chars_match(value, deep_is_lower_hex)
  })
}

///|
fn deep_assert_method_samples(
  gen : @core.Gen[String],
  seed_bytes : Bytes,
) -> Unit raise {
  let values = gen.sample(count=512, @dummy.seed(seed_bytes))
  for value in values {
    assert_true(deep_is_http_method(value))
    assert_true(deep_all_chars_match(value, deep_is_upper_ascii))
  }
  for method_name in deep_http_methods() {
    assert_true(deep_contains_string(values, method_name))
  }
}

///|
fn deep_assert_rfc_status_samples(
  gen : @core.Gen[Int32],
  seed_bytes : Bytes,
) -> Unit raise {
  let values = gen.sample(count=4096, @dummy.seed(seed_bytes))
  for value in values {
    assert_true(deep_is_rfc_status_code(value))
  }
  for code in deep_rfc_status_codes() {
    assert_true(deep_contains_int(values, code))
  }
}

///|
test "deep uuid ulid and bson facade formats" {
  deep_assert_uuid_samples(@dummy.uuid_v1(), '1', b"deep-dummy-uuid-v1")
  deep_assert_uuid_samples(@dummy.uuid_v3(), '3', b"deep-dummy-uuid-v3")
  deep_assert_uuid_samples(@dummy.uuid_v4(), '4', b"deep-dummy-uuid-v4")
  deep_assert_uuid_samples(@dummy.uuid_v5(), '5', b"deep-dummy-uuid-v5")
  deep_assert_uuid_samples(@dummy.uuid_v6(), '6', b"deep-dummy-uuid-v6")
  deep_assert_uuid_samples(@dummy.uuid_v7(), '7', b"deep-dummy-uuid-v7")
  deep_assert_uuid_samples(@dummy.uuid_v8(), '8', b"deep-dummy-uuid-v8")
  deep_assert_uuid_samples(@identifier.uuid_v1(), '1', b"deep-ident-uuid-v1")
  deep_assert_uuid_samples(@identifier.uuid_v3(), '3', b"deep-ident-uuid-v3")
  deep_assert_uuid_samples(@identifier.uuid_v4(), '4', b"deep-ident-uuid-v4")
  deep_assert_uuid_samples(@identifier.uuid_v5(), '5', b"deep-ident-uuid-v5")
  deep_assert_uuid_samples(@identifier.uuid_v6(), '6', b"deep-ident-uuid-v6")
  deep_assert_uuid_samples(@identifier.uuid_v7(), '7', b"deep-ident-uuid-v7")
  deep_assert_uuid_samples(@identifier.uuid_v8(), '8', b"deep-ident-uuid-v8")
  deep_assert_string_samples(
    @dummy.ulid(),
    b"deep-dummy-ulid",
    64,
    deep_valid_ulid,
  )
  deep_assert_string_samples(
    @identifier.ulid(),
    b"deep-ident-ulid",
    64,
    deep_valid_ulid,
  )
  deep_assert_object_id_samples(
    @dummy.bson_object_id(),
    b"deep-dummy-object-id",
  )
  deep_assert_object_id_samples(@dummy.bson_oid(), b"deep-dummy-bson-oid")
  deep_assert_object_id_samples(
    @identifier.bson_object_id(),
    b"deep-ident-object-id",
  )
  deep_assert_object_id_samples(@identifier.bson_oid(), b"deep-ident-bson-oid")
  @test.assert_eq(
    @dummy.bson_object_id().sample(
      count=24,
      @dummy.seed(b"deep-dummy-bson-alias"),
    ),
    @dummy.bson_oid().sample(count=24, @dummy.seed(b"deep-dummy-bson-alias")),
  )
  @test.assert_eq(
    @identifier.bson_object_id().sample(
      count=24,
      @dummy.seed(b"deep-ident-bson-alias"),
    ),
    @identifier.bson_oid().sample(
      count=24,
      @dummy.seed(b"deep-ident-bson-alias"),
    ),
  )
}

///|
test "deep base64 padding and alphabet formats" {
  deep_assert_string_samples(@dummy.base64(), b"deep-dummy-base64", 96, value => {
    deep_valid_base64(value, false, true, false)
  })
  deep_assert_string_samples(
    @dummy.base64_padded(),
    b"deep-dummy-base64-padded",
    96,
    value => deep_valid_base64(value, false, true, true),
  )
  deep_assert_string_samples(
    @dummy.base64_no_pad(),
    b"deep-dummy-base64-no-pad",
    96,
    value => deep_valid_base64(value, false, false, false),
  )
  deep_assert_string_samples(
    @dummy.url_safe_base64(),
    b"deep-dummy-url-base64",
    96,
    value => deep_valid_base64(value, true, true, false),
  )
  deep_assert_string_samples(
    @dummy.url_safe_base64_padded(),
    b"deep-dummy-url-base64-padded",
    96,
    value => deep_valid_base64(value, true, true, true),
  )
  deep_assert_string_samples(
    @dummy.url_safe_base64_no_pad(),
    b"deep-dummy-url-base64-no-pad",
    96,
    value => deep_valid_base64(value, true, false, false),
  )
  deep_assert_string_samples(@encoding.base64(), b"deep-enc-base64", 96, value => {
    deep_valid_base64(value, false, true, false)
  })
  deep_assert_string_samples(
    @encoding.base64_padded(),
    b"deep-enc-base64-padded",
    96,
    value => deep_valid_base64(value, false, true, true),
  )
  deep_assert_string_samples(
    @encoding.base64_no_pad(),
    b"deep-enc-base64-no-pad",
    96,
    value => deep_valid_base64(value, false, false, false),
  )
  deep_assert_string_samples(
    @encoding.url_safe_base64(),
    b"deep-enc-url-base64",
    96,
    value => deep_valid_base64(value, true, true, false),
  )
  deep_assert_string_samples(
    @encoding.url_safe_base64_padded(),
    b"deep-enc-url-base64-padded",
    96,
    value => deep_valid_base64(value, true, true, true),
  )
  deep_assert_string_samples(
    @encoding.url_safe_base64_no_pad(),
    b"deep-enc-url-base64-no-pad",
    96,
    value => deep_valid_base64(value, true, false, false),
  )
}

///|
test "deep http method and rfc status tables" {
  deep_assert_method_samples(@dummy.http_method(), b"deep-dummy-http-method")
  deep_assert_method_samples(@http.http_method(), b"deep-http-method")
  deep_assert_rfc_status_samples(
    @dummy.rfc_status_code(),
    b"deep-dummy-rfc-status",
  )
  deep_assert_rfc_status_samples(
    @http.rfc_status_code(),
    b"deep-http-rfc-status",
  )
}

///|
test "deep chrono locale formats" {
  deep_assert_string_samples(
    @dummy.chrono_time(locale=@dummy.fa_ir),
    b"deep-dummy-chrono-fa-time",
    16,
    deep_valid_hms,
  )
  deep_assert_string_samples(
    @dummy.chrono_date(locale=@dummy.fa_ir),
    b"deep-dummy-chrono-fa-date",
    16,
    value => deep_valid_ymd_date(value, '/'),
  )
  deep_assert_string_samples(
    @dummy.chrono_date_time(locale=@dummy.fa_ir),
    b"deep-dummy-chrono-fa-dt",
    16,
    value => deep_valid_ymd_space_datetime(value, '/'),
  )
  deep_assert_string_samples(
    @dummy.chrono_time(locale=@dummy.pt_pt),
    b"deep-dummy-chrono-pt-time",
    16,
    deep_valid_hms,
  )
  deep_assert_string_samples(
    @dummy.chrono_date(locale=@dummy.pt_pt),
    b"deep-dummy-chrono-pt-date",
    16,
    value => deep_valid_dmy_date(value, '-'),
  )
  deep_assert_string_samples(
    @dummy.chrono_date_time(locale=@dummy.pt_pt),
    b"deep-dummy-chrono-pt-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '-'),
  )
  deep_assert_string_samples(
    @dummy.chrono_time(locale=@dummy.tr_tr),
    b"deep-dummy-chrono-tr-time",
    16,
    deep_valid_hms,
  )
  deep_assert_string_samples(
    @dummy.chrono_date(locale=@dummy.tr_tr),
    b"deep-dummy-chrono-tr-date",
    16,
    value => deep_valid_dmy_date(value, '.'),
  )
  deep_assert_string_samples(
    @dummy.chrono_date_time(locale=@dummy.tr_tr),
    b"deep-dummy-chrono-tr-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '.'),
  )
  deep_assert_string_samples(
    @dummy.chrono_time(locale=@dummy.nl_nl),
    b"deep-dummy-chrono-nl-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @dummy.chrono_date(locale=@dummy.nl_nl),
    b"deep-dummy-chrono-nl-date",
    16,
    value => deep_valid_ymd_date(value, '-'),
  )
  deep_assert_string_samples(
    @dummy.chrono_date_time(locale=@dummy.nl_nl),
    b"deep-dummy-chrono-nl-dt",
    16,
    deep_valid_chrono_iso_datetime,
  )
  deep_assert_string_samples(
    @chrono.time(locale=@locales.FA_IR),
    b"deep-chrono-fa-time",
    16,
    deep_valid_hms,
  )
  deep_assert_string_samples(
    @chrono.date(locale=@locales.FA_IR),
    b"deep-chrono-fa-date",
    16,
    value => deep_valid_ymd_date(value, '/'),
  )
  deep_assert_string_samples(
    @chrono.date_time(locale=@locales.FA_IR),
    b"deep-chrono-fa-dt",
    16,
    value => deep_valid_ymd_space_datetime(value, '/'),
  )
  deep_assert_string_samples(
    @chrono.time(locale=@locales.PT_PT),
    b"deep-chrono-pt-time",
    16,
    deep_valid_hms,
  )
  deep_assert_string_samples(
    @chrono.date(locale=@locales.PT_PT),
    b"deep-chrono-pt-date",
    16,
    value => deep_valid_dmy_date(value, '-'),
  )
  deep_assert_string_samples(
    @chrono.date_time(locale=@locales.PT_PT),
    b"deep-chrono-pt-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '-'),
  )
  deep_assert_string_samples(
    @chrono.time(locale=@locales.TR_TR),
    b"deep-chrono-tr-time",
    16,
    deep_valid_hms,
  )
  deep_assert_string_samples(
    @chrono.date(locale=@locales.TR_TR),
    b"deep-chrono-tr-date",
    16,
    value => deep_valid_dmy_date(value, '.'),
  )
  deep_assert_string_samples(
    @chrono.date_time(locale=@locales.TR_TR),
    b"deep-chrono-tr-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '.'),
  )
  deep_assert_string_samples(
    @chrono.time(locale=@locales.NL_NL),
    b"deep-chrono-nl-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @chrono.date(locale=@locales.NL_NL),
    b"deep-chrono-nl-date",
    16,
    value => deep_valid_ymd_date(value, '-'),
  )
  deep_assert_string_samples(
    @chrono.date_time(locale=@locales.NL_NL),
    b"deep-chrono-nl-dt",
    16,
    deep_valid_chrono_iso_datetime,
  )
}

///|
test "deep time locale formats" {
  deep_assert_string_samples(
    @dummy.time_time(locale=@dummy.fa_ir),
    b"deep-dummy-time-fa-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @dummy.time_date(locale=@dummy.fa_ir),
    b"deep-dummy-time-fa-date",
    16,
    value => deep_valid_ymd_date(value, '/'),
  )
  deep_assert_string_samples(
    @dummy.time_date_time(locale=@dummy.fa_ir),
    b"deep-dummy-time-fa-dt",
    16,
    value => deep_valid_ymd_space_datetime(value, '/'),
  )
  deep_assert_string_samples(
    @dummy.time_time(locale=@dummy.pt_pt),
    b"deep-dummy-time-pt-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @dummy.time_date(locale=@dummy.pt_pt),
    b"deep-dummy-time-pt-date",
    16,
    value => deep_valid_dmy_date(value, '-'),
  )
  deep_assert_string_samples(
    @dummy.time_date_time(locale=@dummy.pt_pt),
    b"deep-dummy-time-pt-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '-'),
  )
  deep_assert_string_samples(
    @dummy.time_time(locale=@dummy.tr_tr),
    b"deep-dummy-time-tr-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @dummy.time_date(locale=@dummy.tr_tr),
    b"deep-dummy-time-tr-date",
    16,
    value => deep_valid_dmy_date(value, '.'),
  )
  deep_assert_string_samples(
    @dummy.time_date_time(locale=@dummy.tr_tr),
    b"deep-dummy-time-tr-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '.'),
  )
  deep_assert_string_samples(
    @dummy.time_time(locale=@dummy.nl_nl),
    b"deep-dummy-time-nl-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @dummy.time_date(locale=@dummy.nl_nl),
    b"deep-dummy-time-nl-date",
    16,
    value => deep_valid_dmy_date(value, '-'),
  )
  deep_assert_string_samples(
    @dummy.time_date_time(locale=@dummy.nl_nl),
    b"deep-dummy-time-nl-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '-'),
  )
  deep_assert_string_samples(
    @time.time(locale=@locales.FA_IR),
    b"deep-time-fa-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @time.date(locale=@locales.FA_IR),
    b"deep-time-fa-date",
    16,
    value => deep_valid_ymd_date(value, '/'),
  )
  deep_assert_string_samples(
    @time.date_time(locale=@locales.FA_IR),
    b"deep-time-fa-dt",
    16,
    value => deep_valid_ymd_space_datetime(value, '/'),
  )
  deep_assert_string_samples(
    @time.time(locale=@locales.PT_PT),
    b"deep-time-pt-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @time.date(locale=@locales.PT_PT),
    b"deep-time-pt-date",
    16,
    value => deep_valid_dmy_date(value, '-'),
  )
  deep_assert_string_samples(
    @time.date_time(locale=@locales.PT_PT),
    b"deep-time-pt-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '-'),
  )
  deep_assert_string_samples(
    @time.time(locale=@locales.TR_TR),
    b"deep-time-tr-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @time.date(locale=@locales.TR_TR),
    b"deep-time-tr-date",
    16,
    value => deep_valid_dmy_date(value, '.'),
  )
  deep_assert_string_samples(
    @time.date_time(locale=@locales.TR_TR),
    b"deep-time-tr-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '.'),
  )
  deep_assert_string_samples(
    @time.time(locale=@locales.NL_NL),
    b"deep-time-nl-time",
    16,
    deep_valid_hms_with_fraction,
  )
  deep_assert_string_samples(
    @time.date(locale=@locales.NL_NL),
    b"deep-time-nl-date",
    16,
    value => deep_valid_dmy_date(value, '-'),
  )
  deep_assert_string_samples(
    @time.date_time(locale=@locales.NL_NL),
    b"deep-time-nl-dt",
    16,
    value => deep_valid_dmy_space_datetime(value, '-'),
  )
}

///|
test "deep filesystem semver stable and prerelease formats" {
  deep_assert_string_samples(@dummy.semver(), b"deep-dummy-semver", 96, value => {
    deep_valid_any_semver(value)
  })
  deep_assert_string_samples(
    @dummy.semver_stable(),
    b"deep-dummy-semver-stable",
    96,
    deep_valid_stable_semver,
  )
  deep_assert_string_samples(
    @dummy.semver_unstable(),
    b"deep-dummy-semver-unstable",
    96,
    deep_valid_prerelease_semver,
  )
  deep_assert_string_samples(
    @filesystem.semver(),
    b"deep-fs-semver",
    96,
    deep_valid_any_semver,
  )
  deep_assert_string_samples(
    @filesystem.semver_stable(),
    b"deep-fs-semver-stable",
    96,
    deep_valid_stable_semver,
  )
  deep_assert_string_samples(
    @filesystem.semver_unstable(),
    b"deep-fs-semver-unstable",
    96,
    deep_valid_prerelease_semver,
  )
}

///|
fn frs_more_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn frs_more_is_nonzero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn frs_more_digit_value(ch : Char) -> Int32 {
  ch.to_int() - '0'.to_int()
}

///|
fn frs_more_count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn frs_more_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn frs_more_decimal_value(s : String) -> Int32? {
  if s.is_empty() {
    return None
  }
  let mut value = 0
  for ch in s {
    if !frs_more_is_digit(ch) {
      return None
    }
    value = value * 10 + frs_more_digit_value(ch)
  }
  Some(value)
}

///|
fn frs_more_parts(s : String, sep : String) -> Array[String] {
  s.split(sep).map(part => part.to_owned()).to_array()
}

///|
fn frs_more_has_no_compat_placeholders(s : String) -> Bool {
  !s.contains("#") && !s.contains("^") && !s.contains("$") && !s.contains("{")
}

///|
fn frs_more_assert_number_format(value : String, fmt : String) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') =>
        assert_true(value.get_char(i).map_or(false, frs_more_is_nonzero_digit))
      Some('#') =>
        assert_true(value.get_char(i).map_or(false, frs_more_is_digit))
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("format index out of range")
    }
  }
}

///|
fn frs_more_valid_ipv4(s : String) -> Bool {
  let parts = frs_more_parts(s, ".")
  if parts.length() != 4 {
    return false
  }
  for part in parts {
    guard frs_more_decimal_value(part) is Some(value) else { return false }
    if value < 0 || value > 255 {
      return false
    }
  }
  true
}

///|
fn frs_more_valid_safe_email(s : String) -> Bool {
  if frs_more_count_char(s, '@') != 1 || !s.contains("@example.") {
    return false
  }
  let parts = frs_more_parts(s, "@")
  if parts.length() != 2 || parts[0].is_empty() {
    return false
  }
  parts[1] == "example.com" ||
  parts[1] == "example.net" ||
  parts[1] == "example.org"
}

///|
fn frs_more_username_shape(s : String) -> Bool {
  !s.is_empty() && !s.contains("@") && !s.contains(" ") && !s.contains("#")
}

///|
fn frs_more_sentence_word_count(sentence : String) -> Int32? {
  guard sentence.strip_suffix(".") is Some(body) else { return None }
  Some(frs_more_parts(body.to_owned(), " ").length())
}

///|
fn frs_more_has_sample(items : ArrayView[String], needle : String) -> Bool {
  for item in items {
    if item == needle {
      return true
    }
  }
  false
}

///|
fn frs_more_assert_sample_contains(
  label : String,
  gen : @core.Gen[String],
  needle : String,
  count~ : Int32 = 512,
) -> Unit raise {
  let samples = gen.sample(count~, @dummy.seed(b"compat-source-more-lists"))
  if !frs_more_has_sample(samples, needle) {
    fail("\{label} did not sample source value: \{needle}")
  }
}

///|
fn frs_more_assert_string_samples(
  gen : @core.Gen[String],
  seed_bytes : Bytes,
  count : Int32,
  valid : (String) -> Bool,
) -> Unit raise {
  for value in gen.sample(count~, @dummy.seed(seed_bytes)) {
    assert_true(valid(value))
  }
}

///|
test "generator source lorem count and punctuation invariants via facade" {
  let rng = @dummy.seed(b"compat-source-more-lorem")
  for
    words in @dummy.words(count=@dummy.count_range(1, 1)).sample(count=12, rng) {
    @test.assert_eq(words.length(), 1)
  }
  for
    words in @dummy.words(count=@dummy.count_range(5, 5)).sample(count=12, rng) {
    @test.assert_eq(words.length(), 5)
  }
  for
    sentence in @dummy.sentence(count=@dummy.count_range(3, 3)).sample(
      count=16,
      rng,
    ) {
    assert_true(sentence.has_suffix("."))
    @test.assert_eq(frs_more_sentence_word_count(sentence), Some(3))
  }
  let sentences = @dummy.sentences(count=@dummy.count_range(4, 4)).dummy(rng)
  @test.assert_eq(sentences.length(), 4)
  for sentence in sentences {
    assert_true(sentence.has_suffix("."))
  }
  for
    paragraph in @dummy.paragraph(count=@dummy.count_range(2, 2)).sample(
      count=8,
      rng,
    ) {
    @test.assert_eq(frs_more_count_char(paragraph, '.'), 2)
    assert_true(!paragraph.contains("\n"))
  }
  let paragraphs = @dummy.paragraphs(count=@dummy.count_range(3, 3)).dummy(rng)
  @test.assert_eq(paragraphs.length(), 3)
  for paragraph in paragraphs {
    assert_true(!paragraph.is_empty())
    assert_true(paragraph.contains("."))
  }
}

///|
test "generator source internet generators keep facade-specific shapes" {
  let rng = @dummy.seed(b"compat-source-more-internet")
  for email in @dummy.safe_email().sample(count=32, rng) {
    assert_true(frs_more_valid_safe_email(email))
  }
  for username in @dummy.username().sample(count=64, rng) {
    assert_true(frs_more_username_shape(username))
  }
  for ip in @dummy.ip().sample(count=32, rng) {
    assert_true(frs_more_valid_ipv4(ip))
  }
  frs_more_assert_sample_contains(
    "UserAgent",
    @dummy.user_agent(),
    "Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14",
    count=512,
  )
}

///|
test "generator source format placeholders are resolved through facade" {
  let rng = @dummy.seed(b"compat-source-more-patterns")
  for value in @dummy.number_with_format("^##-literal-#^").sample(count=32, rng) {
    frs_more_assert_number_format(value, "^##-literal-#^")
  }
  for value in @dummy.zip_code(locale=@dummy.zh_cn).sample(count=24, rng) {
    @test.assert_eq(value.length(), 6)
    assert_true(frs_more_all_chars_match(value, frs_more_is_digit))
  }
  for value in @dummy.post_code(locale=@dummy.pt_br).sample(count=24, rng) {
    @test.assert_eq(value.length(), 9)
    @test.assert_eq(value.get_char(5), Some('-'))
    assert_true(
      frs_more_all_chars_match(value[0:5].to_owned(), frs_more_is_digit),
    )
    assert_true(
      frs_more_all_chars_match(value[6:9].to_owned(), frs_more_is_digit),
    )
  }
  for value in @dummy.building_number(locale=@dummy.pt_pt).sample(count=32, rng) {
    assert_true(frs_more_has_no_compat_placeholders(value))
    assert_true(
      value.contains("nº ") ||
      frs_more_all_chars_match(value, frs_more_is_digit),
    )
  }
  for value in @dummy.secondary_address().sample(count=24, rng) {
    assert_true(frs_more_has_no_compat_placeholders(value))
    assert_true(!value.is_empty())
  }
}

///|
test "generator source locale-backed representative lists surface via facade" {
  frs_more_assert_sample_contains(
    "DE_DE city prefix",
    @dummy.city_prefix(locale=@dummy.de_de),
    "Bad",
    count=128,
  )
  frs_more_assert_sample_contains(
    "DE_DE city suffix",
    @dummy.city_suffix(locale=@dummy.de_de),
    "stadt",
    count=128,
  )
  frs_more_assert_sample_contains(
    "PT_PT secondary address type",
    @dummy.secondary_address_type(locale=@dummy.pt_pt),
    "Piso",
    count=128,
  )
  frs_more_assert_sample_contains(
    "JA_JP job seniority",
    @dummy.job_seniority(locale=@dummy.ja_jp),
    "シニア",
    count=128,
  )
  frs_more_assert_sample_contains(
    "PT_PT currency symbol",
    @dummy.currency_symbol(locale=@dummy.pt_pt),
    "€",
    count=128,
  )
}

///|
test "generator source unsupported and range contracts are exposed by facade" {
  let default_plate_seed = b"compat-source-more-plate-default"
  @test.assert_eq(
    @dummy.licence_plate().sample(count=16, @dummy.seed(default_plate_seed)),
    @dummy.licence_plate(locale=@dummy.fr_fr).sample(
      count=16,
      @dummy.seed(default_plate_seed),
    ),
  )
  let unsupported_plate : Result[String, @core.DummyError] = try? @dummy.licence_plate(
    locale=@dummy.en,
  ).dummy(@dummy.seed(b"compat-source-more-bad-plate"))
  assert_true(unsupported_plate is Err(@core.DummyError::UnsupportedLocale(_)))
  let bad_geohash : Result[String, @core.DummyError] = try? @dummy.geohash(
    precision=0,
  ).dummy(@dummy.seed(b"compat-source-more-bad-geohash"))
  assert_true(bad_geohash is Err(@core.DummyError::InvalidCount(_)))
  frs_more_assert_string_samples(
    @dummy.geohash(precision=5),
    b"compat-source-more-geohash",
    24,
    value => value.length() == 5 && frs_more_has_no_compat_placeholders(value),
  )
}

///|
struct SubagentCatalogCase {
  name : String
  mapped : Bool
} derive(Eq, Debug)

///|
fn subagent_contains_string(items : ArrayView[String], target : String) -> Bool {
  for item in items {
    if item == target {
      return true
    }
  }
  false
}

///|
fn subagent_all_ascii_digits(s : String) -> Bool {
  for ch in s {
    if ch < '0' || ch > '9' {
      return false
    }
  }
  true
}

///|
fn subagent_all_upper_ascii(s : String) -> Bool {
  for ch in s {
    if ch < 'A' || ch > 'Z' {
      return false
    }
  }
  true
}

///|
fn subagent_locale_source_files() -> Array[String] {
  [
    "ar_sa.rs", "cy_gb.rs", "de_de.rs", "en.rs", "fa_ir.rs", "fr_fr.rs", "it_it.rs",
    "ja_jp.rs", "mod.rs", "nl_nl.rs", "pt_br.rs", "pt_pt.rs", "tr_tr.rs", "zh_cn.rs",
    "zh_tw.rs",
  ]
}

///|
fn subagent_impl_modules() -> Array[SubagentCatalogCase] {
  [
    { name: "base64", mapped: true, },
    { name: "bigdecimal", mapped: false, },
    { name: "bson_oid", mapped: true, },
    { name: "chrono", mapped: true, },
    { name: "chrono_tz", mapped: false, },
    { name: "color", mapped: true, },
    { name: "decimal", mapped: false, },
    { name: "either", mapped: true, },
    { name: "email_address", mapped: false, },
    { name: "ferroid", mapped: false, },
    { name: "geo", mapped: true, },
    { name: "glam", mapped: false, },
    { name: "http", mapped: true, },
    { name: "indexmap", mapped: false, },
    { name: "semver", mapped: true, },
    { name: "serde_json", mapped: false, },
    { name: "std", mapped: true, },
    { name: "time", mapped: true, },
    { name: "ulid", mapped: true, },
    { name: "url", mapped: false, },
    { name: "uuid", mapped: true, },
    { name: "zerocopy_byteorder", mapped: false, },
  ]
}

///|
fn subagent_std_impl_modules() -> Array[String] {
  [
    "array", "collections", "container", "net", "num", "option", "path", "primitives",
    "result", "string", "time", "tuple",
  ]
}

///|
fn subagent_std_collection_impl_modules() -> Array[String] {
  [
    "binary_heap", "btree_map", "btree_set", "hash_map", "hash_set", "linked_list",
    "vec", "vec_deque",
  ]
}

///|
fn subagent_generator_categories() -> Array[String] {
  [
    "address", "barcode", "boolean", "color", "chrono", "time", "creditcard", "company",
    "http", "internet", "job", "lorem", "markdown", "name", "number", "phone_number",
    "picsum", "filesystem", "currency", "finance", "administrative", "automotive",
  ]
}

///|
fn subagent_generator_functions() -> Array[String] {
  [
    "CityPrefix", "CitySuffix", "CityName", "CountryName", "CountryCode", "StreetSuffix",
    "StreetName", "TimeZone", "StateName", "StateAbbr", "SecondaryAddressType", "SecondaryAddress",
    "ZipCode", "PostCode", "BuildingNumber", "Latitude", "Longitude", "Geohash",
    "Isbn", "Isbn10", "Isbn13", "Boolean", "HexColor", "RgbColor", "RgbaColor", "HslColor",
    "HslaColor", "Color", "Time", "Date", "DateTime", "Duration", "DateTimeBefore",
    "DateTimeAfter", "DateTimeBetween", "CreditCardNumber", "CompanySuffix", "CompanyName",
    "Buzzword", "BuzzwordMiddle", "BuzzwordTail", "CatchPhrase", "BsVerb", "BsAdj",
    "BsNoun", "Bs", "Profession", "Industry", "RfcStatusCode", "ValidStatusCode",
    "FreeEmailProvider", "DomainSuffix", "FreeEmail", "SafeEmail", "Username", "Password",
    "IPv4", "IPv6", "IP", "MACAddress", "UserAgent", "Seniority", "Field", "Position",
    "Title", "Word", "Words", "Sentence", "Sentences", "Paragraph", "Paragraphs",
    "ItalicWord", "BoldWord", "Link", "BulletPoints", "ListItems", "BlockQuoteSingleLine",
    "BlockQuoteMultiLine", "Code", "FirstName", "LastName", "Suffix", "Name", "NameWithTitle",
    "Digit", "NumberWithFormat", "PhoneNumber", "CellNumber", "Image", "ImageWithSeed",
    "ImageGrayscale", "ImageBlur", "ImageCustom", "FilePath", "FileName", "FileExtension",
    "DirPath", "MimeType", "Semver", "SemverStable", "SemverUnstable", "CurrencyCode",
    "CurrencyName", "CurrencySymbol", "Bic", "Isin", "HealthInsuranceCode", "LicencePlate",
  ]
}

///|
fn subagent_key_source_data() -> Array[String] {
  [
    "LOREM_WORD:alias", "NAME_FIRST_NAME:Aaliyah", "NAME_LAST_NAME:Abbott", "INTERNET_FREE_EMAIL_PROVIDER:gmail.com",
    "INTERNET_DOMAIN_SUFFIX:io", "ISBN_EAN:978", "NUMBER_DIGIT:9", "PATH_ROOT_DIRS:/etc",
    "PATH_SEGMENTS:government", "PATH_EXTENSIONS:txt", "CURRENCY_CODE:USD", "CURRENCY_SYMBOL:€",
    "TIME_ZONE:Europe/London", "MIME_TYPE:application/json", "HTTP_METHOD:PATCH",
    "RFC_STATUS_CODE:418", "UNSTABLE_SEMVER:rc", "FR_FR_DEPARTMENT:Paris", "LICENSE_PLATE:$$-###-$$",
    "PT_PT_DOMAIN_SUFFIX:pt", "TR_TR_PHONE_FORMAT:+90 53# ### ####", "ZH_CN_COMPANY_SUFFIX:有限公司",
    "ZH_TW_NAME_TITLE:博士", "CY_GB_DOMAIN_SUFFIX:cymru", "NL_NL_TIME_ZONE:Europe/Amsterdam",
  ]
}

///|
fn subagent_assert_non_empty_samples(
  source_name : String,
  gen : @core.Gen[String],
  count~ : Int32 = 8,
  allow_empty~ : Bool = false,
) -> Unit raise {
  let seed = @dummy.seed(b"compat-subagent-impls-data-port")
  let values = gen.sample(count~, seed)
  @test.assert_eq(values.length(), count)
  for value in values {
    if !allow_empty && value.is_empty() {
      fail(source_name + " produced an empty value")
    }
  }
}

///|
test "subagent locale source list matches public locale surface" {
  let source_files = subagent_locale_source_files()
  @test.assert_eq(source_files.length(), 15)
  @test.assert_eq(
    source_files.join("|"),
    "ar_sa.rs|cy_gb.rs|de_de.rs|en.rs|fa_ir.rs|fr_fr.rs|it_it.rs|ja_jp.rs|mod.rs|nl_nl.rs|pt_br.rs|pt_pt.rs|tr_tr.rs|zh_cn.rs|zh_tw.rs",
  )
  let locale_codes = @locales.all().map(locale => locale.code())
  @test.assert_eq(locale_codes.length(), 14)
  @test.assert_eq(
    locale_codes.join("|"),
    "en|fr_FR|zh_TW|zh_CN|ja_JP|ar_SA|pt_BR|pt_PT|de_DE|it_IT|cy_GB|nl_NL|tr_TR|fa_IR",
  )
  let docs_codes = @dummy.docs_locales().map(item => item.docs_code)
  @test.assert_eq(docs_codes.length(), 13)
  assert_true(!subagent_contains_string(docs_codes, "TR_TR"))
  assert_true(subagent_contains_string(locale_codes, "tr_TR"))
}

///|
test "subagent impl module catalog records mapped and unmapped sources" {
  let modules = subagent_impl_modules()
  @test.assert_eq(modules.length(), 22)
  @test.assert_eq(
    modules.map(item => item.name).join("|"),
    "base64|bigdecimal|bson_oid|chrono|chrono_tz|color|decimal|either|email_address|ferroid|geo|glam|http|indexmap|semver|serde_json|std|time|ulid|url|uuid|zerocopy_byteorder",
  )
  @test.assert_eq(
    modules.filter(item => item.mapped).map(item => item.name).join("|"),
    "base64|bson_oid|chrono|color|either|geo|http|semver|std|time|ulid|uuid",
  )
  @test.assert_eq(
    subagent_std_impl_modules().join("|"),
    "array|collections|container|net|num|option|path|primitives|result|string|time|tuple",
  )
  @test.assert_eq(
    subagent_std_collection_impl_modules().join("|"),
    "binary_heap|btree_map|btree_set|hash_map|hash_set|linked_list|vec|vec_deque",
  )
}

///|
test "subagent generator category and function catalog is complete" {
  let categories = subagent_generator_categories()
  @test.assert_eq(categories.length(), 22)
  @test.assert_eq(
    categories.join("|"),
    "address|barcode|boolean|color|chrono|time|creditcard|company|http|internet|job|lorem|markdown|name|number|phone_number|picsum|filesystem|currency|finance|administrative|automotive",
  )
  let functions = subagent_generator_functions()
  @test.assert_eq(functions.length(), 108)
  for
    required in [
      "CityName", "Geohash", "Isbn13", "HslaColor", "DateTimeBetween", "CreditCardNumber",
      "CatchPhrase", "ValidStatusCode", "MACAddress", "Paragraphs", "BlockQuoteMultiLine",
      "NameWithTitle", "NumberWithFormat", "ImageCustom", "SemverUnstable", "CurrencySymbol",
      "HealthInsuranceCode", "LicencePlate",
    ] {
    assert_true(subagent_contains_string(functions, required))
  }
}

///|
test "subagent key data catalog records non-empty source values" {
  let data = subagent_key_source_data()
  @test.assert_eq(data.length(), 25)
  for item in data {
    guard item.split_once(":") is Some((source, value)) else {
      fail("source data entry is missing ':'")
    }
    assert_true(!source.is_empty())
    assert_true(!value.is_empty())
  }
  for
    required in [
      "LOREM_WORD:alias", "INTERNET_DOMAIN_SUFFIX:io", "ISBN_EAN:978", "MIME_TYPE:application/json",
      "HTTP_METHOD:PATCH", "RFC_STATUS_CODE:418", "UNSTABLE_SEMVER:rc", "ZH_CN_COMPANY_SUFFIX:有限公司",
      "CY_GB_DOMAIN_SUFFIX:cymru",
    ] {
    assert_true(subagent_contains_string(data, required))
  }
}

///|
test "subagent public facade data samples stay non-empty" {
  subagent_assert_non_empty_samples("first_name", @dummy.first_name())
  subagent_assert_non_empty_samples("last_name", @dummy.last_name())
  subagent_assert_non_empty_samples("name", @dummy.name())
  subagent_assert_non_empty_samples("word", @dummy.word())
  subagent_assert_non_empty_samples(
    "sentence",
    @dummy.sentence(count=@dummy.count_range(3, 3)),
  )
  subagent_assert_non_empty_samples("company_name", @dummy.company_name())
  subagent_assert_non_empty_samples("catch_phrase", @dummy.catch_phrase())
  subagent_assert_non_empty_samples("bs", @dummy.bs())
  subagent_assert_non_empty_samples(
    "free_email_provider",
    @dummy.free_email_provider(),
  )
  subagent_assert_non_empty_samples("domain_suffix", @dummy.domain_suffix())
  subagent_assert_non_empty_samples("user_agent", @dummy.user_agent())
  subagent_assert_non_empty_samples("mime_type", @dummy.mime_type())
  subagent_assert_non_empty_samples("file_extension", @dummy.file_extension())
  subagent_assert_non_empty_samples("currency_code", @dummy.currency_code())
  subagent_assert_non_empty_samples("currency_name", @dummy.currency_name())
  subagent_assert_non_empty_samples("time_zone", @dummy.time_zone())
}

///|
test "subagent locale-backed data arrays surface distinctive source data" {
  subagent_assert_non_empty_samples(
    "pt_PT domain_suffix",
    @dummy.domain_suffix(locale=@dummy.pt_pt),
  )
  subagent_assert_non_empty_samples(
    "tr_TR phone_number",
    @dummy.phone_number(locale=@dummy.tr_tr),
  )
  subagent_assert_non_empty_samples(
    "zh_CN company_suffix",
    @dummy.company_suffix(locale=@dummy.zh_cn),
  )
  subagent_assert_non_empty_samples(
    "zh_TW title",
    @dummy.title(locale=@dummy.zh_tw),
  )
  subagent_assert_non_empty_samples(
    "cy_GB free_email_provider",
    @dummy.free_email_provider(locale=@dummy.cy_gb),
  )
  subagent_assert_non_empty_samples(
    "nl_NL time_zone",
    @dummy.time_zone(locale=@dummy.nl_nl),
  )
  subagent_assert_non_empty_samples(
    "fa_IR country_name",
    @dummy.country_name(locale=@dummy.fa_ir),
  )
  subagent_assert_non_empty_samples(
    "ar_SA first_name",
    @dummy.first_name(locale=@dummy.ar_sa),
  )
}

///|
test "subagent facade format invariants cover catalog families" {
  for
    code in @dummy.country_code().sample(
      count=48,
      @dummy.seed(b"compat-subagent-country-code"),
    ) {
    @test.assert_eq(code.length(), 2)
    assert_true(subagent_all_upper_ascii(code))
  }
  for
    digit in @dummy.digit_string().sample(
      count=48,
      @dummy.seed(b"compat-subagent-digit-string"),
    ) {
    @test.assert_eq(digit.length(), 1)
    assert_true(subagent_all_ascii_digits(digit))
  }
  for
    postcode in @dummy.post_code(locale=@dummy.zh_cn).sample(
      count=24,
      @dummy.seed(b"compat-subagent-zh-postcode"),
    ) {
    @test.assert_eq(postcode.length(), 6)
    assert_true(subagent_all_ascii_digits(postcode))
  }
  for
    extension in @dummy.file_extension().sample(
      count=32,
      @dummy.seed(b"compat-subagent-extension"),
    ) {
    assert_true(!extension.contains("."))
    assert_true(!extension.is_empty())
  }
  for
    status in @dummy.valid_status_code().sample(
      count=64,
      @dummy.seed(b"compat-subagent-status"),
    ) {
    assert_true(status >= 100 && status < 600)
  }
  for
    geohash in @dummy.geohash(precision=9).sample(
      count=16,
      @dummy.seed(b"compat-subagent-geohash"),
    ) {
    @test.assert_eq(geohash.length(), 9)
  }
}

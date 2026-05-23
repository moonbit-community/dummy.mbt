///|
fn compat_internet_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_internet_is_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  compat_internet_is_digit(ch) ||
  (code >= 'a'.to_int() && code <= 'f'.to_int()) ||
  (code >= 'A'.to_int() && code <= 'F'.to_int())
}

///|
fn compat_internet_count_char(s : String, target : Char) -> Int {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn compat_internet_parts(s : String, sep : String) -> Array[String] {
  s.split(sep).map(part => part.to_owned()).to_array()
}

///|
fn compat_internet_decimal_value(s : String) -> Int? {
  if s.is_empty() {
    return None
  }
  let mut value = 0
  for ch in s {
    if !compat_internet_is_digit(ch) {
      return None
    }
    value = value * 10 + ch.to_int() - '0'.to_int()
  }
  Some(value)
}

///|
fn compat_internet_valid_ipv4(s : String) -> Bool {
  let parts = compat_internet_parts(s, ".")
  if parts.length() != 4 {
    return false
  }
  for part in parts {
    guard compat_internet_decimal_value(part) is Some(value) else {
      return false
    }
    if value < 0 || value > 255 {
      return false
    }
  }
  true
}

///|
fn compat_internet_valid_ipv6(s : String) -> Bool {
  let parts = compat_internet_parts(s, ":")
  if parts.length() != 8 {
    return false
  }
  for part in parts {
    if part.is_empty() || part.length() > 4 {
      return false
    }
    for ch in part {
      if !compat_internet_is_hex(ch) {
        return false
      }
    }
  }
  true
}

///|
fn compat_internet_valid_mac(s : String) -> Bool {
  let parts = compat_internet_parts(s, ":")
  if parts.length() != 6 {
    return false
  }
  for part in parts {
    if part.length() != 2 {
      return false
    }
    for ch in part {
      if !compat_internet_is_hex(ch) {
        return false
      }
    }
  }
  true
}

///|
fn compat_internet_valid_email(s : String) -> Bool {
  if compat_internet_count_char(s, '@') != 1 {
    return false
  }
  match s.split_once("@") {
    Some((local_part, domain)) =>
      !local_part.is_empty() &&
      domain.contains(".") &&
      !domain.has_prefix(".") &&
      !domain.has_suffix(".")
    None => false
  }
}

///|
fn compat_internet_valid_password_chars(s : String) -> Bool {
  for ch in s {
    let code = ch.to_int()
    if !((code >= '0'.to_int() && code <= '9'.to_int()) ||
      (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
      (code >= 'a'.to_int() && code <= 'z'.to_int())) {
      return false
    }
  }
  true
}

///|
test "data internet string formats are preserved" {
  let rng = @core.seed(b"format-internet")
  for email in @internet.free_email().sample(count=16, rng) {
    assert_true(compat_internet_valid_email(email))
  }
  for email in @internet.safe_email().sample(count=8, rng) {
    assert_true(compat_internet_valid_email(email))
    assert_true(email.contains("@example."))
  }
  for value in @internet.ipv4().sample(count=16, rng) {
    assert_true(compat_internet_valid_ipv4(value))
  }
  for value in @internet.ipv6().sample(count=16, rng) {
    assert_true(compat_internet_valid_ipv6(value))
  }
  for value in @internet.mac_address().sample(count=16, rng) {
    assert_true(compat_internet_valid_mac(value))
  }
}

///|
test "data password keeps requested length and character set" {
  let rng = @core.seed(b"format-password")
  for
    value in @internet.password(len_range=@core.count_range(12, 12)).sample(
      count=24,
      rng,
    ) {
    @test.assert_eq(value.length(), 12)
    assert_true(compat_internet_valid_password_chars(value))
  }
}

///|
fn count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn is_hex_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  (code >= 'A'.to_int() && code <= 'F'.to_int())
}

///|
fn is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn has_upper_ascii(s : String) -> Bool {
  for ch in s {
    let code = ch.to_int()
    if code >= 'A'.to_int() && code <= 'Z'.to_int() {
      return true
    }
  }
  false
}

///|
fn digit_value(ch : Char) -> Int32 {
  ch.to_int() - '0'.to_int()
}

///|
fn is_ipv4_address(s : String) -> Bool {
  let mut part_count = 1
  let mut part_value = 0
  let mut part_digits = 0
  for ch in s {
    if ch == '.' {
      if part_digits == 0 || part_value > 255 {
        return false
      }
      part_count += 1
      part_value = 0
      part_digits = 0
    } else if is_digit(ch) {
      part_value = part_value * 10 + digit_value(ch)
      part_digits += 1
      if part_digits > 3 {
        return false
      }
    } else {
      return false
    }
  }
  part_count == 4 && part_digits > 0 && part_value <= 255
}

///|
fn is_ipv6_address(s : String) -> Bool {
  let mut group_count = 1
  let mut group_digits = 0
  for ch in s {
    if ch == ':' {
      if group_digits == 0 || group_digits > 4 {
        return false
      }
      group_count += 1
      group_digits = 0
    } else if is_hex_char(ch) {
      group_digits += 1
    } else {
      return false
    }
  }
  group_count == 8 && group_digits > 0 && group_digits <= 4
}

///|
fn has_short_ipv6_group(s : String) -> Bool {
  let mut group_digits = 0
  for ch in s {
    if ch == ':' {
      if group_digits > 0 && group_digits < 4 {
        return true
      }
      group_digits = 0
    } else {
      group_digits += 1
    }
  }
  group_digits > 0 && group_digits < 4
}

///|
fn is_mac_address(s : String) -> Bool {
  let mut group_count = 1
  let mut group_digits = 0
  for ch in s {
    if ch == ':' {
      if group_digits != 2 {
        return false
      }
      group_count += 1
      group_digits = 0
    } else if is_hex_char(ch) {
      group_digits += 1
      if group_digits > 2 {
        return false
      }
    } else {
      return false
    }
  }
  group_count == 6 && group_digits == 2
}

///|
fn email_local_part(s : String) -> String {
  let out = StringBuilder::new()
  for ch in s {
    if ch == '@' {
      return out.to_string()
    }
    out.write_char(ch)
  }
  out.to_string()
}

///|
fn is_lower_first_name(value : String, locale : @locales.Locale) -> Bool {
  for first in @data.name_first_names(locale) {
    if value == first.to_lower() {
      return true
    }
  }
  false
}

///|
fn is_first_plus_number(value : String, locale : @locales.Locale) -> Bool {
  for first in @data.name_first_names(locale) {
    let lower = first.to_lower()
    for n in 0..<256 {
      if value == lower + n.to_string() {
        return true
      }
    }
  }
  false
}

///|
fn is_word_dot_first(value : String, locale : @locales.Locale) -> Bool {
  let parts = value.split(".").map(part => part.to_owned()).to_array()
  if parts.length() != 2 {
    return false
  }
  let word_part = parts[0]
  let first_part = parts[1]
  for word in @data.lorem_words(locale) {
    if word_part == word {
      return is_lower_first_name(first_part, locale)
    }
  }
  false
}

///|
fn is_first_underscore_word(value : String, locale : @locales.Locale) -> Bool {
  let parts = value.split("_").map(part => part.to_owned()).to_array()
  if parts.length() != 2 || !is_lower_first_name(parts[0], locale) {
    return false
  }
  for word in @data.lorem_words(locale) {
    if parts[1] == word {
      return true
    }
  }
  false
}

///|
fn username_shape(value : String, locale : @locales.Locale) -> String {
  if is_lower_first_name(value, locale) {
    "first"
  } else if is_word_dot_first(value, locale) {
    "word.first"
  } else if is_first_plus_number(value, locale) {
    "first_number"
  } else if is_first_underscore_word(value, locale) {
    "first_word"
  } else {
    "unknown"
  }
}

///|
fn has_ascii_local_part(s : String) -> Bool {
  let mut before_at = true
  let mut local_len = 0
  for ch in s {
    if ch == '@' {
      before_at = false
    } else if before_at {
      let code = ch.to_int()
      let allowed = (code >= '0'.to_int() && code <= '9'.to_int()) ||
        (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
        (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
        ch == '.' ||
        ch == '_'
      if !allowed {
        return false
      }
      local_len += 1
    }
  }
  local_len > 0 && !before_at
}

///|
test "email generators use expected domains" {
  let rng = @core.seed(b"internet-email")
  let free = @internet.free_email().dummy(rng)
  @test.assert_eq(count_char(free, '@'), 1)
  assert_true(has_ascii_local_part(free))
  assert_true(
    free.has_suffix("@gmail.com") ||
    free.has_suffix("@yahoo.com") ||
    free.has_suffix("@hotmail.com"),
  )
  let safe = @internet.safe_email().dummy(rng)
  assert_true(safe.contains("@example."))
  assert_true(
    safe.has_suffix("@example.com") ||
    safe.has_suffix("@example.net") ||
    safe.has_suffix("@example.org"),
  )
  assert_true(has_ascii_local_part(safe))
  let safe_local = email_local_part(safe)
  assert_true(is_lower_first_name(safe_local, @locales.EN))
  assert_true(!has_upper_ascii(safe_local))
  let br = @internet.free_email(locale=@locales.PT_BR).dummy(rng)
  assert_true(
    br.has_suffix("@bol.com.br") ||
    br.has_suffix("@gmail.com.br") ||
    br.has_suffix("@hotmail.com.br") ||
    br.has_suffix("@ig.com.br") ||
    br.has_suffix("@outlook.com.br") ||
    br.has_suffix("@terra.com.br") ||
    br.has_suffix("@uol.com.br") ||
    br.has_suffix("@yahoo.com.br"),
  )
  let nl_suffix = @internet.domain_suffix(locale=@locales.NL_NL).dummy(rng)
  assert_true(
    nl_suffix == "nl" ||
    nl_suffix == "com" ||
    nl_suffix == "net" ||
    nl_suffix == "org",
  )
}

///|
test "password honors requested length and character set" {
  let value = @internet.password(len_range=@core.count_range(12, 12)).dummy(
    @core.seed(b"internet-password"),
  )
  @test.assert_eq(value.length(), 12)
  for ch in value {
    let code = ch.to_int()
    assert_true(
      (code >= '0'.to_int() && code <= '9'.to_int()) ||
      (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
      (code >= 'a'.to_int() && code <= 'z'.to_int()),
    )
  }
}

///|
test "password range mirrors half-open example bounds" {
  let left = @internet.password(len_range=@core.count_range(6, 11)).sample(
    count=16,
    @core.seed(b"internet-password-range"),
  )
  let right = @internet.password(len_range=@core.count_range(6, 11)).sample(
    count=16,
    @core.seed(b"internet-password-range"),
  )
  @test.assert_eq(left, right)
  for value in left {
    assert_true(value.length() >= 6 && value.length() <= 11)
    for ch in value {
      let code = ch.to_int()
      assert_true(
        (code >= '0'.to_int() && code <= '9'.to_int()) ||
        (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
        (code >= 'a'.to_int() && code <= 'z'.to_int()),
      )
    }
  }
}

///|
test "ip and mac address formats are shaped correctly" {
  let rng = @core.seed(b"internet-addresses")
  let ipv4 = @internet.ipv4().dummy(rng)
  @test.assert_eq(count_char(ipv4, '.'), 3)
  assert_true(is_ipv4_address(ipv4))
  let ipv6 = @internet.ipv6().dummy(rng)
  @test.assert_eq(count_char(ipv6, ':'), 7)
  assert_true(is_ipv6_address(ipv6))
  for ch in ipv6 {
    if ch != ':' {
      assert_true(is_hex_char(ch))
    }
  }
  let ipv6s = @internet.ipv6().sample(count=32, @core.seed(b"internet-ipv6"))
  let mut saw_short_group = false
  for value in ipv6s {
    assert_true(is_ipv6_address(value))
    if has_short_ipv6_group(value) {
      saw_short_group = true
    }
  }
  assert_true(saw_short_group)
  let mac = @internet.mac_address().dummy(rng)
  @test.assert_eq(mac.length(), 17)
  @test.assert_eq(count_char(mac, ':'), 5)
  assert_true(is_mac_address(mac))
  let ips = @internet.ip().sample(count=32, @core.seed(b"internet-ip-any"))
  for value in ips {
    assert_true(is_ipv4_address(value))
  }
  @test.assert_eq(
    ips,
    @internet.ip().sample(count=32, @core.seed(b"internet-ip-any")),
  )
}

///|
test "domain suffix user agent and username are non-empty" {
  let rng = @core.seed(b"internet-shared")
  let username = @internet.username(locale=@locales.ZH_CN).dummy(rng)
  assert_true(!username.is_empty())
  assert_true(!username.contains("@"))
  assert_true(!username.contains(" "))
  let suffix = @internet.domain_suffix().dummy(rng)
  assert_true(!suffix.is_empty())
  assert_true(!suffix.contains("."))
  assert_true(!suffix.contains("/"))
  let agent = @internet.user_agent().dummy(rng)
  assert_true(agent.has_prefix("Mozilla/5.0"))
  assert_true(agent.contains("("))
  assert_true(agent.contains(")"))
}

///|
test "username follows structural variants" {
  let values = @internet.username().sample(
    count=64,
    @core.seed(b"internet-username-shapes"),
  )
  for value in values {
    assert_true(!value.is_empty())
    assert_true(!value.contains("@"))
    assert_true(!value.contains(" "))
    match username_shape(value, @locales.EN) {
      "first" | "word.first" | "first_number" | "first_word" => ()
      _ => fail("username did not match an shape")
    }
  }
  let first = @data.name_first_names(@locales.EN)[0].to_lower()
  let word = @data.lorem_words(@locales.EN)[0]
  @test.assert_eq(username_shape(first, @locales.EN), "first")
  @test.assert_eq(username_shape(word + "." + first, @locales.EN), "word.first")
  @test.assert_eq(username_shape(first + "42", @locales.EN), "first_number")
  @test.assert_eq(username_shape(first + "_" + word, @locales.EN), "first_word")
}

///|
test "internet generators are deterministic for the same seed" {
  let a = @internet.free_email().sample(
    count=8,
    @core.seed(b"internet-determinism"),
  )
  let b = @internet.free_email().sample(
    count=8,
    @core.seed(b"internet-determinism"),
  )
  @test.assert_eq(a, b)
}

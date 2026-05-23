///|
fn is_standard_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  ch == '+' ||
  ch == '/'
}

///|
fn is_url_safe_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  ch == '-' ||
  ch == '_'
}

///|
fn valid_base64(s : String, url_safe : Bool, allow_padding : Bool) -> Bool {
  if s.is_empty() {
    return true
  }
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
        if !is_url_safe_base64_char(ch) {
          return false
        }
      } else if !is_standard_base64_char(ch) {
        return false
      }
    }
  }
  !allow_padding || padding_count == 0 || s.length() % 4 == 0
}

///|
test "base64 string replacements keep shapes" {
  assert_true(valid_base64("", false, true))
  assert_true(valid_base64("", false, false))
  let rng = @core.seed(b"encoding-base64")
  for value in @encoding.base64().sample(count=16, rng) {
    assert_true(valid_base64(value, false, true))
  }
  for value in @encoding.base64_padded().sample(count=16, rng) {
    assert_true(valid_base64(value, false, true))
    @test.assert_eq(value.length() % 4, 0)
  }
  for value in @encoding.base64_no_pad().sample(count=16, rng) {
    assert_true(valid_base64(value, false, false))
    assert_true(!value.contains("="))
  }
}

///|
test "url-safe base64 replacements keep shapes" {
  assert_true(valid_base64("", true, true))
  assert_true(valid_base64("", true, false))
  let rng = @core.seed(b"encoding-url-safe-base64")
  for value in @encoding.url_safe_base64().sample(count=16, rng) {
    assert_true(valid_base64(value, true, true))
  }
  for value in @encoding.url_safe_base64_padded().sample(count=16, rng) {
    assert_true(valid_base64(value, true, true))
    @test.assert_eq(value.length() % 4, 0)
  }
  for value in @encoding.url_safe_base64_no_pad().sample(count=16, rng) {
    assert_true(valid_base64(value, true, false))
    assert_true(!value.contains("="))
  }
}

///|
test "encoding generators are deterministic for the same seed" {
  let seed = b"encoding-determinism"
  @test.assert_eq(
    @encoding.base64().sample(count=8, @core.seed(seed)),
    @encoding.base64().sample(count=8, @core.seed(seed)),
  )
  @test.assert_eq(
    @encoding.url_safe_base64().sample(count=8, @core.seed(seed)),
    @encoding.url_safe_base64().sample(count=8, @core.seed(seed)),
  )
}

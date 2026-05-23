///|
fn compat_encoding_char_allowed(
  ch : Char,
  url_safe : Bool,
  padding : Bool,
) -> Bool {
  let code = ch.to_int()
  let alnum = (code >= '0'.to_int() && code <= '9'.to_int()) ||
    (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
    (code >= 'a'.to_int() && code <= 'z'.to_int())
  alnum ||
  (!url_safe && (ch == '+' || ch == '/')) ||
  (url_safe && (ch == '-' || ch == '_')) ||
  (padding && ch == '=')
}

///|
fn compat_encoding_valid_base64(
  value : String,
  url_safe : Bool,
  padding : Bool,
) -> Bool {
  if !padding && value.contains("=") {
    return false
  }
  for ch in value {
    if !compat_encoding_char_allowed(ch, url_safe, padding) {
      return false
    }
  }
  true
}

///|
test "data base64 formats keep alphabet padding and determinism" {
  let rng = @core.seed(b"format-encoding")
  for value in @encoding.base64().sample(count=24, rng) {
    assert_true(compat_encoding_valid_base64(value, false, true))
  }
  for value in @encoding.base64_padded().sample(count=24, rng) {
    assert_true(value.length() % 4 == 0)
    assert_true(compat_encoding_valid_base64(value, false, true))
  }
  for value in @encoding.base64_no_pad().sample(count=24, rng) {
    assert_true(compat_encoding_valid_base64(value, false, false))
  }
  for value in @encoding.url_safe_base64().sample(count=24, rng) {
    assert_true(compat_encoding_valid_base64(value, true, true))
  }
  for value in @encoding.url_safe_base64_padded().sample(count=24, rng) {
    assert_true(value.length() % 4 == 0)
    assert_true(compat_encoding_valid_base64(value, true, true))
  }
  for value in @encoding.url_safe_base64_no_pad().sample(count=24, rng) {
    assert_true(compat_encoding_valid_base64(value, true, false))
  }
  @test.assert_eq(
    @encoding.base64().sample(count=12, @core.seed(b"format-encoding-det")),
    @encoding.base64().sample(count=12, @core.seed(b"format-encoding-det")),
  )
}

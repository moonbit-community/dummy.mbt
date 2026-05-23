///|
fn compat_color_is_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'f'.to_int()) ||
  (code >= 'A'.to_int() && code <= 'F'.to_int())
}

///|
fn compat_color_valid_hex(s : String) -> Bool {
  if s.length() != 7 || s.get_char(0) != Some('#') {
    return false
  }
  for i in 1..<7 {
    guard s.get_char(i) is Some(ch) && compat_color_is_hex(ch) else {
      return false
    }
  }
  true
}

///|
test "data CSS color formats are preserved" {
  let rng = @core.seed(b"format-color")
  for value in @color.hex_color().sample(count=16, rng) {
    assert_true(compat_color_valid_hex(value))
  }
  assert_true(@color.rgb_color().dummy(rng).has_prefix("rgb("))
  assert_true(@color.rgba_color().dummy(rng).has_prefix("rgba("))
  assert_true(@color.hsl_color().dummy(rng).has_prefix("hsl("))
  assert_true(@color.hsla_color().dummy(rng).has_prefix("hsla("))
  let lines = @color.color()
    .dummy(rng)
    .split("\n")
    .map(line => line.to_owned())
    .to_array()
  @test.assert_eq(lines.length(), 5)
  assert_true(compat_color_valid_hex(lines[0]))
  assert_true(lines[1].has_prefix("rgb("))
  assert_true(lines[2].has_prefix("rgba("))
  assert_true(lines[3].has_prefix("hsl("))
  assert_true(lines[4].has_prefix("hsla("))
}

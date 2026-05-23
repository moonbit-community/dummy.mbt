///|
fn compat_number_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_number_is_nonzero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn compat_number_assert_format(value : String, fmt : String) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') =>
        assert_true(
          value.get_char(i).map_or(false, compat_number_is_nonzero_digit),
        )
      Some('#') =>
        assert_true(value.get_char(i).map_or(false, compat_number_is_digit))
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing format character")
    }
  }
}

///|
test "data number format placeholders are resolved" {
  let rng = @core.seed(b"format-number")
  for
    value in @number.number_with_format("A^#-#^/literal").sample(count=32, rng) {
    compat_number_assert_format(value, "A^#-#^/literal")
  }
}

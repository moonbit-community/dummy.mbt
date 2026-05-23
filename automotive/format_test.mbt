///|
fn compat_auto_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_auto_is_upper(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
fn compat_auto_placeholders_resolved(s : String) -> Bool {
  !s.contains("#") && !s.contains("$") && !s.is_empty()
}

///|
fn compat_auto_valid_common_plate(s : String) -> Bool {
  s.length() == 9 &&
  compat_auto_is_upper(s.get_char(0).unwrap()) &&
  compat_auto_is_upper(s.get_char(1).unwrap()) &&
  s.get_char(2) == Some('-') &&
  compat_auto_is_digit(s.get_char(3).unwrap()) &&
  compat_auto_is_digit(s.get_char(4).unwrap()) &&
  compat_auto_is_digit(s.get_char(5).unwrap()) &&
  s.get_char(6) == Some('-') &&
  compat_auto_is_upper(s.get_char(7).unwrap()) &&
  compat_auto_is_upper(s.get_char(8).unwrap())
}

///|
test "data automotive formats are preserved" {
  let rng = @core.seed(b"format-automotive")
  for locale in [@locales.FR_FR, IT_IT] {
    for value in @automotive.licence_plate(locale~).sample(count=16, rng) {
      assert_true(compat_auto_valid_common_plate(value))
    }
  }
  for locale in [@locales.NL_NL, PT_PT, TR_TR, FA_IR] {
    for value in @automotive.licence_plate(locale~).sample(count=16, rng) {
      assert_true(compat_auto_placeholders_resolved(value))
    }
  }
}

///|
fn compat_admin_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_admin_all_digits(s : String) -> Bool {
  for ch in s {
    if !compat_admin_is_digit(ch) {
      return false
    }
  }
  true
}

///|
fn compat_admin_valid_health_code(s : String) -> Bool {
  let parts = s.split(" ").map(part => part.to_owned()).to_array()
  parts.length() == 7 &&
  (parts[0] == "1" || parts[0] == "2") &&
  parts[1].length() == 2 &&
  parts[2].length() == 2 &&
  (parts[3].length() == 2 || parts[3].length() == 3) &&
  parts[4].length() == 3 &&
  parts[5].length() == 3 &&
  parts[6].length() >= 1 &&
  parts[6].length() <= 2 &&
  compat_admin_all_digits(parts[0]) &&
  compat_admin_all_digits(parts[1]) &&
  compat_admin_all_digits(parts[2]) &&
  compat_admin_all_digits(parts[4]) &&
  compat_admin_all_digits(parts[5]) &&
  compat_admin_all_digits(parts[6])
}

///|
test "data administrative format is preserved" {
  let values = @administrative.health_insurance_code(locale=@locales.FR_FR).sample(
    count=32,
    @core.seed(b"format-administrative"),
  )
  for value in values {
    assert_true(compat_admin_valid_health_code(value))
  }
}

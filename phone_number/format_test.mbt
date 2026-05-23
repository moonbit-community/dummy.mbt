///|
fn compat_phone_chars_resolved(s : String) -> Bool {
  if s.is_empty() || s.contains("#") || s.contains("^") {
    return false
  }
  for ch in s {
    let code = ch.to_int()
    let ok = (code >= '0'.to_int() && code <= '9'.to_int()) ||
      ch == '+' ||
      ch == '-' ||
      ch == '.' ||
      ch == '(' ||
      ch == ')' ||
      ch == ' ' ||
      ch == 'x'
    if !ok {
      return false
    }
  }
  true
}

///|
test "data phone placeholders are resolved" {
  let rng = @core.seed(b"format-phone")
  for phone in @phone_number.phone_number().sample(count=16, rng) {
    assert_true(compat_phone_chars_resolved(phone))
  }
  for phone in @phone_number.cell_number().sample(count=16, rng) {
    assert_true(compat_phone_chars_resolved(phone))
  }
}

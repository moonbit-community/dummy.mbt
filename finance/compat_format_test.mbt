///|
fn compat_finance_is_upper(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
fn compat_finance_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_finance_all(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn compat_finance_valid_bic(s : String) -> Bool {
  if s.length() != 8 && s.length() != 11 {
    return false
  }
  compat_finance_all(s[0:6].to_owned(), compat_finance_is_upper) &&
  compat_finance_all(s[6:].to_owned(), ch => {
    compat_finance_is_upper(ch) || compat_finance_is_digit(ch)
  })
}

///|
fn compat_finance_isin_char_value(ch : Char) -> Int? {
  if compat_finance_is_digit(ch) {
    Some(ch.to_int() - '0'.to_int())
  } else if compat_finance_is_upper(ch) {
    Some(ch.to_int() - 'A'.to_int() + 10)
  } else {
    None
  }
}

///|
fn compat_finance_valid_isin(s : String) -> Bool {
  if s.length() != 12 {
    return false
  }
  guard compat_finance_all(s[0:2].to_owned(), compat_finance_is_upper) else {
    return false
  }
  let expanded = StringBuilder::new()
  for ch in s {
    guard compat_finance_isin_char_value(ch) is Some(value) else {
      return false
    }
    expanded.write_string(value.to_string())
  }
  let digits = expanded.to_string()
  let mut sum = 0
  let mut double = false
  for i = digits.length() - 1; i >= 0; i = i - 1 {
    let mut value = digits[i].to_int() - '0'.to_int()
    if double {
      value *= 2
      if value > 9 {
        value = value / 10 + value % 10
      }
    }
    sum += value
    double = !double
  }
  sum % 10 == 0
}

///|
test "data finance identifiers keep BIC and ISIN shape" {
  let rng = @core.seed(b"format-finance")
  for value in @finance.bic().sample(count=32, rng) {
    assert_true(compat_finance_valid_bic(value))
  }
  for value in @finance.isin().sample(count=32, rng) {
    assert_true(compat_finance_valid_isin(value))
  }
}

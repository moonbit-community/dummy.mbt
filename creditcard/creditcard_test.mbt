///|
fn digit_at(s : String, i : Int32) -> Int32 {
  match s.get_char(i) {
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
}

///|
fn all_decimal_digits(s : String) -> Bool {
  for i in 0..<s.length() {
    let digit = digit_at(s, i)
    if digit < 0 || digit > 9 {
      return false
    }
  }
  true
}

///|
fn luhn_valid(s : String) -> Bool {
  if !all_decimal_digits(s) {
    return false
  }
  let mut sum = 0
  let len = s.length()
  for i in 0..<len {
    let mut value = digit_at(s, i)
    if (len - i) % 2 == 0 {
      value *= 2
      if value > 9 {
        value -= 9
      }
    }
    sum += value
  }
  sum % 10 == 0
}

///|
fn has_known_prefix(s : String) -> Bool {
  s.has_prefix("4") ||
  s.has_prefix("34") ||
  s.has_prefix("37") ||
  s.has_prefix("51") ||
  s.has_prefix("52") ||
  s.has_prefix("53") ||
  s.has_prefix("54") ||
  s.has_prefix("55")
}

///|
fn issuer_length_matches(s : String) -> Bool {
  if s.has_prefix("34") || s.has_prefix("37") {
    s.length() == 15
  } else if s.has_prefix("4") {
    s.length() == 13 || s.length() == 16
  } else if s.has_prefix("51") ||
    s.has_prefix("52") ||
    s.has_prefix("53") ||
    s.has_prefix("54") ||
    s.has_prefix("55") {
    s.length() == 16
  } else {
    false
  }
}

///|
test "credit_card_number is numeric and luhn-valid" {
  let values = @creditcard.credit_card_number().sample(
    count=32,
    @core.seed(b"credit-card"),
  )
  for value in values {
    assert_true(all_decimal_digits(value))
    assert_true(luhn_valid(value))
  }
}

///|
test "credit_card_number uses supported issuer prefixes" {
  let values = @creditcard.credit_card_number().sample(
    count=32,
    @core.seed(b"credit-prefix"),
  )
  for value in values {
    assert_true(has_known_prefix(value))
    assert_true(issuer_length_matches(value))
  }
}

///|
test "credit_card_number is deterministic for the same seed" {
  let a = @creditcard.credit_card_number().sample(
    count=8,
    @core.seed(b"credit-determinism"),
  )
  let b = @creditcard.credit_card_number().sample(
    count=8,
    @core.seed(b"credit-determinism"),
  )
  @test.assert_eq(a, b)
}

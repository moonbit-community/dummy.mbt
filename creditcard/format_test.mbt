///|
fn compat_card_digit_at(s : String, i : Int32) -> Int32 {
  match s.get_char(i) {
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
}

///|
fn compat_card_all_digits(s : String) -> Bool {
  for i in 0..<s.length() {
    let value = compat_card_digit_at(s, i)
    if value < 0 || value > 9 {
      return false
    }
  }
  true
}

///|
fn compat_card_luhn_valid(s : String) -> Bool {
  if !compat_card_all_digits(s) {
    return false
  }
  let mut sum = 0
  let len = s.length()
  for i in 0..<len {
    let mut value = compat_card_digit_at(s, i)
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
test "data credit card checksum is preserved" {
  let cards = @creditcard.credit_card_number().sample(
    count=32,
    @core.seed(b"format-credit-cards"),
  )
  for card in cards {
    assert_true(card.length() >= 13 && card.length() <= 16)
    assert_true(compat_card_luhn_valid(card))
  }
}

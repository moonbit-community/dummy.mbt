///|
// Compute the Luhn check digit for the generated card-number stem.
fn luhn_check_digit(digits : ArrayView[Int]) -> Int {
  let mut sum = 0
  let len = digits.length()
  for i, digit in digits {
    let mut value = digit
    if (len - i) % 2 == 1 {
      value = digit * 2
      if value > 9 {
        value -= 9
      }
    }
    sum += value
  }
  (10 - sum % 10) % 10
}

///|
// Convert generated decimal digits into the final card-number string.
fn digits_to_string(digits : ArrayView[Int]) -> String {
  let out = StringBuilder::new(size_hint=digits.length())
  for digit in digits {
    out.write_string(digit.to_string())
  }
  out.to_string()
}

///|
/// Generate a Luhn-valid credit card number with a common issuer prefix.
pub fn credit_card_number() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let (prefix, length) = match rng.int(limit=3) {
      0 => ([3, @core.pick([4, 7], rng)], 15)
      1 => ([4], if rng.boolean() { 13 } else { 16 })
      _ => ([5, rng.int(limit=5) + 1], 16)
    }
    let digits : Array[Int] = []
    digits.append(prefix)
    while digits.length() < length - 1 {
      digits.push(rng.int(limit=10))
    }
    digits.push(luhn_check_digit(digits))
    digits_to_string(digits)
  })
}

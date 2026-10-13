///|
fn compat_barcode_digit_value_at(s : String, i : Int32) -> Int32 {
  match s.get_char(i) {
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
}

///|
fn compat_barcode_is_digit_at(s : String, i : Int32) -> Bool {
  let value = compat_barcode_digit_value_at(s, i)
  value >= 0 && value <= 9
}

///|
fn compat_barcode_strip_hyphens(s : String) -> String {
  let out = StringBuilder::new(size_hint=s.length())
  for ch in s {
    if ch != '-' {
      out.write_char(ch)
    }
  }
  out.to_string()
}

///|
fn compat_barcode_valid_isbn13(s : String) -> Bool {
  let s = compat_barcode_strip_hyphens(s)
  if s.length() != 13 {
    return false
  }
  for i in 0..<13 {
    if !compat_barcode_is_digit_at(s, i) {
      return false
    }
  }
  let mut sum = 0
  for i in 0..<12 {
    let digit = compat_barcode_digit_value_at(s, i)
    sum += if i % 2 == 0 { digit } else { digit * 3 }
  }
  compat_barcode_digit_value_at(s, 12) == (10 - sum % 10) % 10
}

///|
fn compat_barcode_valid_isbn10(s : String) -> Bool {
  let s = compat_barcode_strip_hyphens(s)
  if s.length() != 10 {
    return false
  }
  for i in 0..<9 {
    if !compat_barcode_is_digit_at(s, i) {
      return false
    }
  }
  let check = match s.get_char(9) {
    Some('X') => 10
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
  if check < 0 || check > 10 {
    return false
  }
  let mut sum = 0
  for i in 0..<9 {
    sum += compat_barcode_digit_value_at(s, i) * (10 - i)
  }
  (sum + check) % 11 == 0
}

///|
test "data barcode checksums are preserved" {
  let rng = @core.seed(b"format-barcodes")
  for value in @barcode.isbn10().sample(count=16, rng) {
    assert_true(compat_barcode_valid_isbn10(value))
  }
  for value in @barcode.isbn13().sample(count=16, rng) {
    assert_true(value.has_prefix("978-"))
    assert_true(compat_barcode_valid_isbn13(value))
  }
  for value in @barcode.isbn().sample(count=16, rng) {
    assert_true(
      compat_barcode_valid_isbn10(value) || compat_barcode_valid_isbn13(value),
    )
  }
}

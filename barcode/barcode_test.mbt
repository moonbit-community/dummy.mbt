///|
fn digit_value_at(s : String, i : Int32) -> Int32 {
  match s.get_char(i) {
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
}

///|
fn is_ascii_digit_at(s : String, i : Int32) -> Bool {
  let value = digit_value_at(s, i)
  value >= 0 && value <= 9
}

///|
fn all_digits(s : String) -> Bool {
  for i in 0..<s.length() {
    if !is_ascii_digit_at(s, i) {
      return false
    }
  }
  true
}

///|
fn strip_hyphens(s : String) -> String {
  let out = StringBuilder(size_hint=s.length())
  for ch in s {
    if ch != '-' {
      out.write_char(ch)
    }
  }
  out.to_string()
}

///|
fn count_char(s : String, expected : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == expected {
      count += 1
    }
  }
  count
}

///|
fn isbn13_valid(s : String) -> Bool {
  let s = strip_hyphens(s)
  if s.length() != 13 || !all_digits(s) {
    return false
  }
  let mut sum = 0
  for i in 0..<12 {
    let digit = digit_value_at(s, i)
    sum += if i % 2 == 0 { digit } else { digit * 3 }
  }
  digit_value_at(s, 12) == (10 - sum % 10) % 10
}

///|
fn isbn10_check_value(s : String) -> Int32 {
  let s = strip_hyphens(s)
  match s.get_char(9) {
    Some('X') => 10
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
}

///|
fn isbn10_valid(s : String) -> Bool {
  let s = strip_hyphens(s)
  if s.length() != 10 {
    return false
  }
  for i in 0..<9 {
    if !is_ascii_digit_at(s, i) {
      return false
    }
  }
  let check = isbn10_check_value(s)
  if check < 0 || check > 10 {
    return false
  }
  let mut sum = 0
  for i in 0..<9 {
    sum += digit_value_at(s, i) * (10 - i)
  }
  (sum + check) % 11 == 0
}

///|
test "isbn13 has a valid EAN checksum" {
  let values = @barcode.isbn13().sample(count=16, @core.seed(b"isbn13"))
  for value in values {
    assert_true(value.has_prefix("978-"))
    @test.assert_eq(count_char(value, '-'), 4)
    assert_true(isbn13_valid(value))
  }
}

///|
test "isbn10 has a valid checksum" {
  let values = @barcode.isbn10().sample(count=16, @core.seed(b"isbn10"))
  for value in values {
    @test.assert_eq(count_char(value, '-'), 3)
    assert_true(isbn10_valid(value))
  }
}

///|
test "isbn selects either isbn10 or isbn13" {
  let values = @barcode.isbn().sample(count=32, @core.seed(b"isbn-any"))
  for value in values {
    assert_true(isbn10_valid(value) || isbn13_valid(value))
  }
}

///|
test "barcode generators are deterministic for the same seed" {
  let a = @barcode.isbn().sample(count=12, @core.seed(b"isbn-determinism"))
  let b = @barcode.isbn().sample(count=12, @core.seed(b"isbn-determinism"))
  @test.assert_eq(a, b)
}

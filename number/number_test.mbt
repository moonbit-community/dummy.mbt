///|
fn is_ascii_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn is_non_zero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn is_digit_at(s : String, i : Int32) -> Bool {
  match s.get_char(i) {
    Some(ch) => is_ascii_digit(ch)
    None => false
  }
}

///|
fn is_non_zero_digit_at(s : String, i : Int32) -> Bool {
  match s.get_char(i) {
    Some(ch) => is_non_zero_digit(ch)
    None => false
  }
}

///|
fn assert_matches_number_format(value : String, fmt : String) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') => assert_true(is_non_zero_digit_at(value, i))
      Some('#') => assert_true(is_digit_at(value, i))
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing format character")
    }
  }
}

///|
test "digit produces a single decimal digit" {
  let values = @number.digit().sample(count=32, @core.seed(b"number-digit"))
  for value in values {
    assert_true(value >= 0 && value <= 9)
  }
}

///|
test "digit_string uses the NUMBER_DIGIT table" {
  let values = @number.digit_string().sample(
    count=32,
    @core.seed(b"number-digit-string"),
  )
  for value in values {
    @test.assert_eq(value.length(), 1)
    assert_true(value.get_char(0) is Some(ch) && is_ascii_digit(ch))
  }
  let again = @number.digit_string().sample(
    count=32,
    @core.seed(b"number-digit-string"),
  )
  @test.assert_eq(values, again)
}

///|
test "int samples from the requested half-open range" {
  let values = @number.int(range=@core.int_range(-3, 4)).sample(
    count=64,
    @core.seed(b"number-int-range"),
  )
  for value in values {
    assert_true(value >= -3 && value < 4)
  }
}

///|
test "int rejects empty or reversed ranges" {
  let equal : Result[Int32, @core.DummyError] = try? @number.int(
    range=@core.int_range(2, 2),
  ).dummy(@core.seed(b"number-empty-range"))
  assert_true(equal is Err(@core.DummyError::InvalidRange(_)))
  let reversed : Result[Int32, @core.DummyError] = try? @number.int(
    range=@core.int_range(5, 1),
  ).dummy(@core.seed(b"number-reversed-range"))
  assert_true(reversed is Err(@core.DummyError::InvalidRange(_)))
}

///|
test "number_with_format replaces digit placeholders" {
  let value = @number.number_with_format("ID-^##-#^").dummy(
    @core.seed(b"number-format"),
  )
  @test.assert_eq(value.length(), 9)
  assert_true(value.has_prefix("ID-"))
  @test.assert_eq(value.get_char(6), Some('-'))
  assert_true(is_non_zero_digit_at(value, 3))
  assert_true(is_digit_at(value, 4))
  assert_true(is_digit_at(value, 7))
  assert_true(is_non_zero_digit_at(value, 8))
}

///|
test "number_with_format leaves literal characters unchanged" {
  let value = @number.number_with_format("order:^#/#").dummy(
    @core.seed(b"number-literals"),
  )
  assert_true(value.has_prefix("order:"))
  @test.assert_eq(value.get_char(8), Some('/'))
  let braces = @number.number_with_format("{}").sample(
    count=8,
    @core.seed(b"number-brace-literals"),
  )
  for value in braces {
    @test.assert_eq(value, "{}")
  }
}

///|
test "number_with_format matches examples" {
  let number = @number.number_with_format("^###").dummy(
    @core.seed(b"number-example-number"),
  )
  assert_matches_number_format(number, "^###")
  let flat = @number.number_with_format("FLAT 0# ^#/F").dummy(
    @core.seed(b"number-example-flat"),
  )
  assert_matches_number_format(flat, "FLAT 0# ^#/F")
  let phone = @number.number_with_format("(+852) 6### ####").dummy(
    @core.seed(b"number-example-phone"),
  )
  assert_matches_number_format(phone, "(+852) 6### ####")
}

///|
test "number_with_format handles empty format" {
  let value = @number.number_with_format("").dummy(
    @core.seed(b"number-empty-format"),
  )
  @test.assert_eq(value, "")
}

///|
test "number_with_format caret placeholders are never zero in batches" {
  let values = @number.number_with_format("^^^^^^^^^^").sample(
    count=64,
    @core.seed(b"number-caret-batch"),
  )
  for value in values {
    @test.assert_eq(value.length(), 10)
    for i in 0..<value.length() {
      assert_true(is_non_zero_digit_at(value, i))
    }
  }
}

///|
test "number generators are deterministic for the same seed" {
  let a = @number.number_with_format("^#^#").sample(
    count=8,
    @core.seed(b"number-determinism"),
  )
  let b = @number.number_with_format("^#^#").sample(
    count=8,
    @core.seed(b"number-determinism"),
  )
  @test.assert_eq(a, b)
}

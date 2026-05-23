///|
fn is_decimal_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn is_licence_letter(ch : Char) -> Bool {
  for
    candidate in [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q',
      'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z',
    ] {
    if ch == candidate {
      return true
    }
  }
  false
}

///|
fn char_at_is(s : String, i : Int, pred : (Char) -> Bool) -> Bool {
  match s.get_char(i) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn has_char_at(s : String, i : Int, ch : Char) -> Bool {
  s.get_char(i) == Some(ch)
}

///|
fn matches_common_plate(s : String) -> Bool {
  s.length() == 9 &&
  has_char_at(s, 2, '-') &&
  has_char_at(s, 6, '-') &&
  char_at_is(s, 0, is_licence_letter) &&
  char_at_is(s, 1, is_licence_letter) &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 5, is_decimal_digit) &&
  char_at_is(s, 7, is_licence_letter) &&
  char_at_is(s, 8, is_licence_letter)
}

///|
fn matches_nl_variant_1(s : String) -> Bool {
  s.length() == 8 &&
  char_at_is(s, 0, is_licence_letter) &&
  char_at_is(s, 1, is_licence_letter) &&
  has_char_at(s, 2, '-') &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 5, is_decimal_digit) &&
  has_char_at(s, 6, '-') &&
  char_at_is(s, 7, is_licence_letter)
}

///|
fn matches_nl_variant_2(s : String) -> Bool {
  s.length() == 8 &&
  char_at_is(s, 0, is_licence_letter) &&
  has_char_at(s, 1, '-') &&
  char_at_is(s, 2, is_decimal_digit) &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  has_char_at(s, 5, '-') &&
  char_at_is(s, 6, is_licence_letter) &&
  char_at_is(s, 7, is_licence_letter)
}

///|
fn matches_nl_variant_3(s : String) -> Bool {
  s.length() == 8 &&
  char_at_is(s, 0, is_licence_letter) &&
  char_at_is(s, 1, is_licence_letter) &&
  char_at_is(s, 2, is_licence_letter) &&
  has_char_at(s, 3, '-') &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 5, is_decimal_digit) &&
  has_char_at(s, 6, '-') &&
  char_at_is(s, 7, is_licence_letter)
}

///|
fn matches_nl_plate(s : String) -> Bool {
  matches_nl_variant_1(s) || matches_nl_variant_2(s) || matches_nl_variant_3(s)
}

///|
fn matches_pt_variant_1(s : String) -> Bool {
  s.length() == 8 &&
  has_char_at(s, 2, '-') &&
  has_char_at(s, 5, '-') &&
  char_at_is(s, 0, is_licence_letter) &&
  char_at_is(s, 1, is_licence_letter) &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 6, is_decimal_digit) &&
  char_at_is(s, 7, is_decimal_digit)
}

///|
fn matches_pt_variant_2(s : String) -> Bool {
  s.length() == 8 &&
  has_char_at(s, 2, '-') &&
  has_char_at(s, 5, '-') &&
  char_at_is(s, 0, is_decimal_digit) &&
  char_at_is(s, 1, is_decimal_digit) &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 6, is_licence_letter) &&
  char_at_is(s, 7, is_licence_letter)
}

///|
fn matches_pt_variant_3(s : String) -> Bool {
  s.length() == 8 &&
  has_char_at(s, 2, '-') &&
  has_char_at(s, 5, '-') &&
  char_at_is(s, 0, is_decimal_digit) &&
  char_at_is(s, 1, is_decimal_digit) &&
  char_at_is(s, 3, is_licence_letter) &&
  char_at_is(s, 4, is_licence_letter) &&
  char_at_is(s, 6, is_decimal_digit) &&
  char_at_is(s, 7, is_decimal_digit)
}

///|
fn matches_pt_variant_4(s : String) -> Bool {
  s.length() == 8 &&
  has_char_at(s, 2, ' ') &&
  has_char_at(s, 5, ' ') &&
  char_at_is(s, 0, is_decimal_digit) &&
  char_at_is(s, 1, is_decimal_digit) &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 6, is_licence_letter) &&
  char_at_is(s, 7, is_licence_letter)
}

///|
fn matches_pt_variant_5(s : String) -> Bool {
  s.length() == 8 &&
  has_char_at(s, 2, ' ') &&
  has_char_at(s, 5, ' ') &&
  char_at_is(s, 0, is_decimal_digit) &&
  char_at_is(s, 1, is_decimal_digit) &&
  char_at_is(s, 3, is_licence_letter) &&
  char_at_is(s, 4, is_licence_letter) &&
  char_at_is(s, 6, is_decimal_digit) &&
  char_at_is(s, 7, is_decimal_digit)
}

///|
fn matches_pt_variant_6(s : String) -> Bool {
  s.length() == 8 &&
  has_char_at(s, 2, ' ') &&
  has_char_at(s, 5, ' ') &&
  char_at_is(s, 0, is_licence_letter) &&
  char_at_is(s, 1, is_licence_letter) &&
  char_at_is(s, 3, is_decimal_digit) &&
  char_at_is(s, 4, is_decimal_digit) &&
  char_at_is(s, 6, is_licence_letter) &&
  char_at_is(s, 7, is_licence_letter)
}

///|
fn matches_pt_plate(s : String) -> Bool {
  matches_pt_variant_1(s) ||
  matches_pt_variant_2(s) ||
  matches_pt_variant_3(s) ||
  matches_pt_variant_4(s) ||
  matches_pt_variant_5(s) ||
  matches_pt_variant_6(s)
}

///|
fn matches_tr_fa_variant_1(s : String) -> Bool {
  s.length() == 10 &&
  char_at_is(s, 0, is_decimal_digit) &&
  char_at_is(s, 1, is_decimal_digit) &&
  has_char_at(s, 2, ' ') &&
  has_char_at(s, 3, 'A') &&
  has_char_at(s, 4, 'B') &&
  has_char_at(s, 5, 'C') &&
  has_char_at(s, 6, ' ') &&
  char_at_is(s, 7, is_decimal_digit) &&
  char_at_is(s, 8, is_decimal_digit) &&
  char_at_is(s, 9, is_decimal_digit)
}

///|
fn matches_tr_fa_variant_2(s : String) -> Bool {
  s.length() == 10 &&
  char_at_is(s, 0, is_decimal_digit) &&
  char_at_is(s, 1, is_decimal_digit) &&
  has_char_at(s, 2, ' ') &&
  has_char_at(s, 3, 'A') &&
  has_char_at(s, 4, 'B') &&
  has_char_at(s, 5, ' ') &&
  char_at_is(s, 6, is_decimal_digit) &&
  char_at_is(s, 7, is_decimal_digit) &&
  char_at_is(s, 8, is_decimal_digit) &&
  char_at_is(s, 9, is_decimal_digit)
}

///|
fn matches_tr_fa_plate(s : String) -> Bool {
  matches_tr_fa_variant_1(s) || matches_tr_fa_variant_2(s)
}

///|
test "licence_plate supports FR_FR and IT_IT format" {
  for locale in [@locales.FR_FR, @locales.IT_IT] {
    let values = @automotive.licence_plate(locale~).sample(
      count=32,
      @core.seed(b"automotive-common"),
    )
    for value in values {
      assert_true(matches_common_plate(value))
    }
  }
}

///|
test "licence_plate defaults to FR_FR" {
  let seed = b"automotive-default"
  @test.assert_eq(
    @automotive.licence_plate().dummy(@core.seed(seed)),
    @automotive.licence_plate(locale=@locales.FR_FR).dummy(@core.seed(seed)),
  )
}

///|
test "licence_plate supports NL_NL formats" {
  let values = @automotive.licence_plate(locale=@locales.NL_NL).sample(
    count=128,
    @core.seed(b"automotive-nl"),
  )
  let mut seen_1 = false
  let mut seen_2 = false
  let mut seen_3 = false
  for value in values {
    assert_true(matches_nl_plate(value))
    if matches_nl_variant_1(value) {
      seen_1 = true
    }
    if matches_nl_variant_2(value) {
      seen_2 = true
    }
    if matches_nl_variant_3(value) {
      seen_3 = true
    }
  }
  assert_true(seen_1)
  assert_true(seen_2)
  assert_true(seen_3)
}

///|
test "licence_plate supports PT_PT formats" {
  let values = @automotive.licence_plate(locale=@locales.PT_PT).sample(
    count=256,
    @core.seed(b"automotive-pt"),
  )
  let mut seen_1 = false
  let mut seen_2 = false
  let mut seen_3 = false
  let mut seen_4 = false
  let mut seen_5 = false
  let mut seen_6 = false
  for value in values {
    assert_true(matches_pt_plate(value))
    if matches_pt_variant_1(value) {
      seen_1 = true
    }
    if matches_pt_variant_2(value) {
      seen_2 = true
    }
    if matches_pt_variant_3(value) {
      seen_3 = true
    }
    if matches_pt_variant_4(value) {
      seen_4 = true
    }
    if matches_pt_variant_5(value) {
      seen_5 = true
    }
    if matches_pt_variant_6(value) {
      seen_6 = true
    }
  }
  assert_true(seen_1)
  assert_true(seen_2)
  assert_true(seen_3)
  assert_true(seen_4)
  assert_true(seen_5)
  assert_true(seen_6)
}

///|
test "licence_plate supports TR_TR and FA_IR formats" {
  for locale in [@locales.TR_TR, @locales.FA_IR] {
    let values = @automotive.licence_plate(locale~).sample(
      count=64,
      @core.seed(b"automotive-tr-fa"),
    )
    let mut seen_1 = false
    let mut seen_2 = false
    for value in values {
      assert_true(matches_tr_fa_plate(value))
      if matches_tr_fa_variant_1(value) {
        seen_1 = true
      }
      if matches_tr_fa_variant_2(value) {
        seen_2 = true
      }
    }
    assert_true(seen_1)
    assert_true(seen_2)
  }
}

///|
test "licence_plate is deterministic for the same seed" {
  let seed = b"automotive-determinism"
  let a = @automotive.licence_plate(locale=@locales.NL_NL).sample(
    count=16,
    @core.seed(seed),
  )
  let b = @automotive.licence_plate(locale=@locales.NL_NL).sample(
    count=16,
    @core.seed(seed),
  )
  @test.assert_eq(a, b)
}

///|
test "licence_plate rejects unsupported locales" {
  let result : Result[String, @core.DummyError] = try? @automotive.licence_plate(
    locale=@locales.EN,
  ).dummy(@core.seed(b"automotive-unsupported"))
  assert_true(result is Err(@core.DummyError::UnsupportedLocale(_)))
}

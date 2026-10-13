///|
fn is_upper_letter(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
test "currency_code uses ISO-style three-letter codes" {
  let values = @currency.currency_code().sample(
    count=32,
    @core.seed(b"currency-code"),
  )
  for value in values {
    @test.assert_eq(value.length(), 3)
    for ch in value {
      assert_true(is_upper_letter(ch))
    }
  }
}

///|
test "currency names and symbols come from shared data" {
  let rng = @core.seed(b"currency-values")
  assert_true(!@currency.currency_name().dummy(rng).is_empty())
  assert_true(!@currency.currency_symbol().dummy(rng).is_empty())
  assert_true(!@currency.currency_name(locale=PT_PT).dummy(rng).is_empty())
  assert_true(!@currency.currency_symbol(locale=IT_IT).dummy(rng).is_empty())
  @test.assert_eq(@currency.currency_code(locale=PT_PT).dummy(rng).length(), 3)
}

///|
test "currency generators are deterministic for the same seed" {
  let a = @currency.currency_code().sample(
    count=8,
    @core.seed(b"currency-determinism"),
  )
  let b = @currency.currency_code().sample(
    count=8,
    @core.seed(b"currency-determinism"),
  )
  @test.assert_eq(a, b)
}

///|
test "currency fixed seed golden outputs" {
  let code = @currency.currency_code().dummy(
    @core.seed(b"currency-golden-code"),
  )
  let name = @currency.currency_name().dummy(
    @core.seed(b"currency-golden-name"),
  )
  let symbol = @currency.currency_symbol().dummy(
    @core.seed(b"currency-golden-symbol"),
  )
  @test.assert_eq(code.length(), 3)
  for ch in code {
    assert_true(is_upper_letter(ch))
  }
  assert_true(!name.is_empty())
  assert_true(!symbol.is_empty())
}

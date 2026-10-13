///|
fn is_phone_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  ch == '+' ||
  ch == '(' ||
  ch == ')' ||
  ch == '-' ||
  ch == '.' ||
  ch == ' ' ||
  ch == 'x'
}

///|
fn all_phone_chars(s : String) -> Bool {
  for ch in s {
    if !is_phone_char(ch) {
      return false
    }
  }
  true
}

///|
test "phone_number uses style phone formats" {
  let values = @phone_number.phone_number(locale=EN).sample(
    count=32,
    @core.seed(b"phone-en"),
  )
  for value in values {
    assert_true(all_phone_chars(value))
    assert_true(!value.is_empty())
  }
}

///|
test "cell_number uses the cell format set" {
  let values = @phone_number.cell_number(locale=EN).sample(
    count=16,
    @core.seed(b"cell-en"),
  )
  for value in values {
    assert_true(all_phone_chars(value))
    assert_true(!value.contains("x"))
  }
}

///|
test "zh phone formats keep locale prefixes" {
  let rng = @core.seed(b"phone-zh")
  let cn = @phone_number.phone_number(locale=ZH_CN).dummy(rng)
  assert_true(cn.has_prefix("+86 1"))
  let tw = @phone_number.phone_number(locale=ZH_TW).dummy(rng)
  assert_true(tw.has_prefix("+886 9"))
  assert_true(
    @phone_number.cell_number(locale=ZH_CN)
    .dummy(@core.seed(b"cell-zh-cn"))
    .has_prefix("+86 1"),
  )
  assert_true(
    @phone_number.cell_number(locale=ZH_TW)
    .dummy(@core.seed(b"cell-zh-tw"))
    .has_prefix("+886 9"),
  )
}

///|
test "phone generators are deterministic for the same seed" {
  let a = @phone_number.phone_number().sample(
    count=8,
    @core.seed(b"phone-determinism"),
  )
  let b = @phone_number.phone_number().sample(
    count=8,
    @core.seed(b"phone-determinism"),
  )
  @test.assert_eq(a, b)
}

///|
test "phone locale data and fixed seed golden outputs" {
  let fr = @phone_number.phone_number(locale=FR_FR).dummy(
    @core.seed(b"phone-fr"),
  )
  assert_true(all_phone_chars(fr))
  @test.assert_eq(fr.length(), 14)
  let pt_br = @phone_number.cell_number(locale=PT_BR).dummy(
    @core.seed(b"phone-pt-br"),
  )
  assert_true(all_phone_chars(pt_br))
  assert_true(pt_br.contains("9"))
  let en = @phone_number.phone_number(locale=EN).dummy(
    @core.seed(b"phone-golden-en"),
  )
  let en_cell = @phone_number.cell_number(locale=EN).dummy(
    @core.seed(b"cell-golden-en"),
  )
  let zh_cn = @phone_number.phone_number(locale=ZH_CN).dummy(
    @core.seed(b"phone-golden-cn"),
  )
  let zh_tw = @phone_number.phone_number(locale=ZH_TW).dummy(
    @core.seed(b"phone-golden-tw"),
  )
  assert_true(all_phone_chars(en))
  assert_true(all_phone_chars(en_cell))
  assert_true(zh_cn.has_prefix("+86 1"))
  assert_true(zh_tw.has_prefix("+886 9"))
}

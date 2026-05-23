///|
fn contains_space(s : String) -> Bool {
  s.contains(" ")
}

///|
test "name generators use locale templates" {
  let rng = @core.seed(b"name-locale")
  let en_name = @name.name(locale=@locales.EN).dummy(rng)
  assert_true(contains_space(en_name))
  let zh_cn_name = @name.name(locale=@locales.ZH_CN).dummy(rng)
  assert_true(!zh_cn_name.is_empty())
  assert_true(!contains_space(zh_cn_name))
  let zh_tw_name = @name.name(locale=@locales.ZH_TW).dummy(rng)
  assert_true(!zh_tw_name.is_empty())
  assert_true(!contains_space(zh_tw_name))
}

///|
test "name_with_title includes a locale title" {
  let rng = @core.seed(b"name-title")
  let en = @name.name_with_title(locale=@locales.EN).dummy(rng)
  assert_true(!en.is_empty())
  assert_true(contains_space(en))
  let zh = @name.name_with_title(locale=@locales.ZH_CN).dummy(rng)
  assert_true(
    zh.has_suffix("先生") ||
    zh.has_suffix("小姐") ||
    zh.has_suffix("男士") ||
    zh.has_suffix("女士"),
  )
}

///|
test "non-first-wave name locales use locale data when present" {
  let value = @name.name(locale=@locales.FR_FR).dummy(@core.seed(b"name-fr"))
  assert_true(!value.is_empty())
  assert_true(contains_space(value))
  let ar = @name.name(locale=@locales.AR_SA).dummy(@core.seed(b"name-ar"))
  assert_true(!ar.is_empty())
  assert_true(contains_space(ar))
  let ja_title = @name.name_with_title(locale=@locales.JA_JP).dummy(
    @core.seed(b"name-ja-title"),
  )
  assert_true(ja_title.has_suffix("様"))
}

///|
test "name generators are deterministic for the same seed" {
  let a = @name.name(locale=@locales.ZH_TW).sample(
    count=8,
    @core.seed(b"name-determinism"),
  )
  let b = @name.name(locale=@locales.ZH_TW).sample(
    count=8,
    @core.seed(b"name-determinism"),
  )
  @test.assert_eq(a, b)
}

///|
test "name fixed seed locale golden outputs" {
  let en = @name.name(locale=@locales.EN).dummy(@core.seed(b"name-golden-en"))
  let en_title = @name.name_with_title(locale=@locales.EN).dummy(
    @core.seed(b"name-title-golden-en"),
  )
  let zh_cn = @name.name(locale=@locales.ZH_CN).dummy(
    @core.seed(b"name-golden-cn"),
  )
  let zh_cn_title = @name.name_with_title(locale=@locales.ZH_CN).dummy(
    @core.seed(b"name-title-golden-cn"),
  )
  let zh_tw = @name.name(locale=@locales.ZH_TW).dummy(
    @core.seed(b"name-golden-tw"),
  )
  let zh_tw_title = @name.name_with_title(locale=@locales.ZH_TW).dummy(
    @core.seed(b"name-title-golden-tw"),
  )
  assert_true(contains_space(en))
  assert_true(!en_title.is_empty())
  assert_true(contains_space(en_title))
  assert_true(!contains_space(zh_cn))
  assert_true(!contains_space(zh_cn_title))
  assert_true(!contains_space(zh_tw))
  assert_true(!contains_space(zh_tw_title))
}

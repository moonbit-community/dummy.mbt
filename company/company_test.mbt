///|
test "company_name uses locale spacing rules" {
  let rng = @core.seed(b"company-name")
  let en = @company.company_name(locale=@locales.EN).dummy(rng)
  assert_true(en.contains(" "))
  let zh = @company.company_name(locale=@locales.ZH_CN).dummy(rng)
  assert_true(!zh.is_empty())
  assert_true(!zh.contains(" "))
}

///|
test "catch_phrase and bs compose phrase pieces" {
  let rng = @core.seed(b"company-phrases")
  let catch_phrase = @company.catch_phrase(locale=@locales.EN).dummy(rng)
  assert_true(catch_phrase.contains(" "))
  let bs = @company.bs(locale=@locales.EN).dummy(rng)
  assert_true(bs.contains(" "))
  let zh_catch_phrase = @company.catch_phrase(locale=@locales.ZH_CN).dummy(rng)
  assert_true(!zh_catch_phrase.is_empty())
  assert_true(!zh_catch_phrase.contains(" "))
}

///|
test "profession industry and suffix use migrated locale data where available" {
  let rng = @core.seed(b"company-fallback")
  assert_true(
    !@company.company_suffix(locale=@locales.FR_FR).dummy(rng).is_empty(),
  )
  assert_true(!@company.profession(locale=@locales.FR_FR).dummy(rng).is_empty())
  assert_true(!@company.industry(locale=@locales.FR_FR).dummy(rng).is_empty())
  assert_true(
    @company.company_name(locale=@locales.JA_JP)
    .dummy(@core.seed(b"company-ja-name"))
    .contains("株式会社") ||
    @company.company_name(locale=@locales.JA_JP)
    .dummy(@core.seed(b"company-ja-name"))
    .contains("(株)") ||
    @company.company_name(locale=@locales.JA_JP)
    .dummy(@core.seed(b"company-ja-name"))
    .contains("有限会社") ||
    @company.company_name(locale=@locales.JA_JP)
    .dummy(@core.seed(b"company-ja-name"))
    .contains("(有)"),
  )
}

///|
test "company generators are deterministic for the same seed" {
  let a = @company.catch_phrase(locale=@locales.ZH_CN).sample(
    count=8,
    @core.seed(b"company-determinism"),
  )
  let b = @company.catch_phrase(locale=@locales.ZH_CN).sample(
    count=8,
    @core.seed(b"company-determinism"),
  )
  @test.assert_eq(a, b)
}

///|
test "company fixed seed locale golden outputs" {
  let en_name = @company.company_name(locale=@locales.EN).dummy(
    @core.seed(b"company-golden-name-en"),
  )
  let en_catch = @company.catch_phrase(locale=@locales.EN).dummy(
    @core.seed(b"company-golden-catch-en"),
  )
  let en_bs = @company.bs(locale=@locales.EN).dummy(
    @core.seed(b"company-golden-bs-en"),
  )
  let zh_cn_name = @company.company_name(locale=@locales.ZH_CN).dummy(
    @core.seed(b"company-golden-name-cn"),
  )
  let zh_cn_catch = @company.catch_phrase(locale=@locales.ZH_CN).dummy(
    @core.seed(b"company-golden-catch-cn"),
  )
  let zh_cn_bs = @company.bs(locale=@locales.ZH_CN).dummy(
    @core.seed(b"company-golden-bs-cn"),
  )
  assert_true(en_name.contains(" "))
  assert_true(en_catch.contains(" "))
  assert_true(en_bs.contains(" "))
  assert_true(!zh_cn_name.contains(" "))
  assert_true(!zh_cn_catch.contains(" "))
  assert_true(!zh_cn_bs.contains(" "))
}

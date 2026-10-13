///|
fn count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
test "job title is composed from seniority field and position" {
  let title = @job.title(locale=@locales.EN).dummy(@core.seed(b"job-title"))
  assert_true(title.contains(" "))
  assert_true(count_char(title, ' ') >= 2)
}

///|
test "job pieces are non-empty across locale fallback" {
  let rng = @core.seed(b"job-pieces")
  assert_true(!@job.seniority(locale=@locales.ZH_CN).dummy(rng).is_empty())
  assert_true(!@job.field(locale=@locales.ZH_CN).dummy(rng).is_empty())
  assert_true(!@job.position(locale=@locales.ZH_CN).dummy(rng).is_empty())
  assert_true(!@job.title(locale=@locales.FR_FR).dummy(rng).is_empty())
  @test.assert_eq(
    @job.title(locale=@locales.FR_FR).dummy(@core.seed(b"job-fallback")),
    @job.title(locale=@locales.EN).dummy(@core.seed(b"job-fallback")),
  )
}

///|
test "job generators are deterministic for the same seed" {
  let a = @job.title(locale=@locales.ZH_CN).sample(
    count=8,
    @core.seed(b"job-determinism"),
  )
  let b = @job.title(locale=@locales.ZH_CN).sample(
    count=8,
    @core.seed(b"job-determinism"),
  )
  @test.assert_eq(a, b)
}

///|
test "job fixed seed locale golden outputs" {
  let en = @job.title(locale=@locales.EN).dummy(@core.seed(b"job-golden-en"))
  let zh_cn = @job.title(locale=@locales.ZH_CN).dummy(
    @core.seed(b"job-golden-cn"),
  )
  let zh_tw_seniority = @job.seniority(locale=@locales.ZH_TW).dummy(
    @core.seed(b"job-golden-tw-seniority"),
  )
  let zh_tw_field = @job.field(locale=@locales.ZH_TW).dummy(
    @core.seed(b"job-golden-tw-field"),
  )
  let zh_tw_position = @job.position(locale=@locales.ZH_TW).dummy(
    @core.seed(b"job-golden-tw-position"),
  )
  @test.assert_eq(count_char(en, ' '), 2)
  @test.assert_eq(count_char(zh_cn, ' '), 2)
  assert_true(!zh_tw_seniority.is_empty())
  assert_true(!zh_tw_field.is_empty())
  assert_true(!zh_tw_position.is_empty())
}

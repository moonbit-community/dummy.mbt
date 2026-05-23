///|
test "chrono date and time locale formats" {
  let en_time = @chrono.time(locale=@locales.EN).dummy(
    @core.seed(b"chrono-en-time"),
  )
  @test.assert_eq(en_time.length(), 18)
  @test.assert_eq(en_time.get_char(2), Some(':'))
  @test.assert_eq(en_time.get_char(5), Some(':'))
  @test.assert_eq(en_time.get_char(8), Some('.'))
  let en_date = @chrono.date(locale=@locales.EN).dummy(
    @core.seed(b"chrono-en-date"),
  )
  @test.assert_eq(en_date.length(), 10)
  @test.assert_eq(en_date.get_char(4), Some('-'))
  @test.assert_eq(en_date.get_char(7), Some('-'))
  let fa = @chrono.date(locale=@locales.FA_IR).dummy(
    @core.seed(b"chrono-fa-date"),
  )
  @test.assert_eq(fa.length(), 10)
  @test.assert_eq(fa.get_char(4), Some('/'))
  @test.assert_eq(fa.get_char(7), Some('/'))
  let it = @chrono.date(locale=@locales.IT_IT).dummy(
    @core.seed(b"chrono-it-date"),
  )
  @test.assert_eq(it.length(), 10)
  @test.assert_eq(it.get_char(2), Some('-'))
  @test.assert_eq(it.get_char(5), Some('-'))
  let tr = @chrono.date(locale=@locales.TR_TR).dummy(
    @core.seed(b"chrono-tr-date"),
  )
  @test.assert_eq(tr.length(), 10)
  @test.assert_eq(tr.get_char(2), Some('.'))
  @test.assert_eq(tr.get_char(5), Some('.'))
}

///|
test "chrono datetime locale formats" {
  let en = @chrono.date_time(locale=@locales.EN).dummy(
    @core.seed(b"chrono-en-dt"),
  )
  assert_true(en.contains("T"))
  assert_true(en.has_suffix("+00:00"))
  let fa = @chrono.date_time(locale=@locales.FA_IR).dummy(
    @core.seed(b"chrono-fa-dt"),
  )
  @test.assert_eq(fa.length(), 19)
  @test.assert_eq(fa.get_char(4), Some('/'))
  @test.assert_eq(fa.get_char(10), Some(' '))
  let it = @chrono.date_time(locale=@locales.IT_IT).dummy(
    @core.seed(b"chrono-it-dt"),
  )
  @test.assert_eq(it.length(), 19)
  @test.assert_eq(it.get_char(2), Some('-'))
  @test.assert_eq(it.get_char(10), Some(' '))
  let tr = @chrono.date_time(locale=@locales.TR_TR).dummy(
    @core.seed(b"chrono-tr-dt"),
  )
  @test.assert_eq(tr.length(), 19)
  @test.assert_eq(tr.get_char(2), Some('.'))
  @test.assert_eq(tr.get_char(10), Some(' '))
}

///|
test "chrono before after and between are deterministic" {
  let seed = b"chrono-determinism"
  @test.assert_eq(
    @chrono.duration().sample(count=8, @core.seed(seed)),
    @chrono.duration().sample(count=8, @core.seed(seed)),
  )
  @test.assert_eq(
    @chrono.date_time_before(anchor_minutes=1000).sample(
      count=4,
      @core.seed(seed),
    ),
    @chrono.date_time_before(anchor_minutes=1000).sample(
      count=4,
      @core.seed(seed),
    ),
  )
  @test.assert_eq(
    @chrono.date_time_after(anchor_minutes=1000).sample(
      count=4,
      @core.seed(seed),
    ),
    @chrono.date_time_after(anchor_minutes=1000).sample(
      count=4,
      @core.seed(seed),
    ),
  )
  @test.assert_eq(
    @chrono.date_time_between(10, 20).sample(count=4, @core.seed(seed)),
    @chrono.date_time_between(10, 20).sample(count=4, @core.seed(seed)),
  )
}

///|
test "chrono before after and between respect minute ranges" {
  let before = @chrono.date_time_before(
    anchor_minutes=24 * 60,
    locale=@locales.IT_IT,
  ).dummy(@core.seed(b"chrono-before"))
  let after = @chrono.date_time_after(anchor_minutes=0, locale=@locales.FA_IR).dummy(
    @core.seed(b"chrono-after"),
  )
  let between = @chrono.date_time_between(0, 1, locale=@locales.TR_TR).dummy(
    @core.seed(b"chrono-between"),
  )
  @test.assert_eq(before.length(), 19)
  @test.assert_eq(before.get_char(2), Some('-'))
  @test.assert_eq(after.length(), 19)
  @test.assert_eq(after.get_char(4), Some('/'))
  @test.assert_eq(between, "01.01.2000 00:00:45")
}

///|
test "chrono between rejects reversed range" {
  let bad : Result[@core.Gen[String], @core.DummyError] = try? @chrono.date_time_between(
    5, 5,
  )
  assert_true(bad is Err(@core.DummyError::InvalidRange(_)))
}

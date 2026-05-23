///|
fn expect_shape(value : String, shape : String) -> Unit raise {
  @test.assert_eq(value.length(), shape.length())
  for i in 0..<shape.length() {
    match shape.get_char(i) {
      Some('#') => {
        let ch = value.get_char(i)
        assert_true(ch >= Some('0') && ch <= Some('9'))
      }
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing shape character")
    }
  }
}

///|
test "time includes subsecond placeholder" {
  let value = @time.time().dummy(@core.seed(b"time-time"))
  expect_shape(value, "##:##:##.#########")
}

///|
test "date uses locale backed time date formats" {
  expect_shape(
    @time.date(locale=EN).dummy(@core.seed(b"time-en-date")),
    "####-##-##",
  )
  expect_shape(
    @time.date(locale=FA_IR).dummy(@core.seed(b"time-fa-date")),
    "####/##/##",
  )
  expect_shape(
    @time.date(locale=IT_IT).dummy(@core.seed(b"time-it-date")),
    "##-##-####",
  )
  expect_shape(
    @time.date(locale=NL_NL).dummy(@core.seed(b"time-nl-date")),
    "##-##-####",
  )
  expect_shape(
    @time.date(locale=PT_BR).dummy(@core.seed(b"time-pt-br-date")),
    "##/##/####",
  )
  expect_shape(
    @time.date(locale=PT_PT).dummy(@core.seed(b"time-pt-pt-date")),
    "##-##-####",
  )
  expect_shape(
    @time.date(locale=TR_TR).dummy(@core.seed(b"time-tr-date")),
    "##.##.####",
  )
}

///|
test "date_time uses locale backed time datetime formats" {
  expect_shape(
    @time.date_time(locale=EN).dummy(@core.seed(b"time-en-dt")),
    "####-##-##T##:##:##+0000",
  )
  expect_shape(
    @time.date_time(locale=FA_IR).dummy(@core.seed(b"time-fa-dt")),
    "####/##/## ##:##:##",
  )
  expect_shape(
    @time.date_time(locale=IT_IT).dummy(@core.seed(b"time-it-dt")),
    "##-##-#### ##:##:##",
  )
  expect_shape(
    @time.date_time(locale=NL_NL).dummy(@core.seed(b"time-nl-dt")),
    "##-##-#### ##:##:##",
  )
  expect_shape(
    @time.date_time(locale=PT_BR).dummy(@core.seed(b"time-pt-br-dt")),
    "##/##/####T##:##:##+0000",
  )
  expect_shape(
    @time.date_time(locale=PT_PT).dummy(@core.seed(b"time-pt-pt-dt")),
    "##-##-#### ##:##:##",
  )
  expect_shape(
    @time.date_time(locale=TR_TR).dummy(@core.seed(b"time-tr-dt")),
    "##.##.#### ##:##:##",
  )
}

///|
test "duration is deterministic and in the supported minute range" {
  let a = @time.duration().sample(count=16, @core.seed(b"time-duration"))
  let b = @time.duration().sample(count=16, @core.seed(b"time-duration"))
  @test.assert_eq(a, b)
  for value in a {
    assert_true(value >= 0 && value <= 366 * 1440)
  }
}

///|
test "before after and between are deterministic" {
  let before_a = @time.date_time_before(anchor_minutes=1000).sample(
    count=8,
    @core.seed(b"time-before"),
  )
  let before_b = @time.date_time_before(anchor_minutes=1000).sample(
    count=8,
    @core.seed(b"time-before"),
  )
  @test.assert_eq(before_a, before_b)
  let after_a = @time.date_time_after(anchor_minutes=1000).sample(
    count=8,
    @core.seed(b"time-after"),
  )
  let after_b = @time.date_time_after(anchor_minutes=1000).sample(
    count=8,
    @core.seed(b"time-after"),
  )
  @test.assert_eq(after_a, after_b)
  let between_a = @time.date_time_between(10, 20).sample(
    count=8,
    @core.seed(b"time-between"),
  )
  let between_b = @time.date_time_between(10, 20).sample(
    count=8,
    @core.seed(b"time-between"),
  )
  @test.assert_eq(between_a, between_b)
}

///|
test "between rejects reversed ranges" {
  try @time.date_time_between(20, 10) catch {
    error => assert_true(error is InvalidRange(_))
  } noraise {
    _ => fail("expected InvalidRange to be raised")
  }
}

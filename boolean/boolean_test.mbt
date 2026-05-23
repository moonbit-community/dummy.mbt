///|
test "boolean ratio boundaries match semantics" {
  let rng = @core.seed(b"boolean-boundaries")
  for value in @boolean.boolean(ratio=0).sample(count=16, rng) {
    assert_true(!value)
  }
  for value in @boolean.boolean(ratio=100).sample(count=16, rng) {
    assert_true(value)
  }
}

///|
test "boolean rejects ratios outside 0..100" {
  let low : Result[Bool, @core.DummyError] = try? @boolean.boolean(ratio=-1).dummy(
    @core.seed(b"boolean-low"),
  )
  assert_true(low is Err(@core.DummyError::InvalidRange(_)))
  let high : Result[Bool, @core.DummyError] = try? @boolean.boolean(ratio=101).dummy(
    @core.seed(b"boolean-high"),
  )
  assert_true(high is Err(@core.DummyError::InvalidRange(_)))
}

///|
test "boolean is deterministic for the same seed" {
  let a = @boolean.boolean(ratio=37).sample(
    count=16,
    @core.seed(b"boolean-determinism"),
  )
  let b = @boolean.boolean(ratio=37).sample(
    count=16,
    @core.seed(b"boolean-determinism"),
  )
  @test.assert_eq(a, b)
}

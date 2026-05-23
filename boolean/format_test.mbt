///|
test "data boolean ratio boundaries are preserved" {
  let rng = @core.seed(b"format-boolean")
  for value in @boolean.boolean(ratio=0).sample(count=32, rng) {
    assert_true(!value)
  }
  for value in @boolean.boolean(ratio=100).sample(count=32, rng) {
    assert_true(value)
  }
}

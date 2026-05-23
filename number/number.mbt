///|
/// Generate a decimal digit from 0 through 9.
pub fn digit() -> @core.Gen[Int] {
  @core.Gen::new(rng => rng.int(limit=10))
}

///|
/// Generate a decimal digit string from the `NUMBER_DIGIT` table.
pub fn digit_string() -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.number_digits(), rng))
}

///|
/// Generate a string by replacing `^` with 1-9 and `#` with 0-9.
pub fn number_with_format(fmt : String) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.numerify(fmt, rng))
}

///|
/// Generate an integer from a half-open range `[start, end)`.
pub fn int(
  range? : @core.IntRange = @core.int_range(0, 1000),
) -> @core.Gen[Int] {
  @core.Gen::new(rng => range.sample(rng))
}

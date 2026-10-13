///|
/// Half-open integer range used by integer fakers.
///
/// `start` is possible and `end` is excluded, matching MoonBit/random `limit`
/// semantics. The range is validated when sampled.
pub(all) struct IntRange {
  start : Int32
  end : Int32
} derive(Eq, Debug)

///|
/// Construct a half-open integer range `[start, end)`.
pub fn int_range(start : Int32, end : Int32) -> IntRange {
  { start, end, }
}

///|
/// Validate that `end` is greater than `start`.
pub fn IntRange::validate(self : IntRange) -> Unit raise DummyError {
  if self.end <= self.start {
    raise DummyError::InvalidRange(
      "expected end > start, got \{self.start}..\{self.end}",
    )
  }
}

///|
/// Sample an integer from `[start, end)`.
pub fn IntRange::sample(
  self : IntRange,
  rng : @random.Rand,
) -> Int32 raise DummyError {
  self.validate()
  self.start + rng.int(limit=self.end - self.start)
}

///|
/// Inclusive count range for lengths and collection sizes.
///
/// Counts must be non-negative. Both `min` and `max` are possible outputs.
pub(all) struct CountRange {
  min : Int32
  max : Int32
} derive(Eq, Debug)

///|
/// Construct an inclusive count range `[min, max]`.
pub fn count_range(min : Int32, max : Int32) -> CountRange {
  { min, max, }
}

///|
/// Validate that the count range is non-negative and ordered.
pub fn CountRange::validate(self : CountRange) -> Unit raise DummyError {
  if self.min < 0 || self.max < self.min {
    raise DummyError::InvalidRange(
      "expected 0 <= min <= max, got \{self.min}..\{self.max}",
    )
  }
}

///|
/// Sample a count from `[min, max]`.
pub fn CountRange::sample(
  self : CountRange,
  rng : @random.Rand,
) -> Int32 raise DummyError {
  self.validate()
  self.min + rng.int(limit=self.max - self.min + 1)
}

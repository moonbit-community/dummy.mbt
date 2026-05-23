///|
/// Generate `true` with `ratio` percent probability.
pub fn boolean(ratio? : Int = 50) -> @core.Gen[Bool] {
  @core.Gen::new(rng => @core.random_bool(ratio, rng))
}

///|
/// Normalize arbitrary seed bytes to the 32-byte ChaCha8 seed shape.
///
/// Bytes beyond 32 are ignored; missing bytes are filled with zero. This makes
/// short human-readable seeds convenient while keeping output deterministic.
pub fn normalize_seed(seed_bytes : Bytes) -> Bytes {
  Bytes::makei(32, i => {
    match seed_bytes.get(i) {
      Some(byte) => byte
      None => (0).to_byte()
    }
  })
}

///|
/// Create a deterministic ChaCha8 RNG from arbitrary seed bytes.
pub fn seed(seed_bytes : Bytes) -> @random.Rand {
  @random.Rand::chacha8(seed=normalize_seed(seed_bytes))
}

///|
/// Create the package default deterministic RNG.
pub fn default_seeded() -> @random.Rand {
  seed(b"moonbit-community/dummy/default")
}

///|
/// Sample an integer from a validated `IntRange`.
pub fn random_int(range : IntRange, rng : @random.Rand) -> Int raise DummyError {
  range.sample(rng)
}

///|
/// Sample a boolean that is true with `ratio` percent probability.
///
/// `ratio` must be in `0..=100`.
pub fn random_bool(ratio : Int, rng : @random.Rand) -> Bool raise DummyError {
  if ratio < 0 || ratio > 100 {
    raise DummyError::InvalidRange("boolean ratio must be in 0..100")
  }
  rng.int(limit=100) < ratio
}

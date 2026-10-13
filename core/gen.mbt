///|
/// Lazy dummy-data generator.
///
/// A `Gen[T]` stores generation logic and only consumes randomness when
/// `dummy` or `sample` is called.
pub(all) struct Gen[T] {
  run : (@random.Rand) -> T raise DummyError
}

///|
/// Create a generator from a function that consumes a shared RNG.
pub fn[T] Gen::new(run : (@random.Rand) -> T raise DummyError) -> Gen[T] {
  Gen::{ run, }
}

///|
/// Create a generator that always yields `value` without consuming randomness.
pub fn[T] Gen::pure(value : T) -> Gen[T] {
  Gen::new(_rng => value)
}

///|
/// Produce one value from the generator.
///
/// The supplied RNG is advanced in place, so repeated calls form a deterministic
/// sequence for a fixed seed.
pub fn[T] Gen::dummy(self : Gen[T], rng : @random.Rand) -> T raise DummyError {
  (self.run)(rng)
}

///|
/// Produce `count` values by repeatedly running the same generator.
///
/// Raises `DummyError::InvalidCount` when `count` is negative.
pub fn[T] Gen::sample(
  self : Gen[T],
  count~ : Int32,
  rng : @random.Rand,
) -> Array[T] raise DummyError {
  if count < 0 {
    raise DummyError::InvalidCount(count)
  }
  let out : Array[T] = []
  for _ in 0..<count {
    out.push(self.dummy(rng))
  }
  out
}

///|
/// Transform generated values without changing when randomness is consumed.
pub fn[T, U] Gen::map(self : Gen[T], f : (T) -> U) -> Gen[U] {
  Gen::new(rng => f(self.dummy(rng)))
}

///|
/// Build a dependent generator from each produced value.
///
/// The outer and inner generators share the same RNG so composition remains a
/// single reproducible sequence.
pub fn[T, U] Gen::flat_map(self : Gen[T], f : (T) -> Gen[U]) -> Gen[U] {
  Gen::new(rng => f(self.dummy(rng)).dummy(rng))
}

///|
/// Choose one generator uniformly from `items`.
///
/// Raises `DummyError::EmptyCandidates` if no candidates are supplied.
pub fn[T] one_of(items : ArrayView[Gen[T]]) -> Gen[T] raise DummyError {
  if items.length() == 0 {
    raise DummyError::EmptyCandidates("one_of")
  }
  Gen::new(rng => {
    let idx = rng.int(limit=items.length())
    items[idx].dummy(rng)
  })
}

///|
/// Choose one generator according to positive integer weights.
///
/// Weights less than or equal to zero are ignored. Raises if the list is empty
/// or if no candidate has a positive weight.
pub fn[T] weighted(
  items : ArrayView[(Int32, Gen[T])],
) -> Gen[T] raise DummyError {
  if items.length() == 0 {
    raise DummyError::EmptyCandidates("weighted")
  }
  let total = items.fold(init=0, (acc, item) => {
    let (weight, _) = item
    if weight > 0 {
      acc + weight
    } else {
      acc
    }
  })
  if total <= 0 {
    raise DummyError::InvalidRange(
      "weighted requires at least one positive weight",
    )
  }
  Gen::new(rng => {
    let target = rng.int(limit=total)
    let mut running = 0
    for item in items {
      let (weight, candidate) = item
      if weight > 0 {
        running += weight
        if target < running {
          return candidate.dummy(rng)
        }
      }
    }
    items[items.length() - 1].1.dummy(rng)
  })
}

///|
/// Trait for project-specific default fake values.
///
/// Implement this when a type should have a natural default generator, then call
/// `Type::dummy_default(rng)` directly or compose it inside a `Gen`.
pub(open) trait DummyDefault {
  fn dummy_default(@random.Rand) -> Self raise DummyError
}

///|
/// Default boolean generator with equal true/false probability.
pub impl DummyDefault for Bool with fn dummy_default(rng) {
  rng.boolean()
}

///|
/// Default integer generator from the core random source.
pub impl DummyDefault for Int32 with fn dummy_default(rng) {
  rng.int()
}

///|
/// Default ASCII string generator with length 4 through 10.
pub impl DummyDefault for String with fn dummy_default(rng) {
  let len = CountRange::{ min: 4, max: 10, }.sample(rng)
  random_ascii(len, rng)
}

///|
/// Default optional generator: choose `Some` or `None` with equal probability.
pub impl[T : DummyDefault] DummyDefault for T? with fn dummy_default(rng) {
  if rng.boolean() {
    Some(T::dummy_default(rng))
  } else {
    None
  }
}

///|
/// Default array generator with length 0 through 4.
pub impl[T : DummyDefault] DummyDefault for Array[T] with fn dummy_default(rng) {
  let len = CountRange::{ min: 0, max: 4, }.sample(rng)
  Array::makei(len, _ => T::dummy_default(rng))
}

///|
/// Default result generator: choose `Ok` or `Err` with equal probability.
pub impl[T : DummyDefault, E : DummyDefault] DummyDefault for Result[T, E] with fn dummy_default(
  rng,
) {
  if rng.boolean() {
    Ok(T::dummy_default(rng))
  } else {
    Err(E::dummy_default(rng))
  }
}

///|
/// Default pair generator that samples both elements from the same RNG.
pub impl[A : DummyDefault, B : DummyDefault] DummyDefault for (A, B) with fn dummy_default(
  rng,
) {
  (A::dummy_default(rng), B::dummy_default(rng))
}

///|
/// Default triple generator that samples all elements from the same RNG.
pub impl[A : DummyDefault, B : DummyDefault, C : DummyDefault] DummyDefault for (
  A,
  B,
  C,
) with fn dummy_default(rng) {
  (A::dummy_default(rng), B::dummy_default(rng), C::dummy_default(rng))
}

///|
/// Default four-tuple generator that samples all elements from the same RNG.
pub impl[A : DummyDefault, B : DummyDefault, C : DummyDefault, D : DummyDefault] DummyDefault for (
  A,
  B,
  C,
  D,
) with fn dummy_default(rng) {
  (
    A::dummy_default(rng),
    B::dummy_default(rng),
    C::dummy_default(rng),
    D::dummy_default(rng),
  )
}

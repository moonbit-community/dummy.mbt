///|
test "seed is deterministic after normalization" {
  let rng1 = seed(b"same-seed")
  let rng2 = seed(b"same-seed")
  let a = pick_string(["alpha", "beta", "gamma"], rng1)
  let b = pick_string(["alpha", "beta", "gamma"], rng2)
  @test.assert_eq(a, b)
}

///|
test "range validation rejects empty ranges" {
  let rng = default_seeded()
  let result : Result[Int32, DummyError] = try? int_range(3, 3).sample(rng)
  assert_true(result is Err(DummyError::InvalidRange(_)))
}

///|
test "sample length and weighted generation" {
  let rng = default_seeded()
  let gen = weighted([(1, Gen::pure("a")), (3, Gen::pure("b"))])
  let values = gen.sample(count=5, rng)
  @test.assert_eq(values.length(), 5)
}

///|
test "empty candidates report an explicit error" {
  let rng = default_seeded()
  let result : Result[String, DummyError] = try? pick_string([], rng)
  assert_true(result is Err(DummyError::EmptyCandidates(_)))
}

///|
fn[T : DummyDefault] dummy_default_sequence(
  seed_bytes : Bytes,
  count : Int32,
) -> Array[T] raise DummyError {
  let rng = seed(seed_bytes)
  Array::makei(count, _ => T::dummy_default(rng))
}

///|
fn[T] gen_sequence(
  gen : Gen[T],
  seed_bytes : Bytes,
  count : Int32,
) -> Array[T] raise DummyError {
  gen.sample(count~, seed(seed_bytes))
}

///|
test "style seed reproducibility keeps full sample order" {
  let gen = Gen::new(rng => {
    let label = pick_string(["alpha", "beta", "gamma", "delta"], rng)
    let value = int_range(10, 99).sample(rng)
    "\{label}:\{value}"
  })
  let left = gen_sequence(gen, b"compat-order-seed", 16)
  let right = gen_sequence(gen, b"compat-order-seed", 16)
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 16)
}

///|
test "sample preserves requested length and generator order" {
  let mut next = 0
  let gen = Gen::new(_rng => {
    next += 1
    next
  })
  let values = gen.sample(count=5, default_seeded())
  @test.assert_eq(values, [1, 2, 3, 4, 5])
}

///|
test "one_of reports empty input and handles singleton input" {
  let rng = default_seeded()
  let empty : Result[Gen[String], DummyError] = try? one_of([])
  assert_true(empty is Err(DummyError::EmptyCandidates("one_of")))
  let only = one_of([Gen::pure("only")]).dummy(rng)
  @test.assert_eq(only, "only")
}

///|
test "weighted rejects empty and non-positive totals" {
  let empty : Result[Gen[String], DummyError] = try? weighted([])
  assert_true(empty is Err(DummyError::EmptyCandidates("weighted")))
  let zero : Result[Gen[String], DummyError] = try? weighted([
    (0, Gen::pure("zero")),
    (-2, Gen::pure("negative")),
  ])
  assert_true(zero is Err(DummyError::InvalidRange(_)))
}

///|
test "weighted ignores non-positive candidates and keeps deterministic order" {
  let gen = weighted([
    (0, Gen::pure("zero")),
    (-3, Gen::pure("negative")),
    (5, Gen::pure("positive")),
  ])
  let left = gen_sequence(gen, b"compat-weighted-single-positive", 12)
  let right = gen_sequence(gen, b"compat-weighted-single-positive", 12)
  @test.assert_eq(left, right)
  @test.assert_eq(left, [
    "positive", "positive", "positive", "positive", "positive", "positive", "positive",
    "positive", "positive", "positive", "positive", "positive",
  ])
}

///|
test "DummyDefault Bool Int String Option Array Result and tuples are seed-stable" {
  let seed_bytes = b"compat-std-impl-dummy-default"
  let bools : Array[Bool] = dummy_default_sequence(seed_bytes, 12)
  let bools_again : Array[Bool] = dummy_default_sequence(seed_bytes, 12)
  @test.assert_eq(bools, bools_again)
  let ints : Array[Int32] = dummy_default_sequence(seed_bytes, 12)
  let ints_again : Array[Int32] = dummy_default_sequence(seed_bytes, 12)
  @test.assert_eq(ints, ints_again)
  let strings : Array[String] = dummy_default_sequence(seed_bytes, 12)
  let strings_again : Array[String] = dummy_default_sequence(seed_bytes, 12)
  @test.assert_eq(strings, strings_again)
  for text in strings {
    assert_true(text.length() >= 4 && text.length() <= 10)
  }
  let options : Array[Int32?] = dummy_default_sequence(seed_bytes, 12)
  let options_again : Array[Int32?] = dummy_default_sequence(seed_bytes, 12)
  @test.assert_eq(options, options_again)
  let arrays : Array[Array[Int32]] = dummy_default_sequence(seed_bytes, 8)
  let arrays_again : Array[Array[Int32]] = dummy_default_sequence(seed_bytes, 8)
  @test.assert_eq(arrays, arrays_again)
  for values in arrays {
    assert_true(values.length() >= 0 && values.length() <= 4)
  }
  let results : Array[Result[Int32, String]] = dummy_default_sequence(
    seed_bytes, 12,
  )
  let results_again : Array[Result[Int32, String]] = dummy_default_sequence(
    seed_bytes, 12,
  )
  @test.assert_eq(results, results_again)
  let pairs : Array[(Bool, Int32)] = dummy_default_sequence(seed_bytes, 12)
  let pairs_again : Array[(Bool, Int32)] = dummy_default_sequence(
    seed_bytes, 12,
  )
  @test.assert_eq(pairs, pairs_again)
  let triples : Array[(Bool, Int32, String)] = dummy_default_sequence(
    seed_bytes, 8,
  )
  let triples_again : Array[(Bool, Int32, String)] = dummy_default_sequence(
    seed_bytes, 8,
  )
  @test.assert_eq(triples, triples_again)
  let quads : Array[(Bool, Int32, String, Int32?)] = dummy_default_sequence(
    seed_bytes, 6,
  )
  let quads_again : Array[(Bool, Int32, String, Int32?)] = dummy_default_sequence(
    seed_bytes, 6,
  )
  @test.assert_eq(quads, quads_again)
}

///|
test "DummyDefault nested Option Array sequence is reproducible" {
  let left : Array[Array[String]?] = dummy_default_sequence(
    b"compat-nested-std-impl", 10,
  )
  let right : Array[Array[String]?] = dummy_default_sequence(
    b"compat-nested-std-impl", 10,
  )
  @test.assert_eq(left, right)
}

///|
fn is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn dimensions_are_in_compat_range(url : String) -> Bool {
  let mut prev_number = -1
  let mut last_number = -1
  let mut in_number = false
  let mut value = 0
  for ch in url {
    if ch == '?' {
      if in_number {
        prev_number = last_number
        last_number = value
      }
      return prev_number >= 100 &&
        prev_number <= 800 &&
        last_number >= 100 &&
        last_number <= 800
    } else if is_digit(ch) {
      in_number = true
      value = value * 10 + ch.to_int() - '0'.to_int()
    } else if in_number {
      prev_number = last_number
      last_number = value
      in_number = false
      value = 0
    }
  }
  if in_number {
    prev_number = last_number
    last_number = value
  }
  prev_number >= 100 &&
  prev_number <= 800 &&
  last_number >= 100 &&
  last_number <= 800
}

///|
fn blur_param_is_in_compat_range(url : String) -> Bool {
  let mut after_equals = false
  let mut digits = 0
  let mut value = 0
  for ch in url {
    if after_equals {
      if is_digit(ch) {
        value = value * 10 + ch.to_int() - '0'.to_int()
        digits += 1
      } else {
        return false
      }
    } else if ch == '=' {
      after_equals = true
    }
  }
  after_equals && digits > 0 && value >= 1 && value <= 10
}

///|
fn seed_segment_is_decimal(url : String) -> Bool {
  match url[:].strip_prefix("https://picsum.photos/seed/") {
    Some(rest) =>
      match rest.split_once("/") {
        Some((seed, _tail)) =>
          !seed.is_empty() &&
          seed.fold(init=true, (ok, ch) => ok && is_digit(ch))
        None => false
      }
    None => false
  }
}

///|
test "image urls use picsum dimensions" {
  let values = @picsum.image().sample(count=16, @core.seed(b"picsum-image"))
  for value in values {
    assert_true(value.has_prefix("https://picsum.photos/"))
    assert_true(!value.contains("?"))
    assert_true(!value.contains("/seed/"))
    assert_true(dimensions_are_in_compat_range(value))
  }
}

///|
test "seeded and filtered image urls use expected query shapes" {
  let rng = @core.seed(b"picsum-variants")
  let seeded = @picsum.image_with_seed().dummy(rng)
  assert_true(seeded.has_prefix("https://picsum.photos/seed/"))
  assert_true(seed_segment_is_decimal(seeded))
  assert_true(dimensions_are_in_compat_range(seeded))
  let grayscale = @picsum.image_grayscale().dummy(rng)
  assert_true(grayscale.has_prefix("https://picsum.photos/"))
  assert_true(grayscale.has_suffix("?grayscale"))
  assert_true(dimensions_are_in_compat_range(grayscale))
  let blur = @picsum.image_blur().dummy(rng)
  assert_true(blur.has_prefix("https://picsum.photos/"))
  assert_true(blur.contains("?blur="))
  assert_true(dimensions_are_in_compat_range(blur))
  assert_true(blur_param_is_in_compat_range(blur))
}

///|
test "image_custom renders exact dimensions seed and params" {
  let url = @picsum.image_custom({
    width: 320,
    height: 240,
    grayscale: true,
    blur: Some(4),
    seed: Some("demo"),
  }).dummy(@core.seed(b"picsum-custom"))
  @test.assert_eq(
    url, "https://picsum.photos/seed/demo/320/240?grayscale&blur=4",
  )
}

///|
test "image_custom omits query string when no options request params" {
  let url = @picsum.image_custom({
    width: 640,
    height: 480,
    grayscale: false,
    blur: None,
    seed: None,
  }).dummy(@core.seed(b"picsum-custom-plain"))
  @test.assert_eq(url, "https://picsum.photos/640/480")
}

///|
test "image_custom keeps seed path before query parameters" {
  let url = @picsum.image_custom({
    width: 800,
    height: 600,
    grayscale: true,
    blur: None,
    seed: Some("abc123"),
  }).dummy(@core.seed(b"picsum-custom-seeded"))
  @test.assert_eq(url, "https://picsum.photos/seed/abc123/800/600?grayscale")
}

///|
test "image_custom rejects invalid options" {
  try
    @picsum.image_custom({
      width: 0,
      height: 240,
      grayscale: false,
      blur: None,
      seed: None,
    }).dummy(@core.seed(b"picsum-bad-size"))
  catch {
    error => assert_true(error is InvalidRange(_))
  } noraise {
    _ => fail("expected InvalidRange to be raised")
  }
  try
    @picsum.image_custom({
      width: 320,
      height: 240,
      grayscale: false,
      blur: Some(11),
      seed: None,
    }).dummy(@core.seed(b"picsum-bad-blur"))
  catch {
    error => assert_true(error is InvalidRange(_))
  } noraise {
    _ => fail("expected InvalidRange to be raised")
  }
}

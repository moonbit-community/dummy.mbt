///|
/// Pick one item uniformly from a non-empty array view.
pub fn[T] pick(items : ArrayView[T], rng : @random.Rand) -> T raise DummyError {
  if items.length() == 0 {
    raise DummyError::EmptyCandidates("pick")
  }
  items[rng.int(limit=items.length())]
}

///|
/// Pick one string uniformly from a non-empty array view.
pub fn pick_string(
  items : ArrayView[String],
  rng : @random.Rand,
) -> String raise DummyError {
  pick(items, rng)
}

///|
/// Render an style template by replacing token strings with values.
///
/// Tokens are literal strings such as `{FirstName}`. Replacement is sequential,
/// so callers should avoid overlapping token names.
pub fn render_template(
  template : String,
  pairs : ArrayView[(String, String)],
) -> String {
  let mut out = template
  for item in pairs {
    let (key, value) = item
    out = out.replace_all(old=key, new=value)
  }
  out
}

///|
/// Apply number formatting rules.
///
/// `#` becomes a digit from 0 through 9, `^` becomes a digit from 1 through 9,
/// and every other character is copied unchanged.
pub fn numerify(pattern : String, rng : @random.Rand) -> String {
  let out = StringBuilder::new(size_hint=pattern.length())
  for ch in pattern {
    match ch {
      '#' => out.write_string(rng.int(limit=10).to_string())
      '^' => out.write_string((rng.int(limit=9) + 1).to_string())
      _ => out.write_char(ch)
    }
  }
  out.to_string()
}

///|
/// Pick `count` strings from `items`, preserving sample order.
pub fn repeat_pick(
  items : ArrayView[String],
  count : Int32,
  rng : @random.Rand,
) -> Array[String] raise DummyError {
  if count < 0 {
    raise DummyError::InvalidCount(count)
  }
  let out : Array[String] = []
  for _ in 0..<count {
    out.push(pick_string(items, rng))
  }
  out
}

///|
/// Join strings with `sep`.
///
/// This small wrapper keeps call sites independent from concrete array/view
/// conversions.
pub fn join_strings(items : ArrayView[String], sep : String) -> String {
  items.to_owned().join(sep)
}

///|
/// Generate a lowercase ASCII string of length `len`.
pub fn random_ascii(len : Int32, rng : @random.Rand) -> String raise DummyError {
  if len < 0 {
    raise DummyError::InvalidCount(len)
  }
  let chars : Array[String] = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
    "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
  ]
  let out = StringBuilder::new(size_hint=len)
  for _ in 0..<len {
    out.write_string(pick_string(chars, rng))
  }
  out.to_string()
}

///|
/// Generate a decimal digit string of length `len`.
pub fn random_digit_string(
  len : Int32,
  rng : @random.Rand,
) -> String raise DummyError {
  if len < 0 {
    raise DummyError::InvalidCount(len)
  }
  let out = StringBuilder::new(size_hint=len)
  for _ in 0..<len {
    out.write_string(rng.int(limit=10).to_string())
  }
  out.to_string()
}

///|
/// Left-pad `value` with `pad` until it reaches `width` code units.
pub fn pad_left(value : String, width : Int32, pad : Char) -> String {
  if value.length() >= width {
    value
  } else {
    let out = StringBuilder::new(size_hint=width)
    for _ in value.length()..<width {
      out.write_char(pad)
    }
    out.write_string(value)
    out.to_string()
  }
}

///|
/// Render an integer as a two-character uppercase hexadecimal byte.
pub fn hex_byte(value : Int32) -> String {
  pad_left(value.to_string(radix=16).to_upper(), 2, '0')
}

///|
/// Render an integer as a four-character uppercase hexadecimal word.
pub fn hex_u16(value : Int32) -> String {
  pad_left(value.to_string(radix=16).to_upper(), 4, '0')
}

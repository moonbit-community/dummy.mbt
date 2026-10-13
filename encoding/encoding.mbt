///|
// Standard RFC 4648 base64 alphabet.
fn standard_base64_chars() -> Array[String] {
  [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
    "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
    "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/",
  ]
}

///|
// URL-safe RFC 4648 base64 alphabet.
fn url_safe_base64_chars() -> Array[String] {
  [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
    "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
    "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "_",
  ]
}

///|
// Random byte values represented as Int for simple bit arithmetic.
fn random_bytes(len : Int32, rng : @random.Rand) -> Array[Int32] {
  Array::makei(len, _ => rng.int(limit=256))
}

///|
// Write one 24-bit block as four base64 characters.
fn write_base64_quad(
  out : StringBuilder,
  chars : ArrayView[String],
  a : Int32,
  b : Int32,
  c : Int32,
) -> Unit {
  let triple = a * 65536 + b * 256 + c
  out.write_string(chars[triple / 262144])
  out.write_string(chars[triple / 4096 % 64])
  out.write_string(chars[triple / 64 % 64])
  out.write_string(chars[triple % 64])
}

///|
// Encode bytes with the supplied alphabet. Padding can be disabled to model
// the no-pad variants.
fn encode_base64(
  bytes : ArrayView[Int32],
  chars : ArrayView[String],
  padding : Bool,
) -> String {
  let out = StringBuilder(size_hint=(bytes.length() + 2) / 3 * 4)
  let full = bytes.length() / 3
  for block in 0..<full {
    let i = block * 3
    write_base64_quad(out, chars, bytes[i], bytes[i + 1], bytes[i + 2])
  }
  let rem = bytes.length() % 3
  if rem == 1 {
    let a = bytes[bytes.length() - 1]
    let triple = a * 65536
    out.write_string(chars[triple / 262144])
    out.write_string(chars[triple / 4096 % 64])
    if padding {
      out.write_string("==")
    }
  } else if rem == 2 {
    let a = bytes[bytes.length() - 2]
    let b = bytes[bytes.length() - 1]
    let triple = a * 65536 + b * 256
    out.write_string(chars[triple / 262144])
    out.write_string(chars[triple / 4096 % 64])
    out.write_string(chars[triple / 64 % 64])
    if padding {
      out.write_string("=")
    }
  }
  out.to_string()
}

///|
// Generate a random byte string and encode it using the requested alphabet and
// padding mode.
fn base64_string(url_safe : Bool, padding : Bool, rng : @random.Rand) -> String {
  let chars = if url_safe {
    url_safe_base64_chars()
  } else {
    standard_base64_chars()
  }
  let len = rng.int(limit=10)
  encode_base64(random_bytes(len, rng), chars, padding)
}

///|
/// Generate a standard base64 string, randomly choosing padded or unpadded form.
pub fn base64() -> @core.Gen[String] {
  @core.Gen::new(rng => base64_string(false, rng.boolean(), rng))
}

///|
/// Generate a standard base64 string with `=` padding.
pub fn base64_padded() -> @core.Gen[String] {
  @core.Gen::new(rng => base64_string(false, true, rng))
}

///|
/// Generate a standard base64 string without `=` padding.
pub fn base64_no_pad() -> @core.Gen[String] {
  @core.Gen::new(rng => base64_string(false, false, rng))
}

///|
/// Generate a URL-safe base64 string, randomly choosing padded or unpadded form.
pub fn url_safe_base64() -> @core.Gen[String] {
  @core.Gen::new(rng => base64_string(true, rng.boolean(), rng))
}

///|
/// Generate a URL-safe base64 string with `=` padding.
pub fn url_safe_base64_padded() -> @core.Gen[String] {
  @core.Gen::new(rng => base64_string(true, true, rng))
}

///|
/// Generate a URL-safe base64 string without `=` padding.
pub fn url_safe_base64_no_pad() -> @core.Gen[String] {
  @core.Gen::new(rng => base64_string(true, false, rng))
}

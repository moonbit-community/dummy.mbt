///|
// Lowercase hexadecimal alphabet for UUID and ObjectId strings.
fn lower_hex_chars() -> Array[String] {
  [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f",
  ]
}

///|
// Generate `len` lowercase hexadecimal characters.
fn random_hex(len : Int32, rng : @random.Rand) -> String raise @core.DummyError {
  let out = StringBuilder::new(size_hint=len)
  let chars = lower_hex_chars()
  for _ in 0..<len {
    out.write_string(@core.pick_string(chars, rng))
  }
  out.to_string()
}

///|
// UUID variant nibble for RFC 4122-like strings.
fn uuid_variant_char(rng : @random.Rand) -> String raise @core.DummyError {
  @core.pick_string(["8", "9", "a", "b"], rng)
}

///|
// Render a UUID string, optionally forcing the version nibble.
fn uuid_string(
  version : String?,
  rng : @random.Rand,
) -> String raise @core.DummyError {
  let group3 = match version {
    Some(v) => v + random_hex(3, rng)
    None => random_hex(4, rng)
  }
  random_hex(8, rng) +
  "-" +
  random_hex(4, rng) +
  "-" +
  group3 +
  "-" +
  uuid_variant_char(rng) +
  random_hex(3, rng) +
  "-" +
  random_hex(12, rng)
}

///|
// Build a generator for a specific UUID version nibble.
fn uuid_version(version : String) -> @core.Gen[String] {
  @core.Gen::new(rng => uuid_string(Some(version), rng))
}

///|
/// Generate a UUID string.
pub fn uuid() -> @core.Gen[String] {
  @core.Gen::new(rng => uuid_string(None, rng))
}

///|
/// Generate a UUID string with version marker `1`.
pub fn uuid_v1() -> @core.Gen[String] {
  uuid_version("1")
}

///|
/// Generate a UUID string with version marker `3`.
pub fn uuid_v3() -> @core.Gen[String] {
  uuid_version("3")
}

///|
/// Generate a UUID string with version marker `4`.
pub fn uuid_v4() -> @core.Gen[String] {
  uuid_version("4")
}

///|
/// Generate a UUID string with version marker `5`.
pub fn uuid_v5() -> @core.Gen[String] {
  uuid_version("5")
}

///|
/// Generate a UUID string with version marker `6`.
pub fn uuid_v6() -> @core.Gen[String] {
  uuid_version("6")
}

///|
/// Generate a UUID string with version marker `7`.
pub fn uuid_v7() -> @core.Gen[String] {
  uuid_version("7")
}

///|
/// Generate a UUID string with version marker `8`.
pub fn uuid_v8() -> @core.Gen[String] {
  uuid_version("8")
}

///|
// First ULID character is constrained so the 128-bit value stays in range.
fn ulid_first_chars() -> Array[String] {
  ["0", "1", "2", "3", "4", "5", "6", "7"]
}

///|
// Crockford base32 alphabet used by ULID.
fn ulid_chars() -> Array[String] {
  [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
    "G", "H", "J", "K", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z",
  ]
}

///|
/// Generate a 26-character ULID string.
pub fn ulid() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let out = StringBuilder::new(size_hint=26)
    out.write_string(@core.pick_string(ulid_first_chars(), rng))
    let chars = ulid_chars()
    for _ in 1..<26 {
      out.write_string(@core.pick_string(chars, rng))
    }
    out.to_string()
  })
}

///|
/// Generate a 24-character BSON ObjectId string.
pub fn bson_object_id() -> @core.Gen[String] {
  @core.Gen::new(rng => random_hex(24, rng))
}

///|
/// Alias for `bson_object_id`.
pub fn bson_oid() -> @core.Gen[String] {
  bson_object_id()
}

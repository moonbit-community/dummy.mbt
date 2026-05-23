///|
fn compat_identifier_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_identifier_is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  compat_identifier_is_digit(ch) ||
  (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn compat_identifier_uuid(value : String, version : Char?) -> Bool {
  if value.length() != 36 ||
    value.get_char(8) != Some('-') ||
    value.get_char(13) != Some('-') ||
    value.get_char(18) != Some('-') ||
    value.get_char(23) != Some('-') {
    return false
  }
  match version {
    Some(v) => if value.get_char(14) != Some(v) { return false }
    None => ()
  }
  for i in 0..<value.length() {
    match value.get_char(i) {
      Some('-') => ()
      Some(ch) => if !compat_identifier_is_lower_hex(ch) { return false }
      None => return false
    }
  }
  true
}

///|
fn compat_identifier_valid_ulid(value : String) -> Bool {
  if value.length() != 26 {
    return false
  }
  for ch in value {
    let code = ch.to_int()
    if !((code >= '0'.to_int() && code <= '9'.to_int()) ||
      (code >= 'A'.to_int() && code <= 'Z'.to_int())) {
      return false
    }
  }
  true
}

///|
fn compat_identifier_valid_oid(value : String) -> Bool {
  if value.length() != 24 {
    return false
  }
  for ch in value {
    if !compat_identifier_is_lower_hex(ch) {
      return false
    }
  }
  true
}

///|
test "data identifier formats keep typed versions" {
  let rng = @core.seed(b"format-identifiers")
  assert_true(compat_identifier_uuid(@identifier.uuid().dummy(rng), None))
  for
    item in [
      (@identifier.uuid_v1(), '1'),
      (@identifier.uuid_v3(), '3'),
      (@identifier.uuid_v4(), '4'),
      (@identifier.uuid_v5(), '5'),
      (@identifier.uuid_v6(), '6'),
      (@identifier.uuid_v7(), '7'),
      (@identifier.uuid_v8(), '8'),
    ] {
    let (gen, version) = item
    for value in gen.sample(count=8, rng) {
      assert_true(compat_identifier_uuid(value, Some(version)))
    }
  }
  for value in @identifier.ulid().sample(count=16, rng) {
    assert_true(compat_identifier_valid_ulid(value))
  }
  for value in @identifier.bson_oid().sample(count=16, rng) {
    assert_true(compat_identifier_valid_oid(value))
  }
}

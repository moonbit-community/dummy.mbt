///|
fn is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  is_digit(ch) || (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn is_uuid_variant(ch : Char) -> Bool {
  ch == '8' || ch == '9' || ch == 'a' || ch == 'b'
}

///|
fn is_ulid_char(ch : Char) -> Bool {
  for
    candidate in [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
      'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X',
      'Y', 'Z',
    ] {
    if ch == candidate {
      return true
    }
  }
  false
}

///|
fn char_at_is(s : String, i : Int, pred : (Char) -> Bool) -> Bool {
  match s.get_char(i) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn valid_uuid(s : String, version : Char?) -> Bool {
  if s.length() != 36 ||
    s.get_char(8) != Some('-') ||
    s.get_char(13) != Some('-') ||
    s.get_char(18) != Some('-') ||
    s.get_char(23) != Some('-') ||
    !char_at_is(s, 19, is_uuid_variant) {
    return false
  }
  match version {
    Some(v) => if s.get_char(14) != Some(v) { return false }
    None => ()
  }
  for i in 0..<36 {
    if i != 8 && i != 13 && i != 18 && i != 23 {
      if !char_at_is(s, i, is_lower_hex) {
        return false
      }
    }
  }
  true
}

///|
fn valid_ulid(s : String) -> Bool {
  if s.length() != 26 {
    return false
  }
  match s.get_char(0) {
    Some(ch) => {
      let code = ch.to_int()
      if !(code >= '0'.to_int() && code <= '7'.to_int()) {
        return false
      }
    }
    None => return false
  }
  for ch in s {
    if !is_ulid_char(ch) {
      return false
    }
  }
  true
}

///|
fn valid_object_id(s : String) -> Bool {
  if s.length() != 24 {
    return false
  }
  for ch in s {
    if !is_lower_hex(ch) {
      return false
    }
  }
  true
}

///|
test "uuid string replacements keep hyphenated shapes" {
  let rng = @core.seed(b"identifier-uuid")
  assert_true(valid_uuid(@identifier.uuid().dummy(rng), None))
  assert_true(valid_uuid(@identifier.uuid_v1().dummy(rng), Some('1')))
  assert_true(valid_uuid(@identifier.uuid_v3().dummy(rng), Some('3')))
  assert_true(valid_uuid(@identifier.uuid_v4().dummy(rng), Some('4')))
  assert_true(valid_uuid(@identifier.uuid_v5().dummy(rng), Some('5')))
  assert_true(valid_uuid(@identifier.uuid_v6().dummy(rng), Some('6')))
  assert_true(valid_uuid(@identifier.uuid_v7().dummy(rng), Some('7')))
  assert_true(valid_uuid(@identifier.uuid_v8().dummy(rng), Some('8')))
}

///|
test "ulid and bson oid string replacements keep shapes" {
  let rng = @core.seed(b"identifier-extra")
  for value in @identifier.ulid().sample(count=16, rng) {
    assert_true(valid_ulid(value))
  }
  for value in @identifier.bson_oid().sample(count=16, rng) {
    assert_true(valid_object_id(value))
  }
}

///|
test "identifier generators are deterministic for the same seed" {
  let seed = b"identifier-determinism"
  @test.assert_eq(
    @identifier.uuid_v4().sample(count=8, @core.seed(seed)),
    @identifier.uuid_v4().sample(count=8, @core.seed(seed)),
  )
  @test.assert_eq(
    @identifier.ulid().sample(count=8, @core.seed(seed)),
    @identifier.ulid().sample(count=8, @core.seed(seed)),
  )
  @test.assert_eq(
    @identifier.bson_object_id().sample(count=8, @core.seed(seed)),
    @identifier.bson_object_id().sample(count=8, @core.seed(seed)),
  )
}

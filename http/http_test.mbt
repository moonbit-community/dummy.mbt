///|
fn is_known_method(value : String) -> Bool {
  value == "GET" ||
  value == "POST" ||
  value == "PUT" ||
  value == "PATCH" ||
  value == "DELETE" ||
  value == "HEAD" ||
  value == "OPTIONS" ||
  value == "CONNECT" ||
  value == "TRACE"
}

///|
fn contains_int(items : ArrayView[Int], value : Int) -> Bool {
  for item in items {
    if item == value {
      return true
    }
  }
  false
}

///|
fn compat_5_1_0_rfc_status_codes() -> Array[Int] {
  [
    100, 101, 102, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302,
    303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410,
    411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 426, 428, 429, 431,
    451, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511,
  ]
}

///|
fn is_rfc_status_code(value : Int) -> Bool {
  contains_int(compat_5_1_0_rfc_status_codes(), value)
}

///|
fn is_all_upper_ascii(value : String) -> Bool {
  for ch in value {
    let code = ch.to_int()
    if code < 'A'.to_int() || code > 'Z'.to_int() {
      return false
    }
  }
  true
}

///|
test "valid_status_code stays in HTTP status code range" {
  let values = @http.valid_status_code().sample(
    count=32,
    @core.seed(b"http-valid"),
  )
  for value in values {
    assert_true(value >= 100 && value < 600)
  }
}

///|
test "rfc_status_code stays in HTTP status code range" {
  let values = @http.rfc_status_code().sample(count=32, @core.seed(b"http-rfc"))
  for value in values {
    assert_true(value >= 100 && value < 600)
    assert_true(is_rfc_status_code(value))
  }
}

///|
test "rfc_status_code samples 5.1.0 RFC status set" {
  let values = @http.rfc_status_code().sample(
    count=4096,
    @core.seed(b"http-rfc-compat-5-1-0"),
  )
  for value in values {
    assert_true(is_rfc_status_code(value))
    assert_true(value != 103)
    assert_true(value != 425)
  }
  for value in compat_5_1_0_rfc_status_codes() {
    assert_true(contains_int(values, value))
  }
}

///|
test "http_method uses standard uppercase methods" {
  let values = @http.http_method().sample(count=16, @core.seed(b"http-method"))
  for value in values {
    assert_true(is_known_method(value))
    assert_true(is_all_upper_ascii(value))
  }
}

///|
test "http method samples cover safe idempotent and entity methods" {
  let values = @http.http_method().sample(
    count=128,
    @core.seed(b"http-method-coverage"),
  )
  let mut saw_get = false
  let mut saw_head = false
  let mut saw_post = false
  let mut saw_delete = false
  for value in values {
    if value == "GET" {
      saw_get = true
    } else if value == "HEAD" {
      saw_head = true
    } else if value == "POST" {
      saw_post = true
    } else if value == "DELETE" {
      saw_delete = true
    }
  }
  assert_true(saw_get)
  assert_true(saw_head)
  assert_true(saw_post)
  assert_true(saw_delete)
}

///|
test "http generators are deterministic for the same seed" {
  let a = @http.valid_status_code().sample(
    count=8,
    @core.seed(b"http-determinism"),
  )
  let b = @http.valid_status_code().sample(
    count=8,
    @core.seed(b"http-determinism"),
  )
  @test.assert_eq(a, b)
}

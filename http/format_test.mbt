///|
fn compat_http_known_method(value : String) -> Bool {
  value == "GET" ||
  value == "POST" ||
  value == "PUT" ||
  value == "DELETE" ||
  value == "HEAD" ||
  value == "OPTIONS" ||
  value == "CONNECT" ||
  value == "PATCH" ||
  value == "TRACE"
}

///|
test "data HTTP ranges and methods are preserved" {
  let rng = @core.seed(b"format-http")
  for status in @http.valid_status_code().sample(count=32, rng) {
    assert_true(status >= 100 && status < 600)
  }
  for status in @http.rfc_status_code().sample(count=32, rng) {
    assert_true(status >= 100 && status < 600)
  }
  for http_method_name in @http.http_method().sample(count=32, rng) {
    assert_true(compat_http_known_method(http_method_name))
  }
}

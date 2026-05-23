///|
/// Generate an RFC-listed HTTP status code from the table.
pub fn rfc_status_code() -> @core.Gen[Int] {
  @core.Gen::new(rng => @core.pick(@data.http_statuses(), rng))
}

///|
/// Generate an integer in the HTTP status-code range 100 through 599.
pub fn valid_status_code() -> @core.Gen[Int] {
  @core.Gen::new(rng => rng.int(limit=500) + 100)
}

///|
/// Generate an uppercase HTTP method.
pub fn http_method() -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.http_methods(), rng))
}

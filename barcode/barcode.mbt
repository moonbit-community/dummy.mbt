///|
// ISBN registrant ranges used by the generator. The chosen registrant length
// controls where the hyphen between registrant and publication segments lands.
priv struct RegistrantRule {
  min : String
  max : String
  registrant_len : Int32
}

///|
// Intermediate ISBN parts before the ISBN-10 or ISBN-13 check digit is added.
priv struct IsbnProperties {
  ean : String
  group : String
  registrant : String
  publication : String
}

///|
// Return the registrant-length rules for the supported English-language groups.
fn isbn_rules_for_group(group : String) -> Array[RegistrantRule] {
  match group {
    "0" =>
      [
        { min: "0000000", max: "1999999", registrant_len: 2, },
        { min: "2000000", max: "2279999", registrant_len: 3, },
        { min: "2280000", max: "2289999", registrant_len: 4, },
        { min: "2290000", max: "6479999", registrant_len: 3, },
        { min: "6480000", max: "6489999", registrant_len: 7, },
        { min: "6490000", max: "6999999", registrant_len: 3, },
        { min: "7000000", max: "8499999", registrant_len: 4, },
        { min: "8500000", max: "8999999", registrant_len: 5, },
        { min: "9000000", max: "9499999", registrant_len: 6, },
        { min: "9500000", max: "9999999", registrant_len: 7, },
      ]
    "1" =>
      [
        { min: "0000000", max: "0999999", registrant_len: 2, },
        { min: "20100000000000", max: "3999999", registrant_len: 3, },
        { min: "4000000", max: "5499999", registrant_len: 4, },
        { min: "5500000", max: "7319999", registrant_len: 5, },
        { min: "7320000", max: "7399999", registrant_len: 7, },
        { min: "7400000", max: "8697999", registrant_len: 5, },
        { min: "8698000", max: "9729999", registrant_len: 6, },
        { min: "9730000", max: "9877999", registrant_len: 4, },
        { min: "9878000", max: "9989999", registrant_len: 6, },
        { min: "9990000", max: "9999999", registrant_len: 7, },
      ]
    _ => []
  }
}

///|
// Decide the registrant segment length by matching the registration/publication
// suffix against the group's range table.
fn isbn_registrant_len(group : String, suffix_reg_pub : String) -> Int32 {
  for rule in isbn_rules_for_group(group) {
    if rule.min <= suffix_reg_pub && suffix_reg_pub <= rule.max {
      return rule.registrant_len
    }
  }
  0
}

///|
// Split a random registration/publication stem into ISBN components. The EAN is
// fixed to 978 for stable ISBN-13 output.
fn isbn_properties(group : String, reg_pub : String) -> IsbnProperties {
  let reg_pub_len = reg_pub.length()
  let suffix_reg_pub = reg_pub.unsafe_substring(start=0, end=reg_pub_len - 1)
  let reg_len = isbn_registrant_len(group, suffix_reg_pub)
  {
    ean: "978",
    group,
    registrant: reg_pub.unsafe_substring(start=0, end=reg_len),
    publication: reg_pub.unsafe_substring(start=reg_len, end=reg_pub_len),
  }
}

///|
// Concatenate ISBN components without hyphens so checksum algorithms can read
// each digit in sequence.
fn IsbnProperties::body(self : IsbnProperties, include_ean~ : Bool) -> String {
  if include_ean {
    self.ean + self.group + self.registrant + self.publication
  } else {
    self.group + self.registrant + self.publication
  }
}

///|
// Convert an ASCII digit character to its numeric value.
fn digit_value(ch : Char) -> Int32 {
  ch.to_int() - '0'.to_int()
}

///|
// ISBN-10 check digit: weighted sum modulo 11, where value 10 is rendered `X`.
fn isbn10_checksum(properties : IsbnProperties) -> String {
  let body = properties.body(include_ean=false)
  let mut sum = 0
  for i, ch in body {
    sum += (i + 1) * digit_value(ch)
  }
  let check = sum % 11
  if check == 10 {
    "X"
  } else {
    check.to_string()
  }
}

///|
// ISBN-13 check digit: alternating 1/3 weights over the 12-digit body.
fn isbn13_checksum(properties : IsbnProperties) -> Int32 {
  let body = properties.body(include_ean=true)
  let mut sum = 0
  for i, ch in body {
    let digit = digit_value(ch)
    sum += if i % 2 == 0 { digit } else { digit * 3 }
  }
  (10 - sum % 10) % 10
}

///|
// Render a hyphenated ISBN-10 string.
fn IsbnProperties::format10(self : IsbnProperties) -> String {
  self.group +
  "-" +
  self.registrant +
  "-" +
  self.publication +
  "-" +
  isbn10_checksum(self)
}

///|
// Render a hyphenated ISBN-13 string.
fn IsbnProperties::format13(self : IsbnProperties) -> String {
  self.ean +
  "-" +
  self.group +
  "-" +
  self.registrant +
  "-" +
  self.publication +
  "-" +
  isbn13_checksum(self).to_string()
}

///|
/// Generate a valid, hyphenated ISBN-13 string.
pub fn isbn13() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let group = if rng.int(limit=2) == 0 { "0" } else { "1" }
    let reg_pub_len = 13 - 3 - group.length() - 1
    let reg_pub = StringBuilder::new(size_hint=reg_pub_len)
    for _ in 0..<reg_pub_len {
      reg_pub.write_string(rng.int(limit=10).to_string())
    }
    isbn_properties(group, reg_pub.to_string()).format13()
  })
}

///|
/// Generate a valid, hyphenated ISBN-10 string.
pub fn isbn10() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let group = if rng.int(limit=2) == 0 { "0" } else { "1" }
    let reg_pub_len = 13 - 3 - group.length() - 1
    let reg_pub = StringBuilder::new(size_hint=reg_pub_len)
    for _ in 0..<reg_pub_len {
      reg_pub.write_string(rng.int(limit=10).to_string())
    }
    isbn_properties(group, reg_pub.to_string()).format10()
  })
}

///|
/// Generate either an ISBN-10 or ISBN-13 string.
pub fn isbn() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    if rng.boolean() {
      isbn10().dummy(rng)
    } else {
      isbn13().dummy(rng)
    }
  })
}

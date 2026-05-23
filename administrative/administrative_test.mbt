///|
fn is_decimal_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn all_decimal_digits(s : String) -> Bool {
  for ch in s {
    if !is_decimal_digit(ch) {
      return false
    }
  }
  true
}

///|
fn decimal_string_to_int(s : String) -> Int {
  let mut value = 0
  for ch in s {
    value = value * 10 + ch.to_int() - '0'.to_int()
  }
  value
}

///|
fn decimal_mod_97(digits : String) -> Int {
  let mut rem = 0
  for ch in digits {
    rem = (rem * 10 + ch.to_int() - '0'.to_int()) % 97
  }
  rem
}

///|
fn is_fr_department(department : String) -> Bool {
  for
    candidate in [
      "01", "02", "03", "04", "05", "06", "07", "08", "09", "11", "12", "13", "14",
      "15", "16", "17", "18", "19", "2A", "2B", "21", "22", "23", "24", "25", "26",
      "27", "28", "29", "31", "32", "33", "34", "35", "36", "37", "38", "39", "41",
      "42", "43", "44", "45", "46", "47", "48", "49", "51", "52", "53", "54", "55",
      "56", "57", "58", "59", "61", "62", "63", "64", "65", "66", "67", "68", "69",
      "71", "72", "73", "74", "75", "76", "77", "78", "79", "81", "82", "83", "84",
      "85", "86", "87", "88", "89", "91", "92", "93", "94", "95", "971", "972", "973",
      "974", "975", "976", "977", "978", "984", "986", "987", "988", "989",
    ] {
    if candidate == department {
      return true
    }
  }
  false
}

///|
fn department_code_for_key(department : String) -> String {
  match department {
    "2A" => "19"
    "2B" => "18"
    _ => decimal_string_to_int(department).to_string()
  }
}

///|
fn split_code(code : String) -> Array[String] {
  code.split(" ").map(part => part.to_owned()).to_array()
}

///|
fn assert_valid_health_insurance_code(code : String) -> Unit raise {
  let parts = split_code(code)
  @test.assert_eq(parts.length(), 7)
  let sex = parts[0]
  let year = parts[1]
  let month = parts[2]
  let department = parts[3]
  let town = parts[4]
  let order = parts[5]
  let key_text = parts[6]
  assert_true(sex == "1" || sex == "2")
  @test.assert_eq(year.length(), 2)
  assert_true(all_decimal_digits(year))
  @test.assert_eq(month.length(), 2)
  assert_true(all_decimal_digits(month))
  let month_number = decimal_string_to_int(month)
  assert_true(month_number >= 1 && month_number <= 12)
  assert_true(is_fr_department(department))
  @test.assert_eq(town.length(), 3)
  assert_true(all_decimal_digits(town))
  @test.assert_eq(order.length(), 3)
  assert_true(all_decimal_digits(order))
  assert_true(all_decimal_digits(key_text))
  let expected_key = 97 -
    decimal_mod_97(
      sex + year + month + department_code_for_key(department) + town + order,
    )
  @test.assert_eq(decimal_string_to_int(key_text), expected_key)
}

///|
test "health_insurance_code defaults to FR_FR and has valid NIR shape" {
  let values = @administrative.health_insurance_code().sample(
    count=32,
    @core.seed(b"health-insurance-fr"),
  )
  for value in values {
    assert_valid_health_insurance_code(value)
  }
}

///|
test "health_insurance_code supports explicit FR_FR locale" {
  let value = @administrative.health_insurance_code(locale=@locales.FR_FR).dummy(
    @core.seed(b"health-insurance-explicit-fr"),
  )
  assert_valid_health_insurance_code(value)
}

///|
test "health_insurance_code is deterministic for the same seed" {
  let seed = b"health-insurance-determinism"
  let a = @administrative.health_insurance_code(locale=@locales.FR_FR).sample(
    count=8,
    @core.seed(seed),
  )
  let b = @administrative.health_insurance_code(locale=@locales.FR_FR).sample(
    count=8,
    @core.seed(seed),
  )
  @test.assert_eq(a, b)
}

///|
test "health_insurance_code rejects unsupported locales" {
  let result : Result[String, @core.DummyError] = try? @administrative.health_insurance_code(
    locale=@locales.EN,
  ).dummy(@core.seed(b"health-insurance-unsupported"))
  assert_true(result is Err(@core.DummyError::UnsupportedLocale(_)))
}

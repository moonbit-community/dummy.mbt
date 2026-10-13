///|
// French department codes used by the health insurance number generator.
fn fr_fr_departments() -> Array[String] {
  [
    "01", "02", "03", "04", "05", "06", "07", "08", "09", "11", "12", "13", "14",
    "15", "16", "17", "18", "19", "2A", "2B", "21", "22", "23", "24", "25", "26",
    "27", "28", "29", "31", "32", "33", "34", "35", "36", "37", "38", "39", "41",
    "42", "43", "44", "45", "46", "47", "48", "49", "51", "52", "53", "54", "55",
    "56", "57", "58", "59", "61", "62", "63", "64", "65", "66", "67", "68", "69",
    "71", "72", "73", "74", "75", "76", "77", "78", "79", "81", "82", "83", "84",
    "85", "86", "87", "88", "89", "91", "92", "93", "94", "95", "971", "972", "973",
    "974", "975", "976", "977", "978", "984", "986", "987", "988", "989",
  ]
}

///|
// Parse an ASCII decimal string without allocation-heavy conversions.
fn decimal_string_to_int(s : String) -> Int32 {
  let mut value = 0
  for ch in s {
    value = value * 10 + ch.to_int() - '0'.to_int()
  }
  value
}

///|
// Map Corsica department labels to the numeric values used in the key formula.
fn department_code_for_key(department : String) -> String {
  match department {
    "2A" => "19"
    "2B" => "18"
    _ => decimal_string_to_int(department).to_string()
  }
}

///|
// Streaming modulo 97 for long decimal identifiers.
fn decimal_mod_97(digits : String) -> Int32 {
  let mut rem = 0
  for ch in digits {
    rem = (rem * 10 + ch.to_int() - '0'.to_int()) % 97
  }
  rem
}

///|
// Generate a French social-security-style health insurance code and key.
fn health_insurance_code_fr_fr(
  rng : @random.Rand,
) -> String raise @core.DummyError {
  let sex = rng.int(limit=2) + 1
  let birth_year = rng.int(limit=99)
  let birth_month = rng.int(limit=12) + 1
  let department = @core.pick_string(fr_fr_departments(), rng)
  let town_code = rng.int(limit=999)
  let order_code = rng.int(limit=999)
  let year = @core.pad_left(birth_year.to_string(), 2, '0')
  let month = @core.pad_left(birth_month.to_string(), 2, '0')
  let town = @core.pad_left(town_code.to_string(), 3, '0')
  let order = @core.pad_left(order_code.to_string(), 3, '0')
  let number_digits = sex.to_string() +
    year +
    month +
    department_code_for_key(department) +
    town +
    order
  let key = 97 - decimal_mod_97(number_digits)
  "\{sex} \{year} \{month} \{department} \{town} \{order} \{key}"
}

///|
/// Generate a locale-specific administrative health insurance code.
///
/// Currently only `FR_FR` has a meaningful locale-specific implementation.
pub fn health_insurance_code(
  locale~ : @locales.Locale = FR_FR,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    match locale {
      FR_FR => health_insurance_code_fr_fr(rng)
      _ => raise UnsupportedLocale(locale.code())
    }
  })
}

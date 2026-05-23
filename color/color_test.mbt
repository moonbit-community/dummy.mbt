///|
fn is_hex_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  (code >= 'A'.to_int() && code <= 'F'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn decimal_value(ch : Char) -> Int32? {
  let code = ch.to_int()
  if code >= '0'.to_int() && code <= '9'.to_int() {
    Some(code - '0'.to_int())
  } else {
    None
  }
}

///|
fn numbers_in(s : String) -> Array[Int32] {
  let values : Array[Int32] = []
  let mut current = 0
  let mut reading = false
  for ch in s {
    match decimal_value(ch) {
      Some(digit) => {
        current = current * 10 + digit
        reading = true
      }
      None =>
        if reading {
          values.push(current)
          current = 0
          reading = false
        }
    }
  }
  if reading {
    values.push(current)
  }
  values
}

///|
fn assert_hex_color(value : String) -> Unit raise {
  @test.assert_eq(value.length(), 7)
  assert_true(value.has_prefix("#"))
  for i in 1..<7 {
    match value.get_char(i) {
      Some(ch) => assert_true(is_hex_char(ch))
      None => fail("missing hex character")
    }
  }
}

///|
fn assert_rgb_color(rgb : String) -> Unit raise {
  assert_true(rgb.has_prefix("rgb("))
  assert_true(rgb.has_suffix(")"))
  @test.assert_eq(count_char(rgb, ','), 2)
  let rgb_numbers = numbers_in(rgb)
  @test.assert_eq(rgb_numbers.length(), 3)
  for value in rgb_numbers {
    assert_true(value >= 0 && value <= 255)
  }
}

///|
fn assert_rgba_color(rgba : String) -> Unit raise {
  assert_true(rgba.has_prefix("rgba("))
  assert_true(rgba.has_suffix(")"))
  @test.assert_eq(count_char(rgba, ','), 3)
  @test.assert_eq(count_char(rgba, '.'), 1)
  let rgba_numbers = numbers_in(rgba)
  assert_true(rgba_numbers.length() >= 5)
  for i in 0..<3 {
    assert_true(rgba_numbers[i] >= 0 && rgba_numbers[i] <= 255)
  }
  @test.assert_eq(rgba_numbers[3], 0)
  assert_true(rgba_numbers[4] >= 0 && rgba_numbers[4] <= 99)
}

///|
fn assert_hsl_color(hsl : String) -> Unit raise {
  assert_true(hsl.has_prefix("hsl("))
  assert_true(hsl.has_suffix(")"))
  @test.assert_eq(count_char(hsl, '%'), 2)
  let hsl_numbers = numbers_in(hsl)
  @test.assert_eq(hsl_numbers.length(), 3)
  assert_true(hsl_numbers[0] >= 0 && hsl_numbers[0] < 360)
  assert_true(hsl_numbers[1] >= 0 && hsl_numbers[1] <= 100)
  assert_true(hsl_numbers[2] >= 0 && hsl_numbers[2] <= 100)
}

///|
fn assert_hsla_color(hsla : String) -> Unit raise {
  assert_true(hsla.has_prefix("hsla("))
  assert_true(hsla.has_suffix(")"))
  @test.assert_eq(count_char(hsla, '%'), 2)
  @test.assert_eq(count_char(hsla, ','), 3)
  @test.assert_eq(count_char(hsla, '.'), 1)
  let hsla_numbers = numbers_in(hsla)
  assert_true(hsla_numbers.length() >= 5)
  assert_true(hsla_numbers[0] >= 0 && hsla_numbers[0] < 360)
  assert_true(hsla_numbers[1] >= 0 && hsla_numbers[1] <= 100)
  assert_true(hsla_numbers[2] >= 0 && hsla_numbers[2] <= 100)
  @test.assert_eq(hsla_numbers[3], 0)
  assert_true(hsla_numbers[4] >= 0 && hsla_numbers[4] <= 99)
}

///|
test "hex_color uses CSS hex format" {
  let values = @color.hex_color().sample(count=16, @core.seed(b"hex-color"))
  for value in values {
    assert_hex_color(value)
  }
}

///|
test "rgb and rgba colors use CSS function format" {
  let rng = @core.seed(b"rgb-colors")
  assert_rgb_color(@color.rgb_color().dummy(rng))
  assert_rgba_color(@color.rgba_color().dummy(rng))
}

///|
test "hsl and hsla colors use percentage CSS function format" {
  let rng = @core.seed(b"hsl-colors")
  assert_hsl_color(@color.hsl_color().dummy(rng))
  assert_hsla_color(@color.hsla_color().dummy(rng))
}

///|
test "color returns color block format" {
  let value = @color.color().dummy(@core.seed(b"color-block"))
  let lines = value.split("\n").map(line => line.to_owned()).to_array()
  @test.assert_eq(lines.length(), 5)
  assert_hex_color(lines[0])
  assert_rgb_color(lines[1])
  assert_rgba_color(lines[2])
  assert_hsl_color(lines[3])
  assert_hsla_color(lines[4])
}

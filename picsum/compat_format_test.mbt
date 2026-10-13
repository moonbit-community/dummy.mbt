///|
fn compat_picsum_decimal(value : String) -> Int32? {
  if value.is_empty() {
    return None
  }
  let mut out = 0
  for ch in value {
    let code = ch.to_int()
    if code < '0'.to_int() || code > '9'.to_int() {
      return None
    }
    out = out * 10 + code - '0'.to_int()
  }
  Some(out)
}

///|
fn compat_picsum_dimensions_in_range(url : String) -> Bool {
  let path = url
    .strip_prefix("https://picsum.photos/")
    .unwrap_or(url[:])
    .to_owned()
  let path = match path.split_once("?") {
    Some((head, _)) => head.to_owned()
    None => path
  }
  let parts = path.split("/").map(part => part.to_owned()).to_array()
  let start = if parts.length() >= 4 && parts[0] == "seed" { 2 } else { 0 }
  if parts.length() < start + 2 {
    return false
  }
  guard compat_picsum_decimal(parts[start]) is Some(width) else { return false }
  guard compat_picsum_decimal(parts[start + 1]) is Some(height) else {
    return false
  }
  width >= 100 && width <= 800 && height >= 100 && height <= 800
}

///|
test "data picsum URL variants are preserved" {
  let rng = @core.seed(b"format-picsum")
  for value in @picsum.image().sample(count=16, rng) {
    assert_true(value.has_prefix("https://picsum.photos/"))
    assert_true(!value.contains("?"))
    assert_true(compat_picsum_dimensions_in_range(value))
  }
  let seeded = @picsum.image_with_seed().dummy(rng)
  assert_true(seeded.has_prefix("https://picsum.photos/seed/"))
  assert_true(compat_picsum_dimensions_in_range(seeded))
  let grayscale = @picsum.image_grayscale().dummy(rng)
  assert_true(grayscale.has_suffix("?grayscale"))
  assert_true(compat_picsum_dimensions_in_range(grayscale))
  let blur = @picsum.image_blur().dummy(rng)
  assert_true(blur.contains("?blur="))
  assert_true(compat_picsum_dimensions_in_range(blur))
  let custom = @picsum.image_custom(@picsum.ImageOptions::{
    width: 320,
    height: 240,
    grayscale: true,
    blur: Some(4),
    seed: Some("demo"),
  }).dummy(rng)
  @test.assert_eq(
    custom, "https://picsum.photos/seed/demo/320/240?grayscale&blur=4",
  )
}

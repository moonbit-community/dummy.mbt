///|
fn count_char(s : String, target : Char) -> Int {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn all_digits_or_dots(s : String) -> Bool {
  for ch in s {
    let code = ch.to_int()
    let is_digit = code >= '0'.to_int() && code <= '9'.to_int()
    if !is_digit && ch != '.' {
      return false
    }
  }
  true
}

///|
fn is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn is_lower_ascii_or_digit(s : String) -> Bool {
  for ch in s {
    let code = ch.to_int()
    let is_lower = code >= 'a'.to_int() && code <= 'z'.to_int()
    let is_digit = code >= '0'.to_int() && code <= '9'.to_int()
    if !is_lower && !is_digit {
      return false
    }
  }
  true
}

///|
fn has_non_empty_file_stem_and_extension(s : String) -> Bool {
  let mut dot_count = 0
  let mut before_dot = 0
  let mut after_dot = 0
  let mut seen_dot = false
  for ch in s {
    if ch == '.' {
      dot_count += 1
      seen_dot = true
    } else if ch == '/' {
      return false
    } else if seen_dot {
      after_dot += 1
    } else {
      before_dot += 1
    }
  }
  dot_count == 1 && before_dot > 0 && after_dot > 0
}

///|
fn valid_path_shape(
  s : String,
  max_segments : Int,
  allow_root_only : Bool,
) -> Bool {
  if s == "/" {
    return allow_root_only
  }
  let mut last_was_slash = false
  let mut saw_segment = false
  let mut segment_count = 0
  for ch in s {
    if ch == '/' {
      if last_was_slash {
        return false
      }
      if saw_segment {
        segment_count += 1
      }
      last_was_slash = true
    } else {
      saw_segment = true
      last_was_slash = false
    }
  }
  if !saw_segment || last_was_slash {
    return false
  }
  segment_count += 1
  segment_count <= max_segments
}

///|
fn valid_dir_path_shape(s : String) -> Bool {
  valid_path_shape(s, 5, true)
}

///|
fn valid_file_path_shape(s : String) -> Bool {
  if s.contains("//") {
    return false
  }
  valid_path_shape(s, 6, false)
}

///|
fn mime_type_has_type_and_subtype(s : String) -> Bool {
  let mut slash_count = 0
  let mut before = 0
  let mut after = 0
  let mut seen_slash = false
  for ch in s {
    if ch == '/' {
      slash_count += 1
      seen_slash = true
    } else if seen_slash {
      after += 1
    } else {
      before += 1
    }
  }
  slash_count == 1 && before > 0 && after > 0
}

///|
fn stable_semver_in_compat_ranges(s : String) -> Bool {
  let mut part = 0
  let mut value = 0
  let mut digits = 0
  for ch in s {
    if ch == '.' {
      if digits == 0 {
        return false
      }
      if part == 0 && value > 8 {
        return false
      }
      if part > 0 && value > 19 {
        return false
      }
      part += 1
      value = 0
      digits = 0
    } else if is_digit(ch) {
      value = value * 10 + ch.to_int() - '0'.to_int()
      digits += 1
    } else {
      return false
    }
  }
  digits > 0 && part == 2 && value <= 19
}

///|
test "file name and path keep filesystem shape" {
  let rng = @core.seed(b"filesystem-paths")
  let extension = @filesystem.file_extension().dummy(rng)
  assert_true(!extension.is_empty())
  assert_true(!extension.contains("."))
  assert_true(!extension.contains("/"))
  assert_true(is_lower_ascii_or_digit(extension))
  let name = @filesystem.file_name().dummy(rng)
  assert_true(name.contains("."))
  assert_true(!name.contains("/"))
  assert_true(has_non_empty_file_stem_and_extension(name))
  let dir = @filesystem.dir_path().dummy(rng)
  assert_true(dir.has_prefix("/"))
  assert_true(valid_dir_path_shape(dir))
  assert_true(valid_dir_path_shape("/"))
  let path = @filesystem.file_path().dummy(rng)
  assert_true(path.has_prefix("/"))
  assert_true(path.contains("."))
  assert_true(valid_file_path_shape(path))
}

///|
test "mime_type has type and subtype" {
  let values = @filesystem.mime_type().sample(count=16, @core.seed(b"mime"))
  for value in values {
    assert_true(value.contains("/"))
    assert_true(!value.has_prefix("/"))
    assert_true(!value.has_suffix("/"))
    assert_true(mime_type_has_type_and_subtype(value))
  }
}

///|
test "semver generators produce stable and prerelease versions" {
  let rng = @core.seed(b"semver")
  let stable = @filesystem.semver_stable().dummy(rng)
  @test.assert_eq(count_char(stable, '.'), 2)
  assert_true(all_digits_or_dots(stable))
  assert_true(!stable.contains("-"))
  assert_true(stable_semver_in_compat_ranges(stable))
  let any = @filesystem.semver().dummy(rng)
  assert_true(count_char(any, '.') >= 2)
  let unstable = @filesystem.semver_unstable().dummy(rng)
  assert_true(unstable.contains("-"))
  assert_true(unstable.contains("."))
  @test.assert_eq(count_char(unstable, '.'), 3)
  assert_true(
    unstable.contains("-alpha.") ||
    unstable.contains("-beta.") ||
    unstable.contains("-rc."),
  )
}

///|
test "filesystem generators are deterministic for the same seed" {
  let a = @filesystem.file_path().sample(
    count=8,
    @core.seed(b"filesystem-determinism"),
  )
  let b = @filesystem.file_path().sample(
    count=8,
    @core.seed(b"filesystem-determinism"),
  )
  @test.assert_eq(a, b)
}

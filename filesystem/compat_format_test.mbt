///|
fn compat_fs_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_fs_decimal(s : String) -> Bool {
  !s.is_empty() &&
  ({
    for ch in s {
      if !compat_fs_is_digit(ch) {
        return false
      }
    }
    true
  })
}

///|
fn compat_fs_valid_semver(s : String) -> Bool {
  let parts = s.split("-").map(part => part.to_owned()).to_array()
  if parts.length() < 1 || parts.length() > 2 {
    return false
  }
  let nums = parts[0].split(".").map(part => part.to_owned()).to_array()
  nums.length() == 3 &&
  compat_fs_decimal(nums[0]) &&
  compat_fs_decimal(nums[1]) &&
  compat_fs_decimal(nums[2]) &&
  (parts.length() == 1 || !parts[1].is_empty())
}

///|
test "data semver formats are preserved" {
  let rng = @core.seed(b"format-filesystem")
  for value in @filesystem.semver().sample(count=32, rng) {
    assert_true(compat_fs_valid_semver(value))
  }
  let stable = @filesystem.semver_stable().dummy(rng)
  assert_true(compat_fs_valid_semver(stable))
  assert_true(!stable.contains("-"))
  let unstable = @filesystem.semver_unstable().dummy(rng)
  assert_true(compat_fs_valid_semver(unstable))
  assert_true(unstable.contains("-"))
}

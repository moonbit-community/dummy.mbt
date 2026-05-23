///|
/// Generate a file extension without a leading dot.
pub fn file_extension() -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.file_extensions(), rng))
}

///|
/// Generate a file name from a path segment and extension.
pub fn file_name() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    @core.pick_string(@data.path_segments(), rng) +
    "." +
    file_extension().dummy(rng)
  })
}

///|
/// Generate a directory path from a root and zero or more segments.
pub fn dir_path() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let root = @core.pick_string(@data.path_root_dirs(), rng)
    let segments : Array[String] = []
    for _ in 0..<4 {
      if rng.boolean() {
        segments.push(@core.pick_string(@data.path_segments(), rng))
      }
    }
    if segments.is_empty() {
      root
    } else if root == "/" {
      "/" + segments.join("/")
    } else {
      root + "/" + segments.join("/")
    }
  })
}

///|
/// Generate a full file path.
pub fn file_path() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let dir = dir_path().dummy(rng)
    if dir == "/" {
      "/" + file_name().dummy(rng)
    } else {
      dir + "/" + file_name().dummy(rng)
    }
  })
}

///|
/// Generate a MIME type string.
pub fn mime_type() -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.mime_types(), rng))
}

///|
/// Generate a semantic version, usually stable and sometimes pre-release.
pub fn semver() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    if rng.int(limit=100) < 10 {
      semver_unstable().dummy(rng)
    } else {
      semver_stable().dummy(rng)
    }
  })
}

///|
/// Generate a stable semantic version.
pub fn semver_stable() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    "\{rng.int(limit=9)}.\{rng.int(limit=20)}.\{rng.int(limit=20)}"
  })
}

///|
/// Generate a semantic version with a pre-release suffix.
pub fn semver_unstable() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let tag = @core.pick_string(["alpha", "beta", "rc"], rng)
    semver_stable().dummy(rng) + "-\{tag}." + rng.int(limit=9).to_string()
  })
}

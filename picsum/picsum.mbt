///|
/// Options for constructing a Picsum image URL.
pub(all) struct ImageOptions {
  width : Int
  height : Int
  grayscale : Bool
  blur : Int?
  seed : String?
} derive(Eq, Debug)

///|
/// Generate a random Picsum image URL.
pub fn image() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let width = rng.int(limit=701) + 100
    let height = rng.int(limit=701) + 100
    "https://picsum.photos/\{width}/\{height}"
  })
}

///|
/// Generate a Picsum image URL with a random seed path segment.
pub fn image_with_seed() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let seed = rng.uint().to_string()
    let width = rng.int(limit=701) + 100
    let height = rng.int(limit=701) + 100
    "https://picsum.photos/seed/\{seed}/\{width}/\{height}"
  })
}

///|
/// Generate a Picsum image URL with `?grayscale`.
pub fn image_grayscale() -> @core.Gen[String] {
  @core.Gen::new(rng => image().dummy(rng) + "?grayscale")
}

///|
/// Generate a Picsum image URL with a random blur level.
pub fn image_blur() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    image().dummy(rng) + "?blur=" + (rng.int(limit=10) + 1).to_string()
  })
}

///|
/// Generate a Picsum image URL from explicit dimensions and optional modifiers.
pub fn image_custom(opts : ImageOptions) -> @core.Gen[String] {
  @core.Gen::new(_rng => {
    if opts.width <= 0 || opts.height <= 0 {
      raise @core.DummyError::InvalidRange(
        "picsum image dimensions must be positive",
      )
    }
    let base = match opts.seed {
      Some(seed) =>
        "https://picsum.photos/seed/\{seed}/\{opts.width}/\{opts.height}"
      None => "https://picsum.photos/\{opts.width}/\{opts.height}"
    }
    let params : Array[String] = []
    if opts.grayscale {
      params.push("grayscale")
    }
    match opts.blur {
      Some(blur) => {
        if blur < 1 || blur > 10 {
          raise @core.DummyError::InvalidRange("picsum blur must be in 1..10")
        }
        params.push("blur=\{blur}")
      }
      None => ()
    }
    if params.is_empty() {
      base
    } else {
      base + "?" + params.join("&")
    }
  })
}

///|
/// Generate a hex CSS color string.
pub fn hex_color() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    "#" +
    @core.hex_byte(rng.int(limit=256)) +
    @core.hex_byte(rng.int(limit=256)) +
    @core.hex_byte(rng.int(limit=256))
  })
}

///|
/// Generate an `rgb(r, g, b)` CSS color string.
pub fn rgb_color() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    "rgb(\{rng.int(limit=256)}, \{rng.int(limit=256)}, \{rng.int(limit=256)})"
  })
}

///|
/// Generate an `rgba(r, g, b, a)` CSS color string.
pub fn rgba_color() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let alpha = "0." + @core.pad_left(rng.int(limit=100).to_string(), 2, '0')
    "rgba(\{rng.int(limit=256)}, \{rng.int(limit=256)}, \{rng.int(limit=256)}, \{alpha})"
  })
}

///|
/// Generate an `hsl(h, s%, l%)` CSS color string.
pub fn hsl_color() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    "hsl(\{rng.int(limit=360)}, \{rng.int(limit=101)}%, \{rng.int(limit=101)}%)"
  })
}

///|
/// Generate an `hsla(h, s%, l%, a)` CSS color string.
pub fn hsla_color() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let alpha = "0." + @core.pad_left(rng.int(limit=100).to_string(), 2, '0')
    "hsla(\{rng.int(limit=360)}, \{rng.int(limit=101)}%, \{rng.int(limit=101)}%, \{alpha})"
  })
}

///|
/// Generate a multi-line value containing hex, RGB(A), and HSL(A) variants.
pub fn color() -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let hex = "#" +
      @core.hex_byte(rng.int(limit=256)) +
      @core.hex_byte(rng.int(limit=256)) +
      @core.hex_byte(rng.int(limit=256))
    let rgb = "rgb(\{rng.int(limit=256)}, \{rng.int(limit=256)}, \{rng.int(limit=256)})"
    let alpha = "0." + @core.pad_left(rng.int(limit=100).to_string(), 2, '0')
    let rgba = "rgba(\{rng.int(limit=256)}, \{rng.int(limit=256)}, \{rng.int(limit=256)}, \{alpha})"
    let hsl = "hsl(\{rng.int(limit=360)}, \{rng.int(limit=101)}%, \{rng.int(limit=101)}%)"
    let hsla_alpha = "0." +
      @core.pad_left(rng.int(limit=100).to_string(), 2, '0')
    let hsla = "hsla(\{rng.int(limit=360)}, \{rng.int(limit=101)}%, \{rng.int(limit=101)}%, \{hsla_alpha})"
    [hex, rgb, rgba, hsl, hsla].join("\n")
  })
}

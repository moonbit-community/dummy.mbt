///|
/// Generate one Markdown italic word.
pub fn italic_word(
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @lorem.word(locale~).map(w => "*" + w + "*")
}

///|
/// Generate one Markdown bold word.
pub fn bold_word(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @lorem.word(locale~).map(w => "**" + w + "**")
}

///|
/// Generate a Markdown link with a fake label and example.com URL.
pub fn link(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let label = @lorem.word(locale~).dummy(rng)
    "[" + label + "](https://example.com/" + @core.random_ascii(6, rng) + ")"
  })
}

///|
/// Generate a Markdown bullet list string.
pub fn bullet_points(
  locale~ : @locales.Locale = @locales.EN,
  count~ : @core.CountRange = @core.count_range(2, 5),
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    let lines : Array[String] = []
    for _ in 0..<n {
      lines.push("- " + @lorem.sentence(locale~).dummy(rng))
    }
    lines.join("\n")
  })
}

///|
/// Generate numbered Markdown list item strings.
pub fn list_items(
  locale~ : @locales.Locale = @locales.EN,
  count~ : @core.CountRange = @core.count_range(2, 5),
) -> @core.Gen[Array[String]] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    let lines : Array[String] = []
    for i in 0..<n {
      lines.push("\{i + 1}. " + @lorem.sentence(locale~).dummy(rng))
    }
    lines
  })
}

///|
/// Generate Markdown block quote lines.
pub fn block_quote_single_line(
  locale~ : @locales.Locale = @locales.EN,
  count~ : @core.CountRange = @core.count_range(1, 3),
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    let lines : Array[String] = []
    for _ in 0..<n {
      lines.push("> " + @lorem.sentence(locale~).dummy(rng))
    }
    lines.join("\n")
  })
}

///|
/// Generate a multi-line Markdown block quote string.
pub fn block_quote_multi_line(
  locale~ : @locales.Locale = @locales.EN,
  count~ : @core.CountRange = @core.count_range(2, 4),
) -> @core.Gen[String] {
  block_quote_single_line(locale~, count~)
}

///|
/// Generate a fenced Markdown code block.
pub fn code(
  count~ : @core.CountRange = @core.count_range(2, 4),
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    let lines : Array[String] = ["```"]
    for _ in 0..<n {
      lines.push(
        "let " +
        @core.random_ascii(4, rng) +
        " = " +
        rng.int(limit=100).to_string(),
      )
    }
    lines.push("```")
    lines.join("\n")
  })
}

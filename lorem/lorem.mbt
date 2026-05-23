///|
/// Generate one lorem word for `locale`.
pub fn word(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.lorem_words(locale), rng))
}

///|
/// Generate an array of lorem words.
pub fn words(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(3, 6),
) -> @core.Gen[Array[String]] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    @core.repeat_pick(@data.lorem_words(locale), n, rng)
  })
}

///|
/// Generate one sentence from locale-backed words.
pub fn sentence(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(4, 10),
) -> @core.Gen[String] {
  words(locale~, count~).map(items => {
    let body = @core.join_strings(items, " ")
    match locale {
      @locales.ZH_CN | @locales.ZH_TW => body + "。"
      _ => body + "."
    }
  })
}

///|
/// Generate an array of lorem sentences.
pub fn sentences(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 4),
) -> @core.Gen[Array[String]] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    let out : Array[String] = []
    for _ in 0..<n {
      out.push(sentence(locale~).dummy(rng))
    }
    out
  })
}

///|
/// Generate one paragraph from lorem sentences.
pub fn paragraph(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(3, 5),
) -> @core.Gen[String] {
  sentences(locale~, count~).map(items => @core.join_strings(items, " "))
}

///|
/// Generate an array of lorem paragraphs.
pub fn paragraphs(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 3),
) -> @core.Gen[Array[String]] {
  @core.Gen::new(rng => {
    let n = count.sample(rng)
    let out : Array[String] = []
    for _ in 0..<n {
      out.push(paragraph(locale~).dummy(rng))
    }
    out
  })
}

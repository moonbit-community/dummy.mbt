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
test "words honors requested count" {
  let values = @lorem.words(count=@core.count_range(5, 5)).dummy(
    @core.seed(b"lorem-words"),
  )
  @test.assert_eq(values.length(), 5)
  for value in values {
    assert_true(!value.is_empty())
  }
}

///|
test "lorem range counts mirror determinism examples" {
  let words = @lorem.words(count=@core.count_range(1, 2)).dummy(
    @core.seed(b"lorem-range-words"),
  )
  assert_true(words.length() >= 1 && words.length() <= 2)
  let sentence = @lorem.sentence(count=@core.count_range(1, 2)).dummy(
    @core.seed(b"lorem-range-sentence"),
  )
  assert_true(sentence.has_suffix("."))
  assert_true(count_char(sentence, ' ') <= 1)
  let sentences = @lorem.sentences(count=@core.count_range(1, 2)).dummy(
    @core.seed(b"lorem-range-sentences"),
  )
  assert_true(sentences.length() >= 1 && sentences.length() <= 2)
  let paragraph = @lorem.paragraph(count=@core.count_range(1, 2)).dummy(
    @core.seed(b"lorem-range-paragraph"),
  )
  assert_true(
    count_char(paragraph, '.') >= 1 && count_char(paragraph, '.') <= 2,
  )
  let paragraphs = @lorem.paragraphs(count=@core.count_range(1, 2)).dummy(
    @core.seed(b"lorem-range-paragraphs"),
  )
  assert_true(paragraphs.length() >= 1 && paragraphs.length() <= 2)
  @test.assert_eq(
    paragraphs,
    @lorem.paragraphs(count=@core.count_range(1, 2)).dummy(
      @core.seed(b"lorem-range-paragraphs"),
    ),
  )
}

///|
test "sentence punctuation follows locale" {
  let rng = @core.seed(b"lorem-sentence")
  let en = @lorem.sentence(locale=@locales.EN).dummy(rng)
  assert_true(en.has_suffix("."))
  let zh = @lorem.sentence(locale=@locales.ZH_CN).dummy(rng)
  assert_true(zh.has_suffix("。"))
  let zh_tw = @lorem.sentence(locale=@locales.ZH_TW).dummy(rng)
  assert_true(zh_tw.has_suffix("。"))
}

///|
test "paragraph and paragraphs honor requested count" {
  let rng = @core.seed(b"lorem-paragraph")
  let paragraph = @lorem.paragraph(count=@core.count_range(3, 3)).dummy(rng)
  assert_true(!paragraph.is_empty())
  @test.assert_eq(count_char(paragraph, '.'), 3)
  let paragraphs = @lorem.paragraphs(count=@core.count_range(2, 2)).dummy(rng)
  @test.assert_eq(paragraphs.length(), 2)
}

///|
test "lorem generators are deterministic for the same seed" {
  let a = @lorem.sentences(count=@core.count_range(3, 3)).dummy(
    @core.seed(b"lorem-determinism"),
  )
  let b = @lorem.sentences(count=@core.count_range(3, 3)).dummy(
    @core.seed(b"lorem-determinism"),
  )
  @test.assert_eq(a, b)
}

///|
test "lorem locale fallback and fixed seed golden outputs" {
  let fallback_seed = b"lorem-fallback"
  @test.assert_eq(
    @lorem.word(locale=@locales.FR_FR).dummy(@core.seed(fallback_seed)),
    @lorem.word(locale=@locales.EN).dummy(@core.seed(fallback_seed)),
  )
  let en = @lorem.sentence(locale=@locales.EN, count=@core.count_range(4, 4)).dummy(
    @core.seed(b"lorem-golden-en"),
  )
  let zh_cn = @lorem.sentence(
    locale=@locales.ZH_CN,
    count=@core.count_range(4, 4),
  ).dummy(@core.seed(b"lorem-golden-cn"))
  let zh_tw = @lorem.sentence(
    locale=@locales.ZH_TW,
    count=@core.count_range(4, 4),
  ).dummy(@core.seed(b"lorem-golden-tw"))
  assert_true(en.has_suffix("."))
  @test.assert_eq(count_char(en, ' '), 3)
  assert_true(zh_cn.has_suffix("。"))
  @test.assert_eq(count_char(zh_cn, ' '), 3)
  assert_true(zh_tw.has_suffix("。"))
  @test.assert_eq(count_char(zh_tw, ' '), 3)
}

///|
/// Generate a company suffix such as `Inc.` or a locale-specific equivalent.
pub fn company_suffix(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.company_suffixes(locale), rng))
}

///|
/// Generate a company name using locale-specific templates.
pub fn company_name(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let name1 = @name.last_name(locale~).dummy(rng)
    let name2 = @name.last_name(locale~).dummy(rng)
    let suffix = company_suffix(locale~).dummy(rng)
    let template = @core.pick_string(@data.company_name_templates(locale), rng)
    @core.render_template(template, [
      ("{Name_1}", name1),
      ("{Name_2}", name2),
      ("{Suffix}", suffix),
    ])
  })
}

///|
/// Generate the first part of a company buzzword phrase.
pub fn buzzword(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    @core.pick_string(@data.company_buzzword_heads(locale), rng)
  })
}

///|
/// Generate the middle part of a company buzzword phrase.
pub fn buzzword_middle(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    @core.pick_string(@data.company_buzzword_middles(locale), rng)
  })
}

///|
/// Generate the tail part of a company buzzword phrase.
pub fn buzzword_tail(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    @core.pick_string(@data.company_buzzword_tails(locale), rng)
  })
}

///|
/// Generate a three-part business catch phrase.
pub fn catch_phrase(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let head = buzzword(locale~).dummy(rng)
    let middle = buzzword_middle(locale~).dummy(rng)
    let tail = buzzword_tail(locale~).dummy(rng)
    @core.render_template(@data.company_catch_phrase_template(locale), [
      ("{Head}", head),
      ("{Middle}", middle),
      ("{Tail}", tail),
    ])
  })
}

///|
/// Generate a business-speak verb.
pub fn bs_verb(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.company_bs_verbs(locale), rng))
}

///|
/// Generate a business-speak adjective.
pub fn bs_adj(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.company_bs_adjs(locale), rng))
}

///|
/// Generate a business-speak noun.
pub fn bs_noun(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.company_bs_nouns(locale), rng))
}

///|
/// Generate a complete business-speak phrase.
pub fn bs(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let verb = bs_verb(locale~).dummy(rng)
    let adj = bs_adj(locale~).dummy(rng)
    let noun = bs_noun(locale~).dummy(rng)
    @core.render_template(@data.company_bs_template(locale), [
      ("{Verb}", verb),
      ("{Adj}", adj),
      ("{Noun}", noun),
    ])
  })
}

///|
/// Generate a profession label.
pub fn profession(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    @core.pick_string(@data.company_professions(locale), rng)
  })
}

///|
/// Generate an industry label.
pub fn industry(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.company_industries(locale), rng))
}

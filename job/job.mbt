///|
/// Generate a job seniority segment.
pub fn seniority(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.job_seniority(locale), rng))
}

///|
/// Generate a job field segment.
pub fn field(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.job_fields(locale), rng))
}

///|
/// Generate a job position segment.
pub fn position(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => @core.pick_string(@data.job_positions(locale), rng))
}

///|
/// Generate a full job title from locale-specific job templates.
pub fn title(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let seniority = seniority(locale~).dummy(rng)
    let field = field(locale~).dummy(rng)
    let position = position(locale~).dummy(rng)
    @core.render_template(@data.job_title_template(locale), [
      ("{Seniority}", seniority),
      ("{Field}", field),
      ("{Position}", position),
    ])
  })
}

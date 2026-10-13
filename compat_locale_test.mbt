///|
struct CompatLocalePortCase {
  compat_file : String
  locale : @locales.Locale
  facade : @locales.Locale
}

///|
fn compat_locale_port_cases() -> Array[CompatLocalePortCase] {
  [
    { compat_file: "ar_sa.rs", locale: @locales.AR_SA, facade: @dummy.ar_sa, },
    { compat_file: "cy_gb.rs", locale: @locales.CY_GB, facade: @dummy.cy_gb, },
    { compat_file: "de_de.rs", locale: @locales.DE_DE, facade: @dummy.de_de, },
    { compat_file: "en.rs", locale: @locales.EN, facade: @dummy.en, },
    { compat_file: "fa_ir.rs", locale: @locales.FA_IR, facade: @dummy.fa_ir, },
    { compat_file: "fr_fr.rs", locale: @locales.FR_FR, facade: @dummy.fr_fr, },
    { compat_file: "it_it.rs", locale: @locales.IT_IT, facade: @dummy.it_it, },
    { compat_file: "ja_jp.rs", locale: @locales.JA_JP, facade: @dummy.ja_jp, },
    { compat_file: "nl_nl.rs", locale: @locales.NL_NL, facade: @dummy.nl_nl, },
    { compat_file: "pt_br.rs", locale: @locales.PT_BR, facade: @dummy.pt_br, },
    { compat_file: "pt_pt.rs", locale: @locales.PT_PT, facade: @dummy.pt_pt, },
    { compat_file: "tr_tr.rs", locale: @locales.TR_TR, facade: @dummy.tr_tr, },
    { compat_file: "zh_cn.rs", locale: @locales.ZH_CN, facade: @dummy.zh_cn, },
    { compat_file: "zh_tw.rs", locale: @locales.ZH_TW, facade: @dummy.zh_tw, },
  ]
}

///|
fn compat_locale_data_port_seed() -> Bytes {
  b"compat-locale-data-port"
}

///|
fn assert_locale_backed_string_port(
  case : CompatLocalePortCase,
  generator_name : String,
  gen : @core.Gen[String],
) -> Unit raise {
  let count = 4
  let left = gen.sample(count~, @dummy.seed(compat_locale_data_port_seed()))
  let right = gen.sample(count~, @dummy.seed(compat_locale_data_port_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    if value.is_empty() {
      fail(
        "\{case.compat_file} \{case.locale.code()} \{generator_name} produced an empty value",
      )
    }
  }
}

///|
test "locale modules have MoonBit locale and facade constants" {
  let cases = compat_locale_port_cases()
  @test.assert_eq(cases.length(), 14)
  let compat_files = cases.map(case => case.compat_file).join("|")
  @test.assert_eq(
    compat_files, "ar_sa.rs|cy_gb.rs|de_de.rs|en.rs|fa_ir.rs|fr_fr.rs|it_it.rs|ja_jp.rs|nl_nl.rs|pt_br.rs|pt_pt.rs|tr_tr.rs|zh_cn.rs|zh_tw.rs",
  )
  let locale_codes = cases.map(case => case.locale.code()).join("|")
  @test.assert_eq(
    locale_codes, "ar_SA|cy_GB|de_DE|en|fa_IR|fr_FR|it_IT|ja_JP|nl_NL|pt_BR|pt_PT|tr_TR|zh_CN|zh_TW",
  )
  let exported_codes = @locales.all().map(locale => locale.code()).join("|")
  @test.assert_eq(
    exported_codes, "en|fr_FR|zh_TW|zh_CN|ja_JP|ar_SA|pt_BR|pt_PT|de_DE|it_IT|cy_GB|nl_NL|tr_TR|fa_IR",
  )
  for case in cases {
    if case.locale != case.facade {
      fail("\{case.compat_file} facade constant does not match locale constant")
    }
  }
}

///|
test "locale-backed facade generators are non-empty and deterministic" {
  for case in compat_locale_port_cases() {
    let locale = case.facade
    assert_locale_backed_string_port(
      case,
      "first_name",
      @dummy.first_name(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "last_name",
      @dummy.last_name(locale~),
    )
    assert_locale_backed_string_port(case, "name", @dummy.name(locale~))
    assert_locale_backed_string_port(case, "word", @dummy.word(locale~))
    assert_locale_backed_string_port(
      case,
      "sentence",
      @dummy.sentence(locale~, count=@dummy.count_range(2, 2)),
    )
    assert_locale_backed_string_port(
      case,
      "city_name",
      @dummy.city_name(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "country_name",
      @dummy.country_name(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "street_name",
      @dummy.street_name(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "company_name",
      @dummy.company_name(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "phone_number",
      @dummy.phone_number(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "free_email_provider",
      @dummy.free_email_provider(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "domain_suffix",
      @dummy.domain_suffix(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "currency_name",
      @dummy.currency_name(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "job_title",
      @dummy.job_title(locale~),
    )
    assert_locale_backed_string_port(
      case,
      "time_date",
      @dummy.time_date(locale~),
    )
  }
}

///|
fn locale_extra_contains(items : ArrayView[String], needle : String) -> Bool {
  for item in items {
    if item == needle {
      return true
    }
  }
  false
}

///|
fn locale_extra_sample_contains(
  label : String,
  gen : @core.Gen[String],
  needle : String,
  count~ : Int32 = 512,
) -> Unit raise {
  let samples = gen.sample(count~, @dummy.seed(b"compat-locale-extra-values"))
  if !locale_extra_contains(samples, needle) {
    fail("\{label} did not sample value: \{needle}")
  }
}

///|
fn locale_extra_same_samples(
  label : String,
  left : @core.Gen[String],
  right : @core.Gen[String],
) -> Unit raise {
  let seed = b"compat-locale-extra-fallback"
  @test.assert_eq(
    left.sample(count=48, @dummy.seed(seed)),
    right.sample(count=48, @dummy.seed(seed)),
    msg="\{label} should fall back to the default table",
  )
}

///|
fn locale_extra_has_any_suffix(
  value : String,
  suffixes : ArrayView[String],
) -> Bool {
  for suffix in suffixes {
    if value.has_suffix(suffix) {
      return true
    }
  }
  false
}

///|
test "locale metadata keeps module order and first-wave markers" {
  @test.assert_eq(@locales.all().length(), 14)
  @test.assert_eq(
    @locales.all().map(locale => locale.code()).join("|"),
    "en|fr_FR|zh_TW|zh_CN|ja_JP|ar_SA|pt_BR|pt_PT|de_DE|it_IT|cy_GB|nl_NL|tr_TR|fa_IR",
  )
  @test.assert_eq(
    @locales.all().map(locale => locale.display_name()).join("|"),
    "English|French (France)|Chinese (Taiwan)|Chinese (China)|Japanese (Japan)|Arabic (Saudi Arabia)|Portuguese (Brazil)|Portuguese (Portugal)|German (Germany)|Italian (Italy)|Welsh (United Kingdom)|Dutch (Netherlands)|Turkish (Turkey)|Persian (Iran)",
  )
  let first_wave_codes : Array[String] = []
  for locale in @locales.all() {
    if locale.has_first_wave_data() {
      first_wave_codes.push(locale.code())
    }
  }
  @test.assert_eq(first_wave_codes.join("|"), "en|zh_TW|zh_CN")
}

///|
test "locale accessors preserve fallback contracts through facade" {
  locale_extra_same_samples(
    "ar_SA title",
    @dummy.title(locale=@dummy.ar_sa),
    @dummy.title(locale=@dummy.en),
  )
  locale_extra_same_samples(
    "ar_SA suffix",
    @dummy.suffix(locale=@dummy.ar_sa),
    @dummy.suffix(locale=@dummy.en),
  )
  locale_extra_same_samples(
    "fr_FR domain_suffix",
    @dummy.domain_suffix(locale=@dummy.fr_fr),
    @dummy.domain_suffix(locale=@dummy.en),
  )
  locale_extra_same_samples(
    "cy_GB currency_symbol",
    @dummy.currency_symbol(locale=@dummy.cy_gb),
    @dummy.currency_symbol(locale=@dummy.en),
  )
  locale_extra_same_samples(
    "tr_TR industry",
    @dummy.industry(locale=@dummy.tr_tr),
    @dummy.industry(locale=@dummy.en),
  )
}

///|
test "locale representative name and company values sample via facade" {
  locale_extra_sample_contains(
    "fr_FR NAME_TITLE",
    @dummy.title(locale=@dummy.fr_fr),
    "Mme",
    count=64,
  )
  locale_extra_sample_contains(
    "de_DE NAME_TITLE",
    @dummy.title(locale=@dummy.de_de),
    "Herr",
    count=64,
  )
  locale_extra_sample_contains(
    "tr_TR NAME_SUFFIX",
    @dummy.suffix(locale=@dummy.tr_tr),
    "Hanım",
    count=64,
  )
  locale_extra_sample_contains(
    "ja_JP COMPANY_SUFFIX",
    @dummy.company_suffix(locale=@dummy.ja_jp),
    "株式会社",
    count=128,
  )
  locale_extra_sample_contains(
    "fa_IR COMPANY_SUFFIX",
    @dummy.company_suffix(locale=@dummy.fa_ir),
    "تعاونی",
    count=128,
  )
  locale_extra_sample_contains(
    "it_IT COMPANY_BS_VERBS",
    @dummy.bs_verb(locale=@dummy.it_it),
    "implementare",
    count=128,
  )
  locale_extra_sample_contains(
    "pt_PT COMPANY_PROFESSION",
    @dummy.profession(locale=@dummy.pt_pt),
    "programador",
    count=256,
  )
  locale_extra_sample_contains(
    "zh_CN COMPANY_PROFESSION",
    @dummy.profession(locale=@dummy.zh_cn),
    "程序员",
    count=1024,
  )
}

///|
test "locale representative address and internet values sample via facade" {
  locale_extra_sample_contains(
    "de_DE ADDRESS_SECONDARY_ADDR_TYPE",
    @dummy.secondary_address_type(locale=@dummy.de_de),
    "Gebäude",
    count=128,
  )
  locale_extra_sample_contains(
    "it_IT ADDRESS_SECONDARY_ADDR_TYPE",
    @dummy.secondary_address_type(locale=@dummy.it_it),
    "Interno",
    count=128,
  )
  locale_extra_sample_contains(
    "nl_NL ADDRESS_SECONDARY_ADDR_TYPE",
    @dummy.secondary_address_type(locale=@dummy.nl_nl),
    "Oprit",
    count=128,
  )
  locale_extra_sample_contains(
    "fa_IR INTERNET_FREE_EMAIL_PROVIDER",
    @dummy.free_email_provider(locale=@dummy.fa_ir),
    "mailma.ir",
    count=128,
  )
  locale_extra_sample_contains(
    "it_IT INTERNET_FREE_EMAIL_PROVIDER",
    @dummy.free_email_provider(locale=@dummy.it_it),
    "libero.it",
    count=128,
  )
  locale_extra_sample_contains(
    "nl_NL INTERNET_DOMAIN_SUFFIX",
    @dummy.domain_suffix(locale=@dummy.nl_nl),
    "nl",
    count=64,
  )
  locale_extra_sample_contains(
    "tr_TR ADDRESS_STATE",
    @dummy.state_name(locale=@dummy.tr_tr),
    "İstanbul",
    count=256,
  )
  locale_extra_sample_contains(
    "tr_TR ADDRESS_STATE_ABBR",
    @dummy.state_abbr(locale=@dummy.tr_tr),
    "34",
    count=256,
  )
  locale_extra_sample_contains(
    "it_IT ADDRESS_TIME_ZONE",
    @dummy.time_zone(locale=@dummy.it_it),
    "Europe/Rome",
    count=8,
  )
  locale_extra_sample_contains(
    "nl_NL ADDRESS_TIME_ZONE",
    @dummy.time_zone(locale=@dummy.nl_nl),
    "Europe/Amsterdam",
    count=8,
  )
  locale_extra_sample_contains(
    "pt_PT ADDRESS_TIME_ZONE",
    @dummy.time_zone(locale=@dummy.pt_pt),
    "Atlantic/Madeira",
    count=64,
  )
}

///|
test "locale templates keep visible facade shape" {
  let rng = @dummy.seed(b"compat-locale-extra-shapes")
  let ja_name = @dummy.name(locale=@dummy.ja_jp).dummy(rng)
  assert_true(ja_name.contains(" "))
  let ja_name_with_title = @dummy.name_with_title(locale=@dummy.ja_jp).dummy(
    rng,
  )
  assert_true(!ja_name_with_title.contains(" "))
  assert_true(ja_name_with_title.has_suffix("様"))
  let zh_name = @dummy.name(locale=@dummy.zh_cn).dummy(rng)
  assert_true(!zh_name.contains(" "))
  let zh_name_with_title = @dummy.name_with_title(locale=@dummy.zh_tw).dummy(
    rng,
  )
  assert_true(!zh_name_with_title.contains(" "))
  assert_true(
    locale_extra_has_any_suffix(zh_name_with_title, [
      "先生", "夫人", "女士", "小姐", "博士",
    ]),
  )
  let fa_bs = @dummy.bs(locale=@dummy.fa_ir).dummy(rng)
  assert_true(fa_bs.contains(" "))
  let it_bs = @dummy.bs(locale=@dummy.it_it).dummy(rng)
  assert_true(it_bs.contains(" "))
  let zh_bs = @dummy.bs(locale=@dummy.zh_cn).dummy(rng)
  assert_true(!zh_bs.contains(" "))
}

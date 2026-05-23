///|
fn docs_catalog_seed() -> Bytes {
  b"compat-docs-catalog"
}

///|
fn docs_catalog_assert_string(
  name : String,
  gen : @core.Gen[String],
  allow_empty~ : Bool = false,
) -> Unit raise {
  let left = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  let right = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 3)
  for value in left {
    if !allow_empty && value.is_empty() {
      fail("\{name} produced an empty sample")
    }
  }
}

///|
fn docs_catalog_assert_string_array(
  name : String,
  gen : @core.Gen[Array[String]],
) -> Unit raise {
  let left = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  let right = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 3)
  for values in left {
    if values.is_empty() {
      fail("\{name} produced an empty array")
    }
    for value in values {
      if value.is_empty() {
        fail("\{name} produced an empty array item")
      }
    }
  }
}

///|
fn docs_catalog_assert_int(
  name : String,
  gen : @core.Gen[Int32],
  valid : (Int32) -> Bool,
) -> Unit raise {
  let left = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  let right = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 3)
  for value in left {
    if !valid(value) {
      fail("\{name} produced an invalid sample")
    }
  }
}

///|
fn docs_catalog_assert_bool(gen : @core.Gen[Bool]) -> Unit raise {
  let left = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  let right = gen.sample(count=3, @dummy.seed(docs_catalog_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 3)
}

///|
fn docs_catalog_assert_locale(
  docs_code : String,
  locale : @locales.Locale,
) -> Unit raise {
  docs_catalog_assert_string(
    "locale " + docs_code + " name",
    @dummy.name(locale~),
  )
  docs_catalog_assert_string(
    "locale " + docs_code + " sentence",
    @dummy.sentence(locale~, count=@dummy.count_range(2, 2)),
  )
}

///|
test "docs locales generate non-empty deterministic names and sentences" {
  let docs = @dummy.docs_locales()
  for item in docs {
    docs_catalog_assert_locale(item.docs_code, item.locale)
  }
}

///|
test "person address internet and image generators produce valid samples" {
  docs_catalog_assert_string("first_name", @dummy.first_name())
  docs_catalog_assert_string("last_name", @dummy.last_name())
  docs_catalog_assert_string("title", @dummy.title())
  docs_catalog_assert_string("suffix", @dummy.suffix())
  docs_catalog_assert_string("name", @dummy.name())
  docs_catalog_assert_string("name_with_title", @dummy.name_with_title())
  docs_catalog_assert_string("city_prefix", @dummy.city_prefix())
  docs_catalog_assert_string("city_suffix", @dummy.city_suffix())
  docs_catalog_assert_string("city_name", @dummy.city_name())
  docs_catalog_assert_string("country_name", @dummy.country_name())
  docs_catalog_assert_string("country_code", @dummy.country_code())
  docs_catalog_assert_string("street_suffix", @dummy.street_suffix())
  docs_catalog_assert_string("street_name", @dummy.street_name())
  docs_catalog_assert_string("time_zone", @dummy.time_zone())
  docs_catalog_assert_string("state_name", @dummy.state_name())
  docs_catalog_assert_string("state_abbr", @dummy.state_abbr())
  docs_catalog_assert_string(
    "secondary_address_type",
    @dummy.secondary_address_type(),
  )
  docs_catalog_assert_string("secondary_address", @dummy.secondary_address())
  docs_catalog_assert_string("zip_code", @dummy.zip_code())
  docs_catalog_assert_string("post_code", @dummy.post_code())
  docs_catalog_assert_string("building_number", @dummy.building_number())
  docs_catalog_assert_string("latitude", @dummy.latitude())
  docs_catalog_assert_string("longitude", @dummy.longitude())
  docs_catalog_assert_string("geohash", @dummy.geohash(precision=8))
  docs_catalog_assert_string(
    "free_email_provider",
    @dummy.free_email_provider(),
  )
  docs_catalog_assert_string("domain_suffix", @dummy.domain_suffix())
  docs_catalog_assert_string("free_email", @dummy.free_email())
  docs_catalog_assert_string("safe_email", @dummy.safe_email())
  docs_catalog_assert_string("username", @dummy.username())
  docs_catalog_assert_string(
    "password",
    @dummy.password(len_range=@dummy.count_range(8, 8)),
  )
  docs_catalog_assert_string("ipv4", @dummy.ipv4())
  docs_catalog_assert_string("ipv6", @dummy.ipv6())
  docs_catalog_assert_string("ip", @dummy.ip())
  docs_catalog_assert_string("mac_address", @dummy.mac_address())
  docs_catalog_assert_string("user_agent", @dummy.user_agent())
  docs_catalog_assert_string("picsum_image", @dummy.picsum_image())
  docs_catalog_assert_string(
    "picsum_image_with_seed",
    @dummy.picsum_image_with_seed(),
  )
  docs_catalog_assert_string(
    "picsum_image_grayscale",
    @dummy.picsum_image_grayscale(),
  )
  docs_catalog_assert_string("picsum_image_blur", @dummy.picsum_image_blur())
  docs_catalog_assert_string(
    "picsum_image_custom",
    @dummy.picsum_image_custom(
      @dummy.image_options(
        width=320,
        height=240,
        grayscale=true,
        blur=4,
        seed="docs",
      ),
    ),
  )
}

///|
test "lorem company job phone and markdown generators produce valid samples" {
  docs_catalog_assert_string("word", @dummy.word())
  docs_catalog_assert_string_array(
    "words",
    @dummy.words(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "sentence",
    @dummy.sentence(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string_array(
    "sentences",
    @dummy.sentences(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "paragraph",
    @dummy.paragraph(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string_array(
    "paragraphs",
    @dummy.paragraphs(count=@dummy.count_range(1, 1)),
  )
  docs_catalog_assert_string("company_suffix", @dummy.company_suffix())
  docs_catalog_assert_string("company_name", @dummy.company_name())
  docs_catalog_assert_string("buzzword", @dummy.buzzword())
  docs_catalog_assert_string("buzzword_middle", @dummy.buzzword_middle())
  docs_catalog_assert_string("buzzword_tail", @dummy.buzzword_tail())
  docs_catalog_assert_string("catch_phrase", @dummy.catch_phrase())
  docs_catalog_assert_string("bs_verb", @dummy.bs_verb())
  docs_catalog_assert_string("bs_adj", @dummy.bs_adj())
  docs_catalog_assert_string("bs_noun", @dummy.bs_noun())
  docs_catalog_assert_string("bs", @dummy.bs())
  docs_catalog_assert_string("profession", @dummy.profession())
  docs_catalog_assert_string("industry", @dummy.industry())
  docs_catalog_assert_string("job_seniority", @dummy.job_seniority())
  docs_catalog_assert_string("job_field", @dummy.job_field())
  docs_catalog_assert_string("job_position", @dummy.job_position())
  docs_catalog_assert_string("job_title", @dummy.job_title())
  docs_catalog_assert_string("phone_number", @dummy.phone_number())
  docs_catalog_assert_string("cell_number", @dummy.cell_number())
  docs_catalog_assert_string("italic_word", @dummy.italic_word())
  docs_catalog_assert_string("bold_word", @dummy.bold_word())
  docs_catalog_assert_string("markdown_link", @dummy.markdown_link())
  docs_catalog_assert_string(
    "bullet_points",
    @dummy.bullet_points(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string_array(
    "list_items",
    @dummy.list_items(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "block_quote_single_line",
    @dummy.block_quote_single_line(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "block_quote_multi_line",
    @dummy.block_quote_multi_line(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "markdown_code",
    @dummy.markdown_code(count=@dummy.count_range(2, 2)),
  )
}

///|
test "numeric finance filesystem and regional generators produce valid samples" {
  docs_catalog_assert_string("hex_color", @dummy.hex_color())
  docs_catalog_assert_string("rgb_color", @dummy.rgb_color())
  docs_catalog_assert_string("rgba_color", @dummy.rgba_color())
  docs_catalog_assert_string("hsl_color", @dummy.hsl_color())
  docs_catalog_assert_string("hsla_color", @dummy.hsla_color())
  docs_catalog_assert_string("color", @dummy.color())
  docs_catalog_assert_string("chrono_time", @dummy.chrono_time())
  docs_catalog_assert_string("chrono_date", @dummy.chrono_date())
  docs_catalog_assert_string("chrono_date_time", @dummy.chrono_date_time())
  docs_catalog_assert_int("chrono_duration", @dummy.chrono_duration(), value => {
    value >= 0
  })
  docs_catalog_assert_string(
    "chrono_date_time_before",
    @dummy.chrono_date_time_before(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "chrono_date_time_after",
    @dummy.chrono_date_time_after(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "chrono_date_time_between",
    @dummy.chrono_date_time_between(0, 10),
  )
  docs_catalog_assert_string("time_time", @dummy.time_time())
  docs_catalog_assert_string("time_date", @dummy.time_date())
  docs_catalog_assert_string("time_date_time", @dummy.time_date_time())
  docs_catalog_assert_int("time_duration", @dummy.time_duration(), value => {
    value >= 0
  })
  docs_catalog_assert_string(
    "time_date_time_before",
    @dummy.time_date_time_before(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "time_date_time_after",
    @dummy.time_date_time_after(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "time_date_time_between",
    @dummy.time_date_time_between(0, 10),
  )
  docs_catalog_assert_string("digit_string", @dummy.digit_string())
  docs_catalog_assert_int("digit", @dummy.digit(), value => {
    value >= 0 && value <= 9
  })
  docs_catalog_assert_string(
    "number_with_format",
    @dummy.number_with_format("##-^^"),
  )
  docs_catalog_assert_bool(@dummy.boolean(ratio=50))
  docs_catalog_assert_string("currency_code", @dummy.currency_code())
  docs_catalog_assert_string("currency_name", @dummy.currency_name())
  docs_catalog_assert_string("currency_symbol", @dummy.currency_symbol())
  docs_catalog_assert_string("bic", @dummy.bic())
  docs_catalog_assert_string("isin", @dummy.isin())
  docs_catalog_assert_string("credit_card_number", @dummy.credit_card_number())
  docs_catalog_assert_string("isbn", @dummy.isbn())
  docs_catalog_assert_string("isbn10", @dummy.isbn10())
  docs_catalog_assert_string("isbn13", @dummy.isbn13())
  docs_catalog_assert_string("file_path", @dummy.file_path())
  docs_catalog_assert_string("file_name", @dummy.file_name())
  docs_catalog_assert_string("file_extension", @dummy.file_extension())
  docs_catalog_assert_string("dir_path", @dummy.dir_path())
  docs_catalog_assert_string("mime_type", @dummy.mime_type())
  docs_catalog_assert_string("semver", @dummy.semver())
  docs_catalog_assert_string("semver_stable", @dummy.semver_stable())
  docs_catalog_assert_string("semver_unstable", @dummy.semver_unstable())
  docs_catalog_assert_int("rfc_status_code", @dummy.rfc_status_code(), value => {
    value >= 100 && value <= 599
  })
  docs_catalog_assert_int("valid_status_code", @dummy.valid_status_code(), value => {
    value >= 100 && value <= 599
  })
  docs_catalog_assert_string("http_method", @dummy.http_method())
  docs_catalog_assert_string(
    "health_insurance_code",
    @dummy.health_insurance_code(locale=@dummy.fr_fr),
  )
  docs_catalog_assert_string(
    "licence_plate",
    @dummy.licence_plate(locale=@dummy.fr_fr),
  )
}

///|
test "identifier and encoding generators produce deterministic strings" {
  docs_catalog_assert_string("uuid", @dummy.uuid())
  docs_catalog_assert_string("uuid_v1", @dummy.uuid_v1())
  docs_catalog_assert_string("uuid_v3", @dummy.uuid_v3())
  docs_catalog_assert_string("uuid_v4", @dummy.uuid_v4())
  docs_catalog_assert_string("uuid_v5", @dummy.uuid_v5())
  docs_catalog_assert_string("uuid_v6", @dummy.uuid_v6())
  docs_catalog_assert_string("uuid_v7", @dummy.uuid_v7())
  docs_catalog_assert_string("uuid_v8", @dummy.uuid_v8())
  docs_catalog_assert_string("ulid", @dummy.ulid())
  docs_catalog_assert_string("bson_object_id", @dummy.bson_object_id())
  docs_catalog_assert_string("bson_oid", @dummy.bson_oid())
  docs_catalog_assert_string("base64", @dummy.base64(), allow_empty=true)
  docs_catalog_assert_string(
    "base64_padded",
    @dummy.base64_padded(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "base64_no_pad",
    @dummy.base64_no_pad(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "url_safe_base64",
    @dummy.url_safe_base64(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "url_safe_base64_padded",
    @dummy.url_safe_base64_padded(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "url_safe_base64_no_pad",
    @dummy.url_safe_base64_no_pad(),
    allow_empty=true,
  )
}

///|
struct FcLocaleCase {
  docs_code : String
  locale : @locales.Locale
} derive(Eq, Debug)

///|
fn fc_compat_docs_locales() -> Array[FcLocaleCase] {
  [
    { docs_code: "EN", locale: EN, },
    { docs_code: "FR_FR", locale: FR_FR, },
    { docs_code: "AR_SA", locale: AR_SA, },
    { docs_code: "ZH_TW", locale: ZH_TW, },
    { docs_code: "ZH_CN", locale: ZH_CN, },
    { docs_code: "JA_JP", locale: JA_JP, },
    { docs_code: "PT_BR", locale: PT_BR, },
    { docs_code: "PT_PT", locale: PT_PT, },
    { docs_code: "DE_DE", locale: DE_DE, },
    { docs_code: "IT_IT", locale: IT_IT, },
    { docs_code: "CY_GB", locale: CY_GB, },
    { docs_code: "NL_NL", locale: NL_NL, },
    { docs_code: "FA_IR", locale: FA_IR, },
  ]
}

///|
fn fc_assert_non_empty_sequence(
  name : String,
  gen : @core.Gen[String],
  allow_empty~ : Bool = false,
) -> Unit raise {
  let left = gen.sample(count=4, @dummy.seed(b"compat-feature-catalog"))
  let right = gen.sample(count=4, @dummy.seed(b"compat-feature-catalog"))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 4)
  if !allow_empty {
    for value in left {
      if value.is_empty() {
        fail("\{name} produced an empty generated value")
      }
    }
  }
}

///|
test "documentation locales generate non-empty deterministic names" {
  let locales = fc_compat_docs_locales()
  for item in locales {
    fc_assert_non_empty_sequence(
      "docs locale " + item.docs_code,
      @dummy.name(locale=item.locale),
    )
  }
}

///|
test "facade generators produce deterministic samples and valid choices" {
  fc_assert_non_empty_sequence("chrono_date_time", @dummy.chrono_date_time())
  fc_assert_non_empty_sequence("ulid", @dummy.ulid())
  fc_assert_non_empty_sequence("uuid_v8", @dummy.uuid_v8())
  fc_assert_non_empty_sequence("color", @dummy.color())
  fc_assert_non_empty_sequence("geohash", @dummy.geohash(precision=8))
  fc_assert_non_empty_sequence("semver", @dummy.semver())
  fc_assert_non_empty_sequence("time_date_time", @dummy.time_date_time())
  fc_assert_non_empty_sequence("base64", @dummy.base64(), allow_empty=true)
  fc_assert_non_empty_sequence("bson_oid", @dummy.bson_oid())
  let status = @dummy.rfc_status_code().sample(
    count=4,
    @dummy.seed(b"compat-feature-http"),
  )
  for code in status {
    assert_true(code >= 100 && code < 600)
  }
  let either_phone = @dummy.one_of([@dummy.phone_number(), @dummy.cell_number()]).dummy(
    @dummy.seed(b"compat-feature-either"),
  )
  assert_true(!either_phone.is_empty())
}

///|
fn ddt_seed(label : String) -> Bytes {
  ignore(label)
  b"compat-docs-data-port"
}

///|
fn ddt_assert_non_empty(name : String, value : String) -> Unit raise {
  if value.is_empty() {
    fail("\{name} produced an empty docs-data sample")
  }
}

///|
fn ddt_assert_string_samples(
  name : String,
  gen : @core.Gen[String],
  count~ : Int32 = 4,
) -> Array[String] raise {
  let seed_bytes = ddt_seed(name)
  let left = gen.sample(count~, @dummy.seed(seed_bytes))
  let right = gen.sample(count~, @dummy.seed(seed_bytes))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    ddt_assert_non_empty(name, value)
  }
  left
}

///|
fn ddt_assert_int_samples(
  name : String,
  gen : @core.Gen[Int32],
  count~ : Int32 = 4,
  valid~ : (Int32) -> Bool = _ => true,
) -> Array[Int32] raise {
  let seed_bytes = ddt_seed(name)
  let left = gen.sample(count~, @dummy.seed(seed_bytes))
  let right = gen.sample(count~, @dummy.seed(seed_bytes))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    if !valid(value) {
      fail("\{name} produced an invalid docs-data sample: \{value}")
    }
  }
  left
}

///|
fn ddt_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn ddt_is_nonzero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn ddt_is_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  ddt_is_digit(ch) ||
  (code >= 'a'.to_int() && code <= 'f'.to_int()) ||
  (code >= 'A'.to_int() && code <= 'F'.to_int())
}

///|
fn ddt_char_at_is(s : String, index : Int32, pred : (Char) -> Bool) -> Bool {
  match s.get_char(index) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn ddt_count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn ddt_valid_email(s : String) -> Bool {
  if ddt_count_char(s, '@') != 1 || s.has_prefix("@") || s.has_suffix("@") {
    return false
  }
  let mut seen_at = false
  let mut domain_has_dot = false
  for ch in s {
    if ch == '@' {
      seen_at = true
    } else if ch == ' ' {
      return false
    } else if seen_at && ch == '.' {
      domain_has_dot = true
    }
  }
  domain_has_dot && !s.has_suffix(".")
}

///|
fn ddt_valid_phone(s : String) -> Bool {
  if s.is_empty() || s.contains("#") || s.contains("^") {
    return false
  }
  for ch in s {
    if !(ddt_is_digit(ch) ||
      ch == '+' ||
      ch == '-' ||
      ch == '.' ||
      ch == '(' ||
      ch == ')' ||
      ch == ' ' ||
      ch == 'x') {
      return false
    }
  }
  true
}

///|
fn ddt_valid_uuid(s : String, version : Char) -> Bool {
  if s.length() != 36 ||
    s.get_char(8) != Some('-') ||
    s.get_char(13) != Some('-') ||
    s.get_char(18) != Some('-') ||
    s.get_char(23) != Some('-') ||
    s.get_char(14) != Some(version) {
    return false
  }
  for i in 0..<36 {
    if i != 8 && i != 13 && i != 18 && i != 23 {
      if !ddt_char_at_is(s, i, ddt_is_hex) {
        return false
      }
    }
  }
  true
}

///|
fn ddt_valid_base64_or_empty(s : String, url_safe : Bool) -> Bool {
  for ch in s {
    let code = ch.to_int()
    let alpha = (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
      (code >= 'a'.to_int() && code <= 'z'.to_int())
    if !(alpha ||
      ddt_is_digit(ch) ||
      ch == '=' ||
      (url_safe && (ch == '-' || ch == '_')) ||
      (!url_safe && (ch == '+' || ch == '/'))) {
      return false
    }
  }
  true
}

///|
fn ddt_assert_number_format(value : String, fmt : String) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') => assert_true(ddt_char_at_is(value, i, ddt_is_nonzero_digit))
      Some('#') => assert_true(ddt_char_at_is(value, i, ddt_is_digit))
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing docs-data format character")
    }
  }
}

///|
test "locale and default facade calls produce valid samples" {
  let rng = @dummy.seed(ddt_seed("examples-locales"))
  let en_name = @dummy.name(locale=@dummy.en).dummy(rng)
  let zh_name = @dummy.name(locale=@dummy.zh_cn).dummy(rng)
  let ja_name = @dummy.name(locale=@dummy.ja_jp).dummy(rng)
  ddt_assert_non_empty("name(locale=@dummy.en)", en_name)
  ddt_assert_non_empty("name(locale=@dummy.zh_cn)", zh_name)
  ddt_assert_non_empty("name(locale=@dummy.ja_jp)", ja_name)
  let words = @dummy.words(locale=@dummy.en, count=@dummy.count_range(3, 5)).dummy(
    rng,
  )
  assert_true(words.length() >= 3 && words.length() <= 5)
  for word in words {
    ddt_assert_non_empty(
      "words(locale=@dummy.en, count=@dummy.count_range(3, 5))", word,
    )
  }
  let sentence = @dummy.sentence(
    locale=@dummy.fr_fr,
    count=@dummy.count_range(5, 10),
  ).dummy(rng)
  ddt_assert_non_empty(
    "sentence(locale=@dummy.fr_fr, count=@dummy.count_range(5, 10))", sentence,
  )
  let email = @dummy.safe_email().dummy(rng)
  assert_true(ddt_valid_email(email))
  assert_true(email.contains("@example."))
  let password = @dummy.password(len_range=@dummy.count_range(10, 20)).dummy(
    rng,
  )
  assert_true(password.length() >= 10 && password.length() <= 20)
  ddt_assert_non_empty("city_name()", @dummy.city_name().dummy(rng))
  ddt_assert_non_empty("country_name()", @dummy.country_name().dummy(rng))
}

///|
test "facade samples respect ranges counts and deterministic seeds" {
  for
    id in ddt_assert_int_samples(
      "int",
      @dummy.int(range=@dummy.int_range(1000, 9999)),
      count=12,
      valid=value => value >= 1000 && value < 9999,
    ) {
    assert_true(id >= 1000 && id < 9999)
  }
  let username_like = @dummy.password(len_range=@dummy.count_range(5, 15)).dummy(
    @dummy.seed(ddt_seed("range-string")),
  )
  assert_true(username_like.length() >= 5 && username_like.length() <= 15)
  let names = @dummy.name().sample(
    count=10,
    @dummy.seed(ddt_seed("collections")),
  )
  @test.assert_eq(names.length(), 10)
  for name in names {
    ddt_assert_non_empty("name().sample(count=10, rng)", name)
  }
  let gen = @dummy.one_of([
    @dummy.name(),
    @dummy.company_name(),
    @dummy.safe_email(),
  ])
  let left = gen.sample(count=8, @dummy.seed(ddt_seed("seeded-rng")))
  let right = gen.sample(count=8, @dummy.seed(ddt_seed("seeded-rng")))
  @test.assert_eq(left, right)
}

///|
test "date time uuid http picsum and one_of generators produce valid samples" {
  ignore(ddt_assert_string_samples("chrono_date", @dummy.chrono_date()))
  ignore(ddt_assert_string_samples("chrono_time", @dummy.chrono_time()))
  ignore(
    ddt_assert_string_samples("chrono_date_time", @dummy.chrono_date_time()),
  )
  ignore(
    ddt_assert_string_samples(
      "chrono_date_time_before",
      @dummy.chrono_date_time_before(anchor_minutes=1000),
    ),
  )
  ignore(
    ddt_assert_string_samples(
      "chrono_date_time_after",
      @dummy.chrono_date_time_after(anchor_minutes=1000),
    ),
  )
  ignore(
    ddt_assert_string_samples(
      "chrono_date_time_between",
      @dummy.chrono_date_time_between(0, 30 * 24 * 60),
    ),
  )
  ignore(ddt_assert_string_samples("time_date", @dummy.time_date()))
  ignore(ddt_assert_string_samples("time_time", @dummy.time_time()))
  for uuid in @dummy.uuid_v1().sample(count=4, @dummy.seed(ddt_seed("uuid-v1"))) {
    assert_true(ddt_valid_uuid(uuid, '1'))
  }
  for uuid in @dummy.uuid_v4().sample(count=4, @dummy.seed(ddt_seed("uuid-v4"))) {
    assert_true(ddt_valid_uuid(uuid, '4'))
  }
  for uuid in @dummy.uuid_v7().sample(count=4, @dummy.seed(ddt_seed("uuid-v7"))) {
    assert_true(ddt_valid_uuid(uuid, '7'))
  }
  ignore(
    ddt_assert_int_samples("rfc_status_code", @dummy.rfc_status_code(), valid=code => {
      code >= 100 && code < 600
    }),
  )
  ignore(
    ddt_assert_int_samples("valid_status_code", @dummy.valid_status_code(), valid=code => {
      code >= 100 && code < 600
    }),
  )
  let custom_url = @dummy.picsum_image_custom(
    @dummy.image_options(
      width=800,
      height=600,
      grayscale=true,
      blur=5,
      seed="myseed",
    ),
  ).dummy(@dummy.seed(ddt_seed("picsum-custom")))
  @test.assert_eq(
    custom_url, "https://picsum.photos/seed/myseed/800/600?grayscale&blur=5",
  )
  let contact_phone = @dummy.one_of([
    @dummy.phone_number(),
    @dummy.cell_number(),
  ]).dummy(@dummy.seed(ddt_seed("either-phone")))
  assert_true(ddt_valid_phone(contact_phone))
}

///|
test "facade formats and weighted phone choices remain valid" {
  ignore(
    ddt_assert_string_samples("chrono_date_time", @dummy.chrono_date_time()),
  )
  ignore(ddt_assert_string_samples("time_date_time", @dummy.time_date_time()))
  ignore(
    ddt_assert_int_samples("http_status_code", @dummy.http_status_code(), valid=code => {
      code >= 100 && code < 600
    }),
  )
  for
    value in @dummy.ulid().sample(
      count=4,
      @dummy.seed(ddt_seed("feature-ulid")),
    ) {
    @test.assert_eq(value.length(), 26)
  }
  for
    value in @dummy.uuid_v8().sample(
      count=4,
      @dummy.seed(ddt_seed("feature-uuid")),
    ) {
    assert_true(ddt_valid_uuid(value, '8'))
  }
  for
    value in @dummy.base64().sample(
      count=8,
      @dummy.seed(ddt_seed("feature-base64")),
    ) {
    assert_true(ddt_valid_base64_or_empty(value, false))
  }
  for
    value in @dummy.url_safe_base64().sample(
      count=8,
      @dummy.seed(ddt_seed("feature-url-base64")),
    ) {
    assert_true(ddt_valid_base64_or_empty(value, true))
  }
  for
    value in @dummy.bson_oid().sample(
      count=4,
      @dummy.seed(ddt_seed("feature-bson")),
    ) {
    @test.assert_eq(value.length(), 24)
    for ch in value {
      assert_true(ddt_is_hex(ch))
    }
  }
  for
    value in @dummy.number_with_format("CLI-^##-#").sample(
      count=8,
      @dummy.seed(ddt_seed("feature-geo-number")),
    ) {
    ddt_assert_number_format(value, "CLI-^##-#")
  }
  ignore(ddt_assert_string_samples("hex_color", @dummy.hex_color()))
  ignore(ddt_assert_string_samples("semver", @dummy.semver()))
  let phone = @dummy.weighted([
    (1, @dummy.phone_number()),
    (1, @dummy.cell_number()),
  ]).dummy(@dummy.seed(ddt_seed("feature-either")))
  assert_true(ddt_valid_phone(phone))
}

///|
fn fdm_seed(label : String) -> Bytes {
  ignore(label)
  b"compat-docs-data-more-port"
}

///|
fn fdm_assert_non_empty(label : String, value : String) -> Unit raise {
  if value.is_empty() {
    fail(label + " produced an empty sample")
  }
}

///|
fn fdm_assert_string_gen(label : String, gen : @core.Gen[String]) -> Unit raise {
  let left = gen.sample(count=2, @dummy.seed(fdm_seed(label)))
  let right = gen.sample(count=2, @dummy.seed(fdm_seed(label)))
  @test.assert_eq(left, right)
  for value in left {
    fdm_assert_non_empty(label, value)
  }
}

///|
fn fdm_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn fdm_is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  fdm_is_digit(ch) || (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn fdm_char_at(s : String, index : Int32, ch : Char) -> Bool {
  s.get_char(index) == Some(ch)
}

///|
fn fdm_valid_uuid(s : String, version : Char) -> Bool {
  if s.length() != 36 ||
    !fdm_char_at(s, 8, '-') ||
    !fdm_char_at(s, 13, '-') ||
    !fdm_char_at(s, 18, '-') ||
    !fdm_char_at(s, 23, '-') ||
    !fdm_char_at(s, 14, version) {
    return false
  }
  for i in 0..<36 {
    if i != 8 && i != 13 && i != 18 && i != 23 {
      match s.get_char(i) {
        Some(ch) => if !fdm_is_lower_hex(ch) { return false }
        None => return false
      }
    }
  }
  true
}

///|
fn fdm_count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn fdm_valid_email(s : String) -> Bool {
  fdm_count_char(s, '@') == 1 &&
  !s.has_prefix("@") &&
  !s.has_suffix("@") &&
  !s.contains(" ") &&
  s.contains(".")
}

///|
fn fdm_all_digits(s : String) -> Bool {
  if s.is_empty() {
    return false
  }
  for ch in s {
    if !fdm_is_digit(ch) {
      return false
    }
  }
  true
}

///|
fn fdm_valid_stable_semver(s : String) -> Bool {
  let parts = s.split(".").map(part => part.to_owned()).to_array()
  parts.length() == 3 &&
  fdm_all_digits(parts[0]) &&
  fdm_all_digits(parts[1]) &&
  fdm_all_digits(parts[2])
}

///|
test "docs locales generate valid deterministic facade samples" {
  let docs = @dummy.docs_locales()
  for item in docs {
    fdm_assert_string_gen(
      item.docs_code + " first_name",
      @dummy.first_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " last_name",
      @dummy.last_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " name",
      @dummy.name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " sentence",
      @dummy.sentence(locale=item.locale, count=@dummy.count_range(3, 3)),
    )
    fdm_assert_string_gen(
      item.docs_code + " city_name",
      @dummy.city_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " country_name",
      @dummy.country_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " company_name",
      @dummy.company_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " job_title",
      @dummy.job_title(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " phone_number",
      @dummy.phone_number(locale=item.locale),
    )
    let email = @dummy.free_email(locale=item.locale).dummy(
      @dummy.seed(fdm_seed(item.docs_code + " FreeEmail")),
    )
    assert_true(fdm_valid_email(email))
    fdm_assert_string_gen(
      item.docs_code + " currency_code",
      @dummy.currency_code(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " chrono_date_time",
      @dummy.chrono_date_time(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " time_date_time",
      @dummy.time_date_time(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " markdown_link",
      @dummy.markdown_link(locale=item.locale),
    )
  }
}

///|
test "facade generators preserve output shapes and boundary values" {
  let rng = @dummy.seed(fdm_seed("supported-generator-shapes"))
  fdm_assert_string_gen("title", @dummy.title())
  fdm_assert_string_gen("suffix", @dummy.suffix())
  fdm_assert_string_gen("name_with_title", @dummy.name_with_title())
  fdm_assert_string_gen("street_suffix", @dummy.street_suffix())
  fdm_assert_string_gen("street_name", @dummy.street_name())
  fdm_assert_string_gen("time_zone", @dummy.time_zone())
  fdm_assert_string_gen("state_name", @dummy.state_name())
  fdm_assert_string_gen("state_abbr", @dummy.state_abbr())
  fdm_assert_string_gen(
    "secondary_address_type",
    @dummy.secondary_address_type(),
  )
  fdm_assert_string_gen("secondary_address", @dummy.secondary_address())
  fdm_assert_string_gen("post_code", @dummy.post_code())
  fdm_assert_string_gen("building_number", @dummy.building_number())
  assert_true(!@dummy.latitude().dummy(rng).is_empty())
  assert_true(!@dummy.longitude().dummy(rng).is_empty())
  @test.assert_eq(@dummy.geohash(precision=7).dummy(rng).length(), 7)
  assert_true(@dummy.ipv4().dummy(rng).contains("."))
  assert_true(@dummy.ipv6().dummy(rng).contains(":"))
  assert_true(@dummy.mac_address().dummy(rng).contains(":"))
  assert_true(
    @dummy.picsum_image().dummy(rng).has_prefix("https://picsum.photos/"),
  )
  assert_true(
    @dummy.picsum_image_with_seed()
    .dummy(rng)
    .has_prefix("https://picsum.photos/seed/"),
  )
  assert_true(@dummy.picsum_image_grayscale().dummy(rng).contains("grayscale"))
  assert_true(@dummy.picsum_image_blur().dummy(rng).contains("blur="))
  assert_true(
    @dummy.words(count=@dummy.count_range(4, 4)).dummy(rng).length() == 4,
  )
  assert_true(
    @dummy.sentences(count=@dummy.count_range(2, 2)).dummy(rng).length() == 2,
  )
  assert_true(
    @dummy.paragraphs(count=@dummy.count_range(2, 2)).dummy(rng).length() == 2,
  )
  assert_true(@dummy.boolean(ratio=0).dummy(rng) == false)
  assert_true(@dummy.boolean(ratio=100).dummy(rng) == true)
  @test.assert_eq(@dummy.digit_string().dummy(rng).length(), 1)
  let formatted = @dummy.number_with_format("A^##").dummy(rng)
  @test.assert_eq(formatted.length(), 4)
  @test.assert_eq(formatted.get_char(0), Some('A'))
  assert_true(@dummy.credit_card_number().dummy(rng).length() >= 13)
  assert_true(@dummy.isbn10().dummy(rng).length() >= 10)
  assert_true(@dummy.isbn13().dummy(rng).length() >= 13)
  assert_true(@dummy.file_path().dummy(rng).contains("/"))
  assert_true(@dummy.file_name().dummy(rng).contains("."))
  assert_true(!@dummy.file_extension().dummy(rng).contains("."))
  assert_true(@dummy.mime_type().dummy(rng).contains("/"))
  assert_true(fdm_valid_stable_semver(@dummy.semver_stable().dummy(rng)))
  assert_true(@dummy.semver_unstable().dummy(rng).contains("-"))
  assert_true(@dummy.hex_color().dummy(rng).has_prefix("#"))
  assert_true(@dummy.rgb_color().dummy(rng).has_prefix("rgb("))
  assert_true(@dummy.rgba_color().dummy(rng).has_prefix("rgba("))
  assert_true(@dummy.hsl_color().dummy(rng).has_prefix("hsl("))
  assert_true(@dummy.hsla_color().dummy(rng).has_prefix("hsla("))
  assert_true(@dummy.italic_word().dummy(rng).has_prefix("*"))
  assert_true(@dummy.bold_word().dummy(rng).has_prefix("**"))
  assert_true(@dummy.markdown_link().dummy(rng).contains("]("))
  assert_true(
    @dummy.bullet_points(count=@dummy.count_range(2, 2))
    .dummy(rng)
    .contains("- "),
  )
  @test.assert_eq(
    @dummy.list_items(count=@dummy.count_range(2, 2)).dummy(rng).length(),
    2,
  )
  assert_true(@dummy.block_quote_single_line().dummy(rng).has_prefix(">"))
  assert_true(@dummy.block_quote_multi_line().dummy(rng).contains(">"))
  assert_true(@dummy.markdown_code().dummy(rng).has_prefix("```"))
  assert_true(
    !@dummy.health_insurance_code(locale=@dummy.fr_fr).dummy(rng).is_empty(),
  )
  assert_true(!@dummy.licence_plate(locale=@dummy.fr_fr).dummy(rng).is_empty())
  assert_true(fdm_valid_uuid(@dummy.uuid_v3().dummy(rng), '3'))
  assert_true(fdm_valid_uuid(@dummy.uuid_v5().dummy(rng), '5'))
}

///|
test "facade usage examples produce valid samples" {
  let rng = @dummy.seed(fdm_seed("examples-smoke"))
  fdm_assert_non_empty("Basic Usage Name", @dummy.name().dummy(rng))
  assert_true(@dummy.int(range=@dummy.int_range(0, 256)).dummy(rng) >= 0)
  ignore(@dummy.boolean().dummy(rng))
  fdm_assert_non_empty("Specific EN", @dummy.name(locale=@dummy.en).dummy(rng))
  fdm_assert_non_empty(
    "Specific ZH_CN",
    @dummy.name(locale=@dummy.zh_cn).dummy(rng),
  )
  fdm_assert_non_empty(
    "Specific JA_JP",
    @dummy.name(locale=@dummy.ja_jp).dummy(rng),
  )
  @test.assert_eq(
    @dummy.words(locale=@dummy.en, count=@dummy.count_range(3, 3))
    .dummy(rng)
    .length(),
    3,
  )
  assert_true(fdm_valid_email(@dummy.safe_email().dummy(rng)))
  assert_true(
    @dummy.password(len_range=@dummy.count_range(10, 20)).dummy(rng).length() >=
    10,
  )
  assert_true(@dummy.int(range=@dummy.int_range(1000, 9999)).dummy(rng) >= 1000)
  @test.assert_eq(@dummy.name().sample(count=10, rng).length(), 10)
  let left = @dummy.name().sample(
    count=3,
    @dummy.seed(fdm_seed("deterministic")),
  )
  let right = @dummy.name().sample(
    count=3,
    @dummy.seed(fdm_seed("deterministic")),
  )
  @test.assert_eq(left, right)
  fdm_assert_string_gen("chrono_date", @dummy.chrono_date())
  fdm_assert_string_gen("chrono_time", @dummy.chrono_time())
  fdm_assert_string_gen("chrono_date_time", @dummy.chrono_date_time())
  assert_true(fdm_valid_uuid(@dummy.uuid_v1().dummy(rng), '1'))
  assert_true(fdm_valid_uuid(@dummy.uuid_v4().dummy(rng), '4'))
  assert_true(fdm_valid_uuid(@dummy.uuid_v7().dummy(rng), '7'))
  assert_true(@dummy.rfc_status_code().dummy(rng) >= 100)
  assert_true(@dummy.valid_status_code().dummy(rng) < 600)
  @test.assert_eq(
    @dummy.picsum_image_custom(
      @dummy.image_options(
        width=800,
        height=600,
        grayscale=true,
        blur=5,
        seed="myseed",
      ),
    ).dummy(rng),
    "https://picsum.photos/seed/myseed/800/600?grayscale&blur=5",
  )
  let either_phone = @dummy.one_of([@dummy.phone_number(), @dummy.cell_number()]).dummy(
    rng,
  )
  fdm_assert_non_empty("Either phone", either_phone)
}

///|
fn fddp_seed(label : String) -> Bytes {
  ignore(label)
  b"compat-docs-deep-port"
}

///|
fn fddp_assert_non_empty(label : String, value : String) -> Unit raise {
  if value.is_empty() {
    fail("\{label} produced an empty docs sample")
  }
}

///|
fn fddp_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn fddp_count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn fddp_valid_email(s : String) -> Bool {
  if fddp_count_char(s, '@') != 1 || s.has_prefix("@") || s.has_suffix("@") {
    return false
  }
  let mut seen_at = false
  let mut domain_has_dot = false
  for ch in s {
    if ch == '@' {
      seen_at = true
    } else if ch == ' ' {
      return false
    } else if seen_at && ch == '.' {
      domain_has_dot = true
    }
  }
  domain_has_dot && !s.has_suffix(".")
}

///|
fn fddp_unresolved_template_chars(s : String) -> Bool {
  s.contains("#") || s.contains("^") || s.contains("{") || s.contains("}")
}

///|
test "facade API samples preserve counts and formats" {
  let rng = @dummy.seed(fddp_seed("api-usage"))
  let default_name = @dummy.name().dummy(rng)
  fddp_assert_non_empty("@dummy.name()", default_name)
  let zh_names = @dummy.name(locale=@dummy.zh_cn).sample(count=5, rng)
  @test.assert_eq(zh_names.length(), 5)
  for value in zh_names {
    fddp_assert_non_empty("@dummy.name(locale=@dummy.zh_cn)", value)
  }
  let emails = @dummy.free_email().sample(count=3, rng)
  @test.assert_eq(emails.length(), 3)
  for value in emails {
    assert_true(fddp_valid_email(value))
  }
  let passwords = @dummy.password(len_range=@dummy.count_range(12, 24)).sample(
    count=5,
    rng,
  )
  @test.assert_eq(passwords.length(), 5)
  for value in passwords {
    assert_true(value.length() >= 12 && value.length() <= 24)
  }
  let fr_company = @dummy.company_name(locale=@dummy.fr_fr).dummy(rng)
  fddp_assert_non_empty("@dummy.company_name(locale=@dummy.fr_fr)", fr_company)
  let cities = @dummy.city_name().sample(count=3, rng)
  @test.assert_eq(cities.length(), 3)
  for value in cities {
    fddp_assert_non_empty("@dummy.city_name()", value)
    assert_true(!fddp_unresolved_template_chars(value))
  }
  let zip = @dummy.zip_code().dummy(rng)
  fddp_assert_non_empty("@dummy.zip_code()", zip)
  assert_true(!fddp_unresolved_template_chars(zip))
  assert_true(
    zip.contains("-") ||
    zip.contains(" ") ||
    (zip.get_char(0) is Some(ch) && fddp_is_digit(ch)),
  )
  let country = @dummy.country_name().dummy(rng)
  fddp_assert_non_empty("@dummy.country_name()", country)
  assert_true(!fddp_unresolved_template_chars(country))
}

///|
struct DdxDocsLocaleCase {
  docs_code : String
  locale : @locales.Locale
}

///|
fn ddx_docs_locale_cases() -> Array[DdxDocsLocaleCase] {
  [
    { docs_code: "EN", locale: @dummy.en, },
    { docs_code: "FR_FR", locale: @dummy.fr_fr, },
    { docs_code: "AR_SA", locale: @dummy.ar_sa, },
    { docs_code: "ZH_TW", locale: @dummy.zh_tw, },
    { docs_code: "ZH_CN", locale: @dummy.zh_cn, },
    { docs_code: "JA_JP", locale: @dummy.ja_jp, },
    { docs_code: "PT_BR", locale: @dummy.pt_br, },
    { docs_code: "PT_PT", locale: @dummy.pt_pt, },
    { docs_code: "DE_DE", locale: @dummy.de_de, },
    { docs_code: "IT_IT", locale: @dummy.it_it, },
    { docs_code: "CY_GB", locale: @dummy.cy_gb, },
    { docs_code: "NL_NL", locale: @dummy.nl_nl, },
    { docs_code: "FA_IR", locale: @dummy.fa_ir, },
  ]
}

///|
fn ddx_seed(label : String) -> Bytes {
  ignore(label)
  b"compat-docs-extra-port"
}

///|
fn ddx_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn ddx_is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  ddx_is_digit(ch) || (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn ddx_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn ddx_char_at_eq(s : String, i : Int32, ch : Char) -> Bool {
  s.get_char(i) == Some(ch)
}

///|
fn ddx_char_at_is(s : String, i : Int32, pred : (Char) -> Bool) -> Bool {
  match s.get_char(i) {
    Some(ch) => pred(ch)
    None => false
  }
}

///|
fn ddx_is_uuid_variant(ch : Char) -> Bool {
  ch == '8' || ch == '9' || ch == 'a' || ch == 'b'
}

///|
fn ddx_valid_uuid(s : String, version : Char) -> Bool {
  if s.length() != 36 ||
    !ddx_char_at_eq(s, 8, '-') ||
    !ddx_char_at_eq(s, 13, '-') ||
    !ddx_char_at_eq(s, 18, '-') ||
    !ddx_char_at_eq(s, 23, '-') ||
    !ddx_char_at_eq(s, 14, version) ||
    !ddx_char_at_is(s, 19, ddx_is_uuid_variant) {
    return false
  }
  for i in 0..<36 {
    if i != 8 && i != 13 && i != 18 && i != 23 {
      if !ddx_char_at_is(s, i, ddx_is_lower_hex) {
        return false
      }
    }
  }
  true
}

///|
fn ddx_is_standard_base64_char(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'z'.to_int()) ||
  ddx_is_digit(ch) ||
  ch == '+' ||
  ch == '/'
}

///|
fn ddx_valid_base64(s : String) -> Bool {
  let mut seen_padding = false
  let mut padding_count = 0
  for ch in s {
    if ch == '=' {
      seen_padding = true
      padding_count += 1
      if padding_count > 2 {
        return false
      }
    } else if seen_padding || !ddx_is_standard_base64_char(ch) {
      return false
    }
  }
  padding_count == 0 || s.length() % 4 == 0
}

///|
fn ddx_all_digits(s : String) -> Bool {
  !s.is_empty() && ddx_all_chars_match(s, ddx_is_digit)
}

///|
fn ddx_valid_stable_semver(s : String) -> Bool {
  let parts = s.split(".").map(part => part.to_owned()).to_array()
  parts.length() == 3 &&
  ddx_all_digits(parts[0]) &&
  ddx_all_digits(parts[1]) &&
  ddx_all_digits(parts[2])
}

///|
test "facade locale constants generate non-empty names" {
  let cases = ddx_docs_locale_cases()
  for case in cases {
    let sample = @dummy.name(locale=case.locale).dummy(
      @dummy.seed(ddx_seed(case.docs_code)),
    )
    assert_true(!sample.is_empty())
  }
}

///|
test "facade identifiers encodings and formatted values have valid shapes" {
  let rng = @dummy.seed(ddx_seed("feature-flags"))
  assert_true(!@dummy.chrono_date_time().dummy(rng).is_empty())
  assert_true(@dummy.rfc_status_code().dummy(rng) >= 100)
  @test.assert_eq(@dummy.ulid().dummy(rng).length(), 26)
  assert_true(ddx_valid_uuid(@dummy.uuid_v8().dummy(rng), '8'))
  let hex = @dummy.hex_color().dummy(rng)
  assert_true(hex.length() == 7 && hex.get_char(0) == Some('#'))
  assert_true(ddx_valid_stable_semver(@dummy.semver_stable().dummy(rng)))
  assert_true(!@dummy.time_date_time().dummy(rng).is_empty())
  assert_true(
    !@dummy.one_of([@dummy.phone_number(), @dummy.cell_number()])
    .dummy(rng)
    .is_empty(),
  )
  assert_true(ddx_valid_base64(@dummy.base64().dummy(rng)))
  let oid = @dummy.bson_oid().dummy(rng)
  assert_true(oid.length() == 24 && ddx_all_chars_match(oid, ddx_is_lower_hex))
  let geohash = @dummy.geohash(precision=9).dummy(rng)
  @test.assert_eq(geohash.length(), 9)
}

///|
test "facade composes locale names ranges and nested samples" {
  let rng = @dummy.seed(ddx_seed("html-quickref"))
  let en_name = @dummy.name(locale=@dummy.en).dummy(rng)
  let zh_name = @dummy.name(locale=@dummy.zh_cn).dummy(rng)
  let ranged = @dummy.int(range=@dummy.int_range(1, 100)).dummy(rng)
  let collection = @dummy.name().sample(count=5, rng)
  let nested = @core.Gen::new(rng => {
    @dummy.name(locale=@dummy.en).sample(count=4, rng)
  }).sample(count=3, rng)
  assert_true(!en_name.is_empty())
  assert_true(!zh_name.is_empty())
  assert_true(ranged >= 1 && ranged < 100)
  @test.assert_eq(collection.length(), 5)
  for value in collection {
    assert_true(!value.is_empty())
  }
  @test.assert_eq(nested.length(), 3)
  for row in nested {
    @test.assert_eq(row.length(), 4)
    for value in row {
      assert_true(!value.is_empty())
    }
  }
}

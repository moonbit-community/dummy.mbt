///|
fn record(samples : Array[String], key : String, value : String) -> Unit {
  samples.push("\{key}=\{value}")
}

///|
fn record_int(samples : Array[String], key : String, value : Int32) -> Unit {
  let text = value.to_string()
  record(samples, key, text)
}

///|
fn record_bool(samples : Array[String], key : String, value : Bool) -> Unit {
  let text = if value { "true" } else { "false" }
  record(samples, key, text)
}

///|
fn facade_determinism_samples(seed_bytes : Bytes) -> String raise {
  let rng = @dummy.seed(seed_bytes)
  let samples : Array[String] = []
  let zh_dummy = @dummy.Dummy::new(locale=@dummy.zh_cn)
  record(samples, "dummy.name", zh_dummy.name().dummy(rng))
  record(samples, "dummy.email", zh_dummy.email().dummy(rng))
  record(samples, "dummy.sentence", zh_dummy.sentence().dummy(rng))
  record(
    samples,
    "one_of",
    @dummy.one_of([@dummy.name(), @dummy.city_name()]).dummy(rng),
  )
  record(
    samples,
    "weighted",
    @dummy.weighted([(1, @dummy.country_name()), (3, @dummy.company_name())]).dummy(
      rng,
    ),
  )
  record(samples, "first_name", @dummy.first_name().dummy(rng))
  record(samples, "last_name", @dummy.last_name().dummy(rng))
  record(samples, "title", @dummy.title().dummy(rng))
  record(samples, "suffix", @dummy.suffix().dummy(rng))
  record(samples, "name", @dummy.name().dummy(rng))
  record(samples, "name_with_title", @dummy.name_with_title().dummy(rng))
  record(samples, "word", @dummy.word().dummy(rng))
  record(samples, "words", @dummy.words().dummy(rng).join("|"))
  record(samples, "sentence", @dummy.sentence().dummy(rng))
  record(samples, "sentences", @dummy.sentences().dummy(rng).join("|"))
  record(samples, "paragraph", @dummy.paragraph().dummy(rng))
  record(samples, "paragraphs", @dummy.paragraphs().dummy(rng).join("|"))
  record(samples, "city_prefix", @dummy.city_prefix().dummy(rng))
  record(samples, "city_suffix", @dummy.city_suffix().dummy(rng))
  record(samples, "city_name", @dummy.city_name().dummy(rng))
  record(samples, "country_name", @dummy.country_name().dummy(rng))
  record(samples, "country_code", @dummy.country_code().dummy(rng))
  record(samples, "street_suffix", @dummy.street_suffix().dummy(rng))
  record(samples, "street_name", @dummy.street_name().dummy(rng))
  record(samples, "time_zone", @dummy.time_zone().dummy(rng))
  record(samples, "state_name", @dummy.state_name().dummy(rng))
  record(samples, "state_abbr", @dummy.state_abbr().dummy(rng))
  record(
    samples,
    "secondary_address_type",
    @dummy.secondary_address_type().dummy(rng),
  )
  record(samples, "secondary_address", @dummy.secondary_address().dummy(rng))
  record(samples, "zip_code", @dummy.zip_code().dummy(rng))
  record(samples, "post_code", @dummy.post_code().dummy(rng))
  record(samples, "building_number", @dummy.building_number().dummy(rng))
  record(samples, "latitude", @dummy.latitude().dummy(rng))
  record(samples, "longitude", @dummy.longitude().dummy(rng))
  record(samples, "geohash", @dummy.geohash(precision=10).dummy(rng))
  record(samples, "company_name", @dummy.company_name().dummy(rng))
  record(samples, "catch_phrase", @dummy.catch_phrase().dummy(rng))
  record(samples, "company_suffix", @dummy.company_suffix().dummy(rng))
  record(samples, "buzzword", @dummy.buzzword().dummy(rng))
  record(samples, "buzzword_middle", @dummy.buzzword_middle().dummy(rng))
  record(samples, "buzzword_tail", @dummy.buzzword_tail().dummy(rng))
  record(samples, "bs_verb", @dummy.bs_verb().dummy(rng))
  record(samples, "bs_adj", @dummy.bs_adj().dummy(rng))
  record(samples, "bs_noun", @dummy.bs_noun().dummy(rng))
  record(samples, "bs", @dummy.bs().dummy(rng))
  record(samples, "profession", @dummy.profession().dummy(rng))
  record(samples, "industry", @dummy.industry().dummy(rng))
  record(samples, "phone_number", @dummy.phone_number().dummy(rng))
  record(samples, "cell_number", @dummy.cell_number().dummy(rng))
  record(samples, "username", @dummy.username().dummy(rng))
  record(
    samples,
    "free_email_provider",
    @dummy.free_email_provider().dummy(rng),
  )
  record(samples, "domain_suffix", @dummy.domain_suffix().dummy(rng))
  record(samples, "free_email", @dummy.free_email().dummy(rng))
  record(samples, "safe_email", @dummy.safe_email().dummy(rng))
  record(samples, "ipv4", @dummy.ipv4().dummy(rng))
  record(samples, "ipv6", @dummy.ipv6().dummy(rng))
  record(samples, "ip", @dummy.ip().dummy(rng))
  record(samples, "mac_address", @dummy.mac_address().dummy(rng))
  record(
    samples,
    "password",
    @dummy.password(len_range=@dummy.count_range(10, 10)).dummy(rng),
  )
  record(samples, "user_agent", @dummy.user_agent().dummy(rng))
  record(samples, "currency_code", @dummy.currency_code().dummy(rng))
  record(samples, "currency_name", @dummy.currency_name().dummy(rng))
  record(samples, "currency_symbol", @dummy.currency_symbol().dummy(rng))
  record(samples, "job_seniority", @dummy.job_seniority().dummy(rng))
  record(samples, "job_field", @dummy.job_field().dummy(rng))
  record(samples, "job_position", @dummy.job_position().dummy(rng))
  record(samples, "job_title", @dummy.job_title().dummy(rng))
  record_int(samples, "digit", @dummy.digit().dummy(rng))
  record(
    samples,
    "number_with_format",
    @dummy.number_with_format("###-##-####").dummy(rng),
  )
  record_int(
    samples,
    "int",
    @dummy.int(range=@dummy.int_range(10, 20)).dummy(rng),
  )
  record_bool(samples, "boolean", @dummy.boolean(ratio=75).dummy(rng))
  record(samples, "isbn", @dummy.isbn().dummy(rng))
  record(samples, "isbn10", @dummy.isbn10().dummy(rng))
  record(samples, "isbn13", @dummy.isbn13().dummy(rng))
  record(samples, "credit_card_number", @dummy.credit_card_number().dummy(rng))
  record(samples, "bic", @dummy.bic().dummy(rng))
  record(samples, "isin", @dummy.isin().dummy(rng))
  record(
    samples,
    "health_insurance_code",
    @dummy.health_insurance_code(locale=@dummy.fr_fr).dummy(rng),
  )
  record(
    samples,
    "licence_plate",
    @dummy.licence_plate(locale=@dummy.nl_nl).dummy(rng),
  )
  record(samples, "hex_color", @dummy.hex_color().dummy(rng))
  record(samples, "rgb_color", @dummy.rgb_color().dummy(rng))
  record(samples, "rgba_color", @dummy.rgba_color().dummy(rng))
  record(samples, "hsl_color", @dummy.hsl_color().dummy(rng))
  record(samples, "hsla_color", @dummy.hsla_color().dummy(rng))
  record(samples, "color", @dummy.color().dummy(rng))
  record(samples, "file_path", @dummy.file_path().dummy(rng))
  record(samples, "file_extension", @dummy.file_extension().dummy(rng))
  record(samples, "file_name", @dummy.file_name().dummy(rng))
  record(samples, "dir_path", @dummy.dir_path().dummy(rng))
  record(samples, "mime_type", @dummy.mime_type().dummy(rng))
  record(samples, "semver", @dummy.semver().dummy(rng))
  record(samples, "semver_stable", @dummy.semver_stable().dummy(rng))
  record(samples, "semver_unstable", @dummy.semver_unstable().dummy(rng))
  record(samples, "uuid", @dummy.uuid().dummy(rng))
  record(samples, "uuid_v1", @dummy.uuid_v1().dummy(rng))
  record(samples, "uuid_v3", @dummy.uuid_v3().dummy(rng))
  record(samples, "uuid_v4", @dummy.uuid_v4().dummy(rng))
  record(samples, "uuid_v5", @dummy.uuid_v5().dummy(rng))
  record(samples, "uuid_v6", @dummy.uuid_v6().dummy(rng))
  record(samples, "uuid_v7", @dummy.uuid_v7().dummy(rng))
  record(samples, "uuid_v8", @dummy.uuid_v8().dummy(rng))
  record(samples, "ulid", @dummy.ulid().dummy(rng))
  record(samples, "bson_oid", @dummy.bson_oid().dummy(rng))
  record(samples, "base64", @dummy.base64().dummy(rng))
  record(samples, "url_safe_base64", @dummy.url_safe_base64().dummy(rng))
  record(samples, "italic_word", @dummy.italic_word().dummy(rng))
  record(samples, "bold_word", @dummy.bold_word().dummy(rng))
  record(samples, "markdown_link", @dummy.markdown_link().dummy(rng))
  record(samples, "bullet_points", @dummy.bullet_points().dummy(rng))
  record(samples, "list_items", @dummy.list_items().dummy(rng).join("|"))
  record(
    samples,
    "block_quote_single_line",
    @dummy.block_quote_single_line().dummy(rng),
  )
  record(
    samples,
    "block_quote_multi_line",
    @dummy.block_quote_multi_line().dummy(rng),
  )
  record(samples, "markdown_code", @dummy.markdown_code().dummy(rng))
  record_int(samples, "http_status_code", @dummy.http_status_code().dummy(rng))
  record_int(samples, "rfc_status_code", @dummy.rfc_status_code().dummy(rng))
  record_int(
    samples,
    "valid_status_code",
    @dummy.valid_status_code().dummy(rng),
  )
  record(samples, "http_method", @dummy.http_method().dummy(rng))
  record(samples, "picsum_image", @dummy.picsum_image().dummy(rng))
  record(
    samples,
    "picsum_image_with_seed",
    @dummy.picsum_image_with_seed().dummy(rng),
  )
  record(
    samples,
    "picsum_image_grayscale",
    @dummy.picsum_image_grayscale().dummy(rng),
  )
  record(samples, "picsum_image_blur", @dummy.picsum_image_blur().dummy(rng))
  record(
    samples,
    "picsum_image_custom",
    @dummy.picsum_image_custom(
      @dummy.image_options(
        width=320,
        height=240,
        grayscale=true,
        blur=4,
        seed="fixed",
      ),
    ).dummy(rng),
  )
  samples.join("\n")
}

///|
fn compat_det_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn compat_det_is_lower_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  compat_det_is_digit(ch) || (code >= 'a'.to_int() && code <= 'f'.to_int())
}

///|
fn compat_valid_email(s : String) -> Bool {
  s.split_once("@") is Some((local_part, domain)) &&
  !local_part.is_empty() &&
  domain.contains(".") &&
  !domain.has_prefix(".") &&
  !domain.has_suffix(".")
}

///|
fn compat_phone_chars_resolved(s : String) -> Bool {
  if s.is_empty() || s.contains("#") || s.contains("^") {
    return false
  }
  for ch in s {
    let ok = compat_det_is_digit(ch) ||
      ch == '+' ||
      ch == '-' ||
      ch == '.' ||
      ch == '(' ||
      ch == ')' ||
      ch == ' ' ||
      ch == 'x'
    if !ok {
      return false
    }
  }
  true
}

///|
fn compat_det_digit_value_at(s : String, i : Int32) -> Int32 {
  match s.get_char(i) {
    Some(ch) => ch.to_int() - '0'.to_int()
    None => -1
  }
}

///|
fn compat_det_strip_hyphens(s : String) -> String {
  let out = StringBuilder::new(size_hint=s.length())
  for ch in s {
    if ch != '-' {
      out.write_char(ch)
    }
  }
  out.to_string()
}

///|
fn compat_valid_isbn13(s : String) -> Bool {
  let s = compat_det_strip_hyphens(s)
  if s.length() != 13 {
    return false
  }
  for i in 0..<13 {
    let digit = compat_det_digit_value_at(s, i)
    if digit < 0 || digit > 9 {
      return false
    }
  }
  let mut sum = 0
  for i in 0..<12 {
    let digit = compat_det_digit_value_at(s, i)
    sum += if i % 2 == 0 { digit } else { digit * 3 }
  }
  compat_det_digit_value_at(s, 12) == (10 - sum % 10) % 10
}

///|
fn compat_valid_uuid(value : String, version : Char?) -> Bool {
  if value.length() != 36 ||
    value.get_char(8) != Some('-') ||
    value.get_char(13) != Some('-') ||
    value.get_char(18) != Some('-') ||
    value.get_char(23) != Some('-') {
    return false
  }
  match version {
    Some(v) => if value.get_char(14) != Some(v) { return false }
    None => ()
  }
  for ch in value {
    if ch != '-' && !compat_det_is_lower_hex(ch) {
      return false
    }
  }
  true
}

///|
fn compat_det_decimal(s : String) -> Bool {
  if s.is_empty() {
    return false
  }
  for ch in s {
    if !compat_det_is_digit(ch) {
      return false
    }
  }
  true
}

///|
fn compat_valid_semver(s : String) -> Bool {
  let parts = s.split("-").map(part => part.to_owned()).to_array()
  if parts.length() < 1 || parts.length() > 2 {
    return false
  }
  let nums = parts[0].split(".").map(part => part.to_owned()).to_array()
  nums.length() == 3 &&
  compat_det_decimal(nums[0]) &&
  compat_det_decimal(nums[1]) &&
  compat_det_decimal(nums[2]) &&
  (parts.length() == 1 || !parts[1].is_empty())
}

///|
test "facade generators are deterministic for the same seed" {
  let seed = b"compat-determinism-migration"
  let left = facade_determinism_samples(seed)
  let right = facade_determinism_samples(seed)
  @test.assert_eq(left, right)
}

///|
fn facade_string_samples(
  gen : @core.Gen[String],
  seed_bytes : Bytes,
  count : Int32,
) -> Array[String] raise @core.DummyError {
  gen.sample(count~, @dummy.seed(seed_bytes))
}

///|
test "migrated facade seed reproducibility" {
  let gen = @dummy.one_of([
    @dummy.name(locale=@dummy.en),
    @dummy.company_name(locale=@dummy.zh_cn),
    @dummy.safe_email(),
  ])
  let left = facade_string_samples(gen, b"compat-root-determinism", 16)
  let right = facade_string_samples(gen, b"compat-root-determinism", 16)
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 16)
}

///|
test "migrated facade weighted boundaries" {
  let empty : Result[@core.Gen[String], @core.DummyError] = try? @dummy.weighted([],
  )
  assert_true(empty is Err(@core.DummyError::EmptyCandidates("weighted")))
  let invalid : Result[@core.Gen[String], @core.DummyError] = try? @dummy.weighted([
      (0, @dummy.name()),
      (-1, @dummy.company_name()),
    ],
  )
  assert_true(invalid is Err(@core.DummyError::InvalidRange(_)))
  let gen = @dummy.weighted([
    (0, @dummy.name()),
    (4, @core.Gen::pure("selected")),
  ])
  let values = facade_string_samples(gen, b"compat-root-weighted", 6)
  @test.assert_eq(values, [
    "selected", "selected", "selected", "selected", "selected", "selected",
  ])
}

///|
fn assert_compat_empty_seed_string_sequence(
  name : String,
  gen : @core.Gen[String],
  count : Int32,
  shape : (String) -> Bool,
) -> Unit raise {
  let left = gen.sample(count~, @dummy.seed(b""))
  let right = gen.sample(count~, @dummy.seed(b""))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    if value.is_empty() {
      fail("\{name} produced an empty value from the empty seed")
    }
    if !shape(value) {
      fail("\{name} produced malformed value: \{value}")
    }
  }
}

///|
fn assert_compat_empty_seed_int_sequence(
  name : String,
  gen : @core.Gen[Int32],
  count : Int32,
  shape : (Int32) -> Bool,
) -> Unit raise {
  let left = gen.sample(count~, @dummy.seed(b""))
  let right = gen.sample(count~, @dummy.seed(b""))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    if !shape(value) {
      fail("\{name} produced malformed value: \{value}")
    }
  }
}

///|
fn assert_compat_phone_combo_sequence(
  name : String,
  gen : @core.Gen[String],
) -> Unit raise {
  let count = 16
  let seed_bytes = b"compat-utils-either-phone"
  let left = gen.sample(count~, @dummy.seed(seed_bytes))
  let right = gen.sample(count~, @dummy.seed(seed_bytes))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    if !compat_phone_chars_resolved(value) {
      fail("\{name} left unresolved phone placeholder: \{value}")
    }
  }
}

///|
test "empty seed keeps facade and category generators deterministic" {
  assert_compat_empty_seed_string_sequence(
    "Dummy::name",
    @dummy.Dummy::new(locale=@dummy.zh_cn).name(),
    8,
    value => !value.is_empty(),
  )
  assert_compat_empty_seed_string_sequence(
    "free_email",
    @dummy.free_email(),
    8,
    compat_valid_email,
  )
  assert_compat_empty_seed_string_sequence(
    "phone_number",
    @dummy.phone_number(),
    8,
    compat_phone_chars_resolved,
  )
  assert_compat_empty_seed_string_sequence("isbn13", @barcode.isbn13(), 8, value => {
    value.has_prefix("978") && compat_valid_isbn13(value)
  })
  assert_compat_empty_seed_string_sequence(
    "uuid_v4",
    @identifier.uuid_v4(),
    8,
    value => compat_valid_uuid(value, Some('4')),
  )
  assert_compat_empty_seed_string_sequence(
    "semver",
    @filesystem.semver(),
    8,
    compat_valid_semver,
  )
  assert_compat_empty_seed_int_sequence(
    "valid_status_code",
    @dummy.valid_status_code(),
    8,
    value => value >= 100 && value < 600,
  )
}

///|
test "utils either style phone combinations are deterministic" {
  assert_compat_phone_combo_sequence(
    "one_of(phone_number, cell_number)",
    @dummy.one_of([@dummy.phone_number(), @dummy.cell_number()]),
  )
  assert_compat_phone_combo_sequence(
    "weighted(phone_number, cell_number)",
    @dummy.weighted([(1, @dummy.phone_number()), (2, @dummy.cell_number())]),
  )
}

///|
fn compat_all_locale_sample_count() -> Int32 {
  16
}

///|
fn compat_all_locale_seed() -> Bytes {
  b"compat-all-locale-determinism"
}

///|
fn assert_compat_string_sequence(
  name : String,
  gen : @core.Gen[String],
  allow_empty~ : Bool = false,
) -> Unit raise {
  let count = compat_all_locale_sample_count()
  let left = gen.sample(count~, @dummy.seed(compat_all_locale_seed()))
  let right = gen.sample(count~, @dummy.seed(compat_all_locale_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
  for value in left {
    if !allow_empty && value.is_empty() {
      fail("\{name} produced an empty fallback result")
    }
  }
}

///|
fn assert_compat_int_sequence(gen : @core.Gen[Int32]) -> Unit raise {
  let count = compat_all_locale_sample_count()
  let left = gen.sample(count~, @dummy.seed(compat_all_locale_seed()))
  let right = gen.sample(count~, @dummy.seed(compat_all_locale_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
}

///|
fn assert_compat_bool_sequence(gen : @core.Gen[Bool]) -> Unit raise {
  let count = compat_all_locale_sample_count()
  let left = gen.sample(count~, @dummy.seed(compat_all_locale_seed()))
  let right = gen.sample(count~, @dummy.seed(compat_all_locale_seed()))
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), count)
}

///|
fn assert_compat_all_locale_string(
  name : String,
  make : (@locales.Locale) -> @core.Gen[String] raise @core.DummyError,
) -> Unit raise {
  for locale in @locales.all() {
    let case_name = name + "[" + locale.code() + "]"
    assert_compat_string_sequence(case_name, make(locale))
  }
}

///|
fn assert_compat_all_locale_string_array(
  name : String,
  make : (@locales.Locale) -> @core.Gen[Array[String]] raise @core.DummyError,
) -> Unit raise {
  assert_compat_all_locale_string(name, locale => {
    make(locale).map(items => items.join("|"))
  })
}

///|
test "facade locale-backed generators are deterministic for all locales" {
  assert_compat_all_locale_string("Dummy::name", locale => {
    @dummy.Dummy::new(locale~).name()
  })
  assert_compat_all_locale_string("Dummy::email", locale => {
    @dummy.Dummy::new(locale~).email()
  })
  assert_compat_all_locale_string("Dummy::sentence", locale => {
    @dummy.Dummy::new(locale~).sentence()
  })
  assert_compat_all_locale_string("first_name", locale => {
    @dummy.first_name(locale~)
  })
  assert_compat_all_locale_string("last_name", locale => {
    @dummy.last_name(locale~)
  })
  assert_compat_all_locale_string("title", locale => @dummy.title(locale~))
  assert_compat_all_locale_string("suffix", locale => @dummy.suffix(locale~))
  assert_compat_all_locale_string("name", locale => @dummy.name(locale~))
  assert_compat_all_locale_string("name_with_title", locale => {
    @dummy.name_with_title(locale~)
  })
  assert_compat_all_locale_string("word", locale => @dummy.word(locale~))
  assert_compat_all_locale_string_array("words", locale => {
    @dummy.words(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string("sentence", locale => {
    @dummy.sentence(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string_array("sentences", locale => {
    @dummy.sentences(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string("paragraph", locale => {
    @dummy.paragraph(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string_array("paragraphs", locale => {
    @dummy.paragraphs(locale~, count=@dummy.count_range(1, 1))
  })
  assert_compat_all_locale_string("city_name", locale => {
    @dummy.city_name(locale~)
  })
  assert_compat_all_locale_string("city_prefix", locale => {
    @dummy.city_prefix(locale~)
  })
  assert_compat_all_locale_string("city_suffix", locale => {
    @dummy.city_suffix(locale~)
  })
  assert_compat_all_locale_string("country_name", locale => {
    @dummy.country_name(locale~)
  })
  assert_compat_all_locale_string("street_name", locale => {
    @dummy.street_name(locale~)
  })
  assert_compat_all_locale_string("street_suffix", locale => {
    @dummy.street_suffix(locale~)
  })
  assert_compat_all_locale_string("state_name", locale => {
    @dummy.state_name(locale~)
  })
  assert_compat_all_locale_string("state_abbr", locale => {
    @dummy.state_abbr(locale~)
  })
  assert_compat_all_locale_string("secondary_address_type", locale => {
    @dummy.secondary_address_type(locale~)
  })
  assert_compat_all_locale_string("secondary_address", locale => {
    @dummy.secondary_address(locale~)
  })
  assert_compat_all_locale_string("zip_code", locale => @dummy.zip_code(locale~))
  assert_compat_all_locale_string("post_code", locale => {
    @dummy.post_code(locale~)
  })
  assert_compat_all_locale_string("building_number", locale => {
    @dummy.building_number(locale~)
  })
  assert_compat_all_locale_string("company_name", locale => {
    @dummy.company_name(locale~)
  })
  assert_compat_all_locale_string("catch_phrase", locale => {
    @dummy.catch_phrase(locale~)
  })
  assert_compat_all_locale_string("company_suffix", locale => {
    @dummy.company_suffix(locale~)
  })
  assert_compat_all_locale_string("buzzword", locale => @dummy.buzzword(locale~))
  assert_compat_all_locale_string("buzzword_middle", locale => {
    @dummy.buzzword_middle(locale~)
  })
  assert_compat_all_locale_string("buzzword_tail", locale => {
    @dummy.buzzword_tail(locale~)
  })
  assert_compat_all_locale_string("bs_verb", locale => @dummy.bs_verb(locale~))
  assert_compat_all_locale_string("bs_adj", locale => @dummy.bs_adj(locale~))
  assert_compat_all_locale_string("bs_noun", locale => @dummy.bs_noun(locale~))
  assert_compat_all_locale_string("bs", locale => @dummy.bs(locale~))
  assert_compat_all_locale_string("profession", locale => {
    @dummy.profession(locale~)
  })
  assert_compat_all_locale_string("industry", locale => @dummy.industry(locale~))
  assert_compat_all_locale_string("phone_number", locale => {
    @dummy.phone_number(locale~)
  })
  assert_compat_all_locale_string("cell_number", locale => {
    @dummy.cell_number(locale~)
  })
  assert_compat_all_locale_string("time_zone", locale => {
    @dummy.time_zone(locale~)
  })
  assert_compat_all_locale_string("username", locale => @dummy.username(locale~))
  assert_compat_all_locale_string("free_email_provider", locale => {
    @dummy.free_email_provider(locale~)
  })
  assert_compat_all_locale_string("domain_suffix", locale => {
    @dummy.domain_suffix(locale~)
  })
  assert_compat_all_locale_string("free_email", locale => {
    @dummy.free_email(locale~)
  })
  assert_compat_all_locale_string("safe_email", locale => {
    @dummy.safe_email(locale~)
  })
  assert_compat_all_locale_string("job_seniority", locale => {
    @dummy.job_seniority(locale~)
  })
  assert_compat_all_locale_string("job_field", locale => {
    @dummy.job_field(locale~)
  })
  assert_compat_all_locale_string("job_position", locale => {
    @dummy.job_position(locale~)
  })
  assert_compat_all_locale_string("job_title", locale => {
    @dummy.job_title(locale~)
  })
  assert_compat_all_locale_string("currency_code", locale => {
    @dummy.currency_code(locale~)
  })
  assert_compat_all_locale_string("currency_name", locale => {
    @dummy.currency_name(locale~)
  })
  assert_compat_all_locale_string("currency_symbol", locale => {
    @dummy.currency_symbol(locale~)
  })
  assert_compat_all_locale_string("italic_word", locale => {
    @dummy.italic_word(locale~)
  })
  assert_compat_all_locale_string("bold_word", locale => {
    @dummy.bold_word(locale~)
  })
  assert_compat_all_locale_string("markdown_link", locale => {
    @dummy.markdown_link(locale~)
  })
  assert_compat_all_locale_string("chrono_time", locale => {
    @dummy.chrono_time(locale~)
  })
  assert_compat_all_locale_string("chrono_date", locale => {
    @dummy.chrono_date(locale~)
  })
  assert_compat_all_locale_string("chrono_date_time", locale => {
    @dummy.chrono_date_time(locale~)
  })
  assert_compat_all_locale_string("time_time", locale => {
    @dummy.time_time(locale~)
  })
  assert_compat_all_locale_string("time_date", locale => {
    @dummy.time_date(locale~)
  })
  assert_compat_all_locale_string("time_date_time", locale => {
    @dummy.time_date_time(locale~)
  })
  assert_compat_all_locale_string("bullet_points", locale => {
    @dummy.bullet_points(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string_array("list_items", locale => {
    @dummy.list_items(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string("block_quote_single_line", locale => {
    @dummy.block_quote_single_line(locale~, count=@dummy.count_range(2, 2))
  })
  assert_compat_all_locale_string("block_quote_multi_line", locale => {
    @dummy.block_quote_multi_line(locale~, count=@dummy.count_range(2, 2))
  })
}

///|
test "chrono relative datetime generators are deterministic for all locales" {
  assert_compat_all_locale_string("chrono_date_time_before", locale => {
    @dummy.chrono_date_time_before(anchor_minutes=1000, locale~)
  })
  assert_compat_all_locale_string("chrono_date_time_after", locale => {
    @dummy.chrono_date_time_after(anchor_minutes=1000, locale~)
  })
  assert_compat_all_locale_string("chrono_date_time_between", locale => {
    @dummy.chrono_date_time_between(0, 10, locale~)
  })
}

///|
test "time relative datetime generators are deterministic for all locales" {
  assert_compat_all_locale_string("time_date_time_before", locale => {
    @dummy.time_date_time_before(anchor_minutes=1000, locale~)
  })
  assert_compat_all_locale_string("time_date_time_after", locale => {
    @dummy.time_date_time_after(anchor_minutes=1000, locale~)
  })
  assert_compat_all_locale_string("time_date_time_between", locale => {
    @dummy.time_date_time_between(0, 10, locale~)
  })
}

///|
test "facade locale-independent generators are deterministic" {
  assert_compat_string_sequence(
    "one_of",
    @dummy.one_of([
      @dummy.name(locale=@dummy.en),
      @dummy.name(locale=@dummy.zh_cn),
      @core.Gen::pure("fallback"),
    ]),
  )
  assert_compat_string_sequence(
    "weighted",
    @dummy.weighted([
      (1, @dummy.company_name(locale=@dummy.en)),
      (2, @dummy.safe_email(locale=@dummy.zh_tw)),
    ]),
  )
  assert_compat_string_sequence("country_code", @dummy.country_code())
  assert_compat_string_sequence("time_zone", @dummy.time_zone())
  assert_compat_string_sequence("latitude", @dummy.latitude())
  assert_compat_string_sequence("longitude", @dummy.longitude())
  assert_compat_string_sequence("geohash", @dummy.geohash(precision=10))
  assert_compat_string_sequence(
    "free_email_provider",
    @dummy.free_email_provider(),
  )
  assert_compat_string_sequence("domain_suffix", @dummy.domain_suffix())
  assert_compat_string_sequence(
    "password",
    @dummy.password(len_range=@dummy.count_range(8, 8)),
  )
  assert_compat_string_sequence("ipv4", @dummy.ipv4())
  assert_compat_string_sequence("ipv6", @dummy.ipv6())
  assert_compat_string_sequence("ip", @dummy.ip())
  assert_compat_string_sequence("mac_address", @dummy.mac_address())
  assert_compat_string_sequence("user_agent", @dummy.user_agent())
  assert_compat_string_sequence("currency_code", @dummy.currency_code())
  assert_compat_string_sequence("currency_name", @dummy.currency_name())
  assert_compat_string_sequence("currency_symbol", @dummy.currency_symbol())
  assert_compat_int_sequence(@dummy.digit())
  assert_compat_string_sequence("digit_string", @dummy.digit_string())
  assert_compat_string_sequence(
    "number_with_format",
    @dummy.number_with_format("###-##-####"),
  )
  assert_compat_int_sequence(@dummy.int(range=@dummy.int_range(10, 20)))
  assert_compat_bool_sequence(@dummy.boolean(ratio=75))
  assert_compat_string_sequence("isbn", @dummy.isbn())
  assert_compat_string_sequence("isbn10", @dummy.isbn10())
  assert_compat_string_sequence("isbn13", @dummy.isbn13())
  assert_compat_string_sequence(
    "credit_card_number",
    @dummy.credit_card_number(),
  )
  assert_compat_string_sequence("bic", @dummy.bic())
  assert_compat_string_sequence("isin", @dummy.isin())
  assert_compat_string_sequence(
    "health_insurance_code",
    @dummy.health_insurance_code(locale=@dummy.fr_fr),
  )
  for
    locale in [
      @dummy.fr_fr, @dummy.it_it, @dummy.nl_nl, @dummy.pt_pt, @dummy.tr_tr, @dummy.fa_ir,
    ] {
    assert_compat_string_sequence(
      "licence_plate[" + locale.code() + "]",
      @dummy.licence_plate(locale~),
    )
  }
  assert_compat_string_sequence("hex_color", @dummy.hex_color())
  assert_compat_string_sequence("rgb_color", @dummy.rgb_color())
  assert_compat_string_sequence("rgba_color", @dummy.rgba_color())
  assert_compat_string_sequence("hsl_color", @dummy.hsl_color())
  assert_compat_string_sequence("hsla_color", @dummy.hsla_color())
  assert_compat_string_sequence("color", @dummy.color())
  assert_compat_string_sequence("file_path", @dummy.file_path())
  assert_compat_string_sequence("file_extension", @dummy.file_extension())
  assert_compat_string_sequence("file_name", @dummy.file_name())
  assert_compat_string_sequence("dir_path", @dummy.dir_path())
  assert_compat_string_sequence("mime_type", @dummy.mime_type())
  assert_compat_string_sequence("semver", @dummy.semver())
  assert_compat_string_sequence("semver_stable", @dummy.semver_stable())
  assert_compat_string_sequence("semver_unstable", @dummy.semver_unstable())
  assert_compat_string_sequence("uuid", @dummy.uuid())
  assert_compat_string_sequence("uuid_v1", @dummy.uuid_v1())
  assert_compat_string_sequence("uuid_v3", @dummy.uuid_v3())
  assert_compat_string_sequence("uuid_v4", @dummy.uuid_v4())
  assert_compat_string_sequence("uuid_v5", @dummy.uuid_v5())
  assert_compat_string_sequence("uuid_v6", @dummy.uuid_v6())
  assert_compat_string_sequence("uuid_v7", @dummy.uuid_v7())
  assert_compat_string_sequence("uuid_v8", @dummy.uuid_v8())
  assert_compat_string_sequence("ulid", @dummy.ulid())
  assert_compat_string_sequence("bson_oid", @dummy.bson_oid())
  assert_compat_string_sequence("base64", @dummy.base64(), allow_empty=true)
  assert_compat_string_sequence(
    "base64_padded",
    @dummy.base64_padded(),
    allow_empty=true,
  )
  assert_compat_string_sequence(
    "base64_no_pad",
    @dummy.base64_no_pad(),
    allow_empty=true,
  )
  assert_compat_string_sequence(
    "url_safe_base64",
    @dummy.url_safe_base64(),
    allow_empty=true,
  )
  assert_compat_string_sequence(
    "url_safe_base64_padded",
    @dummy.url_safe_base64_padded(),
    allow_empty=true,
  )
  assert_compat_string_sequence(
    "url_safe_base64_no_pad",
    @dummy.url_safe_base64_no_pad(),
    allow_empty=true,
  )
  assert_compat_string_sequence(
    "markdown_code",
    @dummy.markdown_code(count=@dummy.count_range(2, 2)),
  )
  assert_compat_int_sequence(@dummy.chrono_duration())
  assert_compat_string_sequence(
    "chrono_date_time_before",
    @dummy.chrono_date_time_before(anchor_minutes=1000),
  )
  assert_compat_string_sequence(
    "chrono_date_time_after",
    @dummy.chrono_date_time_after(anchor_minutes=1000),
  )
  assert_compat_string_sequence(
    "chrono_date_time_between",
    @dummy.chrono_date_time_between(0, 10),
  )
  assert_compat_int_sequence(@dummy.time_duration())
  assert_compat_string_sequence(
    "time_date_time_before",
    @dummy.time_date_time_before(anchor_minutes=1000),
  )
  assert_compat_string_sequence(
    "time_date_time_after",
    @dummy.time_date_time_after(anchor_minutes=1000),
  )
  assert_compat_string_sequence(
    "time_date_time_between",
    @dummy.time_date_time_between(0, 10),
  )
  assert_compat_int_sequence(@dummy.http_status_code())
  assert_compat_int_sequence(@dummy.rfc_status_code())
  assert_compat_int_sequence(@dummy.valid_status_code())
  assert_compat_string_sequence("http_method", @dummy.http_method())
  assert_compat_string_sequence("picsum_image", @dummy.picsum_image())
  assert_compat_string_sequence(
    "picsum_image_with_seed",
    @dummy.picsum_image_with_seed(),
  )
  assert_compat_string_sequence(
    "picsum_image_grayscale",
    @dummy.picsum_image_grayscale(),
  )
  assert_compat_string_sequence("picsum_image_blur", @dummy.picsum_image_blur())
  assert_compat_string_sequence(
    "picsum_image_custom",
    @dummy.picsum_image_custom(
      @dummy.image_options(
        width=320,
        height=240,
        grayscale=true,
        blur=4,
        seed="fixed",
      ),
    ),
  )
}

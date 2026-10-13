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
      fail("\{name} produced an empty docs catalog sample")
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
      fail("\{name} produced an empty docs catalog array")
    }
    for value in values {
      if value.is_empty() {
        fail("\{name} produced an empty docs catalog array item")
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
      fail("\{name} produced an invalid docs catalog sample")
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
  normalized_code : String,
  locale : @locales.Locale,
) -> Unit raise {
  assert_true(!docs_code.is_empty())
  @test.assert_eq(locale.code(), normalized_code)
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
test "docs locales catalog is exposed by facade" {
  let docs = @dummy.docs_locales()
  @test.assert_eq(docs.length(), 13)
  @test.assert_eq(
    docs.map(item => item.docs_code).join("|"),
    "EN|FR_FR|AR_SA|ZH_TW|ZH_CN|JA_JP|PT_BR|PT_PT|DE_DE|IT_IT|CY_GB|NL_NL|FA_IR",
  )
  @test.assert_eq(
    docs.map(item => item.name).join("|"),
    "English|French|Arabic|Traditional Chinese|Simplified Chinese|Japanese|Portuguese - Brazil|Portuguese - Portugal|German|Italian|Cymraeg - Welsh|Dutch|Persian (Iran)",
  )
  for item in docs {
    docs_catalog_assert_locale(item.docs_code, item.locale.code(), item.locale)
  }
}

///|
test "docs catalog covers person address internet and image categories" {
  docs_catalog_assert_string("FirstName", @dummy.first_name())
  docs_catalog_assert_string("LastName", @dummy.last_name())
  docs_catalog_assert_string("Title", @dummy.title())
  docs_catalog_assert_string("Suffix", @dummy.suffix())
  docs_catalog_assert_string("Name", @dummy.name())
  docs_catalog_assert_string("NameWithTitle", @dummy.name_with_title())
  docs_catalog_assert_string("CityPrefix", @dummy.city_prefix())
  docs_catalog_assert_string("CitySuffix", @dummy.city_suffix())
  docs_catalog_assert_string("CityName", @dummy.city_name())
  docs_catalog_assert_string("CountryName", @dummy.country_name())
  docs_catalog_assert_string("CountryCode", @dummy.country_code())
  docs_catalog_assert_string("StreetSuffix", @dummy.street_suffix())
  docs_catalog_assert_string("StreetName", @dummy.street_name())
  docs_catalog_assert_string("TimeZone", @dummy.time_zone())
  docs_catalog_assert_string("StateName", @dummy.state_name())
  docs_catalog_assert_string("StateAbbr", @dummy.state_abbr())
  docs_catalog_assert_string(
    "SecondaryAddressType",
    @dummy.secondary_address_type(),
  )
  docs_catalog_assert_string("SecondaryAddress", @dummy.secondary_address())
  docs_catalog_assert_string("ZipCode", @dummy.zip_code())
  docs_catalog_assert_string("PostCode", @dummy.post_code())
  docs_catalog_assert_string("BuildingNumber", @dummy.building_number())
  docs_catalog_assert_string("Latitude", @dummy.latitude())
  docs_catalog_assert_string("Longitude", @dummy.longitude())
  docs_catalog_assert_string("Geohash", @dummy.geohash(precision=8))
  docs_catalog_assert_string("FreeEmailProvider", @dummy.free_email_provider())
  docs_catalog_assert_string("DomainSuffix", @dummy.domain_suffix())
  docs_catalog_assert_string("FreeEmail", @dummy.free_email())
  docs_catalog_assert_string("SafeEmail", @dummy.safe_email())
  docs_catalog_assert_string("Username", @dummy.username())
  docs_catalog_assert_string(
    "Password",
    @dummy.password(len_range=@dummy.count_range(8, 8)),
  )
  docs_catalog_assert_string("IPv4", @dummy.ipv4())
  docs_catalog_assert_string("IPv6", @dummy.ipv6())
  docs_catalog_assert_string("IP", @dummy.ip())
  docs_catalog_assert_string("MACAddress", @dummy.mac_address())
  docs_catalog_assert_string("UserAgent", @dummy.user_agent())
  docs_catalog_assert_string("Image", @dummy.picsum_image())
  docs_catalog_assert_string("ImageWithSeed", @dummy.picsum_image_with_seed())
  docs_catalog_assert_string("ImageGrayscale", @dummy.picsum_image_grayscale())
  docs_catalog_assert_string("ImageBlur", @dummy.picsum_image_blur())
  docs_catalog_assert_string(
    "ImageCustom",
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
test "docs catalog covers lorem company job phone and markdown" {
  docs_catalog_assert_string("Word", @dummy.word())
  docs_catalog_assert_string_array(
    "Words",
    @dummy.words(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "Sentence",
    @dummy.sentence(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string_array(
    "Sentences",
    @dummy.sentences(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "Paragraph",
    @dummy.paragraph(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string_array(
    "Paragraphs",
    @dummy.paragraphs(count=@dummy.count_range(1, 1)),
  )
  docs_catalog_assert_string("CompanySuffix", @dummy.company_suffix())
  docs_catalog_assert_string("CompanyName", @dummy.company_name())
  docs_catalog_assert_string("Buzzword", @dummy.buzzword())
  docs_catalog_assert_string("BuzzwordMiddle", @dummy.buzzword_middle())
  docs_catalog_assert_string("BuzzwordTail", @dummy.buzzword_tail())
  docs_catalog_assert_string("CatchPhrase", @dummy.catch_phrase())
  docs_catalog_assert_string("BsVerb", @dummy.bs_verb())
  docs_catalog_assert_string("BsAdj", @dummy.bs_adj())
  docs_catalog_assert_string("BsNoun", @dummy.bs_noun())
  docs_catalog_assert_string("Bs", @dummy.bs())
  docs_catalog_assert_string("Profession", @dummy.profession())
  docs_catalog_assert_string("Industry", @dummy.industry())
  docs_catalog_assert_string("Seniority", @dummy.job_seniority())
  docs_catalog_assert_string("Field", @dummy.job_field())
  docs_catalog_assert_string("Position", @dummy.job_position())
  docs_catalog_assert_string("JobTitle", @dummy.job_title())
  docs_catalog_assert_string("PhoneNumber", @dummy.phone_number())
  docs_catalog_assert_string("CellNumber", @dummy.cell_number())
  docs_catalog_assert_string("ItalicWord", @dummy.italic_word())
  docs_catalog_assert_string("BoldWord", @dummy.bold_word())
  docs_catalog_assert_string("Link", @dummy.markdown_link())
  docs_catalog_assert_string(
    "BulletPoints",
    @dummy.bullet_points(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string_array(
    "ListItems",
    @dummy.list_items(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "BlockQuoteSingleLine",
    @dummy.block_quote_single_line(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "BlockQuoteMultiLine",
    @dummy.block_quote_multi_line(count=@dummy.count_range(2, 2)),
  )
  docs_catalog_assert_string(
    "Code",
    @dummy.markdown_code(count=@dummy.count_range(2, 2)),
  )
}

///|
test "docs catalog covers numeric finance filesystem and regional categories" {
  docs_catalog_assert_string("HexColor", @dummy.hex_color())
  docs_catalog_assert_string("RgbColor", @dummy.rgb_color())
  docs_catalog_assert_string("RgbaColor", @dummy.rgba_color())
  docs_catalog_assert_string("HslColor", @dummy.hsl_color())
  docs_catalog_assert_string("HslaColor", @dummy.hsla_color())
  docs_catalog_assert_string("Color", @dummy.color())
  docs_catalog_assert_string("ChronoTime", @dummy.chrono_time())
  docs_catalog_assert_string("ChronoDate", @dummy.chrono_date())
  docs_catalog_assert_string("ChronoDateTime", @dummy.chrono_date_time())
  docs_catalog_assert_int("ChronoDuration", @dummy.chrono_duration(), value => {
    value >= 0
  })
  docs_catalog_assert_string(
    "ChronoDateTimeBefore",
    @dummy.chrono_date_time_before(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "ChronoDateTimeAfter",
    @dummy.chrono_date_time_after(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "ChronoDateTimeBetween",
    @dummy.chrono_date_time_between(0, 10),
  )
  docs_catalog_assert_string("TimeTime", @dummy.time_time())
  docs_catalog_assert_string("TimeDate", @dummy.time_date())
  docs_catalog_assert_string("TimeDateTime", @dummy.time_date_time())
  docs_catalog_assert_int("TimeDuration", @dummy.time_duration(), value => {
    value >= 0
  })
  docs_catalog_assert_string(
    "TimeDateTimeBefore",
    @dummy.time_date_time_before(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "TimeDateTimeAfter",
    @dummy.time_date_time_after(anchor_minutes=1000),
  )
  docs_catalog_assert_string(
    "TimeDateTimeBetween",
    @dummy.time_date_time_between(0, 10),
  )
  docs_catalog_assert_string("Digit", @dummy.digit_string())
  docs_catalog_assert_int("DigitIntCompatibility", @dummy.digit(), value => {
    value >= 0 && value <= 9
  })
  docs_catalog_assert_string(
    "NumberWithFormat",
    @dummy.number_with_format("##-^^"),
  )
  docs_catalog_assert_bool(@dummy.boolean(ratio=50))
  docs_catalog_assert_string("CurrencyCode", @dummy.currency_code())
  docs_catalog_assert_string("CurrencyName", @dummy.currency_name())
  docs_catalog_assert_string("CurrencySymbol", @dummy.currency_symbol())
  docs_catalog_assert_string("Bic", @dummy.bic())
  docs_catalog_assert_string("Isin", @dummy.isin())
  docs_catalog_assert_string("CreditCardNumber", @dummy.credit_card_number())
  docs_catalog_assert_string("Isbn", @dummy.isbn())
  docs_catalog_assert_string("Isbn10", @dummy.isbn10())
  docs_catalog_assert_string("Isbn13", @dummy.isbn13())
  docs_catalog_assert_string("FilePath", @dummy.file_path())
  docs_catalog_assert_string("FileName", @dummy.file_name())
  docs_catalog_assert_string("FileExtension", @dummy.file_extension())
  docs_catalog_assert_string("DirPath", @dummy.dir_path())
  docs_catalog_assert_string("MimeType", @dummy.mime_type())
  docs_catalog_assert_string("Semver", @dummy.semver())
  docs_catalog_assert_string("SemverStable", @dummy.semver_stable())
  docs_catalog_assert_string("SemverUnstable", @dummy.semver_unstable())
  docs_catalog_assert_int("RfcStatusCode", @dummy.rfc_status_code(), value => {
    value >= 100 && value <= 599
  })
  docs_catalog_assert_int("ValidStatusCode", @dummy.valid_status_code(), value => {
    value >= 100 && value <= 599
  })
  docs_catalog_assert_string("HttpMethod", @dummy.http_method())
  docs_catalog_assert_string(
    "HealthInsuranceCode",
    @dummy.health_insurance_code(locale=@dummy.fr_fr),
  )
  docs_catalog_assert_string(
    "LicencePlate",
    @dummy.licence_plate(locale=@dummy.fr_fr),
  )
}

///|
test "docs catalog covers identifier and encoding strings" {
  docs_catalog_assert_string("UUID", @dummy.uuid())
  docs_catalog_assert_string("UUIDv1", @dummy.uuid_v1())
  docs_catalog_assert_string("UUIDv3", @dummy.uuid_v3())
  docs_catalog_assert_string("UUIDv4", @dummy.uuid_v4())
  docs_catalog_assert_string("UUIDv5", @dummy.uuid_v5())
  docs_catalog_assert_string("UUIDv6", @dummy.uuid_v6())
  docs_catalog_assert_string("UUIDv7", @dummy.uuid_v7())
  docs_catalog_assert_string("UUIDv8", @dummy.uuid_v8())
  docs_catalog_assert_string("ULID", @dummy.ulid())
  docs_catalog_assert_string("BsonObjectId", @dummy.bson_object_id())
  docs_catalog_assert_string("BsonOid", @dummy.bson_oid())
  docs_catalog_assert_string("Base64", @dummy.base64(), allow_empty=true)
  docs_catalog_assert_string(
    "Base64Padded",
    @dummy.base64_padded(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "Base64NoPad",
    @dummy.base64_no_pad(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "UrlSafeBase64",
    @dummy.url_safe_base64(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "UrlSafeBase64Padded",
    @dummy.url_safe_base64_padded(),
    allow_empty=true,
  )
  docs_catalog_assert_string(
    "UrlSafeBase64NoPad",
    @dummy.url_safe_base64_no_pad(),
    allow_empty=true,
  )
}

///|
struct FcFeatureCase {
  code : String
  mapped : Bool
} derive(Eq, Debug)

///|
struct FcLocaleCase {
  docs_name : String
  docs_code : String
  locale : @locales.Locale
} derive(Eq, Debug)

///|
fn fc_compat_features() -> Array[FcFeatureCase] {
  [
    { code: "derive", mapped: false, },
    { code: "chrono", mapped: true, },
    { code: "chrono-tz", mapped: false, },
    { code: "http", mapped: true, },
    { code: "ulid", mapped: true, },
    { code: "ferroid", mapped: false, },
    { code: "uuid", mapped: true, },
    { code: "bigdecimal", mapped: false, },
    { code: "decimal", mapped: false, },
    { code: "random_color", mapped: true, },
    { code: "geo", mapped: true, },
    { code: "semver", mapped: true, },
    { code: "serde_json", mapped: false, },
    { code: "time", mapped: true, },
    { code: "zerocopy", mapped: false, },
    { code: "glam", mapped: false, },
    { code: "url", mapped: false, },
    { code: "indexmap", mapped: false, },
    { code: "either", mapped: true, },
    { code: "base64", mapped: true, },
    { code: "bson_oid", mapped: true, },
    { code: "always-true-rng", mapped: false, },
    { code: "maybe-non-empty-collections", mapped: false, },
  ]
}

///|
fn fc_compat_docs_locales() -> Array[FcLocaleCase] {
  [
    { docs_name: "English", docs_code: "EN", locale: @locales.EN, },
    { docs_name: "French", docs_code: "FR_FR", locale: @locales.FR_FR, },
    { docs_name: "Arabic", docs_code: "AR_SA", locale: @locales.AR_SA, },
    {
      docs_name: "Traditional Chinese",
      docs_code: "ZH_TW",
      locale: @locales.ZH_TW,
    },
    {
      docs_name: "Simplified Chinese",
      docs_code: "ZH_CN",
      locale: @locales.ZH_CN,
    },
    { docs_name: "Japanese", docs_code: "JA_JP", locale: @locales.JA_JP, },
    {
      docs_name: "Portuguese - Brazil",
      docs_code: "PT_BR",
      locale: @locales.PT_BR,
    },
    {
      docs_name: "Portuguese - Portugal",
      docs_code: "PT_PT",
      locale: @locales.PT_PT,
    },
    { docs_name: "German", docs_code: "DE_DE", locale: @locales.DE_DE, },
    { docs_name: "Italian", docs_code: "IT_IT", locale: @locales.IT_IT, },
    {
      docs_name: "Cymraeg - Welsh",
      docs_code: "CY_GB",
      locale: @locales.CY_GB,
    },
    { docs_name: "Dutch", docs_code: "NL_NL", locale: @locales.NL_NL, },
    { docs_name: "Persian (Iran)", docs_code: "FA_IR", locale: @locales.FA_IR, },
  ]
}

///|
fn fc_contains_string(items : ArrayView[String], needle : String) -> Bool {
  for item in items {
    if item == needle {
      return true
    }
  }
  false
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
        fail("\{name} produced an empty mapped feature value")
      }
    }
  }
}

///|
test "docs feature catalog order is ported" {
  let features = fc_compat_features()
  @test.assert_eq(features.length(), 23)
  @test.assert_eq(
    features.map(item => item.code).join("|"),
    "derive|chrono|chrono-tz|http|ulid|ferroid|uuid|bigdecimal|decimal|random_color|geo|semver|serde_json|time|zerocopy|glam|url|indexmap|either|base64|bson_oid|always-true-rng|maybe-non-empty-collections",
  )
  let mapped = features.filter(item => item.mapped).map(item => item.code)
  @test.assert_eq(
    mapped.join("|"),
    "chrono|http|ulid|uuid|random_color|geo|semver|time|either|base64|bson_oid",
  )
  for item in features {
    assert_true(!item.code.is_empty())
  }
}

///|
test "docs locale catalog order is ported" {
  let locales = fc_compat_docs_locales()
  @test.assert_eq(locales.length(), 13)
  @test.assert_eq(
    locales.map(item => item.docs_code).join("|"),
    "EN|FR_FR|AR_SA|ZH_TW|ZH_CN|JA_JP|PT_BR|PT_PT|DE_DE|IT_IT|CY_GB|NL_NL|FA_IR",
  )
  assert_true(!fc_contains_string(locales.map(item => item.docs_code), "TR_TR"))
  assert_true(
    fc_contains_string(@locales.all().map(locale => locale.code()), "tr_TR"),
  )
  for item in locales {
    assert_true(!item.docs_name.is_empty())
    fc_assert_non_empty_sequence(
      "docs locale " + item.docs_code,
      @dummy.name(locale=item.locale),
    )
  }
}

///|
test "mapped feature catalog has facade coverage" {
  fc_assert_non_empty_sequence("chrono", @dummy.chrono_date_time())
  fc_assert_non_empty_sequence("ulid", @dummy.ulid())
  fc_assert_non_empty_sequence("uuid", @dummy.uuid_v8())
  fc_assert_non_empty_sequence("random_color", @dummy.color())
  fc_assert_non_empty_sequence("geo", @dummy.geohash(precision=8))
  fc_assert_non_empty_sequence("semver", @dummy.semver())
  fc_assert_non_empty_sequence("time", @dummy.time_date_time())
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
test "docs examples map to locale and convenient facade calls" {
  let rng = @dummy.seed(ddt_seed("examples-locales"))
  let en_name = @dummy.name(locale=@dummy.en).dummy(rng)
  let zh_name = @dummy.name(locale=@dummy.zh_cn).dummy(rng)
  let ja_name = @dummy.name(locale=@dummy.ja_jp).dummy(rng)
  ddt_assert_non_empty("Name(EN)", en_name)
  ddt_assert_non_empty("Name(ZH_CN)", zh_name)
  ddt_assert_non_empty("Name(JA_JP)", ja_name)
  let words = @dummy.words(locale=@dummy.en, count=@dummy.count_range(3, 5)).dummy(
    rng,
  )
  assert_true(words.length() >= 3 && words.length() <= 5)
  for word in words {
    ddt_assert_non_empty("Words(EN, 3..5)", word)
  }
  let sentence = @dummy.sentence(
    locale=@dummy.fr_fr,
    count=@dummy.count_range(5, 10),
  ).dummy(rng)
  ddt_assert_non_empty("Sentence(FR_FR, 5..10)", sentence)
  let email = @dummy.safe_email().dummy(rng)
  assert_true(ddt_valid_email(email))
  assert_true(email.contains("@example."))
  let password = @dummy.password(len_range=@dummy.count_range(10, 20)).dummy(
    rng,
  )
  assert_true(password.length() >= 10 && password.length() <= 20)
  ddt_assert_non_empty("CityName()", @dummy.city_name().dummy(rng))
  ddt_assert_non_empty("CountryName()", @dummy.country_name().dummy(rng))
}

///|
test "docs examples map to ranges collections and deterministic seeds" {
  for
    id in ddt_assert_int_samples(
      "range 1000..9999",
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
    ddt_assert_non_empty("fake::vec![String as Name(); 10]", name)
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
test "docs examples map to date time uuid http picsum and either support" {
  ignore(ddt_assert_string_samples("chrono Date()", @dummy.chrono_date()))
  ignore(ddt_assert_string_samples("chrono Time()", @dummy.chrono_time()))
  ignore(
    ddt_assert_string_samples("chrono DateTime()", @dummy.chrono_date_time()),
  )
  ignore(
    ddt_assert_string_samples(
      "chrono DateTimeBefore(now)",
      @dummy.chrono_date_time_before(anchor_minutes=1000),
    ),
  )
  ignore(
    ddt_assert_string_samples(
      "chrono DateTimeAfter(now)",
      @dummy.chrono_date_time_after(anchor_minutes=1000),
    ),
  )
  ignore(
    ddt_assert_string_samples(
      "chrono DateTimeBetween(start, end)",
      @dummy.chrono_date_time_between(0, 30 * 24 * 60),
    ),
  )
  ignore(ddt_assert_string_samples("time Date()", @dummy.time_date()))
  ignore(ddt_assert_string_samples("time Time()", @dummy.time_time()))
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
    ddt_assert_int_samples("RfcStatusCode()", @dummy.rfc_status_code(), valid=code => {
      code >= 100 && code < 600
    }),
  )
  ignore(
    ddt_assert_int_samples("ValidStatusCode()", @dummy.valid_status_code(), valid=code => {
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
test "docs data feature-backed facade groups remain callable" {
  ignore(ddt_assert_string_samples("feature chrono", @dummy.chrono_date_time()))
  ignore(ddt_assert_string_samples("feature time", @dummy.time_date_time()))
  ignore(
    ddt_assert_int_samples("feature http", @dummy.http_status_code(), valid=code => {
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
  ignore(ddt_assert_string_samples("feature random_color", @dummy.hex_color()))
  ignore(ddt_assert_string_samples("feature semver", @dummy.semver()))
  let phone = @dummy.weighted([
    (1, @dummy.phone_number()),
    (1, @dummy.cell_number()),
  ]).dummy(@dummy.seed(ddt_seed("feature-either")))
  assert_true(ddt_valid_phone(phone))
}

///|
struct FdmGeneratorCategory {
  id : String
  title : String
  codes : Array[String]
  supported : Bool
  note_feature : String?
}

///|
fn fdm_generator_categories() -> Array[FdmGeneratorCategory] {
  [
    {
      id: "generator-name",
      title: "Name",
      codes: [
        "FirstName()", "LastName()", "Title()", "Suffix()", "Name()", "NameWithTitle()",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-address",
      title: "Address",
      codes: [
        "CityPrefix()", "CitySuffix()", "CityName()", "CountryName()", "CountryCode()",
        "StreetSuffix()", "StreetName()", "TimeZone()", "StateName()", "StateAbbr()",
        "SecondaryAddressType()", "SecondaryAddress()", "ZipCode()", "PostCode()",
        "BuildingNumber()", "Latitude()", "Longitude()", "Geohash(precision: u8)",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-internet",
      title: "Internet",
      codes: [
        "FreeEmailProvider()", "DomainSuffix()", "FreeEmail()", "SafeEmail()", "Username()",
        "Password(len_range: Range<usize>)", "IPv4()", "IPv6()", "IP()", "MACAddress()",
        "UserAgent()",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-picsum",
      title: "Picsum Images",
      codes: [
        "Image()", "ImageWithSeed()", "ImageGrayscale()", "ImageBlur()", "ImageCustom(opts)",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-lorem",
      title: "Lorem Ipsum",
      codes: [
        "Word()", "Words(count: Range<usize>)", "Sentence(count: Range<usize>)",
        "Sentences(count: Range<usize>)", "Paragraph(count: Range<usize>)", "Paragraphs(count: Range<usize>)",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-company",
      title: "Company",
      codes: [
        "CompanySuffix()", "CompanyName()", "Buzzword()", "BuzzwordMiddle()", "BuzzwordTail()",
        "CatchPhrase()", "BsVerb()", "BsAdj()", "BsNoun()", "Bs()", "Profession()",
        "Industry()",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-job",
      title: "Job",
      codes: ["Seniority()", "Field()", "Position()", "Title()"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-phone",
      title: "Phone",
      codes: ["PhoneNumber()", "CellNumber()"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-datetime",
      title: "Date & Time",
      codes: [
        "Time()", "Date()", "DateTime()", "Duration()", "DateTimeBefore(dt)", "DateTimeAfter(dt)",
        "DateTimeBetween(start, end)",
      ],
      supported: true,
      note_feature: Some("chrono|time"),
    },
    {
      id: "generator-color",
      title: "Color",
      codes: [
        "HexColor()", "RgbColor()", "RgbaColor()", "HslColor()", "HslaColor()", "Color()",
      ],
      supported: true,
      note_feature: Some("random_color"),
    },
    {
      id: "generator-number",
      title: "Number",
      codes: ["Digit()", "NumberWithFormat(fmt: &str)"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-boolean",
      title: "Boolean",
      codes: ["Boolean(ratio: u8)"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-currency",
      title: "Currency & Finance",
      codes: [
        "CurrencyCode()", "CurrencyName()", "CurrencySymbol()", "Bic()", "Isin()",
        "CreditCardNumber()",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-barcode",
      title: "Barcode",
      codes: ["Isbn()", "Isbn10()", "Isbn13()"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-filesystem",
      title: "Filesystem",
      codes: [
        "FilePath()", "FileName()", "FileExtension()", "DirPath()", "MimeType()",
        "Semver()", "SemverStable()", "SemverUnstable()",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-http",
      title: "HTTP",
      codes: ["RfcStatusCode()", "ValidStatusCode()"],
      supported: true,
      note_feature: Some("http"),
    },
    {
      id: "generator-markdown",
      title: "Markdown",
      codes: [
        "ItalicWord()", "BoldWord()", "Link()", "BulletPoints(count)", "ListItems(count)",
        "BlockQuoteSingleLine(count)", "BlockQuoteMultiLine(count)", "Code(count)",
      ],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-administrative",
      title: "Administrative",
      codes: ["HealthInsuranceCode()"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-automotive",
      title: "Automotive",
      codes: ["LicencePlate()"],
      supported: true,
      note_feature: None,
    },
    {
      id: "generator-uuid",
      title: "UUID",
      codes: ["UUIDv1()", "UUIDv3()", "UUIDv4()", "UUIDv5()"],
      supported: true,
      note_feature: Some("uuid"),
    },
    {
      id: "generator-ferroid",
      title: "Ferroid IDs",
      codes: [
        "FerroidULID()", "FerroidTwitterId()", "FerroidInstagramId()", "FerroidMastodonId()",
        "FerroidDiscordId()",
      ],
      supported: false,
      note_feature: Some("ferroid"),
    },
    {
      id: "generator-decimal",
      title: "Decimal Numbers",
      codes: [
        "Decimal()", "PositiveDecimal()", "NegativeDecimal()", "NoDecimalPoints()",
      ],
      supported: false,
      note_feature: Some("decimal"),
    },
    {
      id: "generator-bigdecimal",
      title: "Big Decimal Numbers",
      codes: [
        "BigDecimal()", "PositiveBigDecimal()", "NegativeBigDecimal()", "NoBigDecimalPoints()",
      ],
      supported: false,
      note_feature: Some("bigdecimal"),
    },
  ]
}

///|
enum FdmExampleAvailability {
  FacadeExample
  UnsupportedExample
} derive(Eq, Debug)

///|
struct FdmExampleCase {
  title : String
  language : String
  availability : FdmExampleAvailability
  feature : String?
}

///|
fn fdm_example_cases() -> Array[FdmExampleCase] {
  [
    {
      title: "Basic Facade Usage",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Locale-specific Generators",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Convenient Functions (English Locale)",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Custom DummyDefault Types",
      language: "moonbit",
      availability: UnsupportedExample,
      feature: Some("derive"),
    },
    {
      title: "Using Ranges for Primitives",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Generating Collections",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Deterministic Generation with Seeds",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Date & Time Generation",
      language: "moonbit",
      availability: FacadeExample,
      feature: Some("chrono"),
    },
    {
      title: "UUID Generation",
      language: "moonbit",
      availability: FacadeExample,
      feature: Some("uuid"),
    },
    {
      title: "HTTP Status Codes",
      language: "moonbit",
      availability: FacadeExample,
      feature: Some("http"),
    },
    {
      title: "Picsum Image URLs",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
    {
      title: "Generator Choice Support",
      language: "moonbit",
      availability: FacadeExample,
      feature: Some("either"),
    },
    {
      title: "API Usage",
      language: "moonbit",
      availability: FacadeExample,
      feature: None,
    },
  ]
}

///|
fn fdm_seed(label : String) -> Bytes {
  ignore(label)
  b"compat-docs-data-more-port"
}

///|
fn fdm_assert_non_empty(label : String, value : String) -> Unit raise {
  if value.is_empty() {
    fail(label + " produced an empty docs-data-more sample")
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
fn fdm_count_supported(cases : ArrayView[FdmGeneratorCategory]) -> Int32 {
  let mut count = 0
  for case in cases {
    if case.supported {
      count += case.codes.length()
    }
  }
  count
}

///|
fn fdm_total_codes(cases : ArrayView[FdmGeneratorCategory]) -> Int32 {
  let mut count = 0
  for case in cases {
    count += case.codes.length()
  }
  count
}

///|
fn fdm_join_note_features(cases : ArrayView[FdmGeneratorCategory]) -> String {
  let features : Array[String] = []
  for case in cases {
    match case.note_feature {
      Some(feature) => features.push(case.id + "=" + feature)
      None => ()
    }
  }
  features.join("|")
}

///|
fn fdm_assert_unique(values : ArrayView[String]) -> Unit raise {
  for i in 0..<values.length() {
    for j in (i + 1)..<values.length() {
      if values[i] == values[j] {
        fail("duplicate docs-data-more entry: " + values[i])
      }
    }
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
fn fdm_availability_name(availability : FdmExampleAvailability) -> String {
  match availability {
    FacadeExample => "facade"
    UnsupportedExample => "unsupported"
  }
}

///|
fn fdm_join_example_features(cases : ArrayView[FdmExampleCase]) -> String {
  let features : Array[String] = []
  for case in cases {
    match case.feature {
      Some(feature) => features.push(case.title + "=" + feature)
      None => ()
    }
  }
  features.join("|")
}

///|
test "docs generators data preserves per-category function code order" {
  let cases = fdm_generator_categories()
  @test.assert_eq(cases.length(), 23)
  @test.assert_eq(fdm_total_codes(cases), 126)
  @test.assert_eq(fdm_count_supported(cases), 113)
  @test.assert_eq(
    cases.map(case => case.title).join("|"),
    "Name|Address|Internet|Picsum Images|Lorem Ipsum|Company|Job|Phone|Date & Time|Color|Number|Boolean|Currency & Finance|Barcode|Filesystem|HTTP|Markdown|Administrative|Automotive|UUID|Ferroid IDs|Decimal Numbers|Big Decimal Numbers",
  )
  @test.assert_eq(
    cases.map(case => case.id + ":" + case.codes.join(",")).join("|"),
    "generator-name:FirstName(),LastName(),Title(),Suffix(),Name(),NameWithTitle()|generator-address:CityPrefix(),CitySuffix(),CityName(),CountryName(),CountryCode(),StreetSuffix(),StreetName(),TimeZone(),StateName(),StateAbbr(),SecondaryAddressType(),SecondaryAddress(),ZipCode(),PostCode(),BuildingNumber(),Latitude(),Longitude(),Geohash(precision: u8)|generator-internet:FreeEmailProvider(),DomainSuffix(),FreeEmail(),SafeEmail(),Username(),Password(len_range: Range<usize>),IPv4(),IPv6(),IP(),MACAddress(),UserAgent()|generator-picsum:Image(),ImageWithSeed(),ImageGrayscale(),ImageBlur(),ImageCustom(opts)|generator-lorem:Word(),Words(count: Range<usize>),Sentence(count: Range<usize>),Sentences(count: Range<usize>),Paragraph(count: Range<usize>),Paragraphs(count: Range<usize>)|generator-company:CompanySuffix(),CompanyName(),Buzzword(),BuzzwordMiddle(),BuzzwordTail(),CatchPhrase(),BsVerb(),BsAdj(),BsNoun(),Bs(),Profession(),Industry()|generator-job:Seniority(),Field(),Position(),Title()|generator-phone:PhoneNumber(),CellNumber()|generator-datetime:Time(),Date(),DateTime(),Duration(),DateTimeBefore(dt),DateTimeAfter(dt),DateTimeBetween(start, end)|generator-color:HexColor(),RgbColor(),RgbaColor(),HslColor(),HslaColor(),Color()|generator-number:Digit(),NumberWithFormat(fmt: &str)|generator-boolean:Boolean(ratio: u8)|generator-currency:CurrencyCode(),CurrencyName(),CurrencySymbol(),Bic(),Isin(),CreditCardNumber()|generator-barcode:Isbn(),Isbn10(),Isbn13()|generator-filesystem:FilePath(),FileName(),FileExtension(),DirPath(),MimeType(),Semver(),SemverStable(),SemverUnstable()|generator-http:RfcStatusCode(),ValidStatusCode()|generator-markdown:ItalicWord(),BoldWord(),Link(),BulletPoints(count),ListItems(count),BlockQuoteSingleLine(count),BlockQuoteMultiLine(count),Code(count)|generator-administrative:HealthInsuranceCode()|generator-automotive:LicencePlate()|generator-uuid:UUIDv1(),UUIDv3(),UUIDv4(),UUIDv5()|generator-ferroid:FerroidULID(),FerroidTwitterId(),FerroidInstagramId(),FerroidMastodonId(),FerroidDiscordId()|generator-decimal:Decimal(),PositiveDecimal(),NegativeDecimal(),NoDecimalPoints()|generator-bigdecimal:BigDecimal(),PositiveBigDecimal(),NegativeBigDecimal(),NoBigDecimalPoints()",
  )
  @test.assert_eq(
    fdm_join_note_features(cases),
    "generator-datetime=chrono|time|generator-color=random_color|generator-http=http|generator-uuid=uuid|generator-ferroid=ferroid|generator-decimal=decimal|generator-bigdecimal=bigdecimal",
  )
  fdm_assert_unique(cases.map(case => case.id))
}

///|
test "docs locale catalog supports locale-aware facade groups" {
  let docs = @dummy.docs_locales()
  @test.assert_eq(docs.length(), 13)
  for item in docs {
    @test.assert_eq(item.locale.display_name().is_empty(), false)
    assert_true(item.docs_code != "TR_TR")
    fdm_assert_string_gen(
      item.docs_code + " FirstName",
      @dummy.first_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " LastName",
      @dummy.last_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " Name",
      @dummy.name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " Sentence",
      @dummy.sentence(locale=item.locale, count=@dummy.count_range(3, 3)),
    )
    fdm_assert_string_gen(
      item.docs_code + " CityName",
      @dummy.city_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " CountryName",
      @dummy.country_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " CompanyName",
      @dummy.company_name(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " JobTitle",
      @dummy.job_title(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " PhoneNumber",
      @dummy.phone_number(locale=item.locale),
    )
    let email = @dummy.free_email(locale=item.locale).dummy(
      @dummy.seed(fdm_seed(item.docs_code + " FreeEmail")),
    )
    assert_true(fdm_valid_email(email))
    fdm_assert_string_gen(
      item.docs_code + " CurrencyCode",
      @dummy.currency_code(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " ChronoDateTime",
      @dummy.chrono_date_time(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " TimeDateTime",
      @dummy.time_date_time(locale=item.locale),
    )
    fdm_assert_string_gen(
      item.docs_code + " MarkdownLink",
      @dummy.markdown_link(locale=item.locale),
    )
  }
  @test.assert_eq(@dummy.tr_tr.code(), "tr_TR")
  assert_true(
    !@dummy.docs_locales().map(item => item.docs_code).contains("TR_TR"),
  )
}

///|
test "docs supported generator code names have facade shape coverage" {
  let rng = @dummy.seed(fdm_seed("supported-generator-shapes"))
  fdm_assert_string_gen("Title", @dummy.title())
  fdm_assert_string_gen("Suffix", @dummy.suffix())
  fdm_assert_string_gen("NameWithTitle", @dummy.name_with_title())
  fdm_assert_string_gen("StreetSuffix", @dummy.street_suffix())
  fdm_assert_string_gen("StreetName", @dummy.street_name())
  fdm_assert_string_gen("TimeZone", @dummy.time_zone())
  fdm_assert_string_gen("StateName", @dummy.state_name())
  fdm_assert_string_gen("StateAbbr", @dummy.state_abbr())
  fdm_assert_string_gen("SecondaryAddressType", @dummy.secondary_address_type())
  fdm_assert_string_gen("SecondaryAddress", @dummy.secondary_address())
  fdm_assert_string_gen("PostCode", @dummy.post_code())
  fdm_assert_string_gen("BuildingNumber", @dummy.building_number())
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
test "docs examples data records facade availability and smoke behavior" {
  let cases = fdm_example_cases()
  @test.assert_eq(cases.length(), 13)
  @test.assert_eq(
    cases.map(case => case.language).join("|"),
    "moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit|moonbit",
  )
  @test.assert_eq(
    cases.map(case => fdm_availability_name(case.availability)).join("|"),
    "facade|facade|facade|unsupported|facade|facade|facade|facade|facade|facade|facade|facade|facade",
  )
  @test.assert_eq(
    fdm_join_example_features(cases),
    "Custom DummyDefault Types=derive|Date & Time Generation=chrono|UUID Generation=uuid|HTTP Status Codes=http|Generator Choice Support=either",
  )
  fdm_assert_unique(cases.map(case => case.title))
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
  fdm_assert_string_gen("Date example", @dummy.chrono_date())
  fdm_assert_string_gen("Time example", @dummy.chrono_time())
  fdm_assert_string_gen("DateTime example", @dummy.chrono_date_time())
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
struct FddpFeatureCase {
  code : String
  description : String
}

///|
fn fddp_feature_cases() -> Array[FddpFeatureCase] {
  [
    { code: "derive", description: "Enable #[derive(Dummy)] macro", },
    { code: "chrono", description: "Chrono date/time types support", },
    { code: "chrono-tz", description: "Timezone support with chrono-tz", },
    { code: "http", description: "HTTP types support", },
    { code: "ulid", description: "ULID generation", },
    {
      code: "ferroid",
      description: "Ferroid ID generation (Twitter, Instagram, Discord, etc.)",
    },
    {
      code: "uuid",
      description: "UUID generation (v1, v3, v4, v5, v6, v7, v8)",
    },
    { code: "bigdecimal", description: "Big decimal numbers support", },
    { code: "decimal", description: "Decimal string support", },
    { code: "random_color", description: "Random color generation", },
    { code: "geo", description: "Geographic types support", },
    { code: "semver", description: "Semantic versioning support", },
    { code: "serde_json", description: "JSON value generation", },
    { code: "time", description: "Time-family support", },
    { code: "zerocopy", description: "Zerocopy byte order support", },
    { code: "glam", description: "Game linear algebra math support", },
    { code: "url", description: "URL types support", },
    { code: "indexmap", description: "IndexMap support", },
    { code: "either", description: "Either type support", },
    { code: "base64", description: "Base64 encoding", },
    { code: "bson_oid", description: "BSON ObjectId support", },
    {
      code: "always-true-rng",
      description: "Expose AlwaysTrueRng for testing",
    },
    {
      code: "maybe-non-empty-collections",
      description: "Generate non-empty collections",
    },
  ]
}

///|
struct FddpUnsupportedGeneratorCategory {
  id : String
  feature : String
  title : String
  codes : Array[String]
}

///|
fn fddp_unsupported_generator_categories() -> Array[
  FddpUnsupportedGeneratorCategory,
] {
  [
    {
      id: "generator-ferroid",
      feature: "ferroid",
      title: "Ferroid IDs",
      codes: [
        "FerroidULID()", "FerroidTwitterId()", "FerroidInstagramId()", "FerroidMastodonId()",
        "FerroidDiscordId()",
      ],
    },
    {
      id: "generator-decimal",
      feature: "decimal",
      title: "Decimal Numbers",
      codes: [
        "Decimal()", "PositiveDecimal()", "NegativeDecimal()", "NoDecimalPoints()",
      ],
    },
    {
      id: "generator-bigdecimal",
      feature: "bigdecimal",
      title: "Big Decimal Numbers",
      codes: [
        "BigDecimal()", "PositiveBigDecimal()", "NegativeBigDecimal()", "NoBigDecimalPoints()",
      ],
    },
  ]
}

///|
fn fddp_docs_api_samples() -> Array[String] {
  [
    "@dummy.name()", "@dummy.name(locale=@dummy.zh_cn).sample(count=5)", "@dummy.free_email().sample(count=3)",
    "@dummy.password(len_range=@dummy.count_range(12, 24)).sample(count=5)", "@dummy.company_name(locale=@dummy.fr_fr)",
    "@dummy.city_name().sample(count=3)", "@dummy.zip_code()", "@dummy.country_name()",
  ]
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
fn fddp_assert_unique(values : ArrayView[String]) -> Unit raise {
  for i in 0..<values.length() {
    for j in (i + 1)..<values.length() {
      if values[i] == values[j] {
        fail("duplicate docs entry: " + values[i])
      }
    }
  }
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
fn fddp_total_unsupported_generator_codes(
  categories : ArrayView[FddpUnsupportedGeneratorCategory],
) -> Int32 {
  let mut total = 0
  for category in categories {
    total += category.codes.length()
  }
  total
}

///|
fn fddp_join_unsupported_generator_codes(
  categories : ArrayView[FddpUnsupportedGeneratorCategory],
) -> String {
  let codes : Array[String] = []
  for category in categories {
    for code in category.codes {
      codes.push(code)
    }
  }
  codes.join("|")
}

///|
test "docs features data keeps code and description order" {
  let cases = fddp_feature_cases()
  @test.assert_eq(cases.length(), 23)
  @test.assert_eq(
    cases.map(case => case.code).join("|"),
    "derive|chrono|chrono-tz|http|ulid|ferroid|uuid|bigdecimal|decimal|random_color|geo|semver|serde_json|time|zerocopy|glam|url|indexmap|either|base64|bson_oid|always-true-rng|maybe-non-empty-collections",
  )
  @test.assert_eq(
    cases.map(case => case.code + ": " + case.description).join("|"),
    "derive: Enable #[derive(Dummy)] macro|chrono: Chrono date/time types support|chrono-tz: Timezone support with chrono-tz|http: HTTP types support|ulid: ULID generation|ferroid: Ferroid ID generation (Twitter, Instagram, Discord, etc.)|uuid: UUID generation (v1, v3, v4, v5, v6, v7, v8)|bigdecimal: Big decimal numbers support|decimal: Decimal string support|random_color: Random color generation|geo: Geographic types support|semver: Semantic versioning support|serde_json: JSON value generation|time: Time-family support|zerocopy: Zerocopy byte order support|glam: Game linear algebra math support|url: URL types support|indexmap: IndexMap support|either: Either type support|base64: Base64 encoding|bson_oid: BSON ObjectId support|always-true-rng: Expose AlwaysTrueRng for testing|maybe-non-empty-collections: Generate non-empty collections",
  )
  fddp_assert_unique(cases.map(case => case.code))
  for case in cases {
    fddp_assert_non_empty(case.code, case.description)
  }
}

///|
test "docs generators data names every unsupported generator code" {
  let categories = fddp_unsupported_generator_categories()
  @test.assert_eq(categories.length(), 3)
  @test.assert_eq(
    categories.map(category => category.id).join("|"),
    "generator-ferroid|generator-decimal|generator-bigdecimal",
  )
  @test.assert_eq(
    categories.map(category => category.feature).join("|"),
    "ferroid|decimal|bigdecimal",
  )
  @test.assert_eq(
    categories.map(category => category.title).join("|"),
    "Ferroid IDs|Decimal Numbers|Big Decimal Numbers",
  )
  @test.assert_eq(fddp_total_unsupported_generator_codes(categories), 13)
  @test.assert_eq(
    fddp_join_unsupported_generator_codes(categories),
    "FerroidULID()|FerroidTwitterId()|FerroidInstagramId()|FerroidMastodonId()|FerroidDiscordId()|Decimal()|PositiveDecimal()|NegativeDecimal()|NoDecimalPoints()|BigDecimal()|PositiveBigDecimal()|NegativeBigDecimal()|NoBigDecimalPoints()",
  )
  for category in categories {
    assert_true(category.id.has_prefix("generator-"))
    assert_true(!category.feature.is_empty())
    fddp_assert_unique(category.codes)
    for code in category.codes {
      assert_true(code.has_suffix(")"))
      assert_true(code.contains("("))
    }
  }
}

///|
test "docs API Usage samples map to current facade semantics" {
  let commands = fddp_docs_api_samples()
  @test.assert_eq(
    commands.join("|"),
    "@dummy.name()|@dummy.name(locale=@dummy.zh_cn).sample(count=5)|@dummy.free_email().sample(count=3)|@dummy.password(len_range=@dummy.count_range(12, 24)).sample(count=5)|@dummy.company_name(locale=@dummy.fr_fr)|@dummy.city_name().sample(count=3)|@dummy.zip_code()|@dummy.country_name()",
  )
  fddp_assert_unique(commands)
  @test.assert_eq(@dummy.zh_cn.code(), "zh_CN")
  @test.assert_eq(@dummy.fr_fr.code(), "fr_FR")
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
  name : String
  docs_code : String
  normalized_code : String
  locale : @locales.Locale
}

///|
fn ddx_docs_locale_cases() -> Array[DdxDocsLocaleCase] {
  [
    {
      name: "English",
      docs_code: "EN",
      normalized_code: "en",
      locale: @dummy.en,
    },
    {
      name: "French",
      docs_code: "FR_FR",
      normalized_code: "fr_FR",
      locale: @dummy.fr_fr,
    },
    {
      name: "Arabic",
      docs_code: "AR_SA",
      normalized_code: "ar_SA",
      locale: @dummy.ar_sa,
    },
    {
      name: "Traditional Chinese",
      docs_code: "ZH_TW",
      normalized_code: "zh_TW",
      locale: @dummy.zh_tw,
    },
    {
      name: "Simplified Chinese",
      docs_code: "ZH_CN",
      normalized_code: "zh_CN",
      locale: @dummy.zh_cn,
    },
    {
      name: "Japanese",
      docs_code: "JA_JP",
      normalized_code: "ja_JP",
      locale: @dummy.ja_jp,
    },
    {
      name: "Portuguese - Brazil",
      docs_code: "PT_BR",
      normalized_code: "pt_BR",
      locale: @dummy.pt_br,
    },
    {
      name: "Portuguese - Portugal",
      docs_code: "PT_PT",
      normalized_code: "pt_PT",
      locale: @dummy.pt_pt,
    },
    {
      name: "German",
      docs_code: "DE_DE",
      normalized_code: "de_DE",
      locale: @dummy.de_de,
    },
    {
      name: "Italian",
      docs_code: "IT_IT",
      normalized_code: "it_IT",
      locale: @dummy.it_it,
    },
    {
      name: "Cymraeg - Welsh",
      docs_code: "CY_GB",
      normalized_code: "cy_GB",
      locale: @dummy.cy_gb,
    },
    {
      name: "Dutch",
      docs_code: "NL_NL",
      normalized_code: "nl_NL",
      locale: @dummy.nl_nl,
    },
    {
      name: "Persian (Iran)",
      docs_code: "FA_IR",
      normalized_code: "fa_IR",
      locale: @dummy.fa_ir,
    },
  ]
}

///|
enum DdxFeatureStatus {
  DdxFacadeImplemented
  DdxShapeCompatible
  DdxUnsupportedDocsFeature
} derive(Eq, Debug)

///|
struct DdxFeatureCase {
  code : String
  status : DdxFeatureStatus
}

///|
fn ddx_docs_feature_cases() -> Array[DdxFeatureCase] {
  [
    { code: "derive", status: DdxUnsupportedDocsFeature, },
    { code: "chrono", status: DdxFacadeImplemented, },
    { code: "chrono-tz", status: DdxUnsupportedDocsFeature, },
    { code: "http", status: DdxFacadeImplemented, },
    { code: "ulid", status: DdxFacadeImplemented, },
    { code: "ferroid", status: DdxUnsupportedDocsFeature, },
    { code: "uuid", status: DdxFacadeImplemented, },
    { code: "bigdecimal", status: DdxUnsupportedDocsFeature, },
    { code: "decimal", status: DdxUnsupportedDocsFeature, },
    { code: "random_color", status: DdxFacadeImplemented, },
    { code: "geo", status: DdxShapeCompatible, },
    { code: "semver", status: DdxFacadeImplemented, },
    { code: "serde_json", status: DdxUnsupportedDocsFeature, },
    { code: "time", status: DdxFacadeImplemented, },
    { code: "zerocopy", status: DdxUnsupportedDocsFeature, },
    { code: "glam", status: DdxUnsupportedDocsFeature, },
    { code: "url", status: DdxUnsupportedDocsFeature, },
    { code: "indexmap", status: DdxUnsupportedDocsFeature, },
    { code: "either", status: DdxFacadeImplemented, },
    { code: "base64", status: DdxFacadeImplemented, },
    { code: "bson_oid", status: DdxFacadeImplemented, },
    { code: "always-true-rng", status: DdxUnsupportedDocsFeature, },
    { code: "maybe-non-empty-collections", status: DdxUnsupportedDocsFeature, },
  ]
}

///|
struct DdxGeneratorCategoryCase {
  id : String
  title : String
  count : Int32
  facade_supported : Bool
  has_note : Bool
}

///|
fn ddx_docs_generator_category_cases() -> Array[DdxGeneratorCategoryCase] {
  [
    {
      id: "generator-name",
      title: "Name",
      count: 6,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-address",
      title: "Address",
      count: 18,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-internet",
      title: "Internet",
      count: 11,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-picsum",
      title: "Picsum Images",
      count: 5,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-lorem",
      title: "Lorem Ipsum",
      count: 6,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-company",
      title: "Company",
      count: 12,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-job",
      title: "Job",
      count: 4,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-phone",
      title: "Phone",
      count: 2,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-datetime",
      title: "Date & Time",
      count: 7,
      facade_supported: true,
      has_note: true,
    },
    {
      id: "generator-color",
      title: "Color",
      count: 6,
      facade_supported: true,
      has_note: true,
    },
    {
      id: "generator-number",
      title: "Number",
      count: 2,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-boolean",
      title: "Boolean",
      count: 1,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-currency",
      title: "Currency & Finance",
      count: 6,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-barcode",
      title: "Barcode",
      count: 3,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-filesystem",
      title: "Filesystem",
      count: 8,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-http",
      title: "HTTP",
      count: 2,
      facade_supported: true,
      has_note: true,
    },
    {
      id: "generator-markdown",
      title: "Markdown",
      count: 8,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-administrative",
      title: "Administrative",
      count: 1,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-automotive",
      title: "Automotive",
      count: 1,
      facade_supported: true,
      has_note: false,
    },
    {
      id: "generator-uuid",
      title: "UUID",
      count: 4,
      facade_supported: true,
      has_note: true,
    },
    {
      id: "generator-ferroid",
      title: "Ferroid IDs",
      count: 5,
      facade_supported: false,
      has_note: true,
    },
    {
      id: "generator-decimal",
      title: "Decimal Numbers",
      count: 4,
      facade_supported: false,
      has_note: true,
    },
    {
      id: "generator-bigdecimal",
      title: "Big Decimal Numbers",
      count: 4,
      facade_supported: false,
      has_note: true,
    },
  ]
}

///|
struct DdxExampleCase {
  title : String
  language : String
  note_feature : String?
}

///|
fn ddx_docs_example_cases() -> Array[DdxExampleCase] {
  [
    { title: "Basic Facade Usage", language: "moonbit", note_feature: None, },
    {
      title: "Locale-specific Generators",
      language: "moonbit",
      note_feature: None,
    },
    {
      title: "Convenient Functions (English Locale)",
      language: "moonbit",
      note_feature: None,
    },
    {
      title: "Custom DummyDefault Types",
      language: "moonbit",
      note_feature: None,
    },
    {
      title: "Using Ranges for Primitives",
      language: "moonbit",
      note_feature: None,
    },
    {
      title: "Generating Collections",
      language: "moonbit",
      note_feature: None,
    },
    {
      title: "Deterministic Generation with Seeds",
      language: "moonbit",
      note_feature: None,
    },
    {
      title: "Date & Time Generation",
      language: "moonbit",
      note_feature: Some("chrono"),
    },
    {
      title: "UUID Generation",
      language: "moonbit",
      note_feature: Some("uuid"),
    },
    {
      title: "HTTP Status Codes",
      language: "moonbit",
      note_feature: Some("http"),
    },
    { title: "Picsum Image URLs", language: "moonbit", note_feature: None, },
    {
      title: "Generator Choice Support",
      language: "moonbit",
      note_feature: Some("either"),
    },
    { title: "API Usage", language: "moonbit", note_feature: None, },
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
fn ddx_assert_unique(values : ArrayView[String]) -> Unit raise {
  for i in 0..<values.length() {
    for j in (i + 1)..<values.length() {
      if values[i] == values[j] {
        fail("duplicate docs value: " + values[i])
      }
    }
  }
}

///|
fn ddx_contains_docs_locale_code(
  cases : ArrayView[DdxDocsLocaleCase],
  code : String,
) -> Bool {
  for case in cases {
    if case.docs_code == code {
      return true
    }
  }
  false
}

///|
fn ddx_feature_status_count(
  cases : ArrayView[DdxFeatureCase],
  status : DdxFeatureStatus,
) -> Int32 {
  let mut count = 0
  for case in cases {
    if case.status == status {
      count += 1
    }
  }
  count
}

///|
fn ddx_generator_total(cases : ArrayView[DdxGeneratorCategoryCase]) -> Int32 {
  let mut total = 0
  for case in cases {
    total += case.count
  }
  total
}

///|
fn ddx_supported_generator_total(
  cases : ArrayView[DdxGeneratorCategoryCase],
) -> Int32 {
  let mut total = 0
  for case in cases {
    if case.facade_supported {
      total += case.count
    }
  }
  total
}

///|
fn ddx_join_category_ids_by_support(
  cases : ArrayView[DdxGeneratorCategoryCase],
  supported : Bool,
) -> String {
  let ids : Array[String] = []
  for case in cases {
    if case.facade_supported == supported {
      ids.push(case.id)
    }
  }
  ids.join("|")
}

///|
fn ddx_join_category_note_ids(
  cases : ArrayView[DdxGeneratorCategoryCase],
) -> String {
  let ids : Array[String] = []
  for case in cases {
    if case.has_note {
      ids.push(case.id)
    }
  }
  ids.join("|")
}

///|
fn ddx_example_language_count(
  cases : ArrayView[DdxExampleCase],
  language : String,
) -> Int32 {
  let mut count = 0
  for case in cases {
    if case.language == language {
      count += 1
    }
  }
  count
}

///|
fn ddx_join_example_note_features(cases : ArrayView[DdxExampleCase]) -> String {
  let features : Array[String] = []
  for case in cases {
    match case.note_feature {
      Some(feature) => features.push(feature)
      None => ()
    }
  }
  features.join("|")
}

///|
test "docs locales data maps to facade locale constants" {
  let cases = ddx_docs_locale_cases()
  let public_cases = @dummy.docs_locales()
  @test.assert_eq(cases.length(), 13)
  @test.assert_eq(public_cases.length(), cases.length())
  @test.assert_eq(
    cases.map(case => case.docs_code).join("|"),
    "EN|FR_FR|AR_SA|ZH_TW|ZH_CN|JA_JP|PT_BR|PT_PT|DE_DE|IT_IT|CY_GB|NL_NL|FA_IR",
  )
  @test.assert_eq(
    public_cases.map(case => case.docs_code).join("|"),
    cases.map(case => case.docs_code).join("|"),
  )
  @test.assert_eq(
    cases.map(case => case.name).join("|"),
    "English|French|Arabic|Traditional Chinese|Simplified Chinese|Japanese|Portuguese - Brazil|Portuguese - Portugal|German|Italian|Cymraeg - Welsh|Dutch|Persian (Iran)",
  )
  @test.assert_eq(
    public_cases.map(case => case.name).join("|"),
    cases.map(case => case.name).join("|"),
  )
  ddx_assert_unique(cases.map(case => case.docs_code))
  for i in 0..<cases.length() {
    let case = cases[i]
    let public_case = public_cases[i]
    assert_true(public_case.locale == case.locale)
    @test.assert_eq(case.locale.code(), case.normalized_code)
    let sample = @dummy.name(locale=case.locale).dummy(
      @dummy.seed(ddx_seed(case.docs_code)),
    )
    assert_true(!sample.is_empty())
  }
  assert_true(cases.length() >= 12)
  @test.assert_eq(@locales.TR_TR.code(), "tr_TR")
  assert_true(!ddx_contains_docs_locale_code(cases, "TR_TR"))
  assert_true(@locales.all().length() > cases.length())
}

///|
test "docs feature flags classify current facade coverage" {
  let cases = ddx_docs_feature_cases()
  @test.assert_eq(cases.length(), 23)
  @test.assert_eq(
    cases.map(case => case.code).join("|"),
    "derive|chrono|chrono-tz|http|ulid|ferroid|uuid|bigdecimal|decimal|random_color|geo|semver|serde_json|time|zerocopy|glam|url|indexmap|either|base64|bson_oid|always-true-rng|maybe-non-empty-collections",
  )
  ddx_assert_unique(cases.map(case => case.code))
  @test.assert_eq(ddx_feature_status_count(cases, DdxFacadeImplemented), 10)
  @test.assert_eq(ddx_feature_status_count(cases, DdxShapeCompatible), 1)
  @test.assert_eq(
    ddx_feature_status_count(cases, DdxUnsupportedDocsFeature),
    12,
  )
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
test "docs generators catalog counts supported and unsupported groups" {
  let cases = ddx_docs_generator_category_cases()
  @test.assert_eq(cases.length(), 23)
  @test.assert_eq(ddx_generator_total(cases), 126)
  @test.assert_eq(ddx_supported_generator_total(cases), 113)
  assert_true(ddx_generator_total(cases) >= 100)
  @test.assert_eq(
    cases.map(case => case.id).join("|"),
    "generator-name|generator-address|generator-internet|generator-picsum|generator-lorem|generator-company|generator-job|generator-phone|generator-datetime|generator-color|generator-number|generator-boolean|generator-currency|generator-barcode|generator-filesystem|generator-http|generator-markdown|generator-administrative|generator-automotive|generator-uuid|generator-ferroid|generator-decimal|generator-bigdecimal",
  )
  ddx_assert_unique(cases.map(case => case.id))
  @test.assert_eq(
    ddx_join_category_ids_by_support(cases, false),
    "generator-ferroid|generator-decimal|generator-bigdecimal",
  )
  @test.assert_eq(
    ddx_join_category_note_ids(cases),
    "generator-datetime|generator-color|generator-http|generator-uuid|generator-ferroid|generator-decimal|generator-bigdecimal",
  )
  for case in cases {
    assert_true(case.id.has_prefix("generator-"))
    assert_true(!case.title.is_empty())
    assert_true(case.count > 0)
  }
}

///|
test "docs examples and html quick map to facade calls" {
  let cases = ddx_docs_example_cases()
  @test.assert_eq(cases.length(), 13)
  @test.assert_eq(ddx_example_language_count(cases, "moonbit"), 13)
  @test.assert_eq(
    ddx_join_example_note_features(cases),
    "chrono|uuid|http|either",
  )
  @test.assert_eq(
    cases.map(case => case.title).join("|"),
    "Basic Facade Usage|Locale-specific Generators|Convenient Functions (English Locale)|Custom DummyDefault Types|Using Ranges for Primitives|Generating Collections|Deterministic Generation with Seeds|Date & Time Generation|UUID Generation|HTTP Status Codes|Picsum Image URLs|Generator Choice Support|API Usage",
  )
  ddx_assert_unique(cases.map(case => case.title))
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

///|
struct SdpGeneratorFieldCase {
  id : String
  icon : String
  title : String
  count : Int32
  first_code : String
  first_desc : String
  last_code : String
  last_desc : String
  note_feature : String?
}

///|
fn sdp_generator_field_cases() -> Array[SdpGeneratorFieldCase] {
  [
    {
      id: "generator-name",
      icon: "👤",
      title: "Name",
      count: 6,
      first_code: "FirstName()",
      first_desc: "Generate a first name",
      last_code: "NameWithTitle()",
      last_desc: "Generate a name with title",
      note_feature: None,
    },
    {
      id: "generator-address",
      icon: "📍",
      title: "Address",
      count: 18,
      first_code: "CityPrefix()",
      first_desc: "City name prefix",
      last_code: "Geohash(precision: u8)",
      last_desc: "Generate a geohash",
      note_feature: None,
    },
    {
      id: "generator-internet",
      icon: "🌐",
      title: "Internet",
      count: 11,
      first_code: "FreeEmailProvider()",
      first_desc: "Free email provider domain",
      last_code: "UserAgent()",
      last_desc: "Generate a user agent string",
      note_feature: None,
    },
    {
      id: "generator-picsum",
      icon: "🖼️",
      title: "Picsum Images",
      count: 5,
      first_code: "Image()",
      first_desc: "Random image URL from Picsum",
      last_code: "ImageCustom(opts)",
      last_desc: "Custom image with ImageOptions",
      note_feature: None,
    },
    {
      id: "generator-lorem",
      icon: "📝",
      title: "Lorem Ipsum",
      count: 6,
      first_code: "Word()",
      first_desc: "Generate a single word",
      last_code: "Paragraphs(count: Range<usize>)",
      last_desc: "Generate multiple paragraphs",
      note_feature: None,
    },
    {
      id: "generator-company",
      icon: "🏢",
      title: "Company",
      count: 12,
      first_code: "CompanySuffix()",
      first_desc: "Company suffix (Inc., LLC, etc.)",
      last_code: "Industry()",
      last_desc: "Generate an industry",
      note_feature: None,
    },
    {
      id: "generator-job",
      icon: "💼",
      title: "Job",
      count: 4,
      first_code: "Seniority()",
      first_desc: "Job seniority level",
      last_code: "Title()",
      last_desc: "Complete job title",
      note_feature: None,
    },
    {
      id: "generator-phone",
      icon: "📱",
      title: "Phone",
      count: 2,
      first_code: "PhoneNumber()",
      first_desc: "Generate a phone number",
      last_code: "CellNumber()",
      last_desc: "Generate a cell phone number",
      note_feature: None,
    },
    {
      id: "generator-datetime",
      icon: "📅",
      title: "Date & Time",
      count: 7,
      first_code: "Time()",
      first_desc: "Generate a time",
      last_code: "DateTimeBetween(start, end)",
      last_desc: "DateTime between two times",
      note_feature: Some("chrono|time"),
    },
    {
      id: "generator-color",
      icon: "🎨",
      title: "Color",
      count: 6,
      first_code: "HexColor()",
      first_desc: "Hex color (#RRGGBB)",
      last_code: "Color()",
      last_desc: "Random color object",
      note_feature: Some("random_color"),
    },
    {
      id: "generator-number",
      icon: "🔢",
      title: "Number",
      count: 2,
      first_code: "Digit()",
      first_desc: "Generate a single digit",
      last_code: "NumberWithFormat(fmt: &str)",
      last_desc: "Number with format (^ = 1-9, # = 0-9)",
      note_feature: None,
    },
    {
      id: "generator-boolean",
      icon: "✅",
      title: "Boolean",
      count: 1,
      first_code: "Boolean(ratio: u8)",
      first_desc: "Boolean with probability ratio",
      last_code: "Boolean(ratio: u8)",
      last_desc: "Boolean with probability ratio",
      note_feature: None,
    },
    {
      id: "generator-currency",
      icon: "💰",
      title: "Currency & Finance",
      count: 6,
      first_code: "CurrencyCode()",
      first_desc: "Currency code (USD, EUR, etc.)",
      last_code: "CreditCardNumber()",
      last_desc: "Generate a credit card number",
      note_feature: None,
    },
    {
      id: "generator-barcode",
      icon: "📊",
      title: "Barcode",
      count: 3,
      first_code: "Isbn()",
      first_desc: "ISBN (10 or 13)",
      last_code: "Isbn13()",
      last_desc: "13-digit ISBN",
      note_feature: None,
    },
    {
      id: "generator-filesystem",
      icon: "📁",
      title: "Filesystem",
      count: 8,
      first_code: "FilePath()",
      first_desc: "Generate a file path",
      last_code: "SemverUnstable()",
      last_desc: "Unstable semantic version",
      note_feature: None,
    },
    {
      id: "generator-http",
      icon: "🌐",
      title: "HTTP",
      count: 2,
      first_code: "RfcStatusCode()",
      first_desc: "RFC HTTP status code",
      last_code: "ValidStatusCode()",
      last_desc: "Valid HTTP status code",
      note_feature: Some("http"),
    },
    {
      id: "generator-markdown",
      icon: "📄",
      title: "Markdown",
      count: 8,
      first_code: "ItalicWord()",
      first_desc: "Italic formatted word",
      last_code: "Code(count)",
      last_desc: "Code block",
      note_feature: None,
    },
    {
      id: "generator-administrative",
      icon: "🏥",
      title: "Administrative",
      count: 1,
      first_code: "HealthInsuranceCode()",
      first_desc: "Health insurance code",
      last_code: "HealthInsuranceCode()",
      last_desc: "Health insurance code",
      note_feature: None,
    },
    {
      id: "generator-automotive",
      icon: "🚗",
      title: "Automotive",
      count: 1,
      first_code: "LicencePlate()",
      first_desc: "Vehicle license plate",
      last_code: "LicencePlate()",
      last_desc: "Vehicle license plate",
      note_feature: None,
    },
    {
      id: "generator-uuid",
      icon: "🆔",
      title: "UUID",
      count: 4,
      first_code: "UUIDv1()",
      first_desc: "UUID version 1",
      last_code: "UUIDv5()",
      last_desc: "UUID version 5",
      note_feature: Some("uuid"),
    },
    {
      id: "generator-ferroid",
      icon: "🔗",
      title: "Ferroid IDs",
      count: 5,
      first_code: "FerroidULID()",
      first_desc: "Ferroid ULID",
      last_code: "FerroidDiscordId()",
      last_desc: "Discord ID format",
      note_feature: Some("ferroid"),
    },
    {
      id: "generator-decimal",
      icon: "💯",
      title: "Decimal Numbers",
      count: 4,
      first_code: "Decimal()",
      first_desc: "Random decimal",
      last_code: "NoDecimalPoints()",
      last_desc: "Decimal without fractional part",
      note_feature: Some("decimal"),
    },
    {
      id: "generator-bigdecimal",
      icon: "🔢",
      title: "Big Decimal Numbers",
      count: 4,
      first_code: "BigDecimal()",
      first_desc: "Random big decimal",
      last_code: "NoBigDecimalPoints()",
      last_desc: "Big decimal without fractional part",
      note_feature: Some("bigdecimal"),
    },
  ]
}

///|
struct SdpExampleFileCase {
  file : String
  docs_touchpoint : String
}

///|
fn sdp_example_file_cases() -> Array[SdpExampleFileCase] {
  [
    {
      file: "readme-custom-defaults",
      docs_touchpoint: "Custom DummyDefault Types",
    },
    { file: "readme-collections", docs_touchpoint: "Generating Collections", },
    { file: "readme-composition", docs_touchpoint: "Generator Choice Support", },
    { file: "readme-generators", docs_touchpoint: "Available Generators", },
    { file: "readme-basic", docs_touchpoint: "Basic Facade Usage", },
    { file: "readme-ranges", docs_touchpoint: "Using Ranges for Primitives", },
    { file: "readme-seeded", docs_touchpoint: "Quick Reference", },
    { file: "readme-api", docs_touchpoint: "API Usage", },
  ]
}

///|
fn sdp_docs_example_titles() -> Array[String] {
  [
    "Basic Facade Usage", "Locale-specific Generators", "Convenient Functions (English Locale)",
    "Custom DummyDefault Types", "Using Ranges for Primitives", "Generating Collections",
    "Deterministic Generation with Seeds", "Date & Time Generation", "UUID Generation",
    "HTTP Status Codes", "Picsum Image URLs", "Generator Choice Support", "API Usage",
  ]
}

///|
fn sdp_join_note_features(cases : ArrayView[SdpGeneratorFieldCase]) -> String {
  let out : Array[String] = []
  for case in cases {
    match case.note_feature {
      Some(feature) => out.push(case.id + "=" + feature)
      None => ()
    }
  }
  out.join("|")
}

///|
fn sdp_total_generator_count(cases : ArrayView[SdpGeneratorFieldCase]) -> Int32 {
  let mut total = 0
  for case in cases {
    total += case.count
  }
  total
}

///|
fn sdp_assert_unique(values : ArrayView[String]) -> Unit raise {
  for i in 0..<values.length() {
    for j in (i + 1)..<values.length() {
      if values[i] == values[j] {
        fail("duplicate docs subagent value: " + values[i])
      }
    }
  }
}

///|
fn sdp_code_looks_like_docs_locale(code : String) -> Bool {
  if code == "EN" {
    return true
  }
  code.length() == 5 && code.get_char(2) == Some('_')
}

///|
fn sdp_contains(values : ArrayView[String], needle : String) -> Bool {
  for value in values {
    if value == needle {
      return true
    }
  }
  false
}

///|
test "docs generators data preserves icons and edge descriptions" {
  let cases = sdp_generator_field_cases()
  @test.assert_eq(cases.length(), 23)
  @test.assert_eq(sdp_total_generator_count(cases), 126)
  @test.assert_eq(
    cases.map(case => case.icon).join("|"),
    "👤|📍|🌐|🖼️|📝|🏢|💼|📱|📅|🎨|🔢|✅|💰|📊|📁|🌐|📄|🏥|🚗|🆔|🔗|💯|🔢",
  )
  @test.assert_eq(
    cases.map(case => case.title).join("|"),
    "Name|Address|Internet|Picsum Images|Lorem Ipsum|Company|Job|Phone|Date & Time|Color|Number|Boolean|Currency & Finance|Barcode|Filesystem|HTTP|Markdown|Administrative|Automotive|UUID|Ferroid IDs|Decimal Numbers|Big Decimal Numbers",
  )
  @test.assert_eq(
    cases.map(case => case.first_code + ": " + case.first_desc).join("|"),
    "FirstName(): Generate a first name|CityPrefix(): City name prefix|FreeEmailProvider(): Free email provider domain|Image(): Random image URL from Picsum|Word(): Generate a single word|CompanySuffix(): Company suffix (Inc., LLC, etc.)|Seniority(): Job seniority level|PhoneNumber(): Generate a phone number|Time(): Generate a time|HexColor(): Hex color (#RRGGBB)|Digit(): Generate a single digit|Boolean(ratio: u8): Boolean with probability ratio|CurrencyCode(): Currency code (USD, EUR, etc.)|Isbn(): ISBN (10 or 13)|FilePath(): Generate a file path|RfcStatusCode(): RFC HTTP status code|ItalicWord(): Italic formatted word|HealthInsuranceCode(): Health insurance code|LicencePlate(): Vehicle license plate|UUIDv1(): UUID version 1|FerroidULID(): Ferroid ULID|Decimal(): Random decimal|BigDecimal(): Random big decimal",
  )
  @test.assert_eq(
    cases.map(case => case.last_code + ": " + case.last_desc).join("|"),
    "NameWithTitle(): Generate a name with title|Geohash(precision: u8): Generate a geohash|UserAgent(): Generate a user agent string|ImageCustom(opts): Custom image with ImageOptions|Paragraphs(count: Range<usize>): Generate multiple paragraphs|Industry(): Generate an industry|Title(): Complete job title|CellNumber(): Generate a cell phone number|DateTimeBetween(start, end): DateTime between two times|Color(): Random color object|NumberWithFormat(fmt: &str): Number with format (^ = 1-9, # = 0-9)|Boolean(ratio: u8): Boolean with probability ratio|CreditCardNumber(): Generate a credit card number|Isbn13(): 13-digit ISBN|SemverUnstable(): Unstable semantic version|ValidStatusCode(): Valid HTTP status code|Code(count): Code block|HealthInsuranceCode(): Health insurance code|LicencePlate(): Vehicle license plate|UUIDv5(): UUID version 5|FerroidDiscordId(): Discord ID format|NoDecimalPoints(): Decimal without fractional part|NoBigDecimalPoints(): Big decimal without fractional part",
  )
  @test.assert_eq(
    sdp_join_note_features(cases),
    "generator-datetime=chrono|time|generator-color=random_color|generator-http=http|generator-uuid=uuid|generator-ferroid=ferroid|generator-decimal=decimal|generator-bigdecimal=bigdecimal",
  )
  sdp_assert_unique(cases.map(case => case.id))
}

///|
test "docs locales data keeps public locale names and code shape" {
  let docs = @dummy.docs_locales()
  @test.assert_eq(docs.length(), 13)
  @test.assert_eq(
    docs
    .map(item => item.name + "=" + item.docs_code + "/" + item.locale.code())
    .join("|"),
    "English=EN/en|French=FR_FR/fr_FR|Arabic=AR_SA/ar_SA|Traditional Chinese=ZH_TW/zh_TW|Simplified Chinese=ZH_CN/zh_CN|Japanese=JA_JP/ja_JP|Portuguese - Brazil=PT_BR/pt_BR|Portuguese - Portugal=PT_PT/pt_PT|German=DE_DE/de_DE|Italian=IT_IT/it_IT|Cymraeg - Welsh=CY_GB/cy_GB|Dutch=NL_NL/nl_NL|Persian (Iran)=FA_IR/fa_IR",
  )
  for item in docs {
    assert_true(sdp_code_looks_like_docs_locale(item.docs_code))
    assert_true(!item.name.is_empty())
    @test.assert_eq(item.locale.display_name().is_empty(), false)
  }
  sdp_assert_unique(docs.map(item => item.docs_code))
  assert_true(!sdp_contains(docs.map(item => item.docs_code), "TR_TR"))
  @test.assert_eq(@dummy.tr_tr.code(), "tr_TR")
}

///|
test "docs examples data stays aligned with example directory entries" {
  let files = sdp_example_file_cases()
  let titles = sdp_docs_example_titles()
  @test.assert_eq(files.length(), 8)
  @test.assert_eq(titles.length(), 13)
  @test.assert_eq(
    files.map(case => case.file).join("|"),
    "readme-custom-defaults|readme-collections|readme-composition|readme-generators|readme-basic|readme-ranges|readme-seeded|readme-api",
  )
  @test.assert_eq(
    files.map(case => case.file + "=>" + case.docs_touchpoint).join("|"),
    "readme-custom-defaults=>Custom DummyDefault Types|readme-collections=>Generating Collections|readme-composition=>Generator Choice Support|readme-generators=>Available Generators|readme-basic=>Basic Facade Usage|readme-ranges=>Using Ranges for Primitives|readme-seeded=>Quick Reference|readme-api=>API Usage",
  )
  @test.assert_eq(
    titles.join("|"),
    "Basic Facade Usage|Locale-specific Generators|Convenient Functions (English Locale)|Custom DummyDefault Types|Using Ranges for Primitives|Generating Collections|Deterministic Generation with Seeds|Date & Time Generation|UUID Generation|HTTP Status Codes|Picsum Image URLs|Generator Choice Support|API Usage",
  )
  sdp_assert_unique(files.map(case => case.file))
  sdp_assert_unique(titles)
  for case in files {
    assert_true(case.file.has_prefix("readme-"))
    assert_true(!case.docs_touchpoint.is_empty())
  }
  assert_true(sdp_contains(titles, "API Usage"))
  assert_true(sdp_contains(titles, "Picsum Image URLs"))
}

///|
/// English locale constant, equivalent to `EN`.
pub let en : @locales.Locale = @locales.EN

///|
/// French (France) locale constant, equivalent to `FR_FR`.
pub let fr_fr : @locales.Locale = @locales.FR_FR

///|
/// Traditional Chinese locale constant, equivalent to `ZH_TW`.
pub let zh_tw : @locales.Locale = @locales.ZH_TW

///|
/// Simplified Chinese locale constant, equivalent to `ZH_CN`.
pub let zh_cn : @locales.Locale = @locales.ZH_CN

///|
/// Japanese locale constant, equivalent to `JA_JP`.
pub let ja_jp : @locales.Locale = @locales.JA_JP

///|
/// Arabic (Saudi Arabia) locale constant, equivalent to `AR_SA`.
pub let ar_sa : @locales.Locale = @locales.AR_SA

///|
/// Portuguese (Brazil) locale constant, equivalent to `PT_BR`.
pub let pt_br : @locales.Locale = @locales.PT_BR

///|
/// Portuguese (Portugal) locale constant, equivalent to `PT_PT`.
pub let pt_pt : @locales.Locale = @locales.PT_PT

///|
/// German (Germany) locale constant, equivalent to `DE_DE`.
pub let de_de : @locales.Locale = @locales.DE_DE

///|
/// Italian (Italy) locale constant, equivalent to `IT_IT`.
pub let it_it : @locales.Locale = @locales.IT_IT

///|
/// Welsh (Great Britain) locale constant, equivalent to `CY_GB`.
pub let cy_gb : @locales.Locale = @locales.CY_GB

///|
/// Dutch (Netherlands) locale constant, equivalent to `NL_NL`.
pub let nl_nl : @locales.Locale = @locales.NL_NL

///|
/// Turkish (Turkey) locale constant, equivalent to `TR_TR`.
pub let tr_tr : @locales.Locale = @locales.TR_TR

///|
/// Persian (Iran) locale constant, equivalent to `FA_IR`.
pub let fa_ir : @locales.Locale = @locales.FA_IR

///|
/// Build a deterministic random generator from arbitrary seed bytes.
///
/// The seed is normalized to the 32 bytes required by MoonBit's ChaCha8
/// generator: short inputs are zero-padded and long inputs are truncated.
pub fn seed(seed_bytes : Bytes) -> @random.Rand {
  @core.seed(seed_bytes)
}

///|
/// Return the package default deterministic RNG.
///
/// Use this for examples and quick tests. Prefer `seed` when a caller needs a
/// named, reproducible random stream.
pub fn default_seeded() -> @random.Rand {
  @core.default_seeded()
}

///|
/// Create a half-open integer range for `int` and lower-level core samplers.
///
/// Invalid ranges are reported when the range is sampled.
pub fn int_range(start : Int, end : Int) -> @core.IntRange {
  @core.int_range(start, end)
}

///|
/// Create an inclusive non-negative count range for text/list generators.
///
/// Invalid ranges are reported when the range is sampled.
pub fn count_range(min : Int, max : Int) -> @core.CountRange {
  @core.count_range(min, max)
}

///|
/// Return the locale catalog used by documentation.
pub fn docs_locales() -> Array[@locales.DocsLocale] {
  @locales.docs_locales()
}

///|
/// Choose one generator uniformly from `items`, then run that generator.
///
/// Raises `DummyError::EmptyCandidates` if `items` is empty.
pub fn[T] one_of(
  items : ArrayView[@core.Gen[T]],
) -> @core.Gen[T] raise @core.DummyError {
  @core.one_of(items)
}

///|
/// Choose one generator according to positive integer weights.
///
/// Non-positive weights are ignored. Raises if there are no candidates or if no
/// candidate has a positive weight.
pub fn[T] weighted(
  items : ArrayView[(Int, @core.Gen[T])],
) -> @core.Gen[T] raise @core.DummyError {
  @core.weighted(items)
}

///|
/// Options for `picsum_image_custom`.
///
/// `width` and `height` form the Picsum path. `grayscale` and `blur` become
/// query parameters, and `seed` inserts a stable `/seed/<value>/` path segment.
pub(all) struct ImageOptions {
  width : Int
  height : Int
  grayscale : Bool
  blur : Int?
  seed : String?
} derive(Eq, Debug)

///|
/// Construct `ImageOptions` with current defaults.
///
/// Defaults are `640x480`, no grayscale, no blur, and no seed path segment.
pub fn image_options(
  width? : Int = 640,
  height? : Int = 480,
  grayscale? : Bool = false,
  blur? : Int,
  seed? : String,
) -> ImageOptions {
  ImageOptions::{ width, height, grayscale, blur, seed }
}

///|
/// Small convenience facade that stores a locale for repeated generation.
///
/// Use `Dummy::new(locale=...)` when several common generators should share the
/// same locale without passing `locale` each time.
pub(all) struct Dummy {
  locale : @locales.Locale
} derive(Eq, Debug)

///|
/// Create a locale-bound `Dummy` facade. Defaults to English.
pub fn Dummy::new(locale? : @locales.Locale = @locales.EN) -> Dummy {
  Dummy::{ locale, }
}

///|
/// Generate a locale-bound full name.
pub fn Dummy::name(self : Dummy) -> @core.Gen[String] {
  name(locale=self.locale)
}

///|
/// Generate a locale-bound free email address.
pub fn Dummy::email(self : Dummy) -> @core.Gen[String] {
  free_email(locale=self.locale)
}

///|
/// Generate a locale-bound lorem sentence.
pub fn Dummy::sentence(self : Dummy) -> @core.Gen[String] {
  sentence(locale=self.locale)
}

///|
/// Generate a first/given name for `locale`.
pub fn first_name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @name.first_name(locale~)
}

///|
/// Generate a last/family name for `locale`.
pub fn last_name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @name.last_name(locale~)
}

///|
/// Generate a name title or honorific for `locale`.
pub fn title(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @name.title(locale~)
}

///|
/// Generate a name suffix such as `Jr.` when the locale has suffix data.
pub fn suffix(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @name.suffix(locale~)
}

///|
/// Generate a full name using the selected locale's name template.
pub fn name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @name.name(locale~)
}

///|
/// Generate a full name with title using locale-specific ordering.
pub fn name_with_title(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @name.name_with_title(locale~)
}

///|
/// Generate one lorem word from the selected locale's word table.
pub fn word(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @lorem.word(locale~)
}

///|
/// Generate an array of lorem words.
///
/// The number of words is sampled from the inclusive `count` range.
pub fn words(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(3, 6),
) -> @core.Gen[Array[String]] {
  @lorem.words(locale~, count~)
}

///|
/// Generate one sentence ending with locale-specific punctuation.
///
/// The number of words is sampled from the inclusive `count` range.
pub fn sentence(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(4, 10),
) -> @core.Gen[String] {
  @lorem.sentence(locale~, count~)
}

///|
/// Generate an array of lorem sentences.
///
/// The number of sentences is sampled from the inclusive `count` range.
pub fn sentences(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 4),
) -> @core.Gen[Array[String]] {
  @lorem.sentences(locale~, count~)
}

///|
/// Generate one paragraph from locale-backed lorem sentences.
///
/// The number of sentences is sampled from the inclusive `count` range.
pub fn paragraph(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(3, 5),
) -> @core.Gen[String] {
  @lorem.paragraph(locale~, count~)
}

///|
/// Generate an array of lorem paragraphs.
///
/// The number of paragraphs is sampled from the inclusive `count` range.
pub fn paragraphs(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 3),
) -> @core.Gen[Array[String]] {
  @lorem.paragraphs(locale~, count~)
}

///|
/// Generate a city name using locale templates.
pub fn city_name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @address.city_name(locale~)
}

///|
/// Generate a city prefix such as `North` when the locale supports prefixes.
pub fn city_prefix(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.city_prefix(locale~)
}

///|
/// Generate a city suffix such as `town` or a locale-specific equivalent.
pub fn city_suffix(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.city_suffix(locale~)
}

///|
/// Generate a country name from the selected locale's country table.
pub fn country_name(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.country_name(locale~)
}

///|
/// Generate a country code from the default country-code table.
pub fn country_code() -> @core.Gen[String] {
  @address.country_code()
}

///|
/// Generate a full street name using locale-specific templates.
pub fn street_name(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.street_name(locale~)
}

///|
/// Generate a street suffix such as `Street`, `Avenue`, or local equivalents.
pub fn street_suffix(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.street_suffix(locale~)
}

///|
/// Generate a time zone identifier or locale-backed time zone string.
pub fn time_zone(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @address.time_zone(locale~)
}

///|
/// Generate a state, province, or region name.
pub fn state_name(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @address.state_name(locale~)
}

///|
/// Generate the abbreviation paired with a state or region entry.
pub fn state_abbr(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @address.state_abbr(locale~)
}

///|
/// Generate a secondary address type such as `Apt.` or `Suite`.
pub fn secondary_address_type(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.secondary_address_type(locale~)
}

///|
/// Generate a secondary address designator with a random unit number.
pub fn secondary_address(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.secondary_address(locale~)
}

///|
/// Generate a ZIP-code-shaped string for the selected locale.
pub fn zip_code(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @address.zip_code(locale~)
}

///|
/// Generate a postal-code-shaped string for the selected locale.
pub fn post_code(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @address.post_code(locale~)
}

///|
/// Generate a building number from locale-specific number formats.
pub fn building_number(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @address.building_number(locale~)
}

///|
/// Generate a decimal latitude string.
pub fn latitude() -> @core.Gen[String] {
  @address.latitude()
}

///|
/// Generate a decimal longitude string.
pub fn longitude() -> @core.Gen[String] {
  @address.longitude()
}

///|
/// Generate a base32 geohash-like string with `precision` characters.
pub fn geohash(precision? : Int = 8) -> @core.Gen[String] {
  @address.geohash(precision~)
}

///|
/// Generate a company name using locale templates.
pub fn company_name(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @company.company_name(locale~)
}

///|
/// Generate a three-part business catch phrase.
pub fn catch_phrase(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @company.catch_phrase(locale~)
}

///|
/// Generate a company suffix such as `Inc.` or a locale-specific equivalent.
pub fn company_suffix(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @company.company_suffix(locale~)
}

///|
/// Generate the first part of a company buzzword phrase.
pub fn buzzword(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.buzzword(locale~)
}

///|
/// Generate the middle part of a company buzzword phrase.
pub fn buzzword_middle(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @company.buzzword_middle(locale~)
}

///|
/// Generate the tail part of a company buzzword phrase.
pub fn buzzword_tail(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @company.buzzword_tail(locale~)
}

///|
/// Generate a business-speak verb.
pub fn bs_verb(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.bs_verb(locale~)
}

///|
/// Generate a business-speak adjective.
pub fn bs_adj(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.bs_adj(locale~)
}

///|
/// Generate a business-speak noun.
pub fn bs_noun(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.bs_noun(locale~)
}

///|
/// Generate a complete business-speak phrase.
pub fn bs(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.bs(locale~)
}

///|
/// Generate a profession label.
pub fn profession(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.profession(locale~)
}

///|
/// Generate an industry label.
pub fn industry(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @company.industry(locale~)
}

///|
/// Generate a locale-shaped phone number.
pub fn phone_number(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @phone_number.phone_number(locale~)
}

///|
/// Generate a locale-shaped mobile or cell phone number.
pub fn cell_number(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @phone_number.cell_number(locale~)
}

///|
/// Generate a lowercase username from name-and-word name and word patterns.
pub fn username(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @internet.username(locale~)
}

///|
/// Generate a free email provider domain such as `gmail.com`.
pub fn free_email_provider(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @internet.free_email_provider(locale~)
}

///|
/// Generate a domain suffix such as `com`, `org`, or a locale-specific TLD.
pub fn domain_suffix(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @internet.domain_suffix(locale~)
}

///|
/// Generate an email address at a free email provider.
pub fn free_email(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @internet.free_email(locale~)
}

///|
/// Generate an email address under reserved documentation-safe domains.
pub fn safe_email(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @internet.safe_email(locale~)
}

///|
/// Generate a dotted IPv4 address string.
pub fn ipv4() -> @core.Gen[String] {
  @internet.ipv4()
}

///|
/// Generate an IPv6 address string with hexadecimal groups.
pub fn ipv6() -> @core.Gen[String] {
  @internet.ipv6()
}

///|
/// Generate an IP address string.
///
/// This facade currently follows the IPv4 path.
pub fn ip() -> @core.Gen[String] {
  @internet.ip()
}

///|
/// Generate a colon-separated MAC address string.
pub fn mac_address() -> @core.Gen[String] {
  @internet.mac_address()
}

///|
/// Generate a password whose length is sampled from `len_range`.
pub fn password(
  len_range? : @core.CountRange = @core.count_range(8, 16),
) -> @core.Gen[String] {
  @internet.password(len_range~)
}

///|
/// Generate a user-agent string from the user-agent table.
pub fn user_agent() -> @core.Gen[String] {
  @internet.user_agent()
}

///|
/// Generate an ISO-style currency code for `locale`.
pub fn currency_code(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @currency.currency_code(locale~)
}

///|
/// Generate a currency display name for `locale`.
pub fn currency_name(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @currency.currency_name(locale~)
}

///|
/// Generate a currency symbol for `locale`.
pub fn currency_symbol(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @currency.currency_symbol(locale~)
}

///|
/// Generate a job seniority segment such as `Senior` or local equivalent.
pub fn job_seniority(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @job.seniority(locale~)
}

///|
/// Generate a job field segment.
pub fn job_field(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @job.field(locale~)
}

///|
/// Generate a job position segment.
pub fn job_position(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @job.position(locale~)
}

///|
/// Generate a complete job title from locale-specific job templates.
pub fn job_title(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @job.title(locale~)
}

///|
/// Generate a decimal digit from 0 through 9.
pub fn digit() -> @core.Gen[Int] {
  @number.digit()
}

///|
/// Generate a decimal digit string from the `NUMBER_DIGIT` table.
pub fn digit_string() -> @core.Gen[String] {
  @number.digit_string()
}

///|
/// Generate a string by replacing `^` with 1-9 and `#` with 0-9.
///
/// Other characters are copied unchanged.
pub fn number_with_format(fmt : String) -> @core.Gen[String] {
  @number.number_with_format(fmt)
}

///|
/// Generate an integer from a half-open range `[start, end)`.
pub fn int(
  range? : @core.IntRange = @core.int_range(0, 1000),
) -> @core.Gen[Int] {
  @number.int(range~)
}

///|
/// Generate `true` with `ratio` percent probability.
///
/// `ratio` must be between 0 and 100 when sampled.
pub fn boolean(ratio? : Int = 50) -> @core.Gen[Bool] {
  @boolean.boolean(ratio~)
}

///|
/// Generate an ISBN string, choosing ISBN-10 or ISBN-13.
pub fn isbn() -> @core.Gen[String] {
  @barcode.isbn()
}

///|
/// Generate a valid 10-digit ISBN string.
pub fn isbn10() -> @core.Gen[String] {
  @barcode.isbn10()
}

///|
/// Generate a valid 13-digit ISBN string.
pub fn isbn13() -> @core.Gen[String] {
  @barcode.isbn13()
}

///|
/// Generate a Luhn-valid credit card number with a known issuer shape.
pub fn credit_card_number() -> @core.Gen[String] {
  @creditcard.credit_card_number()
}

///|
/// Generate a Bank Identifier Code string.
pub fn bic() -> @core.Gen[String] {
  @finance.bic()
}

///|
/// Generate an International Securities Identification Number.
pub fn isin() -> @core.Gen[String] {
  @finance.isin()
}

///|
/// Generate a locale-specific administrative health insurance code.
///
/// The data currently has meaningful coverage for French-style codes.
pub fn health_insurance_code(
  locale? : @locales.Locale = @locales.FR_FR,
) -> @core.Gen[String] {
  @administrative.health_insurance_code(locale~)
}

///|
/// Generate a locale-shaped vehicle licence plate.
pub fn licence_plate(
  locale? : @locales.Locale = @locales.FR_FR,
) -> @core.Gen[String] {
  @automotive.licence_plate(locale~)
}

///|
/// Generate a hex CSS color string such as `#a1b2c3`.
pub fn hex_color() -> @core.Gen[String] {
  @color.hex_color()
}

///|
/// Generate an `rgb(r, g, b)` color string.
pub fn rgb_color() -> @core.Gen[String] {
  @color.rgb_color()
}

///|
/// Generate an `rgba(r, g, b, a)` color string.
pub fn rgba_color() -> @core.Gen[String] {
  @color.rgba_color()
}

///|
/// Generate an `hsl(h, s%, l%)` color string.
pub fn hsl_color() -> @core.Gen[String] {
  @color.hsl_color()
}

///|
/// Generate an `hsla(h, s%, l%, a)` color string.
pub fn hsla_color() -> @core.Gen[String] {
  @color.hsla_color()
}

///|
/// Generate a multi-line block containing hex, RGB(A), and HSL(A) color strings.
pub fn color() -> @core.Gen[String] {
  @color.color()
}

///|
/// Generate a file path string.
pub fn file_path() -> @core.Gen[String] {
  @filesystem.file_path()
}

///|
/// Generate a file extension without a leading dot.
pub fn file_extension() -> @core.Gen[String] {
  @filesystem.file_extension()
}

///|
/// Generate a file name containing a stem and extension.
pub fn file_name() -> @core.Gen[String] {
  @filesystem.file_name()
}

///|
/// Generate a directory path string.
pub fn dir_path() -> @core.Gen[String] {
  @filesystem.dir_path()
}

///|
/// Generate a MIME type string such as `text/plain`.
pub fn mime_type() -> @core.Gen[String] {
  @filesystem.mime_type()
}

///|
/// Generate a semantic version string, stable or pre-release.
pub fn semver() -> @core.Gen[String] {
  @filesystem.semver()
}

///|
/// Generate a stable semantic version string.
pub fn semver_stable() -> @core.Gen[String] {
  @filesystem.semver_stable()
}

///|
/// Generate a semantic version string with a pre-release suffix.
pub fn semver_unstable() -> @core.Gen[String] {
  @filesystem.semver_unstable()
}

///|
/// Generate a UUID-shaped string without forcing a specific version marker.
///
/// Use `uuid_v4` when the version marker must be `4`.
pub fn uuid() -> @core.Gen[String] {
  @identifier.uuid()
}

///|
/// Generate a UUID string with version marker `1`.
pub fn uuid_v1() -> @core.Gen[String] {
  @identifier.uuid_v1()
}

///|
/// Generate a UUID string with version marker `3`.
pub fn uuid_v3() -> @core.Gen[String] {
  @identifier.uuid_v3()
}

///|
/// Generate a UUID string with version marker `4`.
pub fn uuid_v4() -> @core.Gen[String] {
  @identifier.uuid_v4()
}

///|
/// Generate a UUID string with version marker `5`.
pub fn uuid_v5() -> @core.Gen[String] {
  @identifier.uuid_v5()
}

///|
/// Generate a UUID string with version marker `6`.
pub fn uuid_v6() -> @core.Gen[String] {
  @identifier.uuid_v6()
}

///|
/// Generate a UUID string with version marker `7`.
pub fn uuid_v7() -> @core.Gen[String] {
  @identifier.uuid_v7()
}

///|
/// Generate a UUID string with version marker `8`.
pub fn uuid_v8() -> @core.Gen[String] {
  @identifier.uuid_v8()
}

///|
/// Generate a 26-character Crockford-base32 ULID string.
pub fn ulid() -> @core.Gen[String] {
  @identifier.ulid()
}

///|
/// Generate a 24-character lowercase hexadecimal BSON ObjectId string.
pub fn bson_object_id() -> @core.Gen[String] {
  @identifier.bson_object_id()
}

///|
/// Alias for `bson_object_id`, matching the BSON OID naming.
pub fn bson_oid() -> @core.Gen[String] {
  @identifier.bson_oid()
}

///|
/// Generate a standard base64 string.
pub fn base64() -> @core.Gen[String] {
  @encoding.base64()
}

///|
/// Generate a standard base64 string with padding.
pub fn base64_padded() -> @core.Gen[String] {
  @encoding.base64_padded()
}

///|
/// Generate a standard base64 string without `=` padding.
pub fn base64_no_pad() -> @core.Gen[String] {
  @encoding.base64_no_pad()
}

///|
/// Generate a URL-safe base64 string.
pub fn url_safe_base64() -> @core.Gen[String] {
  @encoding.url_safe_base64()
}

///|
/// Generate a URL-safe base64 string with padding.
pub fn url_safe_base64_padded() -> @core.Gen[String] {
  @encoding.url_safe_base64_padded()
}

///|
/// Generate a URL-safe base64 string without `=` padding.
pub fn url_safe_base64_no_pad() -> @core.Gen[String] {
  @encoding.url_safe_base64_no_pad()
}

///|
/// Generate a chrono-family time string for `locale`.
pub fn chrono_time(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @chrono.time(locale~)
}

///|
/// Generate a chrono-family date string for `locale`.
pub fn chrono_date(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @chrono.date(locale~)
}

///|
/// Generate a chrono-family date-time string for `locale`.
pub fn chrono_date_time(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @chrono.date_time(locale~)
}

///|
/// Generate a duration represented as minutes.
pub fn chrono_duration() -> @core.Gen[Int] {
  @chrono.duration()
}

///|
/// Generate a chrono-family date-time before `anchor_minutes`.
pub fn chrono_date_time_before(
  anchor_minutes? : Int = 0,
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @chrono.date_time_before(anchor_minutes~, locale~)
}

///|
/// Generate a chrono-family date-time after `anchor_minutes`.
pub fn chrono_date_time_after(
  anchor_minutes? : Int = 0,
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @chrono.date_time_after(anchor_minutes~, locale~)
}

///|
/// Generate a chrono-family date-time between two minute offsets.
///
/// Raises `DummyError::InvalidRange` when `start_minutes >= end_minutes`.
pub fn chrono_date_time_between(
  start_minutes : Int,
  end_minutes : Int,
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] raise @core.DummyError {
  @chrono.date_time_between(start_minutes, end_minutes, locale~)
}

///|
/// Generate a time-family time string for `locale`.
pub fn time_time(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @time.time(locale~)
}

///|
/// Generate a time-family date string for `locale`.
pub fn time_date(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @time.date(locale~)
}

///|
/// Generate a time-family date-time string for `locale`.
pub fn time_date_time(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @time.date_time(locale~)
}

///|
/// Generate a duration represented as minutes.
pub fn time_duration() -> @core.Gen[Int] {
  @time.duration()
}

///|
/// Generate a time-family date-time before `anchor_minutes`.
pub fn time_date_time_before(
  anchor_minutes? : Int = 0,
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @time.date_time_before(anchor_minutes~, locale~)
}

///|
/// Generate a time-family date-time after `anchor_minutes`.
pub fn time_date_time_after(
  anchor_minutes? : Int = 0,
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @time.date_time_after(anchor_minutes~, locale~)
}

///|
/// Generate a time-family date-time between two minute offsets.
///
/// Raises `DummyError::InvalidRange` when `start_minutes > end_minutes`.
pub fn time_date_time_between(
  start_minutes : Int,
  end_minutes : Int,
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] raise @core.DummyError {
  @time.date_time_between(start_minutes, end_minutes, locale~)
}

///|
/// Generate one Markdown italic word, for example `*word*`.
pub fn italic_word(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @markdown.italic_word(locale~)
}

///|
/// Generate one Markdown bold word, for example `**word**`.
pub fn bold_word(locale? : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @markdown.bold_word(locale~)
}

///|
/// Generate a Markdown link whose label and path are fake data.
pub fn markdown_link(
  locale? : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @markdown.link(locale~)
}

///|
/// Generate a Markdown bullet list string.
///
/// The number of bullet lines is sampled from the inclusive `count` range.
pub fn bullet_points(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 5),
) -> @core.Gen[String] {
  @markdown.bullet_points(locale~, count~)
}

///|
/// Generate numbered Markdown list item strings.
///
/// The number of items is sampled from the inclusive `count` range.
pub fn list_items(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 5),
) -> @core.Gen[Array[String]] {
  @markdown.list_items(locale~, count~)
}

///|
/// Generate Markdown block quote lines.
pub fn block_quote_single_line(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(1, 3),
) -> @core.Gen[String] {
  @markdown.block_quote_single_line(locale~, count~)
}

///|
/// Generate a multi-line Markdown block quote.
pub fn block_quote_multi_line(
  locale? : @locales.Locale = @locales.EN,
  count? : @core.CountRange = @core.count_range(2, 4),
) -> @core.Gen[String] {
  @markdown.block_quote_multi_line(locale~, count~)
}

///|
/// Generate a fenced Markdown code block.
pub fn markdown_code(
  count? : @core.CountRange = @core.count_range(2, 4),
) -> @core.Gen[String] {
  @markdown.code(count~)
}

///|
/// Generate a valid HTTP status code.
pub fn http_status_code() -> @core.Gen[Int] {
  @http.valid_status_code()
}

///|
/// Generate an RFC-defined HTTP status code.
pub fn rfc_status_code() -> @core.Gen[Int] {
  @http.rfc_status_code()
}

///|
/// Generate a valid HTTP status code.
pub fn valid_status_code() -> @core.Gen[Int] {
  @http.valid_status_code()
}

///|
/// Generate an uppercase HTTP method.
pub fn http_method() -> @core.Gen[String] {
  @http.http_method()
}

///|
/// Generate a random Picsum image URL.
pub fn picsum_image() -> @core.Gen[String] {
  @picsum.image()
}

///|
/// Generate a Picsum image URL containing a random seed path segment.
pub fn picsum_image_with_seed() -> @core.Gen[String] {
  @picsum.image_with_seed()
}

///|
/// Generate a Picsum image URL with the `grayscale` query parameter.
pub fn picsum_image_grayscale() -> @core.Gen[String] {
  @picsum.image_grayscale()
}

///|
/// Generate a Picsum image URL with a random blur query parameter.
pub fn picsum_image_blur() -> @core.Gen[String] {
  @picsum.image_blur()
}

///|
/// Generate a Picsum image URL from explicit `ImageOptions`.
pub fn picsum_image_custom(opts : ImageOptions) -> @core.Gen[String] {
  @picsum.image_custom(@picsum.ImageOptions::{
    width: opts.width,
    height: opts.height,
    grayscale: opts.grayscale,
    blur: opts.blur,
    seed: opts.seed,
  })
}

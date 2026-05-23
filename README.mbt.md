# moonbit-community/dummy

MoonBit fake-data generator library.

This package keeps randomness explicit: callers pass a deterministic `Rand`, so
tests and examples are reproducible across runs. The public facade uses MoonBit
names and options such as `@dummy.seed`, `@dummy.count_range`,
`@dummy.int_range`, `@dummy.name`, and `@dummy.picsum_image_custom`.

The current package documents the implemented public facade, core generator
abstraction, and generators for name, lorem, address, company, phone number,
internet, currency, job, number, boolean, barcode, credit card, finance, color,
filesystem, markdown, HTTP, chrono/time strings, administrative, automotive,
identifier, encoding, and Picsum URL data.

## Design Notes

The library follows MoonBit conventions:

- Generator structs such as `Name(EN)` become snake_case functions such as
  `@dummy.name(locale=@dummy.en)`.
- Every generator returns `@core.Gen[T]` instead of producing a value immediately.
  This keeps the random source explicit and makes tests reproducible.
- Locale-backed tables and templates are centralized in the `data` package.
  Category packages such as `name`, `address`, and `internet` contain only
  generation logic.
- The root package is the stable facade. Subpackages remain public for users who
  want category-level imports, but most application code should depend on
  `@dummy`.
- The API returns plain MoonBit values. Identifier, encoding, semver, HTTP
  status, and date/time generators expose strings or integers that are easy to
  pass through application code and tests.

## Seeded Generation

Use `@dummy.seed` when examples or tests need stable output. The same seed and
the same sequence of generator calls produce the same values.

```mbt check
///|
test "seeded generation is reproducible" {
  let rng1 = @dummy.seed(b"readme-seed")
  let rng2 = @dummy.seed(b"readme-seed")
  let a = @dummy.name(locale=@dummy.zh_cn).dummy(rng1)
  let b = @dummy.name(locale=@dummy.zh_cn).dummy(rng2)
  @test.assert_eq(a, b)
}
```

`@dummy.seed` normalizes input to the 32-byte ChaCha8 seed expected by
`moonbitlang/core/random`: shorter inputs are zero-padded and longer inputs are
truncated.

## Basic Usage

Generators return `@core.Gen[T]`. Call `.dummy(rng)` for one value or
`.sample(count=..., rng)` for an array of values.

```mbt check
///|
test "basic facade usage" {
  let rng = @dummy.default_seeded()
  let name : String = @dummy.name().dummy(rng)
  let email : String = @dummy.safe_email().dummy(rng)
  let words : Array[String] = @dummy.words(count=@dummy.count_range(3, 5)).dummy(
    rng,
  )
  let ids : Array[Int] = @dummy.int(range=@dummy.int_range(1000, 9999)).sample(
    count=4,
    rng,
  )
  assert_true(!name.is_empty())
  assert_true(email.contains("@"))
  assert_true(words.length() >= 3 && words.length() <= 5)
  @test.assert_eq(ids.length(), 4)
}
```

## Locale and Fallback

Locale-specific data is used when data provides it. Other category requests
fall back to shared defaults unless a category is explicitly locale-specific and
unsupported.

```mbt check
///|
test "locale-specific generators" {
  let rng = @dummy.default_seeded()
  let zh_name = @dummy.name(locale=@dummy.zh_tw).dummy(rng)
  let fr_company = @dummy.company_name(locale=@dummy.fr_fr).dummy(rng)
  let ja_sentence = @dummy.sentence(
    locale=@dummy.ja_jp,
    count=@dummy.count_range(4, 8),
  ).dummy(rng)
  assert_true(!zh_name.is_empty())
  assert_true(!fr_company.is_empty())
  assert_true(!ja_sentence.is_empty())
}
```

Supported locale constants:

| Locale | Constant | code |
|---|---|---|
| English | `@dummy.en` | `EN` |
| French | `@dummy.fr_fr` | `FR_FR` |
| Arabic | `@dummy.ar_sa` | `AR_SA` |
| Traditional Chinese | `@dummy.zh_tw` | `ZH_TW` |
| Simplified Chinese | `@dummy.zh_cn` | `ZH_CN` |
| Japanese | `@dummy.ja_jp` | `JA_JP` |
| Portuguese, Brazil | `@dummy.pt_br` | `PT_BR` |
| Portuguese, Portugal | `@dummy.pt_pt` | `PT_PT` |
| German | `@dummy.de_de` | `DE_DE` |
| Italian | `@dummy.it_it` | `IT_IT` |
| Welsh | `@dummy.cy_gb` | `CY_GB` |
| Dutch | `@dummy.nl_nl` | `NL_NL` |
| Turkish | `@dummy.tr_tr` | `TR_TR` |
| Persian, Iran | `@dummy.fa_ir` | `FA_IR` |

## Generator Categories

The facade exposes MoonBit snake_case functions. Locale-aware generators accept
`locale?`; count-based text and markdown generators accept `count?` using
`@dummy.count_range(min, max)`.

| Category | Facade functions |
|---|---|
| Name | `first_name`, `last_name`, `title`, `suffix`, `name`, `name_with_title` |
| Lorem | `word`, `words`, `sentence`, `sentences`, `paragraph`, `paragraphs` |
| Address | `city_prefix`, `city_suffix`, `city_name`, `country_name`, `country_code`, `street_suffix`, `street_name`, `time_zone`, `state_name`, `state_abbr`, `secondary_address_type`, `secondary_address`, `zip_code`, `post_code`, `building_number`, `latitude`, `longitude`, `geohash` |
| Company | `company_suffix`, `company_name`, `buzzword`, `buzzword_middle`, `buzzword_tail`, `catch_phrase`, `bs_verb`, `bs_adj`, `bs_noun`, `bs`, `profession`, `industry` |
| Internet | `free_email_provider`, `domain_suffix`, `free_email`, `safe_email`, `username`, `password`, `ipv4`, `ipv6`, `ip`, `mac_address`, `user_agent` |
| Phone | `phone_number`, `cell_number` |
| Job | `job_seniority`, `job_field`, `job_position`, `job_title` |
| Number and boolean | `digit`, `number_with_format`, `int`, `boolean` |
| Currency, finance, and cards | `currency_code`, `currency_name`, `currency_symbol`, `bic`, `isin`, `credit_card_number` |
| Barcode | `isbn`, `isbn10`, `isbn13` |
| Filesystem and semver strings | `file_path`, `file_name`, `file_extension`, `dir_path`, `mime_type`, `semver`, `semver_stable`, `semver_unstable` |
| Color | `hex_color`, `rgb_color`, `rgba_color`, `hsl_color`, `hsla_color`, `color` |
| Chrono/time strings | `chrono_time`, `chrono_date`, `chrono_date_time`, `chrono_duration`, `chrono_date_time_before`, `chrono_date_time_after`, `chrono_date_time_between`, `time_time`, `time_date`, `time_date_time`, `time_duration`, `time_date_time_before`, `time_date_time_after`, `time_date_time_between` |
| HTTP | `http_status_code`, `rfc_status_code`, `valid_status_code`, `http_method` |
| Markdown | `italic_word`, `bold_word`, `markdown_link`, `bullet_points`, `list_items`, `block_quote_single_line`, `block_quote_multi_line`, `markdown_code` |
| Administrative | `health_insurance_code` |
| Automotive | `licence_plate` |
| Identifier strings | `uuid`, `uuid_v1`, `uuid_v3`, `uuid_v4`, `uuid_v5`, `uuid_v6`, `uuid_v7`, `uuid_v8`, `ulid`, `bson_object_id`, `bson_oid` |
| Encoding strings | `base64`, `base64_padded`, `base64_no_pad`, `url_safe_base64`, `url_safe_base64_padded`, `url_safe_base64_no_pad` |
| Picsum image URLs | `picsum_image`, `picsum_image_with_seed`, `picsum_image_grayscale`, `picsum_image_blur`, `picsum_image_custom` |

## API Reference

This tracks the implemented facade using MoonBit function names, return shapes,
and helper constructors exposed by this package.

### Names

| Function | Description |
|---|---|
| `first_name(locale?)` | First/given name from the selected locale. |
| `last_name(locale?)` | Last/family name from the selected locale. |
| `title(locale?)` | Name title or honorific such as `Mr.` or a locale-specific form. |
| `suffix(locale?)` | Name suffix such as `Jr.` where the locale has data. |
| `name(locale?)` | Full name assembled with the locale template. |
| `name_with_title(locale?)` | Full name with a title, using locale-specific ordering when available. |

### Lorem

| Function | Description |
|---|---|
| `word(locale?)` | One locale-backed lorem word. |
| `words(locale?, count?)` | Array of words; the sampled length is inclusive over `count`. |
| `sentence(locale?, count?)` | Sentence from locale-backed words, ending with `.` for most locales and `。` for Chinese locales. |
| `sentences(locale?, count?)` | Array of generated sentences. |
| `paragraph(locale?, count?)` | Paragraph made from generated sentences. |
| `paragraphs(locale?, count?)` | Array of generated paragraphs. |

### Address

| Function | Description |
|---|---|
| `city_prefix(locale?)` | City prefix such as `North` where supported. |
| `city_suffix(locale?)` | City suffix such as `town` or locale-specific alternatives. |
| `city_name(locale?)` | Full city name rendered from locale templates. |
| `country_name(locale?)` | Country name table entry. |
| `country_code()` | ISO-style country code sampled from the table. |
| `street_suffix(locale?)` | Street suffix such as `Street` or `Ave`. |
| `street_name(locale?)` | Full street name rendered from locale templates. |
| `time_zone(locale?)` | Time zone identifier or locale-backed label. |
| `state_name(locale?)` | State, province, or region name. |
| `state_abbr(locale?)` | Abbreviation paired with `state_name` where data exists. |
| `secondary_address_type(locale?)` | Unit type such as `Apt.` or `Suite`. |
| `secondary_address(locale?)` | Unit designator plus generated number. |
| `zip_code(locale?)` | Locale-shaped ZIP code. |
| `post_code(locale?)` | Locale-shaped postal code. |
| `building_number(locale?)` | Building number rendered from locale patterns. |
| `latitude()` | Decimal latitude string in the range. |
| `longitude()` | Decimal longitude string in the range. |
| `geohash(precision?)` | Base32 geohash-like string with the requested precision. |

### Internet and Contact

| Function | Description |
|---|---|
| `username(locale?)` | Lowercase username assembled from names, words, and digits. |
| `free_email_provider(locale?)` | Free email provider domain. |
| `domain_suffix(locale?)` | Domain suffix such as `com`, `net`, or locale-specific TLDs. |
| `free_email(locale?)` | Email address using a free provider. |
| `safe_email(locale?)` | Email address under reserved documentation domains. |
| `password(len_range?)` | Password string using the password character table. |
| `ipv4()` | Dotted IPv4 string. |
| `ipv6()` | IPv6 string with hexadecimal groups. |
| `ip()` | IPv4 address string; this facade currently follows the IPv4 path. |
| `mac_address()` | Colon-separated MAC address. |
| `user_agent()` | User-agent string from the table. |
| `phone_number(locale?)` | Locale-shaped phone number. |
| `cell_number(locale?)` | Locale-shaped mobile/cell phone number. |

### Business, Money, and IDs

| Function | Description |
|---|---|
| `company_suffix(locale?)` | Company legal suffix. |
| `company_name(locale?)` | Company name rendered from locale templates. |
| `buzzword(locale?)`, `buzzword_middle(locale?)`, `buzzword_tail(locale?)` | Parts of a marketing buzzword phrase. |
| `catch_phrase(locale?)` | Three-part catch phrase. |
| `bs_verb(locale?)`, `bs_adj(locale?)`, `bs_noun(locale?)`, `bs(locale?)` | Business-speak words and complete phrase. |
| `profession(locale?)`, `industry(locale?)` | Profession or industry labels. |
| `job_seniority(locale?)`, `job_field(locale?)`, `job_position(locale?)`, `job_title(locale?)` | Job title parts and full job title. |
| `currency_code(locale?)`, `currency_name(locale?)`, `currency_symbol(locale?)` | Currency metadata. |
| `bic()` | Bank Identifier Code string. |
| `isin()` | International Securities Identification Number with check digit. |
| `credit_card_number()` | Luhn-valid card number with known issuer shape. |

### Formats and Utilities

| Function | Description |
|---|---|
| `digit()` | Integer from 0 through 9. |
| `number_with_format(fmt)` | Replaces `^` with 1-9 and `#` with 0-9. |
| `int(range?)` | Integer sampled from a half-open `[start, end)` range. |
| `boolean(ratio?)` | `true` with the given percentage ratio, 0 through 100. |
| `isbn()`, `isbn10()`, `isbn13()` | ISBN strings with valid check digits. |
| `hex_color()`, `rgb_color()`, `rgba_color()`, `hsl_color()`, `hsla_color()`, `color()` | CSS-like color strings. |
| `file_path()`, `file_name()`, `file_extension()`, `dir_path()`, `mime_type()` | Path, name, extension, directory, and MIME type strings. |
| `semver()`, `semver_stable()`, `semver_unstable()` | Semantic version strings. |
| `uuid*()`, `ulid()`, `bson_object_id()`, `bson_oid()` | Identifier strings with expected lengths and variant/version markers. |
| `base64*()`, `url_safe_base64*()` | Standard or URL-safe base64 strings with optional padding. |
| `http_status_code()`, `rfc_status_code()`, `valid_status_code()`, `http_method()` | HTTP status codes and methods. |

### Date, Time, Markdown, and Images

| Function | Description |
|---|---|
| `chrono_time(locale?)`, `chrono_date(locale?)`, `chrono_date_time(locale?)` | Date/time formatted strings from the chrono generator family. |
| `chrono_duration()` | Duration as minutes. |
| `chrono_date_time_before(anchor_minutes?, locale?)` | Date-time before the anchor minute. |
| `chrono_date_time_after(anchor_minutes?, locale?)` | Date-time after the anchor minute. |
| `chrono_date_time_between(start_minutes, end_minutes, locale?)` | Date-time in the half-open minute range `[start_minutes, end_minutes)`, requiring `start_minutes < end_minutes`. |
| `time_*` variants | Time-formatted strings from the time generator family; `time_date_time_between` samples `[start_minutes, end_minutes]` and accepts equal endpoints. |
| `italic_word(locale?)`, `bold_word(locale?)`, `markdown_link(locale?)` | Inline Markdown strings. |
| `bullet_points(locale?, count?)`, `list_items(locale?, count?)` | Bullet list string or numbered item array. |
| `block_quote_single_line(locale?, count?)`, `block_quote_multi_line(locale?, count?)`, `markdown_code(count?)` | Block quote and fenced code block strings. |
| `health_insurance_code(locale?)` | Locale-specific administrative code. |
| `licence_plate(locale?)` | Locale-specific vehicle plate. |
| `picsum_image*()` | `https://picsum.photos` URLs with variant-specific query/path parts. |

## Deterministic Samples

Sampling is deterministic too. Recreate the RNG with the same seed to reproduce
the same array.

```mbt check
///|
test "sample is deterministic for a fixed seed" {
  let left = @dummy.free_email(locale=@dummy.en).sample(
    count=3,
    @dummy.seed(b"email-sample"),
  )
  let right = @dummy.free_email(locale=@dummy.en).sample(
    count=3,
    @dummy.seed(b"email-sample"),
  )
  @test.assert_eq(left, right)
  @test.assert_eq(left.length(), 3)
  for email in left {
    assert_true(email.contains("@"))
  }
}
```

Use one RNG when you want a deterministic sequence across different generators.

```mbt check
///|
test "one rng can drive a reproducible record" {
  let rng = @dummy.seed(b"profile-record")
  let username = @dummy.username().dummy(rng)
  let password = @dummy.password(len_range=@dummy.count_range(12, 16)).dummy(
    rng,
  )
  let city = @dummy.city_name(locale=@dummy.de_de).dummy(rng)
  assert_true(!username.is_empty())
  assert_true(password.length() >= 12 && password.length() <= 16)
  assert_true(!city.is_empty())
}
```

## Composition

Use `map`, `flat_map`, `one_of`, and `weighted` to build larger generators from
the facade.

```mbt check
///|
test "compose generators" {
  let rng = @dummy.seed(b"composition")
  let label = @dummy.company_name()
    .map(company => "customer: " + company)
    .dummy(rng)
  let contact = @dummy.one_of([@dummy.phone_number(), @dummy.cell_number()]).dummy(
    rng,
  )
  let weighted_bool = @dummy.weighted([
    (90, @dummy.boolean(ratio=100)),
    (10, @dummy.boolean(ratio=0)),
  ]).dummy(rng)
  assert_true(label.has_prefix("customer: "))
  assert_true(!contact.is_empty())
  assert_true(weighted_bool || !weighted_bool)
}
```

## Picsum Image URLs

Picsum helpers generate `https://picsum.photos/...` URLs. Use
`@dummy.image_options` with `@dummy.picsum_image_custom` for fixed dimensions,
optional grayscale, optional blur, and an optional seed path segment.

```mbt check
///|
test "picsum custom image url" {
  let url = @dummy.picsum_image_custom(
    @dummy.image_options(
      width=800,
      height=600,
      grayscale=true,
      blur=5,
      seed="myseed",
    ),
  ).dummy(@dummy.seed(b"picsum-custom"))
  @test.assert_eq(
    url, "https://picsum.photos/seed/myseed/800/600?grayscale&blur=5",
  )
}
```

```mbt check
///|
test "picsum predefined variants" {
  let rng = @dummy.seed(b"picsum-variants")
  let image = @dummy.picsum_image().dummy(rng)
  let gray = @dummy.picsum_image_grayscale().dummy(rng)
  let blur = @dummy.picsum_image_blur().dummy(rng)
  assert_true(image.has_prefix("https://picsum.photos/"))
  assert_true(gray.has_suffix("?grayscale"))
  assert_true(blur.contains("?blur="))
}
```

## Identifier And Encoding Strings

Identifier and encoding generators return strings with stable, documented
shapes.

```mbt check
///|
test "identifier and encoding strings" {
  let rng = @dummy.seed(b"identifier-encoding")
  let uuid = @dummy.uuid_v4().dummy(rng)
  let ulid = @dummy.ulid().dummy(rng)
  let object_id = @dummy.bson_object_id().dummy(rng)
  let encoded = @dummy.url_safe_base64_no_pad().dummy(rng)
  @test.assert_eq(uuid.length(), 36)
  @test.assert_eq(ulid.length(), 26)
  @test.assert_eq(object_id.length(), 24)
  assert_true(!encoded.contains("="))
}
```

## Locale-Specific Reference Data

Administrative and automotive generators use locale-backed data where the
current facade exposes it.

```mbt check
///|
test "locale-specific administrative and automotive data" {
  let rng = @dummy.seed(b"locale-specific")
  let health_code = @dummy.health_insurance_code(locale=@dummy.fr_fr).dummy(rng)
  let plate = @dummy.licence_plate(locale=@dummy.nl_nl).dummy(rng)
  assert_true(!health_code.is_empty())
  assert_true(!plate.is_empty())
}
```

## Custom `DummyDefault`

For project-specific types, implement `@core.DummyDefault` directly.

```mbt check
///|
struct DemoUser {
  name : String
  active : Bool
} derive(Eq, Debug)

///|
impl @core.DummyDefault for DemoUser with fn dummy_default(rng) {
  { name: @dummy.name().dummy(rng), active: @dummy.boolean().dummy(rng) }
}

///|
test "custom dummy default" {
  let user = DemoUser::dummy_default(@dummy.default_seeded())
  assert_true(!user.name.is_empty())
}
```

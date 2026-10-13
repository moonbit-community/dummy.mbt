// Source basis: 5.1.0 locale/category names and selected data.
// License basis: source data is MIT OR Apache-2.0. This package keeps curated
// MoonBit first-wave data plus larger default tables copied into
// `compat_defaults.mbt` and `compat_locale_backed.mbt`.
//
// This package is intentionally data-only. Public functions return raw
// candidate tables or template strings; generator packages decide how to combine
// those pieces with randomness. Keeping locale fallback here makes category
// packages small and keeps data parity checks concentrated in one place.
//
// Naming follows `<category>_<thing>` for candidate tables and
// `<category>_<thing>_template` for style templates. Template tokens
// are literal strings such as `{FirstName}` and are rendered by
// `@core.render_template`.

///|
/// First/given-name candidates for the selected locale.
pub fn name_first_names(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.FR_FR => compat_fr_fr_name_first_name()
    @locales.ZH_CN => compat_zh_cn_name_first_names()
    @locales.ZH_TW => compat_zh_tw_name_first_names()
    @locales.JA_JP => compat_ja_jp_name_first_name()
    @locales.AR_SA => compat_ar_sa_name_first_name()
    @locales.PT_BR => compat_pt_br_name_first_name()
    @locales.PT_PT => compat_pt_pt_name_first_name()
    @locales.DE_DE => compat_de_de_name_first_name()
    @locales.IT_IT => compat_it_it_name_first_name()
    @locales.CY_GB => compat_cy_gb_name_first_name()
    @locales.NL_NL => compat_nl_nl_name_first_name()
    @locales.TR_TR => compat_tr_tr_name_first_name()
    @locales.FA_IR => compat_fa_ir_name_first_name()
    _ => compat_default_name_first_names()
  }
}

///|
/// Last/family-name candidates for the selected locale.
pub fn name_last_names(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.FR_FR => compat_fr_fr_name_last_name()
    @locales.ZH_CN => compat_zh_cn_name_last_names()
    @locales.ZH_TW => compat_zh_tw_name_last_names()
    @locales.JA_JP => compat_ja_jp_name_last_name()
    @locales.AR_SA => compat_ar_sa_name_last_name()
    @locales.PT_BR => compat_pt_br_name_last_name()
    @locales.PT_PT => compat_pt_pt_name_last_name()
    @locales.DE_DE => compat_de_de_name_last_name()
    @locales.IT_IT => compat_it_it_name_last_name()
    @locales.CY_GB => compat_cy_gb_name_last_name()
    @locales.NL_NL => compat_nl_nl_name_last_name()
    @locales.TR_TR => compat_tr_tr_name_last_name()
    @locales.FA_IR => compat_fa_ir_name_last_name()
    _ => compat_default_name_last_names()
  }
}

///|
/// Name-title candidates for the selected locale.
pub fn name_titles(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.FR_FR => compat_fr_fr_name_title()
    @locales.ZH_CN => compat_zh_cn_name_titles()
    @locales.ZH_TW => compat_zh_tw_name_titles()
    @locales.JA_JP => compat_ja_jp_name_title()
    @locales.PT_PT => compat_pt_pt_name_title()
    @locales.DE_DE => compat_de_de_name_title()
    @locales.IT_IT => compat_it_it_name_title()
    @locales.CY_GB => compat_cy_gb_name_title()
    @locales.NL_NL => compat_nl_nl_name_title()
    @locales.TR_TR => compat_tr_tr_name_title()
    @locales.FA_IR => compat_fa_ir_name_title()
    _ => compat_default_name_titles()
  }
}

///|
/// Name-suffix candidates for the selected locale.
pub fn name_suffixes(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN | @locales.ZH_TW => compat_default_name_suffixes()
    @locales.PT_PT => compat_pt_pt_name_suffix()
    @locales.IT_IT => compat_it_it_name_suffix()
    @locales.TR_TR => compat_tr_tr_name_suffix()
    _ => compat_default_name_suffixes()
  }
}

///|
/// Full-name template for the selected locale.
pub fn name_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN | @locales.ZH_TW => "{LastName}{FirstName}"
    @locales.JA_JP => compat_ja_jp_name_tpl()
    @locales.PT_PT => compat_pt_pt_name_tpl()
    @locales.IT_IT => compat_it_it_name_tpl()
    @locales.TR_TR => compat_tr_tr_name_tpl()
    @locales.FA_IR => compat_fa_ir_name_tpl()
    _ => "{FirstName} {LastName}"
  }
}

///|
/// Full-name-with-title template for the selected locale.
pub fn name_with_title_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN | @locales.ZH_TW => "{LastName}{FirstName}{Title}"
    @locales.JA_JP => compat_ja_jp_name_with_title_tpl()
    @locales.PT_PT => compat_pt_pt_name_with_title_tpl()
    @locales.IT_IT => compat_it_it_name_with_title_tpl()
    @locales.TR_TR => compat_tr_tr_name_with_title_tpl()
    @locales.FA_IR => compat_fa_ir_name_with_title_tpl()
    _ => "{Title} {FirstName} {LastName}"
  }
}

///|
/// Lorem word candidates for the selected locale.
pub fn lorem_words(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_lorem_words()
    _ => compat_default_lorem_words()
  }
}

///|
/// City prefix candidates for the selected locale.
pub fn city_prefixes(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_city_prefixes()
    @locales.PT_PT => compat_pt_pt_address_city_prefix()
    @locales.DE_DE => compat_de_de_address_city_prefix()
    @locales.IT_IT => compat_it_it_address_city_prefix()
    @locales.NL_NL => compat_nl_nl_address_city_prefix()
    @locales.TR_TR => compat_tr_tr_address_city_prefix()
    @locales.FA_IR => compat_fa_ir_address_city_prefix()
    _ => compat_default_city_prefixes()
  }
}

///|
/// City suffix candidates for the selected locale.
pub fn city_suffixes(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_city_suffixes()
    @locales.PT_PT => compat_pt_pt_address_city_suffix()
    @locales.DE_DE => compat_de_de_address_city_suffix()
    @locales.IT_IT => compat_it_it_address_city_suffix()
    @locales.NL_NL => compat_nl_nl_address_city_suffix()
    @locales.TR_TR => compat_tr_tr_address_city_suffix()
    @locales.FA_IR => compat_fa_ir_address_city_suffix()
    _ => compat_default_city_suffixes()
  }
}

///|
/// City-name stem candidates for the selected locale.
pub fn city_names(locale : @locales.Locale) -> Array[String] {
  name_last_names(locale)
}

///|
/// City templates for the selected locale.
///
/// Some locales provide several city shapes; callers should choose one
/// template before rendering.
pub fn city_name_templates(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.DE_DE | @locales.NL_NL =>
      [
        "{CityPrefix}{CityName}{CitySuffix}", "{CityPrefix} {CityName}{CitySuffix}",
        "{CityPrefix}-{CityName}{CitySuffix}", "{CityPrefix}-{CityName}{CitySuffix} {River}",
        "{CityName}{CitySuffix}",
      ]
    _ => [city_template(locale), city_with_prefix_template(locale)]
  }
}

///|
/// River placeholder candidates used by German and Dutch city templates.
pub fn city_rivers(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.DE_DE =>
      [
        "(Rhein)", "(Elbe)", "(Donau)", "(Main)", "(Weser)", "(Oder)", "(Neckar)",
        "(Havel)", "(Mosel)", "(Ems)",
      ]
    @locales.NL_NL => ["{River}"]
    _ => []
  }
}

///|
/// Basic city template for locales without a template list.
pub fn city_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN => "{CityName}{CitySuffix}"
    @locales.FR_FR => compat_fr_fr_address_city_tpl()
    @locales.PT_PT => compat_pt_pt_address_city_tpl()
    @locales.IT_IT => compat_it_it_address_city_tpl()
    @locales.CY_GB => compat_cy_gb_address_city_tpl()
    @locales.TR_TR => compat_tr_tr_address_city_tpl()
    @locales.FA_IR => compat_fa_ir_address_city_tpl()
    _ => "{CityName}{CitySuffix}"
  }
}

///|
/// City-with-prefix template for locales without a template list.
pub fn city_with_prefix_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN => "{CityPrefix}{CityName}{CitySuffix}"
    @locales.PT_PT => compat_pt_pt_address_city_with_prefix_tpl()
    @locales.IT_IT => compat_it_it_address_city_with_prefix_tpl()
    @locales.CY_GB => compat_cy_gb_address_city_with_prefix_tpl()
    @locales.TR_TR => compat_tr_tr_address_city_with_prefix_tpl()
    @locales.FA_IR => compat_fa_ir_address_city_with_prefix_tpl()
    _ => "{CityPrefix} {CityName}{CitySuffix}"
  }
}

///|
/// Country-name candidates for the selected locale.
pub fn country_names(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_country_names()
    @locales.FR_FR => compat_fr_fr_address_country()
    @locales.PT_PT => compat_pt_pt_address_country()
    @locales.DE_DE => compat_de_de_address_country()
    @locales.IT_IT => compat_it_it_address_country()
    @locales.CY_GB => compat_cy_gb_address_country()
    @locales.NL_NL => compat_nl_nl_address_country()
    @locales.TR_TR => compat_tr_tr_address_country()
    @locales.FA_IR => compat_fa_ir_address_country()
    _ => compat_default_country_names()
  }
}

///|
/// Country-code candidates shared across locales.
pub fn country_codes() -> Array[String] {
  compat_country_codes()
}

///|
/// Street-suffix candidates for the selected locale.
pub fn street_suffixes(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_street_suffixes()
    @locales.FR_FR => compat_fr_fr_address_street_suffix()
    @locales.PT_BR => compat_pt_br_address_street_suffix()
    @locales.PT_PT => compat_pt_pt_address_street_suffix()
    @locales.DE_DE => compat_de_de_address_street_suffix()
    @locales.IT_IT => compat_it_it_address_street_suffix()
    @locales.CY_GB => compat_cy_gb_address_street_suffix()
    @locales.NL_NL => compat_nl_nl_address_street_suffix()
    @locales.TR_TR => compat_tr_tr_address_street_suffix()
    @locales.FA_IR => compat_fa_ir_address_street_suffix()
    _ => compat_default_street_suffixes()
  }
}

///|
/// Street-name stem candidates for the selected locale.
pub fn street_names(locale : @locales.Locale) -> Array[String] {
  name_last_names(locale)
}

///|
/// Street-name template for the selected locale.
pub fn street_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN => "{StreetName}{StreetSuffix}"
    @locales.FR_FR => compat_fr_fr_address_street_tpl()
    @locales.PT_BR => compat_pt_br_address_street_tpl()
    @locales.PT_PT => compat_pt_pt_address_street_tpl()
    @locales.DE_DE => compat_de_de_address_street_tpl()
    @locales.IT_IT => compat_it_it_address_street_tpl()
    @locales.CY_GB => compat_cy_gb_address_street_tpl()
    @locales.NL_NL => compat_nl_nl_address_street_tpl()
    @locales.TR_TR => compat_tr_tr_address_street_tpl()
    @locales.FA_IR => compat_fa_ir_address_street_tpl()
    _ => "{StreetName} {StreetSuffix}"
  }
}

///|
// Pair state names with abbreviations while tolerating uneven tables.
fn zip_states(
  names : Array[String],
  abbrs : Array[String],
) -> Array[(String, String)] {
  let out : Array[(String, String)] = []
  let limit = if names.length() < abbrs.length() {
    names.length()
  } else {
    abbrs.length()
  }
  for i in 0..<limit {
    out.push((names[i], abbrs[i]))
  }
  out
}

///|
/// State or region candidates as `(name, abbreviation)` pairs.
pub fn states(locale : @locales.Locale) -> Array[(String, String)] {
  match locale {
    @locales.ZH_CN =>
      [("广东", "GD"), ("浙江", "ZJ"), ("江苏", "JS"), ("四川", "SC")]
    @locales.ZH_TW => [("臺北", "TPE"), ("臺中", "TXG"), ("高雄", "KHH")]
    @locales.PT_BR =>
      zip_states(
        compat_pt_br_address_state(),
        compat_pt_br_address_state_abbr(),
      )
    @locales.PT_PT =>
      zip_states(
        compat_pt_pt_address_state(),
        compat_pt_pt_address_state_abbr(),
      )
    @locales.DE_DE =>
      zip_states(
        compat_de_de_address_state(),
        compat_de_de_address_state_abbr(),
      )
    @locales.IT_IT =>
      zip_states(
        compat_it_it_address_state(),
        compat_it_it_address_state_abbr(),
      )
    @locales.NL_NL =>
      zip_states(
        compat_nl_nl_address_state(),
        compat_nl_nl_address_state_abbr(),
      )
    @locales.TR_TR =>
      zip_states(
        compat_tr_tr_address_state(),
        compat_tr_tr_address_state_abbr(),
      )
    @locales.FA_IR =>
      zip_states(
        compat_fa_ir_address_state(),
        compat_fa_ir_address_state_abbr(),
      )
    _ => compat_us_states()
  }
}

///|
/// Time-zone candidates for the selected locale.
pub fn time_zones(locale~ : @locales.Locale = @locales.EN) -> Array[String] {
  match locale {
    @locales.FR_FR => compat_fr_fr_address_time_zone()
    @locales.PT_PT => compat_pt_pt_address_time_zone()
    @locales.IT_IT => compat_it_it_address_time_zone()
    @locales.NL_NL => compat_nl_nl_address_time_zone()
    @locales.TR_TR => compat_tr_tr_address_time_zone()
    @locales.FA_IR => compat_fa_ir_address_time_zone()
    _ => compat_time_zones()
  }
}

///|
/// Chrono-family time format string for the selected locale.
pub fn chrono_time_format(locale~ : @locales.Locale = @locales.EN) -> String {
  match locale {
    @locales.FA_IR | @locales.IT_IT | @locales.PT_PT | @locales.TR_TR =>
      "%H:%M:%S"
    _ => "%H:%M:%S%.f"
  }
}

///|
/// Chrono-family date format string for the selected locale.
pub fn chrono_date_format(locale~ : @locales.Locale = @locales.EN) -> String {
  match locale {
    @locales.FA_IR => "%Y/%m/%d"
    @locales.IT_IT | @locales.PT_PT => "%d-%m-%Y"
    @locales.TR_TR => "%d.%m.%Y"
    _ => "%F"
  }
}

///|
/// Chrono-family date-time format string for the selected locale.
pub fn chrono_datetime_format(
  locale~ : @locales.Locale = @locales.EN,
) -> String {
  match locale {
    @locales.FA_IR => "%Y/%m/%d %H:%M:%S"
    @locales.IT_IT | @locales.PT_PT => "%d-%m-%Y %H:%M:%S"
    @locales.TR_TR => "%d.%m.%Y %H:%M:%S"
    _ => "%+"
  }
}

///|
/// Time-family time format string for the selected locale.
pub fn time_time_format(locale~ : @locales.Locale = @locales.EN) -> String {
  match locale {
    _ => "[hour]:[minute]:[second][subsecond]"
  }
}

///|
/// Time-family date format string for the selected locale.
pub fn time_date_format(locale~ : @locales.Locale = @locales.EN) -> String {
  match locale {
    @locales.FA_IR => "[year]/[month]/[day]"
    @locales.IT_IT | @locales.NL_NL | @locales.PT_PT => "[day]-[month]-[year]"
    @locales.TR_TR => "[day].[month].[year]"
    @locales.PT_BR => "[day]/[month]/[year]"
    _ => "[year]-[month]-[day]"
  }
}

///|
/// Time-family date-time format string for the selected locale.
pub fn time_datetime_format(locale~ : @locales.Locale = @locales.EN) -> String {
  match locale {
    @locales.FA_IR => "[year]/[month]/[day] [hour]:[minute]:[second]"
    @locales.IT_IT | @locales.NL_NL | @locales.PT_PT =>
      "[day]-[month]-[year] [hour]:[minute]:[second]"
    @locales.TR_TR => "[day].[month].[year] [hour]:[minute]:[second]"
    @locales.PT_BR =>
      "[day]/[month]/[year]T[hour]:[minute]:[second][offset_hour sign:mandatory][offset_minute]"
    _ =>
      "[year]-[month]-[day]T[hour]:[minute]:[second][offset_hour sign:mandatory][offset_minute]"
  }
}

///|
/// Secondary-address type candidates for the selected locale.
pub fn secondary_address_types(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.PT_PT => compat_pt_pt_address_secondary_addr_type()
    @locales.DE_DE => compat_de_de_address_secondary_addr_type()
    @locales.IT_IT => compat_it_it_address_secondary_addr_type()
    @locales.NL_NL => compat_nl_nl_address_secondary_addr_type()
    @locales.FA_IR => compat_fa_ir_address_secondary_addr_type()
    _ => compat_default_secondary_address_types()
  }
}

///|
/// Secondary-address template for the selected locale.
pub fn secondary_address_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN => "{Number}{SecondaryAddrType}"
    @locales.PT_PT => compat_pt_pt_address_secondary_addr_tpl()
    @locales.IT_IT => compat_it_it_address_secondary_addr_tpl()
    @locales.CY_GB => compat_cy_gb_address_secondary_addr_tpl()
    @locales.FA_IR => compat_fa_ir_address_secondary_addr_tpl()
    _ => "{SecondaryAddrType} {Number}"
  }
}

///|
/// ZIP-code format patterns for the selected locale.
pub fn zip_formats(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_zip_formats()
    @locales.FR_FR => compat_fr_fr_address_zip_formats()
    @locales.PT_PT => compat_pt_pt_address_zip_formats()
    @locales.DE_DE => compat_de_de_address_zip_formats()
    @locales.IT_IT => compat_it_it_address_zip_formats()
    @locales.NL_NL => compat_nl_nl_address_zip_formats()
    @locales.TR_TR => compat_tr_tr_address_zip_formats()
    @locales.FA_IR => compat_fa_ir_address_zip_formats()
    _ => compat_default_zip_formats()
  }
}

///|
/// Postal-code format patterns for the selected locale.
pub fn post_code_formats(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_post_code_formats()
    @locales.FR_FR => compat_fr_fr_address_postcode_formats()
    @locales.PT_BR => compat_pt_br_address_postcode_formats()
    @locales.PT_PT => compat_pt_pt_address_postcode_formats()
    @locales.IT_IT => compat_it_it_address_postcode_formats()
    @locales.NL_NL => compat_nl_nl_address_postcode_formats()
    @locales.TR_TR => compat_tr_tr_address_postcode_formats()
    @locales.FA_IR => compat_fa_ir_address_postcode_formats()
    _ => compat_default_post_code_formats()
  }
}

///|
/// Building-number format patterns for the selected locale.
pub fn building_number_formats(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_default_building_number_formats()
    @locales.PT_PT => compat_pt_pt_address_building_number_formats()
    @locales.IT_IT => compat_it_it_address_building_number_formats()
    @locales.TR_TR => compat_tr_tr_address_building_number_formats()
    @locales.FA_IR => compat_fa_ir_address_building_number_formats()
    _ => compat_default_building_number_formats()
  }
}

///|
/// Base32 alphabet used by geohash-like strings.
pub fn geohash_chars() -> Array[String] {
  [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "b", "c", "d", "e", "f", "g",
    "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
  ]
}

///|
/// Decimal digit candidates from locale defaults.
pub fn number_digits() -> Array[String] {
  compat_number_digits()
}

///|
/// ISBN EAN prefix from locale defaults.
pub fn isbn_ean_prefix() -> String {
  compat_isbn_ean()
}

///|
/// Company suffix candidates for the selected locale.
pub fn company_suffixes(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_suffixes()
    @locales.PT_BR => compat_pt_br_company_suffix()
    @locales.PT_PT => compat_pt_pt_company_suffix()
    @locales.DE_DE => compat_de_de_company_suffix()
    @locales.IT_IT => compat_it_it_company_suffix()
    @locales.JA_JP => compat_ja_jp_company_suffix()
    @locales.NL_NL => compat_nl_nl_company_suffix()
    @locales.FA_IR => compat_fa_ir_company_suffix()
    _ => compat_default_company_suffixes()
  }
}

///|
/// Company name templates for the selected locale.
pub fn company_name_templates(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => ["{Name_1}{Suffix}"]
    @locales.JA_JP => compat_ja_jp_company_name_tpls()
    @locales.PT_PT => compat_pt_pt_company_name_tpls()
    @locales.IT_IT => compat_it_it_company_name_tpls()
    @locales.CY_GB => compat_cy_gb_company_name_tpls()
    @locales.FA_IR => compat_fa_ir_company_name_tpls()
    _ => ["{Name_1} {Suffix}", "{Name_1} and {Name_2} {Suffix}"]
  }
}

///|
/// First part candidates for company buzzword phrases.
pub fn company_buzzword_heads(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_buzzword_heads()
    @locales.PT_PT => compat_pt_pt_company_buzzword_head()
    @locales.IT_IT => compat_it_it_company_buzzword_head()
    @locales.CY_GB => compat_cy_gb_company_buzzword_head()
    @locales.FA_IR => compat_fa_ir_company_buzzword_head()
    _ => compat_default_company_buzzword_heads()
  }
}

///|
/// Middle part candidates for company buzzword phrases.
pub fn company_buzzword_middles(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_buzzword_middles()
    @locales.PT_PT => compat_pt_pt_company_buzzword_middle()
    @locales.IT_IT => compat_it_it_company_buzzword_middle()
    @locales.CY_GB => compat_cy_gb_company_buzzword_middle()
    @locales.FA_IR => compat_fa_ir_company_buzzword_middle()
    _ => compat_default_company_buzzword_middles()
  }
}

///|
/// Tail part candidates for company buzzword phrases.
pub fn company_buzzword_tails(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_buzzword_tails()
    @locales.PT_PT => compat_pt_pt_company_buzzword_tail()
    @locales.IT_IT => compat_it_it_company_buzzword_tail()
    @locales.CY_GB => compat_cy_gb_company_buzzword_tail()
    @locales.FA_IR => compat_fa_ir_company_buzzword_tail()
    _ => compat_default_company_buzzword_tails()
  }
}

///|
/// Catch-phrase template for the selected locale.
pub fn company_catch_phrase_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN => "{Head}{Middle}{Tail}"
    @locales.PT_PT => compat_pt_pt_company_catch_phase_tpl()
    @locales.IT_IT => compat_it_it_company_catch_phase_tpl()
    @locales.CY_GB => compat_cy_gb_company_catch_phase_tpl()
    @locales.FA_IR => compat_fa_ir_company_catch_phase_tpl()
    _ => "{Head} {Middle} {Tail}"
  }
}

///|
/// Business-speak verb candidates for the selected locale.
pub fn company_bs_verbs(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_bs_verbs()
    @locales.PT_PT => compat_pt_pt_company_bs_verbs()
    @locales.IT_IT => compat_it_it_company_bs_verbs()
    @locales.CY_GB => compat_cy_gb_company_bs_verbs()
    @locales.FA_IR => compat_fa_ir_company_bs_verbs()
    _ => compat_default_company_bs_verbs()
  }
}

///|
/// Business-speak adjective candidates for the selected locale.
pub fn company_bs_adjs(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_bs_adjs()
    @locales.PT_PT => compat_pt_pt_company_bs_adj()
    @locales.IT_IT => compat_it_it_company_bs_adj()
    @locales.CY_GB => compat_cy_gb_company_bs_adj()
    @locales.FA_IR => compat_fa_ir_company_bs_adj()
    _ => compat_default_company_bs_adjs()
  }
}

///|
/// Business-speak noun candidates for the selected locale.
pub fn company_bs_nouns(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_bs_nouns()
    @locales.PT_PT => compat_pt_pt_company_bs_nouns()
    @locales.IT_IT => compat_it_it_company_bs_nouns()
    @locales.CY_GB => compat_cy_gb_company_bs_nouns()
    @locales.FA_IR => compat_fa_ir_company_bs_nouns()
    _ => compat_default_company_bs_nouns()
  }
}

///|
/// Business-speak phrase template for the selected locale.
pub fn company_bs_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.ZH_CN => "{Verb}{Adj}{Noun}"
    @locales.PT_PT => compat_pt_pt_company_bs_tpl()
    @locales.IT_IT => compat_it_it_company_bs_tpl()
    @locales.FA_IR => compat_fa_ir_company_bs_tpl()
    _ => "{Verb} {Adj} {Noun}"
  }
}

///|
/// Industry candidates for the selected locale.
pub fn company_industries(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_industries()
    @locales.PT_PT => compat_pt_pt_company_industry()
    _ => compat_default_company_industries()
  }
}

///|
/// Profession candidates for the selected locale.
pub fn company_professions(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_company_professions()
    @locales.PT_PT => compat_pt_pt_company_profession()
    _ => compat_default_company_professions()
  }
}

///|
/// Job seniority candidates for the selected locale.
pub fn job_seniority(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_job_seniority()
    @locales.JA_JP => compat_ja_jp_job_seniority()
    @locales.PT_PT => compat_pt_pt_job_seniority()
    @locales.IT_IT => compat_it_it_job_seniority()
    @locales.CY_GB => compat_cy_gb_job_seniority()
    @locales.NL_NL => compat_nl_nl_job_seniority()
    @locales.TR_TR => compat_tr_tr_job_seniority()
    @locales.FA_IR => compat_fa_ir_job_seniority()
    _ => compat_default_job_seniority()
  }
}

///|
/// Job field candidates for the selected locale.
pub fn job_fields(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_job_fields()
    @locales.JA_JP => compat_ja_jp_job_field()
    @locales.PT_PT => compat_pt_pt_job_field()
    @locales.IT_IT => compat_it_it_job_field()
    @locales.CY_GB => compat_cy_gb_job_field()
    @locales.NL_NL => compat_nl_nl_job_field()
    @locales.TR_TR => compat_tr_tr_job_field()
    @locales.FA_IR => compat_fa_ir_job_field()
    _ => compat_default_job_fields()
  }
}

///|
/// Job position candidates for the selected locale.
pub fn job_positions(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => compat_zh_cn_job_positions()
    @locales.JA_JP => compat_ja_jp_job_position()
    @locales.PT_PT => compat_pt_pt_job_position()
    @locales.IT_IT => compat_it_it_job_position()
    @locales.CY_GB => compat_cy_gb_job_position()
    @locales.NL_NL => compat_nl_nl_job_position()
    @locales.TR_TR => compat_tr_tr_job_position()
    @locales.FA_IR => compat_fa_ir_job_position()
    _ => compat_default_job_positions()
  }
}

///|
/// Job title template for the selected locale.
pub fn job_title_template(locale : @locales.Locale) -> String {
  match locale {
    @locales.JA_JP => compat_ja_jp_job_title_tpl()
    @locales.PT_PT => compat_pt_pt_job_title_tpl()
    @locales.IT_IT => compat_it_it_job_title_tpl()
    @locales.CY_GB => compat_cy_gb_job_title_tpl()
    @locales.NL_NL => compat_nl_nl_job_title_tpl()
    @locales.TR_TR => compat_tr_tr_job_title_tpl()
    @locales.FA_IR => compat_fa_ir_job_title_tpl()
    _ => "{Seniority} {Field} {Position}"
  }
}

///|
/// Free email provider candidates for the selected locale.
pub fn email_providers(
  locale~ : @locales.Locale = @locales.EN,
) -> Array[String] {
  match locale {
    @locales.FR_FR => compat_fr_fr_internet_free_email_provider()
    @locales.PT_BR => compat_pt_br_internet_free_email_provider()
    @locales.PT_PT => compat_pt_pt_internet_free_email_provider()
    @locales.IT_IT => compat_it_it_internet_free_email_provider()
    @locales.CY_GB => compat_cy_gb_internet_free_email_provider()
    @locales.NL_NL => compat_nl_nl_internet_free_email_provider()
    @locales.TR_TR => compat_tr_tr_internet_free_email_provider()
    @locales.FA_IR => compat_fa_ir_internet_free_email_provider()
    _ => compat_default_email_providers()
  }
}

///|
/// Domain suffix candidates for the selected locale.
pub fn domain_suffixes(
  locale~ : @locales.Locale = @locales.EN,
) -> Array[String] {
  match locale {
    @locales.PT_BR => compat_pt_br_internet_domain_suffix()
    @locales.PT_PT => compat_pt_pt_internet_domain_suffix()
    @locales.IT_IT => compat_it_it_internet_domain_suffix()
    @locales.CY_GB => compat_cy_gb_internet_domain_suffix()
    @locales.NL_NL => compat_nl_nl_internet_domain_suffix()
    @locales.TR_TR => compat_tr_tr_internet_domain_suffix()
    @locales.FA_IR => compat_fa_ir_internet_domain_suffix()
    _ => compat_default_domain_suffixes()
  }
}

///|
/// Username stem candidates shared across locales.
pub fn usernames() -> Array[String] {
  ["alex", "river", "casey", "morgan", "taylor", "jamie", "quinn"]
}

///|
/// Password character table from defaults.
pub fn password_chars() -> Array[String] {
  compat_default_password_chars()
}

///|
/// User-agent candidates from defaults.
pub fn user_agents() -> Array[String] {
  compat_user_agents()
}

///|
/// Currency code candidates for the selected locale.
pub fn currency_codes(locale~ : @locales.Locale = @locales.EN) -> Array[String] {
  match locale {
    @locales.PT_PT => compat_pt_pt_currency_code()
    @locales.IT_IT => compat_it_it_currency_code()
    @locales.FA_IR => compat_fa_ir_currency_code()
    _ => compat_default_currency_codes()
  }
}

///|
/// Currency name candidates for the selected locale.
pub fn currency_names(locale~ : @locales.Locale = @locales.EN) -> Array[String] {
  match locale {
    @locales.PT_PT => compat_pt_pt_currency_name()
    @locales.IT_IT => compat_it_it_currency_name()
    @locales.CY_GB => compat_cy_gb_currency_name()
    @locales.FA_IR => compat_fa_ir_currency_name()
    _ => compat_default_currency_names()
  }
}

///|
/// Currency symbol candidates for the selected locale.
pub fn currency_symbols(
  locale~ : @locales.Locale = @locales.EN,
) -> Array[String] {
  match locale {
    @locales.PT_PT => compat_pt_pt_currency_symbol()
    @locales.IT_IT => compat_it_it_currency_symbol()
    @locales.FA_IR => compat_fa_ir_currency_symbol()
    _ => compat_default_currency_symbols()
  }
}

///|
/// Small structured currency table used by finance generators and tests.
pub fn currencies() -> Array[(String, String, String)] {
  [
    ("USD", "US Dollar", "$"),
    ("EUR", "Euro", "€"),
    ("CNY", "Yuan Renminbi", "¥"),
    ("JPY", "Yen", "¥"),
    ("GBP", "Pound Sterling", "£"),
  ]
}

///|
/// Named CSS color candidates.
pub fn color_names() -> Array[String] {
  ["red", "green", "blue", "teal", "indigo", "amber", "slate"]
}

///|
/// Root directory candidates for filesystem path generation.
pub fn path_root_dirs() -> Array[String] {
  ["/", "/etc", "/home", "/bin", "/sbin", "/usr", "/tmp", "/var"]
}

///|
/// Path segment candidates used for file and directory names.
pub fn path_segments() -> Array[String] {
  [
    "time", "person", "year", "way", "day", "thing", "man", "world", "life", "hand",
    "part", "child", "eye", "woman", "place", "work", "week", "case", "point", "government",
    "company", "number", "group", "problem", "fact", "good", "new", "first", "last",
    "long", "great", "little", "own", "other", "old", "right", "big", "high", "different",
    "small", "large", "next", "early", "young", "important", "few", "public", "bad",
    "same", "able", "olivia", "liam", "emma", "noah", "ava", "elijah", "sophia",
    "oliver", "isabella", "lucas", "amelia", "mason", "mia", "logan", "charlotte",
    "ethan", "harper", "james", "aria", "jackson",
  ]
}

///|
/// File extension candidates without leading dots.
pub fn file_extensions() -> Array[String] {
  [
    "so", "mp3", "mp4", "flv", "jpg", "png", "txt", "csv", "doc", "xls", "ppt", "zip",
    "rar", "7z", "tar",
  ]
}

///|
/// MIME type candidates from defaults.
pub fn mime_types() -> Array[String] {
  compat_mime_types()
}

///|
/// HTTP status codes from the HTTP status table.
pub fn http_statuses() -> Array[Int32] {
  [
    100, 101, 102, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302,
    303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410,
    411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 426, 428, 429, 431,
    451, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511,
  ]
}

///|
/// HTTP method candidates.
pub fn http_methods() -> Array[String] {
  [
    "GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS", "CONNECT", "TRACE",
  ]
}

///|
/// Phone number format patterns for the selected locale.
pub fn phone_number_formats(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN => ["+86 1##########"]
    @locales.ZH_TW => ["+886 9## ### ###"]
    @locales.FR_FR => compat_fr_fr_phone_number_formats()
    @locales.JA_JP => compat_ja_jp_phone_number_formats()
    @locales.PT_BR => compat_pt_br_phone_number_formats()
    @locales.PT_PT => compat_pt_pt_phone_number_formats()
    @locales.IT_IT => compat_it_it_phone_number_formats()
    @locales.CY_GB => compat_cy_gb_phone_number_formats()
    @locales.NL_NL => compat_nl_nl_phone_number_formats()
    @locales.TR_TR => compat_tr_tr_phone_number_formats()
    @locales.FA_IR => compat_fa_ir_phone_number_formats()
    _ => compat_default_phone_number_formats()
  }
}

///|
/// Cell/mobile number format patterns for the selected locale.
pub fn cell_number_formats(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.ZH_CN | @locales.ZH_TW => phone_number_formats(locale)
    @locales.FR_FR => compat_fr_fr_phone_cell_number_formats()
    @locales.JA_JP => compat_ja_jp_phone_cell_number_formats()
    @locales.PT_BR => compat_pt_br_phone_cell_number_formats()
    @locales.PT_PT => compat_pt_pt_phone_cell_number_formats()
    @locales.IT_IT => compat_it_it_phone_cell_number_formats()
    @locales.CY_GB => compat_cy_gb_phone_cell_number_formats()
    @locales.NL_NL => compat_nl_nl_phone_cell_number_formats()
    @locales.TR_TR => compat_tr_tr_phone_cell_number_formats()
    @locales.FA_IR => compat_fa_ir_phone_cell_number_formats()
    _ => compat_default_cell_number_formats()
  }
}

///|
/// Vehicle licence plate format patterns for supported locales.
///
/// Unsupported locales return an empty table so generator packages can choose
/// whether to fall back or raise an unsupported-locale error.
pub fn licence_plate_formats(locale : @locales.Locale) -> Array[String] {
  match locale {
    @locales.FR_FR | @locales.IT_IT => ["$$-###-$$"]
    @locales.NL_NL => ["$$-###-$", "$-###-$$", "$$$-##-$"]
    @locales.PT_PT =>
      ["$$-##-##", "##-##-$$", "##-$$-##", "## ## $$", "## $$ ##", "$$ ## $$"]
    @locales.TR_TR | @locales.FA_IR => ["## ABC ###", "## AB ####"]
    _ => []
  }
}

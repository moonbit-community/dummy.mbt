///|
/// Locales mirrored from 5.1.0.
///
/// The root package re-exports these as lowercase constants such as
/// `@dummy.en` and `@dummy.zh_cn`.
pub(all) enum Locale {
  EN
  FR_FR
  ZH_TW
  ZH_CN
  JA_JP
  AR_SA
  PT_BR
  PT_PT
  DE_DE
  IT_IT
  CY_GB
  NL_NL
  TR_TR
  FA_IR
} derive(Eq, Debug)

///|
/// Entry from `docs/data/locales.js`.
pub(all) struct DocsLocale {
  name : String
  docs_code : String
  locale : Locale
} derive(Eq, Debug)

///|
/// Return the locale code used in data files and docs.
pub fn Locale::code(self : Locale) -> String {
  match self {
    EN => "en"
    FR_FR => "fr_FR"
    ZH_TW => "zh_TW"
    ZH_CN => "zh_CN"
    JA_JP => "ja_JP"
    AR_SA => "ar_SA"
    PT_BR => "pt_BR"
    PT_PT => "pt_PT"
    DE_DE => "de_DE"
    IT_IT => "it_IT"
    CY_GB => "cy_GB"
    NL_NL => "nl_NL"
    TR_TR => "tr_TR"
    FA_IR => "fa_IR"
  }
}

///|
/// Return a human-readable locale name for documentation and diagnostics.
pub fn Locale::display_name(self : Locale) -> String {
  match self {
    EN => "English"
    FR_FR => "French (France)"
    ZH_TW => "Chinese (Taiwan)"
    ZH_CN => "Chinese (China)"
    JA_JP => "Japanese (Japan)"
    AR_SA => "Arabic (Saudi Arabia)"
    PT_BR => "Portuguese (Brazil)"
    PT_PT => "Portuguese (Portugal)"
    DE_DE => "German (Germany)"
    IT_IT => "Italian (Italy)"
    CY_GB => "Welsh (United Kingdom)"
    NL_NL => "Dutch (Netherlands)"
    TR_TR => "Turkish (Turkey)"
    FA_IR => "Persian (Iran)"
  }
}

///|
/// Return all locales currently exposed by the facade.
pub fn all() -> Array[Locale] {
  [
    EN,
    FR_FR,
    ZH_TW,
    ZH_CN,
    JA_JP,
    AR_SA,
    PT_BR,
    PT_PT,
    DE_DE,
    IT_IT,
    CY_GB,
    NL_NL,
    TR_TR,
    FA_IR,
  ]
}

///|
/// Return the documentation locale catalog in docs order.
///
/// `TR_TR` is available in source data and this package, but is not listed in
/// 5.1.0 docs locale data.
pub fn docs_locales() -> Array[DocsLocale] {
  [
    { name: "English", docs_code: "EN", locale: EN },
    { name: "French", docs_code: "FR_FR", locale: FR_FR },
    { name: "Arabic", docs_code: "AR_SA", locale: AR_SA },
    { name: "Traditional Chinese", docs_code: "ZH_TW", locale: ZH_TW },
    { name: "Simplified Chinese", docs_code: "ZH_CN", locale: ZH_CN },
    { name: "Japanese", docs_code: "JA_JP", locale: JA_JP },
    { name: "Portuguese - Brazil", docs_code: "PT_BR", locale: PT_BR },
    { name: "Portuguese - Portugal", docs_code: "PT_PT", locale: PT_PT },
    { name: "German", docs_code: "DE_DE", locale: DE_DE },
    { name: "Italian", docs_code: "IT_IT", locale: IT_IT },
    { name: "Cymraeg - Welsh", docs_code: "CY_GB", locale: CY_GB },
    { name: "Dutch", docs_code: "NL_NL", locale: NL_NL },
    { name: "Persian (Iran)", docs_code: "FA_IR", locale: FA_IR },
  ]
}

///|
/// Return whether the locale was part of this port's first-wave curated data.
///
/// Later locale data is still available where tables were ported; this
/// marker is kept for tests and migration checks that distinguish the original
/// hand-curated set from later table-backed additions.
pub fn Locale::has_first_wave_data(self : Locale) -> Bool {
  match self {
    EN | ZH_CN | ZH_TW => true
    _ => false
  }
}

///|
fn contains_string(items : ArrayView[String], value : String) -> Bool {
  for item in items {
    if item == value {
      return true
    }
  }
  false
}

///|
test "shared HTTP RFC status set matches 5.1.0" {
  @test.assert_eq(@data.http_statuses(), [
    100, 101, 102, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302,
    303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410,
    411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 426, 428, 429, 431,
    451, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511,
  ])
}

///|
test "shared internet data is available" {
  let providers = @data.email_providers()
  assert_true(contains_string(providers, "gmail.com"))
  assert_true(contains_string(providers, "hotmail.com"))
  let suffixes = @data.domain_suffixes()
  assert_true(contains_string(suffixes, "biz"))
  assert_true(contains_string(suffixes, "co"))
  @test.assert_eq(@data.password_chars().length(), 62)
  @test.assert_eq(@data.user_agents().length(), 19)
  assert_true(
    contains_string(
      @data.user_agents(),
      "Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14",
    ),
  )
}

///|
test "shared phone patterns are available" {
  let en = @data.phone_number_formats(EN)
  assert_true(en.length() >= 16)
  assert_true(contains_string(en, "(^##) ###-####"))
  assert_true(contains_string(en, "^##.###.#### x#####"))
  let cell = @data.cell_number_formats(EN)
  assert_true(contains_string(cell, "1-^##-###-####"))
  assert_true(
    contains_string(@data.phone_number_formats(ZH_CN), "+86 1##########"),
  )
  assert_true(
    contains_string(@data.phone_number_formats(ZH_TW), "+886 9## ### ###"),
  )
}

///|
test "automotive licence plate formats are available" {
  @test.assert_eq(@data.licence_plate_formats(FR_FR), ["$$-###-$$"])
  @test.assert_eq(@data.licence_plate_formats(IT_IT), ["$$-###-$$"])
  @test.assert_eq(@data.licence_plate_formats(NL_NL), [
    "$$-###-$", "$-###-$$", "$$$-##-$",
  ])
  @test.assert_eq(@data.licence_plate_formats(PT_PT), [
    "$$-##-##", "##-##-$$", "##-$$-##", "## ## $$", "## $$ ##", "$$ ## $$",
  ])
  @test.assert_eq(@data.licence_plate_formats(TR_TR), [
    "## ABC ###", "## AB ####",
  ])
  @test.assert_eq(@data.licence_plate_formats(FA_IR), [
    "## ABC ###", "## AB ####",
  ])
  @test.assert_eq(@data.licence_plate_formats(EN), [])
}

///|
test "shared currency and filesystem data is available" {
  assert_true(@data.currency_codes().length() >= 160)
  assert_true(contains_string(@data.currency_codes(), "AED"))
  assert_true(contains_string(@data.currency_codes(), "USD"))
  assert_true(contains_string(@data.currency_codes(), "XAU"))
  assert_true(contains_string(@data.currency_names(), "UAE Dirham"))
  assert_true(
    contains_string(
      @data.currency_names(),
      "Codes specifically reserved for testing purposes",
    ),
  )
  assert_true(contains_string(@data.currency_symbols(), "€"))
  assert_true(contains_string(@data.path_root_dirs(), "/etc"))
  assert_true(contains_string(@data.path_segments(), "government"))
  assert_true(contains_string(@data.file_extensions(), "tar"))
  @test.assert_eq(@data.mime_types().length(), 1860)
  assert_true(
    contains_string(@data.mime_types(), "application/1d-interleaved-parityfec"),
  )
  assert_true(contains_string(@data.mime_types(), "application/epub+zip"))
  assert_true(contains_string(@data.mime_types(), "video/webm"))
  assert_true(contains_string(@data.mime_types(), "x-shader/x-vertex"))
}

///|
test "address default tables are available" {
  @test.assert_eq(@data.states(EN).length(), 50)
  assert_true(contains_string(@data.country_codes(), "US"))
  assert_true(contains_string(@data.country_codes(), "ZW"))
  assert_true(contains_string(@data.time_zones(), "Pacific/Tongatapu"))
  assert_true(contains_string(@data.post_code_formats(EN), "#####-####"))
  assert_true(contains_string(@data.building_number_formats(EN), "#####"))
  @test.assert_eq(@data.geohash_chars().length(), 32)
}

///|
test "number and barcode default constants are available" {
  @test.assert_eq(@data.number_digits(), [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  ])
  @test.assert_eq(@data.isbn_ean_prefix(), "978")
}

///|
test "chrono and time format data is available" {
  @test.assert_eq(@data.chrono_time_format(), "%H:%M:%S%.f")
  @test.assert_eq(@data.chrono_date_format(), "%F")
  @test.assert_eq(@data.chrono_datetime_format(), "%+")
  @test.assert_eq(
    @data.time_time_format(locale=PT_BR),
    "[hour]:[minute]:[second][subsecond]",
  )
  @test.assert_eq(@data.time_date_format(), "[year]-[month]-[day]")
  @test.assert_eq(
    @data.time_datetime_format(),
    "[year]-[month]-[day]T[hour]:[minute]:[second][offset_hour sign:mandatory][offset_minute]",
  )
  @test.assert_eq(@data.chrono_date_format(locale=FA_IR), "%Y/%m/%d")
  @test.assert_eq(
    @data.chrono_datetime_format(locale=IT_IT),
    "%d-%m-%Y %H:%M:%S",
  )
  @test.assert_eq(@data.chrono_date_format(locale=TR_TR), "%d.%m.%Y")
  @test.assert_eq(@data.time_date_format(locale=NL_NL), "[day]-[month]-[year]")
  @test.assert_eq(@data.time_date_format(locale=PT_BR), "[day]/[month]/[year]")
  @test.assert_eq(
    @data.time_datetime_format(locale=FA_IR),
    "[year]/[month]/[day] [hour]:[minute]:[second]",
  )
  @test.assert_eq(@data.time_date_format(locale=TR_TR), "[day].[month].[year]")
  @test.assert_eq(
    @data.time_datetime_format(locale=TR_TR),
    "[day].[month].[year] [hour]:[minute]:[second]",
  )
  @test.assert_eq(
    @data.time_datetime_format(locale=PT_PT),
    "[day]-[month]-[year] [hour]:[minute]:[second]",
  )
  @test.assert_eq(
    @data.time_datetime_format(locale=PT_BR),
    "[day]/[month]/[year]T[hour]:[minute]:[second][offset_hour sign:mandatory][offset_minute]",
  )
}

///|
test "first wave locale data and fallback are non-empty" {
  assert_true(@data.name_first_names(ZH_CN).length() > 10)
  assert_true(@data.name_last_names(ZH_TW).length() > 10)
  assert_true(@data.lorem_words(ZH_CN).length() > 10)
  assert_true(@data.company_suffixes(FR_FR).length() > 0)
  @test.assert_eq(@data.name_template(ZH_CN), "{LastName}{FirstName}")
  @test.assert_eq(@data.name_template(FR_FR), "{FirstName} {LastName}")
}

///|
test "non-first-wave locale data is available" {
  assert_true(contains_string(@data.name_first_names(AR_SA), "أحلام"))
  assert_true(contains_string(@data.name_titles(FR_FR), "Mme"))
  assert_true(contains_string(@data.name_titles(JA_JP), "様"))
  assert_true(
    contains_string(@data.email_providers(locale=PT_BR), "uol.com.br"),
  )
  assert_true(contains_string(@data.domain_suffixes(locale=NL_NL), "nl"))
  assert_true(
    contains_string(@data.phone_number_formats(JA_JP), "011-###-####"),
  )
  assert_true(
    contains_string(@data.cell_number_formats(NL_NL), "+31 06 ########"),
  )
  assert_true(contains_string(@data.post_code_formats(PT_BR), "#####-###"))
  assert_true(contains_string(@data.zip_formats(NL_NL), "#### $$"))
  assert_true(contains_string(@data.time_zones(locale=FR_FR), "Europe/Paris"))
  assert_true(contains_string(@data.company_suffixes(PT_BR), "Ltda."))
  assert_true(contains_string(@data.job_seniority(JA_JP), "シニア"))
  @test.assert_eq(
    @data.job_title_template(JA_JP),
    "{Seniority}{Field}{Position}",
  )
  @test.assert_eq(@data.street_template(FR_FR), "{StreetSuffix} {StreetName}")
  @test.assert_eq(@data.company_bs_template(IT_IT), "{Verb} {Noun} {Adj}")
  @test.assert_eq(@data.states(PT_BR).length(), 27)
}

///|
test "de and nl city special data is available" {
  assert_true(contains_string(@data.city_prefixes(DE_DE), "Bad"))
  assert_true(contains_string(@data.city_suffixes(DE_DE), "stadt"))
  @test.assert_eq(@data.city_name_templates(DE_DE), [
    "{CityPrefix}{CityName}{CitySuffix}", "{CityPrefix} {CityName}{CitySuffix}",
    "{CityPrefix}-{CityName}{CitySuffix}", "{CityPrefix}-{CityName}{CitySuffix} {River}",
    "{CityName}{CitySuffix}",
  ])
  assert_true(contains_string(@data.city_rivers(DE_DE), "(Rhein)"))
  assert_true(contains_string(@data.city_prefixes(NL_NL), "Nieuw"))
  assert_true(contains_string(@data.city_suffixes(NL_NL), "drecht"))
  @test.assert_eq(@data.city_name_templates(NL_NL), [
    "{CityPrefix}{CityName}{CitySuffix}", "{CityPrefix} {CityName}{CitySuffix}",
    "{CityPrefix}-{CityName}{CitySuffix}", "{CityPrefix}-{CityName}{CitySuffix} {River}",
    "{CityName}{CitySuffix}",
  ])
  @test.assert_eq(@data.city_rivers(NL_NL), ["{River}"])
}

///|
test "locale override constants are routed through data accessors" {
  @test.assert_eq(@data.name_template(ZH_TW), "{LastName}{FirstName}")
  @test.assert_eq(
    @data.name_with_title_template(ZH_TW),
    "{LastName}{FirstName}{Title}",
  )
  @test.assert_eq(@data.city_template(ZH_CN), "{CityName}{CitySuffix}")
  @test.assert_eq(
    @data.city_with_prefix_template(ZH_CN),
    "{CityPrefix}{CityName}{CitySuffix}",
  )
  @test.assert_eq(@data.street_template(ZH_CN), "{StreetName}{StreetSuffix}")
  @test.assert_eq(@data.company_name_templates(ZH_CN), ["{Name_1}{Suffix}"])
  @test.assert_eq(
    @data.company_catch_phrase_template(ZH_CN),
    "{Head}{Middle}{Tail}",
  )
  @test.assert_eq(@data.company_bs_template(ZH_CN), "{Verb}{Adj}{Noun}")
  @test.assert_eq(
    @data.job_title_template(ZH_CN),
    "{Seniority} {Field} {Position}",
  )
  assert_true(
    contains_string(@data.email_providers(locale=CY_GB), "draig.example.cymru"),
  )
  assert_true(
    contains_string(
      @data.currency_names(locale=CY_GB),
      "Doler yr Unol Daleithiau",
    ),
  )
  assert_true(contains_string(@data.job_seniority(CY_GB), "Uwch"))
  assert_true(contains_string(@data.company_buzzword_heads(CY_GB), "Addasadwy"))
  assert_true(contains_string(@data.secondary_address_types(PT_PT), "Piso"))
  assert_true(
    contains_string(@data.time_zones(locale=PT_PT), "Atlantic/Azores"),
  )
  assert_true(contains_string(@data.building_number_formats(PT_PT), "nº ###"))
  assert_true(contains_string(@data.currency_codes(locale=PT_PT), "EUR"))
  assert_true(contains_string(@data.currency_symbols(locale=PT_PT), "€"))
  assert_true(contains_string(@data.company_suffixes(PT_PT), "Lda."))
  assert_true(
    contains_string(@data.time_zones(locale=TR_TR), "Europe/Istanbul"),
  )
  assert_true(contains_string(@data.domain_suffixes(locale=TR_TR), "com.tr"))
  assert_true(contains_string(@data.building_number_formats(TR_TR), "No: ###"))
  assert_true(
    contains_string(@data.phone_number_formats(TR_TR), "+90 (212) ### ####"),
  )
  assert_true(contains_string(@data.secondary_address_types(FA_IR), "واحد"))
  assert_true(contains_string(@data.time_zones(locale=FA_IR), "Asia/Tehran"))
  assert_true(contains_string(@data.currency_codes(locale=FA_IR), "IRR"))
}

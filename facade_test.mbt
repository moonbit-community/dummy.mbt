///|
fn digit_at(s : String, i : Int32) -> Int32 {
  match s.get_char(i) {
    Some(c) => c.to_int() - '0'.to_int()
    None => 0
  }
}

///|
fn luhn_valid(s : String) -> Bool {
  let mut sum = 0
  let len = s.length()
  for i in 0..<len {
    let mut value = digit_at(s, i)
    if (len - i) % 2 == 0 {
      value *= 2
      if value > 9 {
        value -= 9
      }
    }
    sum += value
  }
  sum % 10 == 0
}

///|
test "facade seed produces deterministic locale values" {
  let a = @dummy.name(locale=@dummy.zh_cn).dummy(@dummy.seed(b"locale"))
  let b = @dummy.name(locale=@dummy.zh_cn).dummy(@dummy.seed(b"locale"))
  @test.assert_eq(a, b)
}

///|
test "facade samples requested count" {
  let rng = @dummy.default_seeded()
  let words = @dummy.word().sample(count=4, rng)
  @test.assert_eq(words.length(), 4)
}

///|
test "common string formats are shaped correctly" {
  let rng = @dummy.default_seeded()
  let email = @dummy.free_email().dummy(rng)
  assert_true(email.contains("@"))
  let ipv4 = @dummy.ipv4().dummy(rng)
  assert_true(ipv4.contains("."))
  let mac = @dummy.mac_address().dummy(rng)
  @test.assert_eq(mac.length(), 17)
  let color = @dummy.hex_color().dummy(rng)
  assert_true(color.has_prefix("#"))
  @test.assert_eq(color.length(), 7)
  @test.assert_eq(@dummy.uuid_v4().dummy(rng).length(), 36)
  @test.assert_eq(@dummy.ulid().dummy(rng).length(), 26)
  @test.assert_eq(@dummy.bson_oid().dummy(rng).length(), 24)
  assert_true(!@dummy.base64().dummy(rng).is_empty())
}

///|
test "neutral category examples are non-empty" {
  let rng = @dummy.default_seeded()
  let isbn = @dummy.isbn().dummy(rng)
  assert_true(isbn.length() == 10 || isbn.length() == 13)
  let card = @dummy.credit_card_number().dummy(rng)
  @test.assert_eq(card.length(), 16)
  assert_true(luhn_valid(card))
  assert_true(@dummy.bic().dummy(rng).length() >= 8)
  @test.assert_eq(@dummy.isin().dummy(rng).length(), 12)
  assert_true(@dummy.file_path().dummy(rng).contains("/"))
  assert_true(
    @dummy.picsum_image().dummy(rng).has_prefix("https://picsum.photos/"),
  )
}

///|
test "non-first-wave facade locale values remain non-empty" {
  let rng = @dummy.default_seeded()
  let value = @dummy.company_name(locale=@dummy.fr_fr).dummy(rng)
  assert_true(!value.is_empty())
}

///|
test "facade exposes migrated locale data" {
  let rng = @dummy.seed(b"facade-extra-locales")
  assert_true(@dummy.name(locale=@dummy.ar_sa).dummy(rng).contains(" "))
  @test.assert_eq(
    @dummy.time_zone(locale=@dummy.fr_fr).dummy(rng),
    "Europe/Paris",
  )
  assert_true(@dummy.free_email(locale=@dummy.pt_br).dummy(rng).contains(".br"))
  assert_true(
    @dummy.domain_suffix(locale=@dummy.nl_nl).dummy(rng).length() >= 2,
  )
  @test.assert_eq(
    @dummy.currency_code(locale=@dummy.pt_pt).dummy(rng).length(),
    3,
  )
}

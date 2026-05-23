///|
enum FeOrderStatus {
  Completed
  Cancelled
} derive(Eq, Debug)

///|
struct FeItem {
  product_id : Int32
  qty : Int32
  company : String
} derive(Eq, Debug)

///|
struct FeOrder {
  order_id : Int32
  customer : String
  items : Array[FeItem]
  paid : Bool
  status : FeOrderStatus
  uuid : String
} derive(Eq, Debug)

///|
struct FeBasicUser {
  order_id : Int32
  customer : String
  paid : Bool
} derive(Eq, Debug)

///|
impl @core.DummyDefault for FeOrderStatus with fn dummy_default(rng) {
  if @dummy.boolean().dummy(rng) {
    Completed
  } else {
    Cancelled
  }
}

///|
impl @core.DummyDefault for FeItem with fn dummy_default(rng) {
  {
    product_id: @dummy.int(range=@dummy.int_range(1, 100)).dummy(rng),
    qty: @dummy.int(range=@dummy.int_range(1, 10)).dummy(rng),
    company: @dummy.company_name().dummy(rng),
  }
}

///|
impl @core.DummyDefault for FeOrder with fn dummy_default(rng) {
  {
    order_id: @dummy.int(range=@dummy.int_range(1000, 2000)).dummy(rng),
    customer: @dummy.name().dummy(rng),
    items: Array::makei(3, _ => @core.DummyDefault::dummy_default(rng)),
    paid: @dummy.boolean(ratio=70).dummy(rng),
    status: @core.DummyDefault::dummy_default(rng),
    uuid: @dummy.uuid_v4().dummy(rng),
  }
}

///|
impl @core.DummyDefault for FeBasicUser with fn dummy_default(rng) {
  let customer : String = fe_dummy_default(rng)
  let paid : Bool = fe_dummy_default(rng)
  {
    order_id: @dummy.int(range=@dummy.int_range(1000, 2000)).dummy(rng),
    customer,
    paid,
  }
}

///|
fn[T : @core.DummyDefault] fe_dummy_default(
  rng : @random.Rand,
) -> T raise @core.DummyError {
  T::dummy_default(rng)
}

///|
fn fe_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn fe_is_nonzero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn fe_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn fe_is_ab7_char(ch : Char) -> Bool {
  ch == 'A' || ch == 'B' || ch == '7'
}

///|
fn fe_is_xyz_char(ch : Char) -> Bool {
  ch == 'x' || ch == 'y' || ch == 'z'
}

///|
fn fe_result_with(
  ok_gen : @core.Gen[Int32],
  err_gen : @core.Gen[Int32],
) -> @core.Gen[Result[Int32, Int32]] {
  @core.Gen::new(rng => {
    if @dummy.boolean().dummy(rng) {
      Ok(ok_gen.dummy(rng))
    } else {
      Err(err_gen.dummy(rng))
    }
  })
}

///|
fn fe_string_with(
  chars : ArrayView[String],
  len_range : @core.CountRange,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let len = len_range.sample(rng)
    let out = StringBuilder(size_hint=len)
    for _ in 0..<len {
      out.write_string(@core.pick_string(chars, rng))
    }
    out.to_string()
  })
}

///|
fn fe_assert_number_format(value : String, fmt : String) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') =>
        assert_true(value.get_char(i) is Some(ch) && fe_is_nonzero_digit(ch))
      Some('#') => assert_true(value.get_char(i) is Some(ch) && fe_is_digit(ch))
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing format character")
    }
  }
}

///|
fn fe_phone_chars_resolved(value : String) -> Bool {
  !value.is_empty() &&
  fe_all_chars_match(value, ch => {
    fe_is_digit(ch) ||
    ch == ' ' ||
    ch == '+' ||
    ch == '-' ||
    ch == '(' ||
    ch == ')' ||
    ch == '.' ||
    ch == 'x'
  })
}

///|
fn fe_assert_order_shape(order : FeOrder) -> Unit raise {
  assert_true(order.order_id >= 1000 && order.order_id < 2000)
  assert_true(!order.customer.is_empty())
  @test.assert_eq(order.items.length(), 3)
  for item in order.items {
    assert_true(item.product_id >= 1 && item.product_id < 100)
    assert_true(item.qty >= 1 && item.qty < 10)
    assert_true(!item.company.is_empty())
  }
  assert_true(order.status is Completed || order.status is Cancelled)
  @test.assert_eq(order.uuid.length(), 36)
}

///|
test "DummyDefault generates records with the expected fields" {
  let left : FeBasicUser = @core.DummyDefault::dummy_default(
    @dummy.seed(b"compat-basic-user"),
  )
  let right : FeBasicUser = @core.DummyDefault::dummy_default(
    @dummy.seed(b"compat-basic-user"),
  )
  assert_true(left == right)
  assert_true(left.order_id >= 1000 && left.order_id < 2000)
  assert_true(!left.customer.is_empty())
  assert_true(left.paid || !left.paid)
  let order : FeOrder = @core.DummyDefault::dummy_default(
    @dummy.seed(b"compat-derived-order"),
  )
  fe_assert_order_shape(order)
  assert_true(
    order ==
    @core.DummyDefault::dummy_default(@dummy.seed(b"compat-derived-order")),
  )
}

///|
test "DummyDefault generates primitives options results tuples and arrays" {
  let rng = @dummy.seed(b"compat-basic-shapes")
  let option_value : Int32? = fe_dummy_default(rng)
  let nested_option : Int32?? = fe_dummy_default(rng)
  let result_value : Result[Int32, String] = fe_dummy_default(rng)
  let tuple_value : (Bool, Int32, String) = fe_dummy_default(rng)
  let values : Array[Int32] = fe_dummy_default(rng)
  let strings : Array[String] = Array::makei(4, _ => fe_dummy_default(rng))
  assert_true(option_value is None || option_value is Some(_))
  assert_true(nested_option is None || nested_option is Some(_))
  assert_true(result_value is Ok(_) || result_value is Err(_))
  let (_, _, text) = tuple_value
  assert_true(!text.is_empty())
  assert_true(values.length() >= 0 && values.length() <= 4)
  @test.assert_eq(strings.length(), 4)
  for value in strings {
    assert_true(value.length() >= 4 && value.length() <= 10)
  }
}

///|
test "result generator respects custom ok and err ranges" {
  let gen = fe_result_with(
    @dummy.int(range=@dummy.int_range(3, 20)),
    @dummy.int(range=@dummy.int_range(1, 10)),
  )
  let left = gen.sample(count=64, @dummy.seed(b"compat-result-generator-with"))
  let right = gen.sample(count=64, @dummy.seed(b"compat-result-generator-with"))
  @test.assert_eq(left, right)
  let mut saw_ok = false
  let mut saw_err = false
  for value in left {
    match value {
      Ok(item) => {
        saw_ok = true
        assert_true(item >= 3 && item < 20)
      }
      Err(item) => {
        saw_err = true
        assert_true(item >= 1 && item < 10)
      }
    }
  }
  assert_true(saw_ok)
  assert_true(saw_err)
}

///|
test "string generator respects custom charset and length ranges" {
  let fixed = fe_string_with(["A", "B", "7"], @dummy.count_range(8, 8))
  let fixed_left = fixed.sample(count=16, @dummy.seed(b"compat-string-fixed"))
  let fixed_right = fixed.sample(count=16, @dummy.seed(b"compat-string-fixed"))
  @test.assert_eq(fixed_left, fixed_right)
  for value in fixed_left {
    @test.assert_eq(value.length(), 8)
    assert_true(fe_all_chars_match(value, fe_is_ab7_char))
  }
  let ranged = fe_string_with(["x", "y", "z"], @dummy.count_range(5, 15))
  let ranged_left = ranged.sample(
    count=16,
    @dummy.seed(b"compat-string-ranged"),
  )
  let ranged_right = ranged.sample(
    count=16,
    @dummy.seed(b"compat-string-ranged"),
  )
  @test.assert_eq(ranged_left, ranged_right)
  for value in ranged_left {
    assert_true(value.length() >= 5 && value.length() <= 15)
    assert_true(fe_all_chars_match(value, fe_is_xyz_char))
  }
}

///|
test "ranged and nested samples preserve collection shapes" {
  let rng = @dummy.seed(b"compat-usage-collections")
  let names = @dummy.name().sample(count=4, rng)
  let nested_names = @core.Gen::new(rng => {
    @dummy.name(locale=@dummy.zh_cn).sample(count=2, rng)
  }).sample(count=3, rng)
  let ints = @dummy.int(range=@dummy.int_range(3, 7)).sample(count=8, rng)
  let nested_ints = @core.Gen::new(rng => {
    @dummy.int(range=@dummy.int_range(1, 11)).sample(count=2, rng)
  }).sample(count=3, rng)
  @test.assert_eq(names.length(), 4)
  for value in names {
    assert_true(!value.is_empty())
  }
  @test.assert_eq(nested_names.length(), 3)
  for row in nested_names {
    @test.assert_eq(row.length(), 2)
    for value in row {
      assert_true(!value.is_empty())
    }
  }
  @test.assert_eq(ints.length(), 8)
  for value in ints {
    assert_true(value >= 3 && value < 7)
  }
  @test.assert_eq(nested_ints.length(), 3)
  for row in nested_ints {
    @test.assert_eq(row.length(), 2)
    for value in row {
      assert_true(value >= 1 && value < 11)
    }
  }
}

///|
test "generator example categories keep documented local shapes" {
  let rng = @dummy.seed(b"compat-generators-catalog")
  let words = @dummy.words(count=@dummy.count_range(3, 5)).dummy(rng)
  let sentences = @dummy.sentences(count=@dummy.count_range(3, 5)).dummy(rng)
  let jobs = @dummy.job_title().sample(count=3, rng)
  let number = @dummy.number_with_format("^###").dummy(rng)
  let phone = @dummy.number_with_format("(+852) 6### ####").dummy(rng)
  let email = @dummy.free_email().dummy(rng)
  let image = @dummy.picsum_image_custom(
    @dummy.image_options(width=800, height=600),
  ).dummy(rng)
  assert_true(words.length() >= 3 && words.length() <= 5)
  assert_true(sentences.length() >= 3 && sentences.length() <= 5)
  @test.assert_eq(jobs.length(), 3)
  for job in jobs {
    assert_true(!job.is_empty())
  }
  fe_assert_number_format(number, "^###")
  fe_assert_number_format(phone, "(+852) 6### ####")
  assert_true(email.contains("@"))
  @test.assert_eq(image, "https://picsum.photos/800/600")
}

///|
test "option and one_of generators produce valid choices" {
  let rng = @dummy.seed(b"compat-opt-utils")
  let always_some = @core.Gen::new(rng => {
    Some(@dummy.int(range=@dummy.int_range(0, 200)).dummy(rng))
  })
  let always_none : @core.Gen[Int32?] = @core.Gen::pure(None)
  let maybe_nested = @core.Gen::new(rng => {
    if @dummy.boolean(ratio=50).dummy(rng) {
      Some(always_some.dummy(rng))
    } else {
      None
    }
  })
  let phone_or_cell = @dummy.one_of([
    @dummy.phone_number(),
    @dummy.cell_number(),
  ])
  let some_value = always_some.dummy(rng)
  let none_value = always_none.dummy(rng)
  let nested_value = maybe_nested.dummy(rng)
  assert_true(some_value is Some(v) && v >= 0 && v < 200)
  assert_true(none_value is None)
  assert_true(nested_value is None || nested_value is Some(_))
  for value in phone_or_cell.sample(count=10, rng) {
    assert_true(fe_phone_chars_resolved(value))
  }
}

///|
fn fmore_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn fmore_is_nonzero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn fmore_is_upper_letter(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 'A'.to_int() && code <= 'Z'.to_int()
}

///|
fn fmore_is_hex(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  (code >= 'a'.to_int() && code <= 'f'.to_int()) ||
  (code >= 'A'.to_int() && code <= 'F'.to_int())
}

///|
fn fmore_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn fmore_count_char(s : String, target : Char) -> Int32 {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn fmore_non_empty(label : String, value : String) -> Unit raise {
  if value.is_empty() {
    fail("\{label} generated an empty example value")
  }
}

///|
fn fmore_non_empty_array(
  label : String,
  values : ArrayView[String],
) -> Unit raise {
  for value in values {
    fmore_non_empty(label, value)
  }
}

///|
fn fmore_assert_number_format(value : String, fmt : String) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') =>
        assert_true(value.get_char(i) is Some(ch) && fmore_is_nonzero_digit(ch))
      Some('#') =>
        assert_true(value.get_char(i) is Some(ch) && fmore_is_digit(ch))
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing format character")
    }
  }
}

///|
fn fmore_ascii_string_with(
  chars : ArrayView[String],
  len_range : @core.CountRange,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let len = len_range.sample(rng)
    let out = StringBuilder(size_hint=len)
    for _ in 0..<len {
      out.write_string(@core.pick_string(chars, rng))
    }
    out.to_string()
  })
}

///|
fn fmore_fixed_nested_ints(
  rng : @random.Rand,
) -> Array[Array[Array[Int32]]] raise @core.DummyError {
  Array::makei(4, _ => {
    Array::makei(3, _ => {
      @dummy.int(range=@dummy.int_range(1, 11)).sample(count=2, rng)
    })
  })
}

///|
fn fmore_string_map(
  rng : @random.Rand,
) -> Map[Int32, Array[String]] raise @core.DummyError {
  let out : Map[Int32, Array[String]] = Map([])
  for key in 0..<4 {
    out[key] = @dummy.name(locale=@dummy.en).sample(count=2, rng)
  }
  out
}

///|
fn fmore_map_of_int_sets(
  rng : @random.Rand,
) -> Map[Int32, Array[Int32]] raise @core.DummyError {
  let out : Map[Int32, Array[Int32]] = Map([])
  for key in 0..<5 {
    let values = @dummy.int(range=@dummy.int_range(1, 11)).sample(count=6, rng)
    values.sort()
    let unique : Array[Int32] = []
    for value in values {
      if unique.length() == 0 || unique[unique.length() - 1] != value {
        unique.push(value)
      }
    }
    out[key] = unique
  }
  out
}

///|
fn fmore_lines(s : String) -> Array[String] {
  s.split("\n").map(line => line.to_owned()).to_array()
}

///|
fn fmore_each_line_has_prefix(s : String, prefix : String) -> Bool {
  for line in fmore_lines(s) {
    if !line.has_prefix(prefix) {
      return false
    }
  }
  true
}

///|
fn fmore_valid_email(value : String) -> Bool {
  fmore_count_char(value, '@') == 1 &&
  !value.has_prefix("@") &&
  !value.has_suffix("@") &&
  value.split("@").map(part => part.to_owned()).to_array()[1].contains(".")
}

///|
fn fmore_valid_ipv4(value : String) -> Bool {
  let parts = value.split(".").map(part => part.to_owned()).to_array()
  parts.length() == 4 &&
  parts.all(part => {
    !part.is_empty() && fmore_all_chars_match(part, fmore_is_digit)
  })
}

///|
fn fmore_valid_ipv6(value : String) -> Bool {
  let parts = value.split(":").map(part => part.to_owned()).to_array()
  parts.length() == 8 &&
  parts.all(part => {
    part.length() >= 1 &&
    part.length() <= 4 &&
    fmore_all_chars_match(part, fmore_is_hex)
  })
}

///|
fn fmore_valid_mac(value : String) -> Bool {
  let parts = value.split(":").map(part => part.to_owned()).to_array()
  parts.length() == 6 &&
  parts.all(part => {
    part.length() == 2 && fmore_all_chars_match(part, fmore_is_hex)
  })
}

///|
fn fmore_known_http_method(value : String) -> Bool {
  match value {
    "GET"
    | "POST"
    | "PUT"
    | "PATCH"
    | "DELETE"
    | "HEAD"
    | "OPTIONS"
    | "CONNECT"
    | "TRACE" => true
    _ => false
  }
}

///|
fn fmore_uuid_version(value : String, version : Char) -> Bool {
  value.length() == 36 &&
  value.get_char(8) == Some('-') &&
  value.get_char(13) == Some('-') &&
  value.get_char(14) == Some(version) &&
  value.get_char(18) == Some('-') &&
  value.get_char(23) == Some('-')
}

///|
test "facade name samples are repeatable and passwords respect length ranges" {
  let seed = b"fmore-cli-repeat"
  let names = @dummy.name(locale=@dummy.zh_cn).sample(
    count=5,
    @dummy.seed(seed),
  )
  @test.assert_eq(names.length(), 5)
  fmore_non_empty_array("name(locale=@dummy.zh_cn).sample(count=5, rng)", names)
  @test.assert_eq(
    names,
    @dummy.name(locale=@dummy.zh_cn).sample(count=5, @dummy.seed(seed)),
  )
  let passwords = @dummy.password(len_range=@dummy.count_range(10, 20)).sample(
    count=5,
    @dummy.seed(b"fmore-cli-password"),
  )
  @test.assert_eq(passwords.length(), 5)
  for password in passwords {
    assert_true(password.length() >= 10 && password.length() <= 20)
  }
}

///|
test "primitives example ranges samplers and fixed seeds are reproducible" {
  let rng = @dummy.seed(b"fmore-primitives")
  let default_ints = @dummy.int().sample(count=16, rng)
  @test.assert_eq(default_ints.length(), 16)
  for value in @dummy.int(range=@dummy.int_range(3, 7)).sample(count=64, rng) {
    assert_true(value >= 3 && value < 7)
  }
  for value in @dummy.int(range=@dummy.int_range(3, 8)).sample(count=64, rng) {
    assert_true(value >= 3 && value <= 7)
  }
  for value in @dummy.int(range=@dummy.int_range(0, 7)).sample(count=64, rng) {
    assert_true(value >= 0 && value < 7)
  }
  let sampler = @dummy.int(range=@dummy.int_range(1, 11))
  let seed = b"fmore-fixed-seed"
  @test.assert_eq(
    sampler.sample(count=5, @dummy.seed(seed)),
    sampler.sample(count=5, @dummy.seed(seed)),
  )
  @test.assert_eq(
    @dummy.int().sample(count=6, @dummy.seed(seed)),
    @dummy.int().sample(count=6, @dummy.seed(seed)),
  )
  let fixed = fmore_ascii_string_with(["A"], @dummy.count_range(10, 10)).dummy(
    @dummy.seed(b"fmore-fixed-string"),
  )
  @test.assert_eq(fixed, "AAAAAAAAAA")
}

///|
test "locale facade and composed generators produce valid values" {
  let seed = b"fmore-usage"
  let rng = @dummy.seed(seed)
  let localized = @dummy.Dummy::new(locale=@dummy.zh_tw)
  let name = localized.name().dummy(rng)
  let email = localized.email().dummy(rng)
  let sentence = localized.sentence().dummy(rng)
  fmore_non_empty("Dummy::name", name)
  assert_true(fmore_valid_email(email))
  fmore_non_empty("Dummy::sentence", sentence)
  let words = @dummy.words(count=@dummy.count_range(3, 4)).dummy(rng)
  assert_true(words.length() >= 3 && words.length() <= 4)
  fmore_non_empty_array("words(count=@dummy.count_range(3, 4))", words)
  let label = @dummy.company_name()
    .map(company => "customer: " + company)
    .dummy(rng)
  assert_true(label.has_prefix("customer: "))
  let contact = @dummy.one_of([@dummy.phone_number(), @dummy.cell_number()]).dummy(
    rng,
  )
  fmore_non_empty("either phone", contact)
  let weighted = @dummy.weighted([
    (0, @core.Gen::pure("ignored")),
    (1, @core.Gen::pure("selected")),
  ]).dummy(rng)
  @test.assert_eq(weighted, "selected")
  let left = @dummy.Dummy::new(locale=@dummy.zh_tw)
    .name()
    .sample(count=4, @dummy.seed(seed))
  let right = @dummy.Dummy::new(locale=@dummy.zh_tw)
    .name()
    .sample(count=4, @dummy.seed(seed))
  @test.assert_eq(left, right)
}

///|
test "nested arrays maps and unique collections preserve their shapes" {
  let seed = b"fmore-collections"
  let rng = @dummy.seed(seed)
  let vec = @dummy.int(range=@dummy.int_range(0, 256)).sample(
    count=@dummy.count_range(4, 7).sample(rng),
    rng,
  )
  assert_true(vec.length() >= 4 && vec.length() < 8)
  for value in vec {
    assert_true(value >= 0 && value < 256)
  }
  let nested = fmore_fixed_nested_ints(rng)
  @test.assert_eq(nested.length(), 4)
  for rows in nested {
    @test.assert_eq(rows.length(), 3)
    for row in rows {
      @test.assert_eq(row.length(), 2)
      for value in row {
        assert_true(value >= 1 && value <= 10)
      }
    }
  }
  let map = fmore_string_map(@dummy.seed(seed))
  let same_map = fmore_string_map(@dummy.seed(seed))
  @test.assert_eq(map, same_map)
  @test.assert_eq(map.length(), 4)
  for key, values in map {
    assert_true(key >= 0 && key < 4)
    @test.assert_eq(values.length(), 2)
    fmore_non_empty_array("Map[Int32, Array[String]] values", values)
  }
  let map_of_sets = fmore_map_of_int_sets(@dummy.seed(b"fmore-map-of-sets"))
  @test.assert_eq(map_of_sets.length(), 5)
  for key, values in map_of_sets {
    assert_true(key >= 0 && key < 5)
    assert_true(values.length() >= 1 && values.length() <= 6)
    assert_true(values.is_sorted())
    for value in values {
      assert_true(value >= 1 && value <= 10)
    }
  }
}

///|
test "generator example keeps lorem name job company address and internet shapes" {
  let rng = @dummy.seed(b"fmore-generators-core")
  fmore_non_empty_array("name generators", [
    @dummy.first_name().dummy(rng),
    @dummy.last_name().dummy(rng),
    @dummy.title().dummy(rng),
    @dummy.suffix().dummy(rng),
    @dummy.name(locale=@dummy.cy_gb).dummy(rng),
    @dummy.name_with_title(locale=@dummy.zh_cn).dummy(rng),
  ])
  let lorem_values = [
    @dummy.word().dummy(rng),
    @dummy.sentence(count=@dummy.count_range(3, 5)).dummy(rng),
    @dummy.paragraph(count=@dummy.count_range(3, 5)).dummy(rng),
  ]
  fmore_non_empty_array("lorem generators", lorem_values)
  let sentences = @dummy.sentences(count=@dummy.count_range(3, 5)).dummy(rng)
  assert_true(sentences.length() >= 3 && sentences.length() <= 5)
  fmore_non_empty_array("sentences sample", sentences)
  let paragraphs = @dummy.paragraphs(count=@dummy.count_range(3, 5)).dummy(rng)
  assert_true(paragraphs.length() >= 3 && paragraphs.length() <= 5)
  fmore_non_empty_array("paragraphs sample", paragraphs)
  fmore_non_empty_array("job generators", [
    @dummy.job_seniority().dummy(rng),
    @dummy.job_field().dummy(rng),
    @dummy.job_position().dummy(rng),
    @dummy.job_title().dummy(rng),
  ])
  assert_true(@dummy.job_title().sample(count=3, rng).length() == 3)
  fmore_non_empty_array("company generators", [
    @dummy.company_suffix().dummy(rng),
    @dummy.company_name().dummy(rng),
    @dummy.buzzword().dummy(rng),
    @dummy.buzzword_middle().dummy(rng),
    @dummy.buzzword_tail().dummy(rng),
    @dummy.catch_phrase().dummy(rng),
    @dummy.bs_verb().dummy(rng),
    @dummy.bs_adj().dummy(rng),
    @dummy.bs_noun().dummy(rng),
    @dummy.bs().dummy(rng),
    @dummy.profession().dummy(rng),
    @dummy.industry().dummy(rng),
  ])
  fmore_non_empty_array("address generators", [
    @dummy.city_prefix().dummy(rng),
    @dummy.city_suffix().dummy(rng),
    @dummy.city_name().dummy(rng),
    @dummy.country_name().dummy(rng),
    @dummy.country_code().dummy(rng),
    @dummy.state_name().dummy(rng),
    @dummy.state_abbr().dummy(rng),
    @dummy.street_suffix().dummy(rng),
    @dummy.street_name().dummy(rng),
    @dummy.secondary_address_type().dummy(rng),
    @dummy.secondary_address().dummy(rng),
    @dummy.zip_code().dummy(rng),
    @dummy.post_code().dummy(rng),
    @dummy.building_number().dummy(rng),
    @dummy.time_zone().dummy(rng),
  ])
  @test.assert_eq(@dummy.geohash(precision=11).dummy(rng).length(), 11)
  for value in [@dummy.latitude().dummy(rng), @dummy.longitude().dummy(rng)] {
    assert_true(value.contains("."))
  }
  assert_true(fmore_valid_email(@dummy.free_email().dummy(rng)))
  assert_true(fmore_valid_email(@dummy.safe_email().dummy(rng)))
  assert_true(fmore_valid_ipv4(@dummy.ipv4().dummy(rng)))
  assert_true(fmore_valid_ipv6(@dummy.ipv6().dummy(rng)))
  assert_true(fmore_valid_ipv4(@dummy.ip().dummy(rng)))
  assert_true(fmore_valid_mac(@dummy.mac_address().dummy(rng)))
  assert_true(
    @dummy.password(len_range=@dummy.count_range(8, 20)).dummy(rng).length() >=
    8,
  )
  fmore_non_empty_array("internet generators", [
    @dummy.free_email_provider().dummy(rng),
    @dummy.domain_suffix().dummy(rng),
    @dummy.username().dummy(rng),
    @dummy.user_agent().dummy(rng),
  ])
}

///|
test "generator example keeps numeric regional media and markdown contracts" {
  let rng = @dummy.seed(b"fmore-generators-extra")
  for digit in @dummy.digit().sample(count=32, rng) {
    assert_true(digit >= 0 && digit <= 9)
  }
  fmore_assert_number_format(
    @dummy.number_with_format("^###").dummy(rng),
    "^###",
  )
  fmore_assert_number_format(
    @dummy.number_with_format("FLAT 0# ^#/F").dummy(rng),
    "FLAT 0# ^#/F",
  )
  for value in @dummy.boolean(ratio=0).sample(count=5, rng) {
    assert_true(!value)
  }
  for value in @dummy.boolean(ratio=100).sample(count=5, rng) {
    assert_true(value)
  }
  fmore_non_empty_array("money card barcode regional generators", [
    @dummy.currency_code().dummy(rng),
    @dummy.currency_name().dummy(rng),
    @dummy.currency_symbol().dummy(rng),
    @dummy.credit_card_number().dummy(rng),
    @dummy.isbn13().dummy(rng),
    @dummy.isbn10().dummy(rng),
    @dummy.isbn().dummy(rng),
    @dummy.bic().dummy(rng),
    @dummy.isin().dummy(rng),
    @dummy.health_insurance_code(locale=@dummy.fr_fr).dummy(rng),
    @dummy.licence_plate(locale=@dummy.fr_fr).dummy(rng),
  ])
  @test.assert_eq(@dummy.currency_code().dummy(rng).length(), 3)
  assert_true(
    fmore_all_chars_match(
      @dummy.currency_code().dummy(rng),
      fmore_is_upper_letter,
    ),
  )
  fmore_non_empty_array("filesystem generators", [
    @dummy.file_path().dummy(rng),
    @dummy.file_name().dummy(rng),
    @dummy.file_extension().dummy(rng),
    @dummy.dir_path().dummy(rng),
    @dummy.mime_type().dummy(rng),
    @dummy.semver().dummy(rng),
    @dummy.semver_stable().dummy(rng),
    @dummy.semver_unstable().dummy(rng),
  ])
  for http_method_name in @dummy.http_method().sample(count=12, rng) {
    assert_true(fmore_known_http_method(http_method_name))
  }
  for code in @dummy.valid_status_code().sample(count=12, rng) {
    assert_true(code >= 100 && code < 600)
  }
  for code in @dummy.rfc_status_code().sample(count=12, rng) {
    assert_true(code >= 100 && code < 600)
  }
  fmore_non_empty_array("color generators", [
    @dummy.hex_color().dummy(rng),
    @dummy.rgb_color().dummy(rng),
    @dummy.rgba_color().dummy(rng),
    @dummy.hsl_color().dummy(rng),
    @dummy.hsla_color().dummy(rng),
    @dummy.color().dummy(rng),
  ])
  let bullets = @dummy.bullet_points(count=@dummy.count_range(3, 3)).dummy(rng)
  assert_true(fmore_each_line_has_prefix(bullets, "- "))
  let items = @dummy.list_items(count=@dummy.count_range(3, 3)).dummy(rng)
  @test.assert_eq(items.length(), 3)
  assert_true(items[0].has_prefix("1. "))
  assert_true(items[2].has_prefix("3. "))
  assert_true(@dummy.italic_word().dummy(rng).has_prefix("*"))
  assert_true(@dummy.bold_word().dummy(rng).has_prefix("**"))
  assert_true(@dummy.markdown_link().dummy(rng).contains("]("))
  assert_true(
    @dummy.block_quote_single_line(count=@dummy.count_range(2, 2))
    .dummy(rng)
    .has_prefix("> "),
  )
  assert_true(
    @dummy.block_quote_multi_line(count=@dummy.count_range(2, 2))
    .dummy(rng)
    .has_prefix("> "),
  )
  let code = @dummy.markdown_code(count=@dummy.count_range(1, 1)).dummy(rng)
  assert_true(code.has_prefix("```\n"))
  assert_true(code.has_suffix("\n```"))
}

///|
test "identifier encoding picsum and time generators preserve formats and repeatability" {
  let rng = @dummy.seed(b"fmore-feature-strings")
  assert_true(fmore_uuid_version(@dummy.uuid_v1().dummy(rng), '1'))
  assert_true(fmore_uuid_version(@dummy.uuid_v3().dummy(rng), '3'))
  assert_true(fmore_uuid_version(@dummy.uuid_v4().dummy(rng), '4'))
  assert_true(fmore_uuid_version(@dummy.uuid_v5().dummy(rng), '5'))
  assert_true(@dummy.ulid().dummy(rng).length() == 26)
  assert_true(@dummy.bson_object_id().dummy(rng).length() == 24)
  assert_true(@dummy.bson_oid().dummy(rng).length() == 24)
  assert_true(!@dummy.base64_no_pad().dummy(rng).contains("="))
  assert_true(!@dummy.url_safe_base64_no_pad().dummy(rng).contains("="))
  @test.assert_eq(
    @dummy.picsum_image_custom(@dummy.image_options(width=800, height=600)).dummy(
      rng,
    ),
    "https://picsum.photos/800/600",
  )
  @test.assert_eq(
    @dummy.picsum_image_custom(
      @dummy.image_options(width=400, height=300, grayscale=true, blur=5),
    ).dummy(rng),
    "https://picsum.photos/400/300?grayscale&blur=5",
  )
  @test.assert_eq(
    @dummy.picsum_image_custom(
      @dummy.image_options(width=640, height=480, seed="myseed"),
    ).dummy(rng),
    "https://picsum.photos/seed/myseed/640/480",
  )
  assert_true(
    @dummy.picsum_image().dummy(rng).has_prefix("https://picsum.photos/"),
  )
  assert_true(
    @dummy.picsum_image_with_seed()
    .dummy(rng)
    .has_prefix("https://picsum.photos/seed/"),
  )
  assert_true(
    @dummy.picsum_image_grayscale().dummy(rng).has_suffix("?grayscale"),
  )
  assert_true(@dummy.picsum_image_blur().dummy(rng).contains("?blur="))
  fmore_non_empty_array("chrono time strings", [
    @dummy.chrono_time().dummy(rng),
    @dummy.chrono_date().dummy(rng),
    @dummy.chrono_date_time().dummy(rng),
    @dummy.chrono_date_time_before(anchor_minutes=10).dummy(rng),
    @dummy.chrono_date_time_after(anchor_minutes=10).dummy(rng),
    @dummy.chrono_date_time_between(0, 10).dummy(rng),
    @dummy.time_time().dummy(rng),
    @dummy.time_date().dummy(rng),
    @dummy.time_date_time().dummy(rng),
    @dummy.time_date_time_before(anchor_minutes=10).dummy(rng),
    @dummy.time_date_time_after(anchor_minutes=10).dummy(rng),
    @dummy.time_date_time_between(0, 10).dummy(rng),
  ])
  @test.assert_eq(
    @dummy.chrono_duration().sample(count=8, @dummy.seed(b"fmore-duration")),
    @dummy.chrono_duration().sample(count=8, @dummy.seed(b"fmore-duration")),
  )
  @test.assert_eq(
    @dummy.time_duration().sample(count=8, @dummy.seed(b"fmore-time-duration")),
    @dummy.time_duration().sample(count=8, @dummy.seed(b"fmore-time-duration")),
  )
}

///|
struct SubagentLineItem {
  product_id : Int32
  qty : Int32
  company : String
  price_cents : Int32
} derive(Eq, Debug)

///|
enum SubagentOrderStatus {
  Completed
  Cancelled
} derive(Eq, Debug)

///|
struct SubagentOrder {
  order_id : Int32
  customer : String
  items : Array[SubagentLineItem]
  paid : Bool
  status : SubagentOrderStatus
  uuid : String
  total_cents : Int32
} derive(Eq, Debug)

///|
impl @core.DummyDefault for SubagentOrderStatus with fn dummy_default(rng) {
  if @dummy.boolean().dummy(rng) {
    Completed
  } else {
    Cancelled
  }
}

///|
impl @core.DummyDefault for SubagentLineItem with fn dummy_default(rng) {
  {
    product_id: @dummy.int(range=@dummy.int_range(1, 100)).dummy(rng),
    qty: @dummy.int(range=@dummy.int_range(1, 10)).dummy(rng),
    company: @dummy.company_name().dummy(rng),
    price_cents: @dummy.int(range=@dummy.int_range(1, 100_000)).dummy(rng),
  }
}

///|
impl @core.DummyDefault for SubagentOrder with fn dummy_default(rng) {
  {
    order_id: @dummy.int(range=@dummy.int_range(1000, 2000)).dummy(rng),
    customer: @dummy.name().dummy(rng),
    items: Array::makei(3, _ => @core.DummyDefault::dummy_default(rng)),
    paid: @dummy.boolean(ratio=70).dummy(rng),
    status: @core.DummyDefault::dummy_default(rng),
    uuid: @dummy.uuid_v4().dummy(rng),
    total_cents: @dummy.int(range=@dummy.int_range(1, 1_000_000)).dummy(rng),
  }
}

///|
fn subagent_fixed_seed() -> Bytes {
  [
    1, 0, 0, 0, 23, 0, 0, 0, 200, 1, 0, 0, 210, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
  ]
}

///|
fn subagent_examples_is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '0'.to_int() && code <= '9'.to_int()
}

///|
fn subagent_examples_is_nonzero_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= '1'.to_int() && code <= '9'.to_int()
}

///|
fn subagent_all_chars_match(s : String, pred : (Char) -> Bool) -> Bool {
  for ch in s {
    if !pred(ch) {
      return false
    }
  }
  true
}

///|
fn subagent_is_alnum_or_symbol(ch : Char) -> Bool {
  let code = ch.to_int()
  (code >= 'A'.to_int() && code <= 'Z'.to_int()) ||
  (code >= '0'.to_int() && code <= '9'.to_int()) ||
  ch == ')' ||
  ch == '(' ||
  ch == '*' ||
  ch == '&' ||
  ch == '^' ||
  ch == '%' ||
  ch == '$' ||
  ch == '#' ||
  ch == '@' ||
  ch == '!' ||
  ch == '~'
}

///|
fn subagent_valid_email(value : String) -> Bool {
  let parts = value.split("@").map(part => part.to_owned()).to_array()
  parts.length() == 2 &&
  !parts[0].is_empty() &&
  !parts[1].is_empty() &&
  parts[1].contains(".")
}

///|
fn subagent_examples_assert_number_format(
  value : String,
  fmt : String,
) -> Unit raise {
  @test.assert_eq(value.length(), fmt.length())
  for i in 0..<fmt.length() {
    match fmt.get_char(i) {
      Some('^') =>
        assert_true(
          value.get_char(i) is Some(ch) &&
          subagent_examples_is_nonzero_digit(ch),
        )
      Some('#') =>
        assert_true(
          value.get_char(i) is Some(ch) && subagent_examples_is_digit(ch),
        )
      Some(ch) => @test.assert_eq(value.get_char(i), Some(ch))
      None => fail("missing format character")
    }
  }
}

///|
fn subagent_ascii_string_with(
  chars : ArrayView[String],
  len_range : @core.CountRange,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let len = len_range.sample(rng)
    let out = StringBuilder(size_hint=len)
    for _ in 0..<len {
      out.write_string(@core.pick_string(chars, rng))
    }
    out.to_string()
  })
}

///|
fn subagent_result_with(
  ok_gen : @core.Gen[Int32],
  err_gen : @core.Gen[Int32],
) -> @core.Gen[Result[Int32, Int32]] {
  @core.Gen::new(rng => {
    if @dummy.boolean().dummy(rng) {
      Ok(ok_gen.dummy(rng))
    } else {
      Err(err_gen.dummy(rng))
    }
  })
}

///|
fn subagent_map_of_set_like_values(
  rng : @random.Rand,
) -> Map[Int32, Array[Int32]] raise @core.DummyError {
  let out : Map[Int32, Array[Int32]] = Map([])
  for key in 0..<4 {
    let raw = @dummy.int(range=@dummy.int_range(1, 11)).sample(count=8, rng)
    raw.sort()
    let unique : Array[Int32] = []
    for value in raw {
      if unique.length() == 0 || unique[unique.length() - 1] != value {
        unique.push(value)
      }
    }
    out[key] = unique
  }
  out
}

///|
test "examples fixed seed streams replay deterministically" {
  let seed = subagent_fixed_seed()
  let ints = @dummy.int().sample(count=5, @dummy.seed(seed))
  let same_ints = @dummy.int().sample(count=5, @dummy.seed(seed))
  @test.assert_eq(ints, same_ints)
  let ranged = @dummy.int(range=@dummy.int_range(1, 8)).sample(
    count=5,
    @dummy.seed(seed),
  )
  let same_ranged = @dummy.int(range=@dummy.int_range(1, 8)).sample(
    count=5,
    @dummy.seed(seed),
  )
  @test.assert_eq(ranged, same_ranged)
  for value in ranged {
    assert_true(value >= 1 && value < 8)
  }
  let shared = @dummy.seed(seed)
  let first = @dummy.int().sample(count=5, shared)
  let second = @dummy.int().sample(count=5, shared)
  @test.assert_eq(first, ints)
  assert_true(second != ints)
}

///|
test "custom DummyDefault records have valid fields and deterministic values" {
  let seed = b"subagent-derived-order"
  let left : SubagentOrder = @core.DummyDefault::dummy_default(
    @dummy.seed(seed),
  )
  let right : SubagentOrder = @core.DummyDefault::dummy_default(
    @dummy.seed(seed),
  )
  assert_true(left == right)
  assert_true(left.order_id >= 1000 && left.order_id < 2000)
  assert_true(!left.customer.is_empty())
  @test.assert_eq(left.items.length(), 3)
  for item in left.items {
    assert_true(item.product_id >= 1 && item.product_id < 100)
    assert_true(item.qty >= 1 && item.qty < 10)
    assert_true(!item.company.is_empty())
    assert_true(item.price_cents >= 1 && item.price_cents < 100_000)
  }
  assert_true(left.paid || !left.paid)
  assert_true(left.status is Completed || left.status is Cancelled)
  @test.assert_eq(left.uuid.length(), 36)
  assert_true(left.total_cents >= 1 && left.total_cents < 1_000_000)
}

///|
test "primitive result tuple array and string examples keep stable shapes" {
  let rng = @dummy.seed(b"subagent-basic-primitives")
  let option_value : Int32? = @core.DummyDefault::dummy_default(rng)
  let nested_option : Int32?? = @core.DummyDefault::dummy_default(rng)
  let tuple_value : (Bool, Int32, String) = @core.DummyDefault::dummy_default(
    rng,
  )
  let empty_array : Array[Int32] = []
  let fixed_array = @dummy.int(range=@dummy.int_range(0, 10)).sample(
    count=3,
    rng,
  )
  let nested_array = Array::makei(3, _ => {
    @dummy.int(range=@dummy.int_range(1, 10)).sample(count=2, rng)
  })
  let result_gen = subagent_result_with(
    @dummy.int(range=@dummy.int_range(3, 20)),
    @dummy.int(range=@dummy.int_range(1, 10)),
  )
  let results = result_gen.sample(count=32, @dummy.seed(b"subagent-results"))
  let string_gen = subagent_ascii_string_with(
    [
      "A", "B", "Z", "0", "9", ")", "(", "*", "&", "^", "%", "$", "#", "@", "!",
      "~",
    ],
    @dummy.count_range(8, 10),
  )
  let strings = string_gen.sample(count=8, @dummy.seed(b"subagent-strings"))
  assert_true(option_value is None || option_value is Some(_))
  assert_true(nested_option is None || nested_option is Some(_))
  let (_, _, text) = tuple_value
  assert_true(!text.is_empty())
  @test.assert_eq(empty_array.length(), 0)
  @test.assert_eq(fixed_array.length(), 3)
  for value in fixed_array {
    assert_true(value >= 0 && value < 10)
  }
  @test.assert_eq(nested_array.length(), 3)
  for row in nested_array {
    @test.assert_eq(row.length(), 2)
    for value in row {
      assert_true(value >= 1 && value < 10)
    }
  }
  for result in results {
    match result {
      Ok(value) => assert_true(value >= 3 && value < 20)
      Err(value) => assert_true(value >= 1 && value < 10)
    }
  }
  for value in strings {
    assert_true(value.length() >= 8 && value.length() <= 10)
    assert_true(subagent_all_chars_match(value, subagent_is_alnum_or_symbol))
  }
}

///|
test "README facade usage methods exist and compose with locales" {
  let seed = b"subagent-facade-methods"
  let facade = @dummy.Dummy::new(locale=@dummy.zh_cn)
  let name_gen : @core.Gen[String] = facade.name()
  let email_gen : @core.Gen[String] = facade.email()
  let sentence_gen : @core.Gen[String] = facade.sentence()
  let name = name_gen.dummy(@dummy.seed(seed))
  let email = email_gen.dummy(@dummy.seed(seed))
  let sentence = sentence_gen.dummy(@dummy.seed(seed))
  assert_true(!name.is_empty())
  assert_true(subagent_valid_email(email))
  assert_true(!sentence.is_empty())
  @test.assert_eq(
    facade.name().sample(count=4, @dummy.seed(seed)),
    @dummy.Dummy::new(locale=@dummy.zh_cn)
    .name()
    .sample(count=4, @dummy.seed(seed)),
  )
  let direct_words = @dummy.words(count=@dummy.count_range(3, 5)).dummy(
    @dummy.seed(seed),
  )
  assert_true(direct_words.length() >= 3 && direct_words.length() <= 5)
  for word in direct_words {
    assert_true(!word.is_empty())
  }
}

///|
test "array map and unique collection results preserve their formats" {
  let seed = b"subagent-collections"
  let rng = @dummy.seed(seed)
  let vec = @dummy.int(range=@dummy.int_range(0, 256)).sample(
    count=@dummy.count_range(4, 7).sample(rng),
    rng,
  )
  assert_true(vec.length() >= 4 && vec.length() <= 7)
  for value in vec {
    assert_true(value >= 0 && value < 256)
  }
  let map : Map[Int32, Array[String]] = Map([])
  for key in 0..<3 {
    map[key] = @dummy.name(locale=@dummy.en).sample(count=2, rng)
  }
  let same_map : Map[Int32, Array[String]] = Map([])
  let same_rng = @dummy.seed(seed)
  ignore(@dummy.count_range(4, 7).sample(same_rng))
  ignore(
    @dummy.int(range=@dummy.int_range(0, 256)).sample(
      count=vec.length(),
      same_rng,
    ),
  )
  for key in 0..<3 {
    same_map[key] = @dummy.name(locale=@dummy.en).sample(count=2, same_rng)
  }
  @test.assert_eq(map, same_map)
  @test.assert_eq(map.length(), 3)
  for key, values in map {
    assert_true(key >= 0 && key < 3)
    @test.assert_eq(values.length(), 2)
    for value in values {
      assert_true(!value.is_empty())
    }
  }
  let set_map = subagent_map_of_set_like_values(
    @dummy.seed(b"subagent-set-map"),
  )
  @test.assert_eq(set_map.length(), 4)
  for key, values in set_map {
    assert_true(key >= 0 && key < 4)
    assert_true(values.length() >= 1 && values.length() <= 8)
    assert_true(values.is_sorted())
    for value in values {
      assert_true(value >= 1 && value < 11)
    }
  }
}

///|
test "README number boolean and media examples have verifiable formats" {
  let rng = @dummy.seed(b"subagent-readme-formats")
  for value in @dummy.boolean(ratio=0).sample(count=4, rng) {
    assert_true(!value)
  }
  for value in @dummy.boolean(ratio=100).sample(count=4, rng) {
    assert_true(value)
  }
  subagent_examples_assert_number_format(
    @dummy.number_with_format("^###").dummy(rng),
    "^###",
  )
  subagent_examples_assert_number_format(
    @dummy.number_with_format("FLAT 0# ^#/F").dummy(rng),
    "FLAT 0# ^#/F",
  )
  @test.assert_eq(
    @dummy.picsum_image_custom(@dummy.image_options(width=800, height=600)).dummy(
      rng,
    ),
    "https://picsum.photos/800/600",
  )
  @test.assert_eq(
    @dummy.picsum_image_custom(
      @dummy.image_options(width=640, height=480, seed="myseed"),
    ).dummy(rng),
    "https://picsum.photos/seed/myseed/640/480",
  )
  assert_true(@dummy.uuid_v4().dummy(rng).get_char(14) == Some('4'))
  @test.assert_eq(@dummy.ulid().dummy(rng).length(), 26)
  @test.assert_eq(@dummy.bson_object_id().dummy(rng).length(), 24)
}

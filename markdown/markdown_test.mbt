///|
fn count_char(s : String, target : Char) -> Int {
  let mut count = 0
  for ch in s {
    if ch == target {
      count += 1
    }
  }
  count
}

///|
fn each_line_has_prefix(
  s : String,
  prefix_first : Char,
  prefix_second : Char,
) -> Bool {
  let mut at_line_start = true
  let mut pos = 0
  for ch in s {
    if at_line_start {
      if ch != prefix_first {
        return false
      }
      at_line_start = false
      pos = 1
    } else if pos == 1 {
      if ch != prefix_second {
        return false
      }
      pos = 2
    } else if ch == '\n' {
      at_line_start = true
      pos = 0
    }
  }
  pos >= 2
}

///|
fn code_block_lines_have_assignments(s : String) -> Bool {
  let mut line = 0
  let mut current_has_assignment = false
  for ch in s {
    if ch == '\n' {
      if line > 0 && !current_has_assignment {
        return false
      }
      line += 1
      current_has_assignment = false
    } else if line > 0 && ch == '=' {
      current_has_assignment = true
    }
  }
  line >= 2
}

///|
test "word emphasis uses markdown delimiters" {
  let rng = @core.seed(b"markdown-words")
  let italic = @markdown.italic_word().dummy(rng)
  assert_true(italic.has_prefix("*"))
  assert_true(italic.has_suffix("*"))
  assert_true(!italic.has_prefix("**"))
  @test.assert_eq(count_char(italic, '*'), 2)
  let bold = @markdown.bold_word().dummy(rng)
  assert_true(bold.has_prefix("**"))
  assert_true(bold.has_suffix("**"))
  @test.assert_eq(count_char(bold, '*'), 4)
}

///|
test "link uses markdown link syntax with https url" {
  let link = @markdown.link().dummy(@core.seed(b"markdown-link"))
  assert_true(link.has_prefix("["))
  assert_true(link.contains("](https://"))
  assert_true(link.contains("example.com/"))
  assert_true(link.has_suffix(")"))
  @test.assert_eq(count_char(link, '['), 1)
  @test.assert_eq(count_char(link, ']'), 1)
  @test.assert_eq(count_char(link, '('), 1)
  @test.assert_eq(count_char(link, ')'), 1)
}

///|
test "bullet_points and list_items honor requested count" {
  let rng = @core.seed(b"markdown-lists")
  let bullets = @markdown.bullet_points(count=@core.count_range(3, 3)).dummy(
    rng,
  )
  assert_true(bullets.has_prefix("- "))
  @test.assert_eq(count_char(bullets, '\n'), 2)
  assert_true(bullets.contains("\n- "))
  assert_true(each_line_has_prefix(bullets, '-', ' '))
  let items = @markdown.list_items(count=@core.count_range(3, 3)).dummy(rng)
  @test.assert_eq(items.length(), 3)
  assert_true(items[0].has_prefix("1. "))
  assert_true(items[1].has_prefix("2. "))
  assert_true(items[2].has_prefix("3. "))
}

///|
test "block quotes prefix each requested line" {
  let single = @markdown.block_quote_single_line(count=@core.count_range(2, 2)).dummy(
    @core.seed(b"quote-single"),
  )
  assert_true(single.has_prefix("> "))
  @test.assert_eq(count_char(single, '\n'), 1)
  assert_true(single.contains("\n> "))
  assert_true(each_line_has_prefix(single, '>', ' '))
  let multi = @markdown.block_quote_multi_line(count=@core.count_range(3, 3)).dummy(
    @core.seed(b"quote-multi"),
  )
  assert_true(multi.has_prefix("> "))
  @test.assert_eq(count_char(multi, '\n'), 2)
  assert_true(each_line_has_prefix(multi, '>', ' '))
}

///|
test "code block is fenced and contains requested lines" {
  let code = @markdown.code(count=@core.count_range(2, 2)).dummy(
    @core.seed(b"markdown-code"),
  )
  assert_true(code.has_prefix("```\n"))
  assert_true(code.has_suffix("\n```"))
  @test.assert_eq(count_char(code, '\n'), 3)
  assert_true(code.contains("let "))
  assert_true(code_block_lines_have_assignments(code))
}

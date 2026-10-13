///|
// Renderable date/time fields derived from a minute offset plus random seconds
// and fractional seconds.
priv struct Parts {
  year : Int32
  month : Int32
  day : Int32
  hour : Int32
  minute : Int32
  second : Int32
  frac : String
}

///|
// Day offset for 2000-01-01 relative to the Unix epoch.
let base_epoch_day : Int32 = 10957

///|
// Number of minutes in one day.
let day_minutes : Int32 = 24 * 60

///|
// Floor division that behaves correctly for negative minute offsets.
fn floor_div(value : Int32, divisor : Int32) -> Int32 {
  if value >= 0 {
    value / divisor
  } else {
    -((-value + divisor - 1) / divisor)
  }
}

///|
// Floor modulo paired with `floor_div`, keeping minute-of-day non-negative.
fn floor_mod(value : Int32, divisor : Int32) -> Int32 {
  value - floor_div(value, divisor) * divisor
}

///|
// Convert days since Unix epoch to Gregorian year/month/day.
//
// This is Howard Hinnant's civil-from-days algorithm adapted to integer
// MoonBit code so the package does not need a date/time dependency.
fn civil_from_epoch_day(epoch_day : Int32) -> (Int32, Int32, Int32) {
  let z = epoch_day + 719468
  let era = floor_div(z, 146097)
  let doe = z - era * 146097
  let yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365
  let y = yoe + era * 400
  let doy = doe - (365 * yoe + yoe / 4 - yoe / 100)
  let mp = (5 * doy + 2) / 153
  let day = doy - (153 * mp + 2) / 5 + 1
  let month = if mp < 10 { mp + 3 } else { mp - 9 }
  let year = if month <= 2 { y + 1 } else { y }
  (year, month, day)
}

///|
// Convert a minute offset into renderable date/time parts.
fn parts_from_minutes(minutes : Int32, rng : @random.Rand) -> Parts {
  let day_offset = floor_div(minutes, day_minutes)
  let minute_of_day = floor_mod(minutes, day_minutes)
  let (year, month, day) = civil_from_epoch_day(base_epoch_day + day_offset)
  let hour = minute_of_day / 60
  let minute = minute_of_day % 60
  let second = rng.int(limit=60)
  let frac_out = StringBuilder(size_hint=9)
  for _ in 0..<9 {
    frac_out.write_string(rng.int(limit=10).to_string())
  }
  let frac = frac_out.to_string()
  { year, month, day, hour, minute, second, frac, }
}

///|
// Two-digit zero-padded decimal rendering.
fn two(value : Int32) -> String {
  @core.pad_left(value.to_string(), 2, '0')
}

///|
// Four-digit zero-padded decimal rendering.
fn four(value : Int32) -> String {
  @core.pad_left(value.to_string(), 4, '0')
}

///|
// ISO date rendering used by this package's default formats.
fn iso_date(parts : Parts) -> String {
  "\{four(parts.year)}-\{two(parts.month)}-\{two(parts.day)}"
}

///|
// ISO time rendering used by this package's default formats.
fn iso_time(parts : Parts) -> String {
  "\{two(parts.hour)}:\{two(parts.minute)}:\{two(parts.second)}"
}

///|
// Render the small set of chrono format strings exposed by the data package.
fn render_known_format(fmt : String, parts : Parts) -> String {
  match fmt {
    "%H:%M:%S%.f" => iso_time(parts) + "." + parts.frac
    "%H:%M:%S" => iso_time(parts)
    "%F" => iso_date(parts)
    "%Y/%m/%d" => "\{four(parts.year)}/\{two(parts.month)}/\{two(parts.day)}"
    "%d-%m-%Y" => "\{two(parts.day)}-\{two(parts.month)}-\{four(parts.year)}"
    "%d.%m.%Y" => "\{two(parts.day)}.\{two(parts.month)}.\{four(parts.year)}"
    "%+" => iso_date(parts) + "T" + iso_time(parts) + "+00:00"
    "%Y/%m/%d %H:%M:%S" =>
      "\{four(parts.year)}/\{two(parts.month)}/\{two(parts.day)} " +
      iso_time(parts)
    "%d-%m-%Y %H:%M:%S" =>
      "\{two(parts.day)}-\{two(parts.month)}-\{four(parts.year)} " +
      iso_time(parts)
    "%d.%m.%Y %H:%M:%S" =>
      "\{two(parts.day)}.\{two(parts.month)}.\{four(parts.year)} " +
      iso_time(parts)
    _ => iso_date(parts) + "T" + iso_time(parts)
  }
}

///|
// Pick a minute offset in a deterministic span around the base date.
fn random_minutes(rng : @random.Rand) -> Int32 {
  rng.int(limit=20 * 366 * day_minutes) - 10 * 366 * day_minutes
}

///|
// Render a date/time at an exact minute offset using the selected format.
fn render_at(minutes : Int32, fmt : String, rng : @random.Rand) -> String {
  render_known_format(fmt, parts_from_minutes(minutes, rng))
}

///|
/// Generate a time string for the selected locale.
pub fn time(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let minutes = rng.int(limit=day_minutes)
    render_at(minutes, @data.chrono_time_format(locale~), rng)
  })
}

///|
/// Generate a date string for the selected locale.
pub fn date(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let minutes = random_minutes(rng)
    render_at(minutes, @data.chrono_date_format(locale~), rng)
  })
}

///|
/// Generate a date-time string for the selected locale.
pub fn date_time(locale~ : @locales.Locale = EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let minutes = random_minutes(rng)
    render_at(minutes, @data.chrono_datetime_format(locale~), rng)
  })
}

///|
/// Generate a duration represented as minutes.
pub fn duration() -> @core.Gen[Int32] {
  @core.Gen::new(rng => rng.int(limit=366 * day_minutes))
}

///|
/// Generate a date-time before `anchor_minutes`.
pub fn date_time_before(
  anchor_minutes~ : Int32 = 0,
  locale~ : @locales.Locale = EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let offset = duration().dummy(rng) + 1
    render_at(
      anchor_minutes - offset,
      @data.chrono_datetime_format(locale~),
      rng,
    )
  })
}

///|
/// Generate a date-time after `anchor_minutes`.
pub fn date_time_after(
  anchor_minutes~ : Int32 = 0,
  locale~ : @locales.Locale = EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let offset = duration().dummy(rng) + 1
    render_at(
      anchor_minutes + offset,
      @data.chrono_datetime_format(locale~),
      rng,
    )
  })
}

///|
/// Generate a date-time between two minute offsets.
pub fn date_time_between(
  start_minutes : Int32,
  end_minutes : Int32,
  locale~ : @locales.Locale = EN,
) -> @core.Gen[String] raise @core.DummyError {
  if end_minutes <= start_minutes {
    raise InvalidRange(
      "expected end_minutes > start_minutes, got \{start_minutes}..\{end_minutes}",
    )
  }
  @core.Gen::new(rng => {
    let minutes = start_minutes + rng.int(limit=end_minutes - start_minutes)
    render_at(minutes, @data.chrono_datetime_format(locale~), rng)
  })
}

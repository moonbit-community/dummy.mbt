///|
// Number of minutes in one civil day.
const MINUTES_PER_DAY : Int32 = 1440

///|
// Default +/- span used by unconstrained date and date-time generators.
const DEFAULT_SPAN_MINUTES : Int32 = 366 * MINUTES_PER_DAY

///|
// Renderable date/time fields for this package's string output.
priv struct DateParts {
  year : Int32
  month : Int32
  day : Int32
  hour : Int32
  minute : Int32
  second : Int32
  subsecond : Int32
}

///|
// Zero-pad an integer to a fixed width.
fn padded(value : Int32, width : Int32) -> String {
  @core.pad_left(value.to_string(), width, '0')
}

///|
// Floor division that handles negative minute offsets.
fn floor_div(value : Int32, divisor : Int32) -> Int32 {
  if value >= 0 {
    value / divisor
  } else {
    (value - divisor + 1) / divisor
  }
}

///|
// Convert days since Unix epoch to Gregorian year/month/day without depending
// on a date/time library.
fn civil_from_days(days : Int32) -> (Int32, Int32, Int32) {
  let z = days + 719468
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
// Convert minute offsets into renderable date/time parts and random seconds.
fn parts_from_minutes(total_minutes : Int32, rng : @random.Rand) -> DateParts {
  let days = floor_div(total_minutes, MINUTES_PER_DAY)
  let minute_of_day = total_minutes - days * MINUTES_PER_DAY
  let (year, month, day) = civil_from_days(days)
  DateParts::{
    year,
    month,
    day,
    hour: minute_of_day / 60,
    minute: minute_of_day % 60,
    second: rng.int(limit=60),
    subsecond: rng.int(limit=1000000000),
  }
}

///|
// Pick a minute offset within the default time span.
fn random_minutes(rng : @random.Rand) -> Int32 {
  rng.int(limit=DEFAULT_SPAN_MINUTES * 2 + 1) - DEFAULT_SPAN_MINUTES
}

///|
// Render the time component, optionally including nanosecond precision.
fn render_time_parts(parts : DateParts, include_subsecond : Bool) -> String {
  let base = padded(parts.hour, 2) +
    ":" +
    padded(parts.minute, 2) +
    ":" +
    padded(parts.second, 2)
  if include_subsecond {
    base + "." + padded(parts.subsecond, 9)
  } else {
    base
  }
}

///|
// Render the subset of date formats used by the data package.
fn render_date_format(format : String, parts : DateParts) -> String {
  match format {
    "[year]-[month]-[day]" =>
      padded(parts.year, 4) +
      "-" +
      padded(parts.month, 2) +
      "-" +
      padded(parts.day, 2)
    "[day]-[month]-[year]" =>
      padded(parts.day, 2) +
      "-" +
      padded(parts.month, 2) +
      "-" +
      padded(parts.year, 4)
    "[day]/[month]/[year]" =>
      padded(parts.day, 2) +
      "/" +
      padded(parts.month, 2) +
      "/" +
      padded(parts.year, 4)
    "[year]/[month]/[day]" =>
      padded(parts.year, 4) +
      "/" +
      padded(parts.month, 2) +
      "/" +
      padded(parts.day, 2)
    "[day].[month].[year]" =>
      padded(parts.day, 2) +
      "." +
      padded(parts.month, 2) +
      "." +
      padded(parts.year, 4)
    _ =>
      padded(parts.year, 4) +
      "-" +
      padded(parts.month, 2) +
      "-" +
      padded(parts.day, 2)
  }
}

///|
// Render the subset of date-time formats used by the data package.
fn render_datetime_format(format : String, parts : DateParts) -> String {
  match format {
    "[year]/[month]/[day] [hour]:[minute]:[second]" =>
      render_date_format("[year]/[month]/[day]", parts) +
      " " +
      render_time_parts(parts, false)
    "[day]-[month]-[year] [hour]:[minute]:[second]" =>
      render_date_format("[day]-[month]-[year]", parts) +
      " " +
      render_time_parts(parts, false)
    "[day].[month].[year] [hour]:[minute]:[second]" =>
      render_date_format("[day].[month].[year]", parts) +
      " " +
      render_time_parts(parts, false)
    "[day]/[month]/[year]T[hour]:[minute]:[second][offset_hour sign:mandatory][offset_minute]" =>
      render_date_format("[day]/[month]/[year]", parts) +
      "T" +
      render_time_parts(parts, false) +
      "+0000"
    "[year]-[month]-[day]T[hour]:[minute]:[second][offset_hour sign:mandatory][offset_minute]" =>
      render_date_format("[year]-[month]-[day]", parts) +
      "T" +
      render_time_parts(parts, false) +
      "+0000"
    _ =>
      render_date_format("[year]-[month]-[day]", parts) +
      "T" +
      render_time_parts(parts, false) +
      "+0000"
  }
}

///|
// Render a date-time at a precise minute offset for the selected locale.
fn date_time_from_minutes(
  minutes : Int32,
  locale : @locales.Locale,
  rng : @random.Rand,
) -> String {
  render_datetime_format(
    @data.time_datetime_format(locale~),
    parts_from_minutes(minutes, rng),
  )
}

///|
/// Generate a time string for the selected locale.
pub fn time(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let parts = parts_from_minutes(random_minutes(rng), rng)
    match @data.time_time_format(locale~) {
      "[hour]:[minute]:[second][subsecond]" => render_time_parts(parts, true)
      _ => render_time_parts(parts, true)
    }
  })
}

///|
/// Generate a date string for the selected locale.
pub fn date(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    render_date_format(
      @data.time_date_format(locale~),
      parts_from_minutes(random_minutes(rng), rng),
    )
  })
}

///|
/// Generate a date-time string for the selected locale.
pub fn date_time(locale~ : @locales.Locale = @locales.EN) -> @core.Gen[String] {
  @core.Gen::new(rng => date_time_from_minutes(random_minutes(rng), locale, rng))
}

///|
/// Generate a duration represented as minutes.
pub fn duration() -> @core.Gen[Int32] {
  @core.Gen::new(rng => rng.int(limit=DEFAULT_SPAN_MINUTES + 1))
}

///|
/// Generate a date-time before `anchor_minutes`.
pub fn date_time_before(
  anchor_minutes~ : Int32 = 0,
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let offset = rng.int(limit=DEFAULT_SPAN_MINUTES) + 1
    date_time_from_minutes(anchor_minutes - offset, locale, rng)
  })
}

///|
/// Generate a date-time after `anchor_minutes`.
pub fn date_time_after(
  anchor_minutes~ : Int32 = 0,
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] {
  @core.Gen::new(rng => {
    let offset = rng.int(limit=DEFAULT_SPAN_MINUTES) + 1
    date_time_from_minutes(anchor_minutes + offset, locale, rng)
  })
}

///|
/// Generate a date-time between two minute offsets.
pub fn date_time_between(
  start_minutes : Int32,
  end_minutes : Int32,
  locale~ : @locales.Locale = @locales.EN,
) -> @core.Gen[String] raise @core.DummyError {
  if end_minutes < start_minutes {
    raise @core.DummyError::InvalidRange(
      "expected end_minutes >= start_minutes, got \{start_minutes}..\{end_minutes}",
    )
  }
  @core.Gen::new(rng => {
    let span = end_minutes - start_minutes + 1
    date_time_from_minutes(start_minutes + rng.int(limit=span), locale, rng)
  })
}

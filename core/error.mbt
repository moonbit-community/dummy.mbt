///|
/// Checked errors raised by generator construction or sampling.
///
/// Most facade calls return `Gen[T]`; these errors are usually observed when
/// calling `dummy` or `sample` with invalid ranges, empty candidate lists, or a
/// locale that has no meaningful data for a locale-specific category.
pub(all) suberror DummyError {
  /// A numeric or temporal range is invalid for sampling.
  InvalidRange(String)
  /// A requested collection size or string length is negative.
  InvalidCount(Int32)
  /// A random choice was requested from an empty candidate list.
  EmptyCandidates(String)
  /// A locale-specific generator was requested for an unsupported locale.
  UnsupportedLocale(String)
} derive(Eq, Debug)

///|
#deprecated
#doc(hidden)
pub extend DummyError with Eq::{equal, not_equal}

///|
#deprecated
#doc(hidden)
pub extend DummyError with Debug::{to_repr}

# Go Style

Loaded on demand, when writing or reviewing Go. Everything in the global instructions still applies — this file adds what is Go-specific.

## Project Structure

```
/cmd
  /cli
    main.go
  /server
    main.go
/internal
  <package>/
    fileA.go
    fileA_test.go
    fileB.go
    fileB_test.go
    errors.go
/testdata          (only if needed)
```

- `/cmd/<binary>/main.go` — one directory per binary, wiring only: parse flags/env, build dependencies, call into `/internal`. No business logic.
- `/internal/<package>` — the actual work, split into small files grouped by package. A file is named after the thing it exports (see Naming), with its test file beside it.
- `/testdata` — fixture files. The Go toolchain ignores directories named `testdata`, so anything in there is invisible to builds.

## Doc Comments

Doc comments are comments appearing immediately before top-level `package`, `const`, `func`, `type`, and `var` declarations, with **no intervening blank line**. A blank line turns a doc comment into an ordinary comment and it stops being documentation.

**Every exported (capitalized) name gets a doc comment.** Start it with the name being declared:

```go
// ParseFeedWindow converts a since/until pair into a validated time range.
// A zero Until means "no upper bound".
func ParseFeedWindow(params ParseFeedWindowParams) (FeedWindow, error) {
```

Unexported declarations get a comment only under the general comment rule — domain knowledge, a subtle invariant, or a non-obvious tradeoff.

## Allocation — avoid `make` and `new`

Prefer zero values and literals. `var items []Item` is a usable nil slice; `map[string]int{}` and `&Config{}` read better than their `make`/`new` equivalents.

Use `make` or `new` only when:

- Nothing else does the job — `new(int)` for a `*int`, `make(chan int)` / `make(chan int, 8)` for a channel.
- The size is known in advance, so the hint is real information: `make([]int, 0, 256)`, `make(map[int]string, n)`.

A `make` with no capacity argument on a slice or map is the case to avoid — it allocates nothing the zero value or a literal would not, and hides the fact that the size is unknown.

## `errors.go` per package

Each package has an `errors.go` holding its error types. One file means the failure vocabulary of a package is readable in one place, and callers can `errors.As` against named types instead of matching strings.

Rules:

- One error type per distinct failure, named `Err<What>`, carrying the values that made it fail as exported fields.
- Implement `Error() string` on the value receiver — callers should not need a pointer to compare or match.
- Doc comment on each type saying what condition it reports.
- Message text shared between several errors goes in a package-level `const`, so the wording cannot drift.
- The message states what arrived and what was expected; it does not shout, capitalize, or end in punctuation.

```go
package httpapi

import (
	"fmt"
	"time"
)

const limitExpectationText = "expected a non-negative integer, or 0 for no limit"

const dateExpectationText = "expected YYYY-MM-DD or RFC3339"

// ErrUnknownTheme reports a theme slug or alias that is not in the registry.
type ErrUnknownTheme struct {
	RawTheme string
}

func (e ErrUnknownTheme) Error() string {
	return fmt.Sprintf("unknown theme %q", e.RawTheme)
}

// ErrUnknownSource reports a source ID that is not in the registry.
type ErrUnknownSource struct {
	RawSourceID string
}

func (e ErrUnknownSource) Error() string {
	return fmt.Sprintf("unknown source %q", e.RawSourceID)
}

// ErrInvalidDate reports a publish-date bound that parsed as neither spelling.
type ErrInvalidDate struct {
	RawValue string
}

func (e ErrInvalidDate) Error() string {
	return fmt.Sprintf("invalid date %q: %s", e.RawValue, dateExpectationText)
}

// ErrInvalidLimitText reports a limit that arrived as text — a query-string value that was
// not a number, or one that parsed to a negative.
type ErrInvalidLimitText struct {
	RawValue string
}

func (e ErrInvalidLimitText) Error() string {
	return fmt.Sprintf("invalid limit %q: %s", e.RawValue, limitExpectationText)
}

// ErrInvalidLimitNumber reports a limit that arrived already typed, which is the CLI's
// --limit. It is quoted as a number so the message shows what the flag actually held.
type ErrInvalidLimitNumber struct {
	Limit int
}

func (e ErrInvalidLimitNumber) Error() string {
	return fmt.Sprintf("invalid limit %d: %s", e.Limit, limitExpectationText)
}

// ErrBackwardsDateWindow reports a since/until pair that excludes every possible item.
type ErrBackwardsDateWindow struct {
	Since time.Time
	Until time.Time
}

func (e ErrBackwardsDateWindow) Error() string {
	return fmt.Sprintf("since %s is after until %s",
		e.Since.Format(time.RFC3339), e.Until.Format(time.RFC3339))
}
```

Two named types for what looks like one failure (`ErrInvalidLimitText` vs `ErrInvalidLimitNumber`) is deliberate: the value arrives differently from the HTTP layer than from the CLI, and keeping the raw form lets the message show what the caller actually held.

## Table Tests

In a table-driven test, each case states its own expected outcome. When a table mixes passing and failing inputs, give the case struct an explicit `wantErr bool` and branch on it — never infer failure from a zero-valued `want` field, which makes the zero value do double duty as both "no result expected" and a legitimate result.

```go
cases := []struct {
    name     string
    rawPort  string
    wantPort int
    wantErr  bool
}{
    {name: "zero", rawPort: "0", wantErr: true},
    {name: "negative", rawPort: "-1", wantErr: true},
    {name: "lowest valid", rawPort: "1", wantPort: 1},
    {name: "highest valid", rawPort: "65535", wantPort: 65535},
}
```

Always name the cases and run them with `t.Run(testCase.name, ...)`, so a failure prints `/above_the_maximum` rather than an unlabelled input.

Where the error's identity matters, pair `wantErr` with the specific expectation — `wantMissingVariable string`, `wantErrType error` — and assert it with `errors.As` / `errors.Is` rather than on the message text.

Skip `wantErr` when it would be a constant column no branch reads: a table where every case fails, or one with no error path at all. A field nothing varies is noise. If such a table is worth making explicit, the fix is usually a passing case that was missing, not a column of `true`.

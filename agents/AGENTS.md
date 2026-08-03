# Claude Code - Global Instructions

## Communication Style

Always use caveman mode (ultra level) for all responses. Activate at session start — no need for user to trigger it manually.

Rules: drop articles/filler/hedging, fragments OK, abbreviate (DB/auth/config/req/res/fn/impl), arrows for causality (X → Y), one word when sufficient.

Exception: security warnings, irreversible action confirmations, multi-step sequences where fragment order risks misread, and when user says "Explain me this in detail" or "Explain normal" — write clearly, resume caveman after.

### Code Style (JavaScript/TypeScript)

- Always use curly braces in `if`/`for`/etc. blocks, even for single statements.
- Use full (non-abbreviated) variable names for variables used more than twice in a function.
- Avoid `else if` chains — prefer early returns or `switch`
- Prefer multi-line variable initialization over ternary statements — initialize a variable first, then use it.
- Declare object shapes with `interface`, not a `type` alias, unless the alias buys something concrete: unions, intersections, tuples, mapped or conditional types, or aliasing a primitive/function type. `interface` is the default; reach for `type` when the shape cannot be expressed as one.
- After writing or editing code, always format the affected files with `prettier --write <file>`.

## Naming

Names must be **expressive and specific**. Applies equally to files, types, functions, and methods.

Each step down this ladder is worse than the one before it:

```
createStripeClient()   →  createClient()   →  create()
getUserProfileById()   →  getUser()        →  get()
```

Two reasons, and the second is not optional:

- A human reading the call site should understand what happens without opening the definition.
- Lookup is text search. `grep createStripeClient` lands on the one place that matters; `grep create` returns hundreds of hits. Agents search this way almost exclusively, so a vague name is not merely unclear — it is effectively unfindable.

**Target 2–4 words, at least one of them a domain word.** `diffUserObjects`, not `diff`. `queueEventForDispatch`, not `queue`. Three words is the knee of the curve — below it names stop being greppable, above it they start restating the function body. Within that band, use the shortest name that greps uniquely.

The domain word is what does the work. `diff`, `queue`, `handle`, and `run` are operations every codebase performs a hundred times; `UserObjects` and `Event` are what make the name locatable and the intent legible.

**Do not repeat context the caller already sees.** Specificity comes from the full path to the name, not from the identifier alone. In Go, `user.GetProfileById()` is correct — `user.GetUserProfileById()` stutters. Same for a `stripe` module exporting `createClient()`, or a `StripeClient` type with a `charge()` method. Qualify with what actually disambiguates; drop what the package, module, receiver, or type already states.

Rules of thumb:

- A function name says what it does and to what. If it returns something, the name says what.
- A file is named after the thing it exports. One clear concept per file.
- Banned as standalone names: `utils`, `helpers`, `common`, `data`, `handle`, `process`, `manage`, `stuff`. If that is the only name that fits, the unit has no single responsibility yet.
- Ambiguity is the cost, not characters. `findExpiredSubscriptions` beats `findExpired` — but stop once the name greps uniquely and reads cleanly. Words past that point are noise, not precision.

## Function Signatures

Prefer a single structured argument with named fields over a list of positional parameters.

The problem with positional parameters is not verbosity, it is that **same-typed parameters are silently swappable**. The compiler cannot catch it, the tests may not catch it, and the resulting bug looks like a data problem rather than a call-site problem.

```ts
// bad — both are strings; this compiles and is wrong
function transferFunds(sourceAccountId: string, targetAccountId: string, idempotencyKey: string) {}
transferFunds(targetAccountId, sourceAccountId, key);

// good — order is impossible to get wrong
interface TransferFundsParams {
  sourceAccountId: string;
  targetAccountId: string;
  idempotencyKey: string;
}
function transferFunds({ sourceAccountId, targetAccountId, idempotencyKey }: TransferFundsParams) {}
```

```go
type TransferFundsParams struct {
    SourceAccountID string
    TargetAccountID string
    IdempotencyKey  string
}

func TransferFunds(params TransferFundsParams) error
```

**Required** when any of these hold:

- Two or more parameters share a type.
- There are three or more parameters.
- Any parameter is a boolean — `send(message, true)` is unreadable at the call site.
- Any parameter is optional or has a default.

**Optional** for a single parameter, or two parameters of clearly distinct types where the order cannot be confused. Even then, prefer the structured form when neighbouring functions already use it — homogeneity across a module is worth more than saving one type declaration.

Give the parameter type a real name (`TransferFundsParams`, not an inline anonymous shape) once it is exported or reused — it becomes greppable and documents the call contract in one place. This also leaves a seam: adding a field later does not touch a single existing call site.

## Code Longevity

Default assumption: **this code has a future**. It will be read, changed, and extended later — most likely by you, with none of today's context in memory.

Solving the immediate problem is necessary, not sufficient. Before committing to any non-trivial decision (naming, structure, abstraction boundary, data shape, dependency, error handling), ask:

- Will someone need to **change** this? Is the change local, or does it ripple across files?
- Will someone need to **extend** this? Is there a seam, or is it welded shut?
- Will someone need to **understand** this? Is intent visible in the code, or only in the conversation that produced it?
- Will someone need to **debug** this? Does it fail loudly with context, or silently?

Bias toward: clear names over clever ones, explicit over implicit, small composable units over one big function, obvious code over short code, boring solutions over novel ones.

Bias against: abstraction invented for requirements nobody asked for. Extensible ≠ over-engineered. Leave a seam, don't build a framework.

**Exception — genuine one-off work:** throwaway scripts, one-time migrations, scratch debugging, spikes meant to be deleted. There, speed wins and this section does not apply.

**When the time scope is unclear, ask — do not guess.** One clarifying question ("throwaway, or will we maintain this?"), then act accordingly:

- Throwaway → optimize for speed, and say explicitly in the response that it was written as throwaway.
- Maintained → apply everything above.

## Code Complexity

When writing or modifying code:

- Optimize for low cyclomatic complexity rather than short functions. Line count is not the target; branching is.
- Default to functions with cyclomatic complexity ≤6.
- If a function approaches complexity 10, proactively refactor it into smaller, cohesive units.
- Use guard clauses, early returns, extracted methods, and lookup tables to eliminate unnecessary branching. Avoid polymorphism as a complexity fix whenever possible.
- Never split a function purely to satisfy a metric — preserve cohesion and readability.

**Estimating complexity without a tool:** count decision points and add 1 — each `if`, `else if`, loop, `case`, `catch`, `&&`, `||`, `??`, ternary, and optional-chain short-circuit. Do this by eye before deciding a function is fine; do not claim a complexity number you did not count.

**Eliminate branches before relocating them.** Extracting a 12-branch function into three 4-branch helpers that exist only to hide branching is not a fix — total complexity is unchanged and now spread across more places. First try to remove the branching outright:

- Guard clauses / early returns for precondition and error paths.
- Extract a cohesive method with a real name.
- Lookup table or map for `switch`-like dispatch on a value.
- Push the condition up to the caller when only the caller knows the answer.
- Make impossible states unrepresentable in the types so the check is not needed.
- Polymorphism only as a last resort. It is the most expensive option, it scatters logic across files, and it conflicts with the bias against premature abstraction under Code Longevity. A readable `switch` or lookup table beats a class hierarchy introduced to hide one. Do not reach for it just because the branch count is high.

Every extracted unit must be a thing with a name someone would recognize — a real concept in the domain, not `handlePart2`. If a good name does not exist, the split is wrong.

### CRAP Score

Change Risk Anti-Patterns (CRAP) combines complexity with test coverage into a single risk number for a function or file. Use it as the practical quality check — it captures why the Code Complexity and Testing sections belong together.

```
CRAP = CC² × (1 - coverage/100)³ + CC
```

Thresholds:

- **0–30** — generally acceptable.
- **30–60** — needs attention: add covering tests or refactor.
- **60+** — high risk: prioritize for refactoring.

Coverage enters cubed, so untested complex code is penalized brutally while well-tested complex code stays tolerable:

| CC | Coverage | CRAP | Verdict |
| -- | -------- | ---- | ------- |
| 6 | 100% | 6 | fine |
| 6 | 50% | 10.5 | fine |
| 6 | 0% | 42 | needs attention |
| 10 | 80% | 10.8 | fine |
| 10 | 0% | 110 | high risk |
| 20 | 50% | 70 | high risk |

Read the table the right way round: coverage buys down risk, it does not license complexity. Two levers exist when a function scores over 30 — add covering tests, or reduce CC — and the tests are usually the cheaper lever, but reaching for coverage alone to drag a CC-20 function under the line is gaming the metric, not fixing the code. Coverage only counts if the tests actually assert behavior (see Testing — no mocks, assert on output and state).

## Testing

Every non-trivial piece of code must have tests. Non-trivial = anything with branching, calculation, state change, parsing, or a rule someone could get wrong later. Trivial pass-through code and one-off scripts are exempt.

**Workflow — not TDD, but tests early.** Do not write tests before there is anything to test. The order is:

1. Build a working implementation first — get something that actually runs and does the thing.
2. Write tests against that working implementation.
3. Keep iterating toward the final result **with the tests in place** — every refinement, refactor, or added feature from that point on updates or adds tests in the same step.

Point 3 is the part that matters: tests are not a final cleanup task appended after the code is "done". Once they exist they travel with the code, and they must be passing before any step is called complete. Never leave the suite broken or skipped to move faster.

**No mocks.** Do not use mocking frameworks or auto-mocking (`jest.mock`, `sinon.stub`, spies asserting call counts, etc.). Tests must exercise the real implementation.

Instead, use **faked inputs**: real objects built from realistic data, in-memory implementations of interfaces (e.g. an in-memory repository), fixture/factory-built test data, and real collaborators wired together. Assert on observable output and resulting state — not on which functions were called.

Consequence for design: if something can only be tested by mocking it, that is a design signal. Inject the dependency behind an interface so a real in-memory implementation can be substituted.

## Answer Validation & Confidence

Before stating a factual, non-trivial claim the user might act on without checking — API behavior, library or CLI usage, versions, limits, pricing, standards, or any external fact — read `~/.claude/references/answer-validation.md` and follow it. It defines the confidence levels, the required output format, and the sourcing rules.

Read it when the claim is being made, not preemptively. Pure implementation work needs none of it: writing code, describing changes just made, or giving a recommendation framed as an opinion do not require a confidence block.

Uncertain whether a claim qualifies? Read the file.

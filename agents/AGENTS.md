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
- After writing or editing code, always format the affected files with `prettier --write <file>`.

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

For any factual, non-trivial claim:

1. Assign a confidence level:
   - HIGH — confirmed by authoritative primary sources (official docs, specs, source code)
   - MEDIUM — supported by reliable secondary sources but not fully verified
   - LOW — uncertain, inferred, or lacking solid documentation

2. Always include sources as links.

3. Format:
   CONFIDENCE: <HIGH|MEDIUM|LOW>
   <concise answer>
   Sources:
   - <link 1>
   - <link 2>

4. If confidence is MEDIUM or LOW:
   - Briefly explain uncertainty
   - Add a short "How to verify" step

5. Never:
   - Never sound fully confident unless confidence is HIGH.
   - Present guesses as facts
   - Omit sources when making factual claims
   - Claim HIGH confidence without primary-source backing

6. For APIs, libraries, or CLI usage:
   - Prefer official documentation or source code links
   - Include version-specific notes when relevant

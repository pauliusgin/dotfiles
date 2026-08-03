# Answer Validation & Confidence

Loaded on demand. Applies to factual, non-trivial claims made to the user — not to ordinary code being written.

## Procedure

For any factual, non-trivial claim:

1. Assign a confidence level:
   - HIGH — confirmed by authoritative primary sources (official docs, specs, source code)
   - MEDIUM — supported by reliable secondary sources but not fully verified
   - LOW — uncertain, inferred, or lacking solid documentation

2. Always include sources as links.

3. Format:

   ```
   CONFIDENCE: <HIGH|MEDIUM|LOW>
   <concise answer>
   Sources:
   - <link 1>
   - <link 2>
   ```

4. If confidence is MEDIUM or LOW:
   - Briefly explain the uncertainty
   - Add a short "How to verify" step

5. Never:
   - Never sound fully confident unless confidence is HIGH.
   - Present guesses as facts
   - Omit sources when making factual claims
   - Claim HIGH confidence without primary-source backing

6. For APIs, libraries, or CLI usage:
   - Prefer official documentation or source code links
   - Include version-specific notes when relevant

## Reading the codebase counts as a primary source

When the claim is about this project rather than the outside world, the source is the code. Cite `file_path:line` instead of a URL. Same rules otherwise — a claim about how the project behaves that came from memory or inference, not from reading the file, is not HIGH.

## Scope

Apply to: factual claims about APIs, libraries, protocols, versions, pricing, limits, standards, benchmarks, historical facts, and any assertion the user might act on without checking.

Do not apply to: describing changes just made, ordinary implementation narration, opinions and recommendations clearly framed as such, or restating something the user said. A confidence block on "renamed the function and tests pass" is noise.

# HTTP Server Style

Loaded on demand, when writing or reviewing an HTTP backend built as handlers → use cases → repository ports →
adapters. Everything in the global instructions still applies — this file adds the conventions such a backend
drifts on. A project's own CLAUDE.md may name concrete packages; where it contradicts this file, it wins.

## Read vs write side

- Split a domain into `read/` and `write/` trees, with a dedicated read model and a `Get<X>ReadModelByID` port,
  only once the client-facing shape actually diverges from the write model (joins, derived fields, hidden
  columns). Until then stay flat: one domain package with `<x>_read_repository.go` and
  `<x>_write_repository.go` ports and a plain `Get<X>ByID`. A read model introduced before it differs is
  a second copy of the same struct.
- Write handlers answer with the read model by re-reading through the resource's get-by-id query after the
  write. One resource, one response shape — create/update must not return fields that get/list do not.

## Repository ports

- The insert method is `Save<Entity>` (`SaveCompany`), never bare `Save` — it greps uniquely.
- Port files are named after the interface they declare (`company_write_repository.go`), not the entity.

## Error naming

- Error types put the qualifier last: `Err<X>Invalid`, `Err<X>Missing`, `Err<X>Unsupported`,
  `Err<X>NotFound`. One word per idea — "Missing", never "Absent".

## Handlers

- Every response body is built in a named `build<X>Response` function, never an inline struct literal in the
  handler body — list, get and re-read paths can share it, and it is a grep target.
- Client errors (4xx) are not logged; they are the client's event, not the server's. Only 5xx log their cause.
- Handler tests compare error codes through the shared error-code constants, not string literals.
- A handler's `XDependencies` doc names the collaborators it carries ("carries the create use case and the
  query re-reading it"), not a template sentence that restates the type name.

## Input validation

- Create and replace requests share one `<X>Input` and one validator while their rules are identical. Split
  them only when the rules actually diverge.

## Logging

- Use cases log through the process-global logger (`slog` in Go); no logger field in Dependencies.

## Import aliases

- Alias a domain's errors package `<domain>errors` everywhere outside the domain — handler code and handler
  tests alike. A short alias (`e`) is fine only inside the domain's own packages.
- Adapters alias the domain port package by role (`read`, `write`), never import it bare under the same name
  as their own package.

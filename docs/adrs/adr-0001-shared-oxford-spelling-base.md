# ADR-001: Generate spelling policy from a shared base

## Status

Accepted.

## Context

The mockup template and its generated projects need the same en-GB-oxendict
spelling policy as the wider `leynos` estate. Copying curated Oxford overrides
between repositories would allow them to drift.

## Decision

Refresh the shared dictionary published by `leynos/agent-helper-scripts` into
an ignored cache only when its authoritative source is newer. Merge it with the
tracked `typos.local.toml` overlay and deterministically generate the tracked
`typos.toml`. Pin `typos` in the Makefile and enforce `make spelling` in parent
and generated-project CI.

## Consequences

- Oxford stems are curated once for the estate.
- Generated projects retain narrow, reviewable local exceptions.
- A fresh checkout needs network access for its first refresh, then supports
  validated offline cache reuse.

## Amendments

- 25 November 2026: the vendored generator and rollout scripts, and the
  Makefile-pinned `typos` release, are replaced by the pinned
  `typos-config-builder gate` (`make spelling`) at release tag `v0.1.4`, run
  under Python 3.14, in the parent repository and in generated projects. The
  decision above, a shared dictionary merged with the tracked
  `typos.local.toml` overlay into a generated `typos.toml`, is unchanged; only
  the machinery that performs it moved into the builder. With the generator
  tests gone, the parent repository has no Python tests, so its `make test`
  target and CI step are removed.

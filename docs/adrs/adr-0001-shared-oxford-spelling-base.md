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

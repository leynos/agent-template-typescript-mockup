# Developers' guide

## Spelling gate

`make spelling` runs `typos-config-builder gate --repository .` through
`uv tool run --python 3.14`, so `uv` must be available and able to provide
Python 3.14. The builder is pinned by `TYPOS_CONFIG_BUILDER_VERSION` in the
Makefile (default `v0.1.4`); override the variable to try another release tag.

The gate regenerates the tracked `typos.toml` from the shared en-GB-oxendict
dictionary and `typos.local.toml`, then checks spelling and the shared phrase
corrections. It reads tracked files only, so stage new Markdown before
expecting it to be checked. Put repository-only exceptions in
`typos.local.toml`; never edit `typos.toml` by hand. When the authority and the
dictionary cache are both unreachable, the builder falls back to its bundled
snapshot and regenerates `typos.toml` from that.

The same target and files live under `template/`, so generated projects carry
the same gate. `template/typos.local.toml` keeps inline code spans exempt in
Markdown only, through `[patterns] markdown_only`.

## Removed machinery

The vendored `scripts/generate_typos_config.py` and `scripts/typos_rollout.py`
(also under `template/scripts/`), their tests, and the `TYPOS_VERSION` pin are
gone; the builder replaces them.

The parent repository no longer has Python tests, so `pytest.ini`, `make test`
and the CI `make test` step were removed with them. The parent's checks are
`make check-fmt`, the Markdown lint in CI and `make spelling`; the generated
project's own gates are defined in `template/Makefile`.

.PHONY: check-fmt fmt spelling test

TYPOS_VERSION ?= 1.48.0
TYPOS := uv tool run typos@$(TYPOS_VERSION)

MDLINT ?= $(shell command -v markdownlint-cli2 2>/dev/null || printf '%s' "$$HOME/.bun/bin/markdownlint-cli2")
# `make fmt` and `make check-fmt` call mdtablefix directly. `--git` selects the
# Markdown files Git tracks and `--include-untracked` adds the untracked files
# Git does not ignore, so a new document is formatted before it is staged.
# Both modes need mdtablefix 0.6.0 or later; CI pins the version at the
# install-mdtablefix step.
MDTABLEFIX ?= mdtablefix
MDTABLEFIX_SELECT = --git --include-untracked
MDTABLEFIX_RULES = --wrap --renumber --breaks --ellipsis --fences

check-fmt: ## Verify Markdown formatting
	$(MDTABLEFIX) --check $(MDTABLEFIX_SELECT) $(MDTABLEFIX_RULES)

fmt: ## Format Markdown sources
	$(MDTABLEFIX) --in-place $(MDTABLEFIX_SELECT) $(MDTABLEFIX_RULES)
	$(MDLINT) --fix "**/*.md"

spelling: ## Enforce en-GB-oxendict spelling in parent and template prose
	uv run scripts/generate_typos_config.py
	find . -type f \( -name '*.md' -o -name '*.md.jinja' \) -not -path './.git/*' -print0 | \
		xargs -0 $(TYPOS) --config typos.toml --force-exclude

test: ## Validate shared dictionary refresh and generated configuration
	uvx --with hypothesis --with pytest pytest tests/

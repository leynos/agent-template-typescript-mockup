.PHONY: spelling test

TYPOS_VERSION ?= 1.48.0
TYPOS := uv tool run typos@$(TYPOS_VERSION)

spelling: ## Enforce en-GB-oxendict spelling in parent and template prose
	uv run scripts/generate_typos_config.py
	find . -type f \( -name '*.md' -o -name '*.md.jinja' \) -not -path './.git/*' -print0 | \
		xargs -0 $(TYPOS) --config typos.toml --force-exclude

test: ## Validate shared dictionary refresh and generated configuration
	uvx --with hypothesis --with pytest pytest tests/

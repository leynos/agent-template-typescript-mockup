.PHONY: all check-fmt fmt typecheck lint test spelling

all: check-fmt typecheck lint test
	+$(MAKE) spelling

check-fmt:
	bun fmt

fmt: ## Format sources
	bun fmt
	mdformat-all

typecheck:
	bun check:types

lint:
	bun lint

test:
	bun test

TYPOS_CONFIG_BUILDER_VERSION ?= v0.1.4
TYPOS_CONFIG_BUILDER = uv tool run --python 3.14 --from \
	"git+https://github.com/leynos/typos-config-builder.git@$(TYPOS_CONFIG_BUILDER_VERSION)" \
	typos-config-builder

# The gate reads tracked files only; stage new Markdown before expecting it checked.
spelling: ## Enforce en-GB-oxendict spelling in prose
	$(TYPOS_CONFIG_BUILDER) gate --repository .

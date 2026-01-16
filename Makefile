# Run all existing test specs
test: test-unit test-int test-e2e

test-unit:
	@echo "\nUnit testing:"
	@docker run --rm -v "$(shell pwd):/data" link-jumper/unit-and-int-image /usr/local/bin/busted --run=unit

test-int:
	@echo "\nIntegration testing:"
	@docker run --rm -v "$(shell pwd):/data" link-jumper/unit-and-int-image /usr/local/bin/busted --run=int

test-e2e:
	@echo "\nE2E testing:"
	@docker run --rm -v "$(shell pwd):/data" link-jumper/e2e-image nvim --headless -n --noplugin -u tests/e2e/e2e_init.lua

build-images:
	@docker build -f "$(shell pwd)/devops/unit-and-int.Dockerfile" -t link-jumper/unit-and-int-image .
	@docker build -f "$(shell pwd)/devops/e2e.Dockerfile" -t link-jumper/e2e-image .

.DEFAULT_GOAL := test

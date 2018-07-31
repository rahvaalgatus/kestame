ENV = development
BUNDLE = bundle
NANOC = $(BUNDLE) exec nanoc --env=$(ENV)
PORT = 4000

export ENV

love:
	@$(NANOC) compile

compile: love

autocompile: export NANOC_ENV = $(ENV)
autocompile:
	@$(BUNDLE) exec guard start

server:
	@$(NANOC) view --port $(PORT) --live-reload

# Missing --live-reload: https://github.com/guard/guard-nanoc/issues/38.
autoserver:
	@$(NANOC) live --port $(PORT)

deploy: ENV = production
deploy: compile
	@$(NANOC) deploy -t default

.PHONY: love
.PHONY: compile autocompile
.PHONY: server autoserver
.PHONY: deploy

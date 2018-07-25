BUNDLE = bundle
NANOC = $(BUNDLE) exec nanoc
PORT = 4000

love:
	@$(NANOC) compile

compile: love

autocompile:
	@$(BUNDLE) exec guard start

server:
	@$(NANOC) view --port $(PORT) --live-reload

# Missing --live-reload: https://github.com/guard/guard-nanoc/issues/38.
autoserver:
	@$(BUNDLE) exec nanoc live --port $(PORT)

deploy: compile
	@$(NANOC) deploy -t default

.PHONY: love
.PHONY: compile autocompile
.PHONY: server autoserver
.PHONY: deploy

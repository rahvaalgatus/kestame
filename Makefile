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

autoserver:
	@$(NANOC) live --port $(PORT) --live-reload

deploy: ENV = production
deploy: compile
	@$(NANOC) deploy -t default

.PHONY: love
.PHONY: compile autocompile
.PHONY: server autoserver
.PHONY: deploy

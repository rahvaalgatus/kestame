ENV = development
BUNDLE = bundle
NANOC = $(BUNDLE) exec nanoc --env=$(ENV)
PORT = 4000
WGET = wget --quiet

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

content/discussions.csv:
	$(WGET) "https://docs.google.com/spreadsheets/d/e/2PACX-1vTRk6FqIE82qy3Fb7luvJsBVhqV1USNFCc-Zc7MGlxiRe1kLWKeXT5li-iywqa22A2eAbpijj7yFCv1/pub?gid=690582168&single=true&output=csv" -O- | sed -E 's/'"\r"'$$//;s/,[^,]*?$$//;$$a\' > "$@"

content/problems.csv:
	$(WGET) "https://docs.google.com/spreadsheets/d/e/2PACX-1vRNwMwDywEYPduSijldLYntzekHoMqkFqBaK9MUbGUpE63HG2bOyT7pJ_0IUNpsfVgm0dtFPqb8GYb_/pub?gid=1680285954&single=true&output=csv" -O "$@"

.PHONY: love
.PHONY: compile autocompile
.PHONY: server autoserver
.PHONY: deploy

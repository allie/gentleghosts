OS := $(shell uname)

LOVE := love

ifeq ($(OS),Darwin)
	LOVE := /Applications/love.app/Contents/MacOS/love
endif

default: build run

clean:
	@[[ ! -e game.love ]] || rm game.love
	@[[ ! -e pkg ]] || rm -r pkg
	@[[ ! -e doc ]] || rm -r doc

build:
	@zip -qq -r game.love assets/
	@zip -qq -r game.love lib/
	@cd src/ && zip -qq -r ../game.love *

.PHONY: doc
doc:
	@ldoc -d doc -p game -f markdown src

run:
	$(LOVE) ./game.love

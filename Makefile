OS := $(shell uname)
ifeq ($(OS),Darwin)
	LOVE := /Applications/love.app/Contents/MacOS/love
	# A workaround to circumvent the issue mentioned here: https://love2d.org/forums/viewtopic.php?t=85784&p=223279
	WORKAROUND := @rm -r ~/Library/Saved\ Application\ State/org.love2d.love.savedState 2>/dev/null
else
	LOVE := love
	WORKAROUND := 
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
	$(WORKAROUND) || true
	$(LOVE) ./game.love

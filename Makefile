# --------------------------------------------------
# standard Makefile preamble
# see https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error Your Make does not support .RECIPEPREFIX. Use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >
# --------------------------------------------------
SRC=Makefile game.fb
OUTPUT=game

EMULATOR=/Applications/Atari800MacX/Atari800MacX.app
# --------------------------
#
build: $(OUTPUT).atr
.PHONY: build

emulator: $(OUTPUT).atr
> open $(EMULATOR) $(OUTPUT).atr
.PHONY: emulator

$(OUTPUT).atr: $(SRC)
> fb game.fb
> mkatr -x $@ -b $(OUTPUT).xex

serve:
> fswatch -o $(SRC) | xargs -n1 -I{} open $(EMULATOR) build/$(OUTPUT).atr
.PHONY: serve

serve-atr:
> fswatch --latency 2 -o build/$(OUTPUT).o | xargs -n1 -I{}   open $(EMULATOR) build/$(OUTPUT).atr
.PHONY: serve-atr

#> inotifywait -qrm --event modify src/* | while read file; do make; done

clean:
> rm -rf build
.PHONY: clean


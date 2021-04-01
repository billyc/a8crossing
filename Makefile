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

OUTPUT=game

SRC=Makefile game.fb

build: $(OUTPUT).atr
.PHONY: build

emulator: $(OUTPUT).atr
> open /Applications/Atari800MacX/Atari800MacX.app $(OUTPUT).atr
.PHONY: emulate

$(OUTPUT).atr: $(SRC)
> fb game.fb
> mkatr -x $@ -b $(OUTPUT).xex

serve:
> fswatch -o $(SRC) | xargs -n1 -I{} gmake emulator

.PHONY: serve

#> inotifywait -qrm --event modify src/* | while read file; do make; done

clean:
> rm -rf $(OUTPUT).o $(OUTPUT).lbl $(OUTPUT).asm  $(OUTPUT).xex $(OUTPUT).atr
.PHONY: clean


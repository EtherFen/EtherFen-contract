all: build

O := build
SOURCES := $(shell find contracts -name '*.sol')
SHELL = bash

$(O)/debug: $(SOURCES)
	solc --bin --overwrite -o $(O)/debug contracts/TombCore.sol

$(O)/release: $(SOURCES)
	solc --bin --overwrite --optimize -o $(O)/release contracts/TombCore.sol

$(O)/abi: $(SOURCES)
	solc --abi --overwrite -o $(O)/abi contracts/TombCore.sol

debug: $(O)/debug $(O)/abi

build: $(O)/release $(O)/abi

clean:
	rm -rf $(O)/

.PHONY: build debug clean

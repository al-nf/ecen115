SOURCES := $(wildcard *.typ)
PDFS    := $(patsubst %.typ, pdf/%.pdf, $(SOURCES))

.PHONY: all clean

all: $(PDFS)

pdf/:
	mkdir -p pdf

pdf/%.pdf: %.typ | pdf/
	typst compile $< $@

clean:
	rm -f $(PDFS)

SOURCES := $(wildcard ./src/*.ufo)

OTFS := $(patsubst ./src/%.ufo,./autogenerated/otf/%.otf,$(SOURCES))
TTFS := $(patsubst ./src/%.ufo,./autogenerated/ttf/%.ttf,$(SOURCES))
WOFFS := $(patsubst ./src/%.ufo,./autogenerated/woff/%.woff,$(SOURCES))
WOFF2S := $(patsubst ./src/%.ufo,./autogenerated/woff2/%.woff2,$(SOURCES))

all: $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S)

clean:
	rm -rf autogenerated

psfnormalize:
	(cd src && sh -c 'for font in *.ufo; do psfnormalize $$font; done')

autogenerated/otf/%.otf: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

autogenerated/ttf/%.ttf: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

autogenerated/woff/%.woff: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

autogenerated/woff2/%.woff2: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

fontbakery: all
	fontbakery check-googlefonts --html fontbakery-report.html autogenerated/otf/*.otf

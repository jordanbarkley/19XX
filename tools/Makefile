CC := gcc
CFLAGS := -O3
PROGRAMS := n64crc

n64crc_SOURCES := n64crc.c

all: $(PROGRAMS)

clean: 
	$(RM) $(PROGRAMS)

.PHONY: all clean

define COMPILE =
$(1): $($1_SOURCES)
	$(CC) $(CLFAGS) $($1_CFLAGS) $$^ -o $$@
endef

$(foreach p,$(PROGRAMS),$(eval $(call COMPILE,$(p))))

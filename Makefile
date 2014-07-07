include config.mk

SOURCES = $(SCRIPT) $(SCRIPT).1 $(SCRIPT).conf.example Makefile README LICENSE config.mk

default: $(SCRIPT).tmp $(SCRIPT).1.tmp

.tmp.1: config.mk
	m4 -P -D__VERSION__="$(VERSION)" -D__AUTHOR__="$(AUTHOR)" -D__COPYRIGHT__="$(COPYRIGHT)" $< > $@

### $(SCRIPT).tmp: $(SCRIPT) config.mk
### 	m4 -P -D__VERSION__="$(VERSION)" -D__AUTHOR__="$(AUTHOR)" -D__COPYRIGHT__="$(COPYRIGHT)" $< > $@
### 
### $(SCRIPT).1.tmp: $(SCRIPT).1 config.mk
### 	m4 -P -D__VERSION__="$(VERSION)" -D__AUTHOR__="$(AUTHOR)" -D__COPYRIGHT__="$(COPYRIGHT)" $< > $@

install: $(SCRIPT).tmp $(SCRIPT).1.tmp
	mkdir -p $(BINDIR) $(MANDIR) $(ETCDIR)
	install $(SCRIPT).tmp   $(BINDIR)
	install $(SCRIPT).1.tmp $(MANDIR)
	install $(SCRIPT).conf.example $(ETCDIR)
	for a in $(COMMANDS); do \
	    rm -f $(BINDIR)/\$a $(MANDIR)/\$a.1
	    ln -s $(SCRIPT)   $(BINDIR)/\$a
	    ln -s $(SCRIPT).1 $(MANDIR)/\$a.1
	done

dist: $(PKG)-$(VERSION).tar.gz

$(PROG)-$(VERSION).tar.gz: $(PROG)-$(VERSION)
	tar -czf $@ $<

$(PROG)-$(VERSION): $(SOURCES)
	rm -Rf $@
	mkdir $@
	cp -r $(SOURCES) $@/

clean:
	rm -Rf $(PROG)-*.*.* *.bak *.tmp

.PHONY: default install dist clean

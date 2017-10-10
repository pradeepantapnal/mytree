TOOLSPREFIX = arm-kreatv-linux-gnueabihf-
DEFINES += -DHISI_LINUX

# Default tools 
COMPILER = gcc
CXX_COMPILER = g++
ACHIVER = ar
LINKER = ld

CC = $(TOOLSPREFIX)$(COMPILER)
CXX = $(TOOLSPREFIX)$(CXX_COMPILER)
AR = $(TOOLSPREFIX)$(ACHIVER)
LD = $(TOOLSPREFIX)$(LINKER)
NM = $(TOOLSPREFIX)nm
STRIP = $(TOOLSPREFIX)strip
OBJCOPY = $(TOOLSPREFIX)objcopy

prefix = /usr

VERSION=1.7.0
TREE_DEST=tree
BINDIR=${prefix}/bin
MAN=tree.1
MANDIR=${prefix}/man/man1
OBJS=tree.o unix.o html.o xml.o json.o hash.o color.o

# Uncomment options below for your particular OS:

# Linux defaults:
CFLAGS=-ggdb -Wall -DLINUX -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CFLAGS += -Wall -fomit-frame-pointer 

#------------------------------------------------------------

all: clean	tree

tree:	$(OBJS)
	$(CC) $(LDFLAGS) -o $(TREE_DEST) $(OBJS)

$(OBJS): %.o:	%.c tree.h
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	if [ -x $(TREE_DEST) ]; then rm $(TREE_DEST); fi
	if [ -f tree.o ]; then rm *.o; fi
	rm -f *~

install: tree
	install -d $(BINDIR)
	install -d $(MANDIR)
	if [ -e $(TREE_DEST) ]; then \
		install $(TREE_DEST) $(BINDIR)/$(TREE_DEST); \
	fi
	install doc/$(MAN) $(MANDIR)/$(MAN)

distclean:
	if [ -f tree.o ]; then rm *.o; fi
	rm -f *~

dist:	distclean
	tar zcf ../tree-$(VERSION).tgz -C .. `cat .tarball`

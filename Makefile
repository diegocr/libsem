
LIBRARY	= libsem.a
ARCH	= m68k-amigaos
ARCHOPT	= -m68020-60 -msoft-float
ARCHTAG	= 
CC	= $(ARCH)-gcc
CFLAGS	= -O3 -fomit-frame-pointer $(ARCHOPT) -I. -W -Wall $(UFLAGS)
OBJDIR	= .objs_$(ARCH)_$(ARCHTAG)
AR	= $(ARCH)-ar
RANLIB	= $(ARCH)-ranlib
PREFIX	= /usr/local/amiga/$(ARCH)

OBJS = \
	$(OBJDIR)/psem.o \
	$(OBJDIR)/sem_close.o \
	$(OBJDIR)/sem_getvalue.o \
	$(OBJDIR)/sem_init.o \
	$(OBJDIR)/sem_open.o \
	$(OBJDIR)/sem_post.o \
	$(OBJDIR)/sem_timedwait.o \
	$(OBJDIR)/sem_trywait.o \
	$(OBJDIR)/sem_unlink.o \
	$(OBJDIR)/sem_wait.o

$(OBJDIR):
	mkdir -p $@

$(OBJDIR)/%.o: %.c
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $< -o $@

all: $(LIBRARY)

$(LIBRARY): $(OBJDIR) $(OBJS)
	@echo Linking $@...
	@$(AR) cru $@ $(OBJS)
	@$(RANLIB) $@

clean:
	@rm -f $(OBJDIR)/*.o
	@rm -f .objs*/*.o

install:
	@chmod 755 *
	cp -pL ./semaphore.h $(PREFIX)/include
	cp -pL ./$(LIBRARY) $(PREFIX)/lib
	$(RANLIB) $(PREFIX)/lib/$(LIBRARY)

test: $(LIBRARY) test.c
	$(CC) $(CFLAGS) -noixemul test.c -o test -s -L. -lsemdebug -Wl,-Map,test.map,--cref

debug:
	@$(MAKE) LIBRARY=libsemdebug.a UFLAGS="-g -DDEBUG=1" ARCHTAG=debug

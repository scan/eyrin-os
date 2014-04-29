SRCDIR      := ./src/
OBJDIR      := ./build/

ARMGNU		:= arm-none-eabi

SOURCES_ASM := $(wildcard $(SRCDIR)*.s)
SOURCES_C   := $(wildcard $(SRCDIR)*.c)

LDFILE		:= kernel.ld
 
# object files
OBJS        := $(patsubst $(SRCDIR)%.s,$(OBJDIR)%.o,$(SOURCES_ASM))
OBJS        += $(patsubst $(SRCDIR)%.c,$(OBJDIR)%.o,$(SOURCES_C))
 
# Build flags
INCLUDES    := -I include
BASEFLAGS   := -O2 -fpic -pedantic -pedantic-errors -nostdlib
BASEFLAGS   += -ffreestanding -fomit-frame-pointer -mcpu=arm1176jzf-s
WARNFLAGS   := -Wall -Wextra -Wshadow -Wcast-align -Wwrite-strings
WARNFLAGS   += -Wredundant-decls -Winline
WARNFLAGS   += -Wno-attributes -Wno-deprecated-declarations
WARNFLAGS   += -Wno-div-by-zero -Wno-endif-labels -Wfloat-equal
WARNFLAGS   += -Wformat=2 -Wno-format-extra-args -Winit-self
WARNFLAGS   += -Winvalid-pch -Wmissing-format-attribute
WARNFLAGS   += -Wmissing-include-dirs -Wno-multichar
WARNFLAGS   += -Wredundant-decls -Wshadow
WARNFLAGS   += -Wno-sign-compare -Wswitch -Wsystem-headers -Wundef
WARNFLAGS   += -Wno-pragmas -Wno-unused-but-set-parameter
WARNFLAGS   += -Wno-unused-but-set-variable -Wno-unused-result
WARNFLAGS   += -Wwrite-strings -Wdisabled-optimization -Wpointer-arith
WARNFLAGS   += -Werror
ASFLAGS     := $(INCLUDES)
CFLAGS      := $(INCLUDES) $(BASEFLAGS) $(WARNFLAGS)
CFLAGS      += -std=gnu99
 
# build rules
all: kernel.img kernel.list
 
include $(wildcard *.d)

kernel.list: kernel.elf
	$(ARMGNU)-objdump -d $< > $@
 
kernel.elf: $(OBJS) $(LDFILE)
	$(ARMGNU)-ld $(OBJS) -Map kernel.map -T$(LDFILE) -o $@
 
kernel.img: kernel.elf
	$(ARMGNU)-objcopy kernel.elf -O binary kernel.img
 
clean:
	$(RM) -f $(OBJS) kernel.elf kernel.img kernel.list kernel.map
 
dist-clean: clean
	$(RM) -f *.d
 
# C.
$(OBJDIR)%.o: $(SRCDIR)%.c Makefile
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@
 
# AS.
$(OBJDIR)%.o: $(SRCDIR)%.s Makefile
	$(ARMGNU)-as $(ASFLAGS) -c $< -o $@

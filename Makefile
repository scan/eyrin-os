SRCDIR      := ./src/
OBJDIR      := ./build/

ARMGNU		:= arm-none-eabi

LDFILE		:= kernel.ld

 
# Build flags
INCLUDES    := -I include
BASEFLAGS   := -O2 -fpic -nostdlib # -pedantic -pedantic-errors
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
#WARNFLAGS   += -Werror
ASFLAGS     := $(INCLUDES)
CFLAGS      := $(INCLUDES) $(BASEFLAGS) $(WARNFLAGS)
CFLAGS      += -std=c99
CXXFLAGS	:= $(INCLUDES) $(BASEFLAGS) $(WARNFLAGS)
CXXFLAGS	+= -std=c++0x -fno-rtti -fno-exceptions

CC			:= $(ARMGNU)-gcc
CXX			:= $(ARMGNU)-g++
AS			:= $(ARMGNU)-as

# object files
OBJS = $(OBJDIR)boot.o $(OBJDIR)main.o $(OBJDIR)postman.o $(OBJDIR)uart.o

CRTI_OBJ=$(OBJDIR)crti.o
CRTBEGIN_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=$(OBJDIR)crtn.o
 
OBJ_LINK_LIST:=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)
INTERNAL_OBJS:=$(CRTI_OBJ) $(OBJS) $(CRTN_OBJ)

.PHONY: all clean dist
 
# build rules
all: kernel.img kernel.list
 
include $(wildcard *.d)

kernel.list: kernel.elf
	$(ARMGNU)-objdump -d $< > $@
 
kernel.elf: $(OBJ_LINK_LIST) $(LDFILE)
	$(ARMGNU)-ld $(OBJ_LINK_LIST) -Map kernel.map -T$(LDFILE) -o $@ -nostdlib
 
kernel.img: kernel.elf
	$(ARMGNU)-objcopy kernel.elf -O binary kernel.img
 
clean:
	$(RM) -f $(OBJS) kernel.elf kernel.img kernel.list kernel.map
 
dist-clean: clean
	$(RM) -f *.d card.img

start: dist
	qemu-system-arm -cpu arm1176 -m 512 -M raspi -no-reboot -serial stdio -hda card.img

dist: mnt card.img firmware/bootcode.bin firmware/start.elf kernel.img
	mkdir -p ./mnt
	sudo mount -t vfat -o loop card.img ./mnt
	sudo cp firmware/bootcode.bin firmware/start.elf kernel.img ./mnt/
	sudo umount ./mnt

card.img:
	dd if=/dev/zero of=card.img bs=1M count=64
	mkfs.fat -F32 -n RASPIOS card.img

$(OBJDIR)%.o: $(SRCDIR)%.cpp Makefile
	$(ARMGNU)-g++ $(CXXFLAGS) -c $< -o $@

$(OBJDIR)%.o: $(SRCDIR)%.c Makefile
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@
 
$(OBJDIR)%.o: $(SRCDIR)%.s Makefile
	$(ARMGNU)-as $(ASFLAGS) -c $< -o $@

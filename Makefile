ARMGNU ?= arm-none-eabi

BUILD = ./build/
SOURCE = ./src/

TARGET = kernel.img
MAP = kernel.map
LIST = kernel.list

LDFILE = kernel.ld
TMPOUT = $(BUILD)output.elf

OBJECTS = $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s))

.PHONY: all clean

all: $(TARGET) $(LIST)

$(LIST): $(TMPOUT)
	$(ARMGNU)-objdump -d $(TMPOUT) > $(LIST)

$(TARGET): $(TMPOUT)
	$(ARMGNU)-objcopy $(TMPOUT) -O binary $(TARGET)

$(TMPOUT): $(OBJECTS) $(LDFILE)
	$(ARMGNU)-ld --no-undefined $(OBJECTS) -Map $(MAP) -o $(TMPOUT) -T $(LDFILE)

$(BUILD)%.o: $(SOURCE)%.s $(BUILD)
	$(ARMGNU)-as -I $(SOURCE) $< -o $@

$(BUILD):
	mkdir $@

clean : 
	-rm -rf $(BUILD)
	-rm -f $(TARGET)
	-rm -f $(LIST)
	-rm -f $(MAP)

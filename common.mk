GPSIM_FLAGS = -L .
GPSIM = gpsim

GPASM_FLAGS = --debug-info
GPASM = gpasm

# Use ICSP port
MINIPRO_FLAGS += -i
MINIPRO = minipro

%.hex: %.asm
	$(GPASM) $(GPASM_FLAGS) $^

%.bin: %.hex
	srec_cat $^ --intel --crop 0x0 $(SIZE) --fill 0x00 0x0 $(SIZE) -o $@ --binary

all: $(NAME).bin

# Run in simulator
run: $(NAME).hex
	$(GPSIM) $(GPSIM_FLAGS) -s $(NAME).cod $(NAME).hex

# Program
upload: $(NAME).bin $(NAME)-fuses.conf
	# Program memory
	$(MINIPRO) $(MINIPRO_FLAGS) -w $^
	# Config memory
	$(MINIPRO) $(MINIPRO_FLAGS) -e -c config -w $(NAME)-fuses.conf

# Get the program
download:
	# Program memory
	$(MINIPRO) $(MINIPRO_FLAGS) -r $(NAME).bin

# Read out the config word from chip
fuses.conf:
	$(MINIPRO) $(MINIPRO_FLAGS) -c config -r fuses.conf
	-grep 'conf_word = 0x0000' fuses.conf && rm fuses.conf

# Replace config word with our one
$(NAME)-fuses.conf: fuses.conf $(NAME).hex
	sed "s/\(conf_word = 0x21\).*/\1$$(srec_cat $(NAME).hex --intel --exclude 0x0 $(CONFIG) -offset -$(CONFIG) -o - --hex-dump |sed 's/.*: \(..\).*/\1/')/" <fuses.conf >$@

# Chuck mess
clean:
	rm -f *.cod *.hex *.lst *.bin *.conf

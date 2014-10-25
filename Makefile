GPSIM_FLAGS = -L .
GPSIM = gpsim

GPASM_FLAGS = --debug-info
GPASM = gpasm

MINIPRO_FLAGS += -p PIC12F675
# Use ICSP port
#MINIPRO_FLAGS += -i
MINIPRO = minipro

# Programmable code memory (last word is clock calibration)
SIZE = 2046

# Address of the config word in assembly output
CONFIG = 0x400e

%.hex: %.asm
	$(GPASM) $(GPASM_FLAGS) $^

%.bin: %.hex
	srec_cat $^ --intel --crop 0x0 $(SIZE) --fill 0x00 0x0 $(SIZE) -o $@ --binary

all: lala.bin

# Run in simulator
run: lala.hex
	$(GPSIM) $(GPSIM_FLAGS) -s lala.cod lala.hex

# Program
upload: lala.bin lala-fuses.conf
	# Program memory
	$(MINIPRO) $(MINIPRO_FLAGS) -w $^
	# Config memory
	$(MINIPRO) $(MINIPRO_FLAGS) -e -c config -w lala-fuses.conf

# Read out the config word from chip
fuses.conf:
	$(MINIPRO) $(MINIPRO_FLAGS) -c config -r fuses.conf
	-grep 'conf_word = 0x0000' fuses.conf && rm fuses.conf

# Replace config word with our one
lala-fuses.conf: fuses.conf lala.hex
	sed "s/\(conf_word = 0x21\).*/\1$$(srec_cat lala.hex --intel --exclude 0x0 $(CONFIG) -offset -$(CONFIG) -o - --hex-dump |sed 's/.*: \(..\).*/\1/')/" <fuses.conf >$@

# Chuck mess
clean:
	rm -f *.cod *.hex *.lst *.bin *.conf

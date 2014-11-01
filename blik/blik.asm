LIST p=12f675
INCLUDE p12f675.inc

        __CONFIG _WDT_OFF & _INTRC_OSC_NOCLKOUT & _BODEN_OFF & _MCLRE_OFF & _PWRTE_ON

	cblock 0x21
	TRISIO_STATUS
	GPIO_STATUS
	REG025
	REG026
	REG027
	REG028
	REG029
	REG02A
	endc

	ORG 0
	goto	START

	ORG 4
START
	; Initialize GPIO
	bsf	STATUS,RP0 
	clrf	ANSEL 
	movlw	b'11001111'
	movwf	TRISIO
	movlw	b'00000100'
	movwf	WPU

	; Enable digital I/O
	bcf	STATUS,RP0 
	movlw	b'00110100'
	movwf	CMCON 

BLINK
	; State 1
	movlw	b'00010000'
	movwf	GPIO
	call	DELAY

FREEZE
	btfsc	GPIO,2
	goto FREEZE

	; State 2
	movlw	b'00100000'
	movwf	GPIO
	call	DELAY

	goto	BLINK

DELAY
	movlw	0x05
	movwf	REG025
	movlw	0x64
	movwf	REG026
	movlw	0x0a
	movwf	REG027
	movlw	0xff
	movwf	REG028
l6
	movf	REG026,w
	movwf	REG02A
l5
	movf	REG025,w
	movwf	REG029
l4
	movlw	0x17
l3
	addwf	REG028,w
	btfsc	STATUS,0
	goto	l3
	decfsz	REG029,f
	goto	l4
	decfsz	REG02A,f
	goto	l5
	decfsz	REG027,f
	goto	l6
	return

	END

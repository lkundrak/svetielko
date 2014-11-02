LIST p=16f88
INCLUDE p16f88.inc

	__CONFIG _INTRC_IO & _WDT_OFF & _BODEN_OFF & _MCLRE_OFF

	banksel	TRISA
	clrf	TRISA
	banksel	ANSEL
	clrf	ANSEL
	banksel	PORTA
	movlw	b'11111111'
	movwf	PORTA

MEH
	goto	MEH

	END

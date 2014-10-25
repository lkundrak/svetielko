LIST p=12f675
; /usr/share/gputils/header/p12f675.inc
INCLUDE p12f675.inc

; http://www.micahcarrick.com/pic-programming-linux.html

	__CONFIG _WDT_OFF & _INTRC_OSC_NOCLKOUT & _BODEN_OFF
;_WDT_OFF & _CP_OFF & _CPD_OFF

	ORG 0
	GOTO START

	ORG 4
START

	MOVLW	~(1<<GP1)	; 0xfd
	BANKSEL	TRISIO		; BSF STATUS, GPIO
	MOVWF	GPIO

	BANKSEL	GPIO		; BCF STATUS, GPIO
	BSF	GPIO, GP1

	GOTO $
	END

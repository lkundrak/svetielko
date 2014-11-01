LIST p=12f675
; /usr/share/gputils/header/p12f675.inc
INCLUDE p12f675.inc

; http://www.micahcarrick.com/pic-programming-linux.html

        __CONFIG _WDT_OFF & _INTRC_OSC_NOCLKOUT & _BODEN_OFF & _MCLRE_OFF & _PWRTE_ON

	ORG 0
	GOTO START

; Delay = 1 seconds
; Clock frequency = 4 MHz

; Actual delay = 1 seconds = 1000000 cycles
; Error = 0 %

	cblock 0x20
	d1
	d2
	d3
	endc

Delay
			;999990 cycles
	movlw	0x07
;	movlw	0x01
	movwf	d1
	movlw	0x2F
;	movlw	0x01
	movwf	d2
	movlw	0x03
;	movlw	0x01
	movwf	d3
Delay_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	Delay_0

			;6 cycles
	goto	$+1
	goto	$+1
	goto	$+1

			;4 cycles (including call)
	return

;	ORG 4
START

	MOVLW	~(1<<GP1)	; 0xfd
	BANKSEL	TRISIO		; BSF STATUS, GPIO
	MOVWF	GPIO

	BANKSEL	GPIO		; BCF STATUS, GPIO
LOOP
	BCF	GPIO, GP1
;	CALL	Delay
	BSF	GPIO, GP1
;	CALL	Delay
	GOTO LOOP
	END


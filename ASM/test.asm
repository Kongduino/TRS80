;PRTIME2
;Nov 12, 1984
;
ORG 0xDAC0
;ENT 0xDAC0
;
; These are all ROM subroutines
DISPLAY EQU 0x5A58	; print message pointed to by HL
LCD EQU 0x4B44		; print character in register A
CHGET EQU 0x12CB	; wait for keypress
MENU EQU 0x5797		; main MODEL 100 menu
PLOT EQU 0x744C		; Turns on pixel at x (D), y (E), 0-239, 0,63
UNPLOT EQU 0x744D	; Turns off pixel at x (D), y (E), 0-239, 0,63
POSIT EQU 0x4D7C	; Gets cursor position H = x 1-40, L = y 1-8
ESCA EQU 0x4270		; A = escape code. Sends escape code.
CRLF EQU 0x4222
HOME EQU 0x422D		; Set cursor to 1,1
CLS EQU 0x4231
SETSYS EQU 0x4235	; Sets system line (lock line 8). ESC - T
RSTSYS EQU 0x423A	; Resets system line (unlock line 8). ESC - U
LOCK EQU 0x423F		; Locks display. ESC - Y
UNLOCK EQU 0x4244	; Locks display. ESC - W
CURSON EQU 0x4249	; ESC - P
CUROFF EQU 0x424E	; ESC - Q
DELLIN EQU 0x4253	; Deletes line at current cursor position. ESC - M
INSLIN EQU 0x4258	; Inserts a line at current cursor position. ESC - L
ERAEOL EQU 0x425D	; Erases line from cursor to EOL. ESC - K
ENTREV EQU 0x4269	; Sets reverse character mode. ESC - p
EXTREV EQU 0x426E	; Turns off reverse character mode. ESC - q
KYREAD EQU 0x7242	; Scans kbd for a key, returns in A, if any.
					; Z flag set if no key.
					; C flag set if special key. A = 0-7: F1-F8.
					; A = 8-11: LABEL, PRINT, SHIFT, PASTE.
CHGET EQU 0x12CB	; Waits for a key, returns in A. C flag set if special key.
					; F1-F8 return preprogrammed keys
FCTAB DS 'FILES'
DB 0D80 ; F1
DS 'LOAD'
DB 0D80 ; F2
DS 'SAVE'
DB 0D, 80 ; F3
DS 'RUN'
DB 0D, 80 ; F4
DS 'LIST'
DB 0D80 ; F5
DB 80 ; F6 IGNORE
DB 80 ; F7 IGNORE
DS 'MENU'
DB 0D, 80 ; F8
STFNK EQU 0x5A7C	; Sets the table above, LXI HL, FCTAB.
CLRFNK EQU 0x5A79	; Clears the table above.
FNKSB EQU 0x5A9E	; Shows the Function Keys Table if enabled.
DSPFNK EQU 0x42A5	; Displays the Function Keys
ERAFNK EQU 0x428A	; Hides the Function Keys


CHSNS EQU 0x13DB	; Checks kbd queue for characters. Z flag set if queue empty.
KEYX EQU 0x7270		; Checks kbd queue for characters or BREAK.
					; Z flag set if queue empty.
					; C flag set if BREAK pressed.
BRKCHK EQU 0x7283	; Checks for BREAK characters only, CTRL-C or -S.
					; C flag set if BREAK or PAUSE pressed.
INLIN EQU 0x4644	; Gets line from kbd, ended by RETURN. Stored at 0xF685.
PRINTR EQU 0x6D3F	; Sends a character in A to the line printer.
					; C flag set if BREAK pressed and print cancelled.
PNOTAB EQU 0x1470	; Prints character in A without expanding tab characters.
PRTTAB EQU 0x4B55	; Prints character in A expanding tab characters to spaces.
PRTLCD EQU 0x1E5E	; Prints contents of LCD.
DISC EQU 0x52BB		; Disconnects phone line
CONN EQU 0x52D0		; Connects phone line
DIAL EQU 0x532D		; Dials a phone number, HL points to phone number.
RCVX EQU 0x6D6D		; Check RS323 queue for characters. Returns number in A.
					; Z flag set if queue empty.
RV232C EQU 0x6D7E	; Gets a character from RS323 queue. Returns in A.
					; Z flag set if OK, reset if error (PE, PF, OF).
					; C flag set if BREAK pressed.
SD232C EQU 0x6E32	; Sends a character in A to RS323.
SENDCQ EQU 0x6E0B	; Sends ctrl-q, ie XON resume.
SENDCS EQU 0x6E1E	; Sends ctrl-s, ie XOFF pause.
CARDET EQU 0x6EEF	; Detects modem carrier. Returns A = 0 if carrier detected.
					; Z flag set if carrier detected.
BAUDST EQU 0x6E75	; Sets baud rate for RS232. H = 1-9,M (???)
INZCOM EQU 0x6EA6	; Initializes modem and RS232.
					; H = 1-9,M (???)
					; L = UART configuration code
					; bit 0:	0: 1 stop bit; 1: 2 stop bits
					; bit 1:	0: odd parity; 1: even parity
					; bit 2:	0: enable parity; 1: disable parity
					; bits 3-4:	word length = 5 + value (6 to 8)
					; See STAT below.
CLSCOM EQU 0x6ECB	; Deactivates modem and RS232.
DATAR EQU 0x702A	; Reads character from cassette, no checksum. Returns in D.
DATAW EQU 0x6F5B	; Writes a character in A to cassette, no checksum.
CTON EQU 0x14A8		; Turns on cassette motor.
CTOF EQU 0x14AA		; Turns off cassette motor.
CASIN EQU 0x14B0	; Reads a character from cassette and updates checksum.
					; D = character
					; C = updated checksum
CSOUT EQU 0x14C1	; Sends a character in A to cassette and updates checksum.
					; A = character
					; C = current / updated checksum
SYNCW EQU 0x6F46	; Writes cassette header and sync byte.
SYNCR EQU 0x6F85	; Reads cassette header and sync byte.
MAKTXT EQU 0x220F	; 
SECS0 EQU 0xF933     ;memory location for seconds
SECS1 EQU 0xF934     ;memory location for seconds
;
BEGIN:		LXI H, MESSAGE ;set HL pointer to start of message data
			CALL DISPLAY       ;display message
			LXI H, SECS1 ; SECS+1 = 0xF933+1 = 0xF934
			MOV A, M
			CALL LCD
			LXI H, SECS0
			MOV A, M
			CALL LCD
			CALL CHGET
			JMP MENU
MESSAGE:	DS 'TIME = '
			DB 0x00 ;terminator
			RET


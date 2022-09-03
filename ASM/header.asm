ORG 0xDAC0
JP MAIN

; These are all ROM subroutines
DISPLAY EQU 0x5A58	; print message pointed to by HL
LCD EQU 0x4B44		; print character in register A
CHGET EQU 0x12CB	; wait for keypress
MENU EQU 0x5797		; main MODEL 100 menu
UNPLOT EQU 0x744C	; Turns on pixel at x (D), y (E), 0-239, 0,63
PLOT EQU 0x744D		; Turns off pixel at x (D), y (E), 0-239, 0,63
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
FCTAB DEFM 'FILES'
DEFW 0D80 ; F1
DEFM 'LOAD'
DEFW 0D80 ; F2
DEFM 'SAVE'
DEFW 0D80 ; F3
DEFM 'RUN'
DEFW 0D80 ; F4
DEFM 'LIST'
DEFW 0D80 ; F5
DEFW 80 ; F6 IGNORE
DEFW 80 ; F7 IGNORE
DEFM 'MENU'
DEFW 0D80 ; F8
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
MAKTXT EQU 0x220F	; Creates a text file
FILNAM EQU 0xFC93	; Filename 8 bytes max. .DO not required
					; DE = address of Directory entry (Flag)
					; C flag set if file already exists, else new file.
CHKDC EQU 0x5AA9	; Searches for a file in directory.
					; DE points to filename (0x00 terminated)
					; HL has start (TOP) address of file on return.
					; Z flag = 0 if found, 1 not found.
GTXTTB EQU 0x5AE3	; Gets TOP address of file
					; HL = address of directory entry.
					; HL = TOP start address on return.
KILASC EQU 0x1FBE	; Kills a text/DO file.
					; DE = file (TOP) start address
					; HL = address of Directory entry (Flag)
INSCHR EQU 0x6B61	; Inserts character in A into a file at position HL.
					; HL --> HL+1. Carry flag set if out of memory.
MAKHOL EQU 0x6B6D	; Inserts BC number of spaces in a file starting at position HL.
					; HL --> HL+1. Carry flag set if out of memory.
MASDEL EQU 0x6B9F	; Deletes BC number of characters in a file starting at position HL.
INITIO EQU 0x6CD6	; Cold-start reset
IOINIT EQU 0x6CE0	; Warm-start reset
MUSIC EQU 0x72C5	; Makes a tone. DE = frequency. B = Duration: in 1/50th of a second.
; ==============================================
;					OCTAVE
; ==============================================
;Note	1		2		3		4		5
; G		12538	6269	3134	1567	783
; G#	11836	5918	2959	1479	739
; A		11172	5586	2793	1396	698
; A#	10544	5272	2636	1318	659
; B		9952	4976	2488	1244	622
; C		9394	4697	2348	1174	587
; C#	8866	4433	2216	1108	554
; D		8368	4184	2092	1046	523
; D#	7900	3950	1975	987		493
; E		7456	3728	1864	932		466
; F		7032	3516	1758	879		439
; F#	6642	3321	1660	830		415
; ==============================================
TIME EQU 0x190F		; Reads system time. HL = 8-byte address area for TIME, returned as hh:mm:ss.
DATE EQU 0x192F		; Reads system date. HL = 8-byte address area for DATE, returned as mm:dd:yy.
DAY	EQU 0x1962		; Reads system day of the week. HL = 3-byte address area for DAY, returned as ddd.


; Variables
SECS EQU 0xF933		; memory location for seconds
CSRY EQU 0xF639		; CURSOR Y POSITION
CSRX EQU 0xF63A		; CURSOR X POSITION
BEGLCD EQU 0xFE00	; Beginning of LCD memory
ENDLCD EQU 0xFF40	; End of LCD memory --> 0x140 320 bytes : 40 chars x 8 lines
STAT EQU 0xF65B		; Current RS232 settings, 5-byte string:
					; baud, length, parity, stop bits, XON/XOFF
DIRTBL EQU 0xF962	; Directory table
					; Byte 1		Directory flag (file type and status)
					;	bits 0-2	reserved
					;	bit 3		1: invisible file
					;	bit 4		1: ROM file
					;	bit 5		1: machine language file (CO)
					;	bit 6		1: text file (DO)
					;	bit 7		1: valid entry
					; Bytes 2-3		Address of file
					; Bytes 4-11	Filename

MAIN: ; main entry point
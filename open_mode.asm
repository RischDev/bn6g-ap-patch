input	equ	"Megaman Battle Network 6 - Cybeast Gregar (U).gba"
fspace	equ	0x7FE400

.gba
.open input,"combined.gba",8000000h

.org fspace+8000000h
.align 2

writeStoryFlags:
	;set all the story flags to just after beating Gregar
	ldr r0,=flags			;r0 = addr for flags
	ldr r1,=flagValues		;r1 = addr for flags in ram
	mov r2, 14h
	@@writeloop:
		ldrh r3, [r0]
		mov r4, 2h
		lsl r4, 24
		orr r3, r4
		ldrb r4, [r1]
		strb r4, [r3]
		add r0, 2h
		add r1, 1h
		sub r2, 1h
		bne @@writeloop
	
	bx lr					;return
	
writeArea:
	;set the area to Lans Room
	ldr r0,=2001B84h		;r0 = addr for area?
	mov r1,01h				;r1 = area?
	strb r1,[r0]			;write r1 into r0
	
	ldr r0,=2001B85h		;r0 = addr for subarea?
	mov r1,2h				;r1 = subarea?
	strb r1,[r0]			;write r1 into r0
	
	bx lr					;return

writeProgress:
	;set the progress byte to post-Gregar
	ldr r1,=02001B86h		;r1 = progress byte addr
	mov r0,64h				;r0 = progress value
	strb r0,[r1]			;write r0 into r1
	
	;set music progress to just before panic
	ldr r1,=02001B87h		;r1 = progress byte addr
	mov r0,61h				;r0 = progress value
	strb r0,[r1]			;write r0 into r1
	
	bx lr					;return

customRoutine:
	;Complete instruction that would otherwise get overwritten
	strb r1, [r0,r2]
	push r0-r3
	
	bl writeStoryFlags
	bl writeArea
	bl writeProgress
	
	pop r0-r7,r15
	
.pool

flags:
	.dh 0x18B0, 0x18B1, 0x18B2, 0x18B3, 0x1C89, 0x1C8A, 0x1C8E, 0x1C98
	.dh 0x1CAC, 0x1D08, 0x1D09, 0x1D0B, 0x1D0A, 0x1D15, 0x1D89, 0x1DC8
	.dh 0x1D97, 0x1E23, 0x1E4A, 0x1E54
	
flagValues:
	.db 0x20, 0x20, 0x20, 0x20, 0xFC, 0x40, 0x2F, 0x67, 0x82, 0x7F, 0xF9, 0x99, 0xFF, 0x83, 0x02, 0x02
	.db 0x00, 0x60, 0xFC, 0xE0
	
	
.align 4
.pool
.org 8142774h
mainHook:
	;Set main hook that triggers when you press new game
	ldr r0,=customRoutine|1b
	bx r0

.pool

;Close file and finish
.close
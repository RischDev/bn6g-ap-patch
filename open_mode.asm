input	equ	"Megaman Battle Network 6 - Cybeast Gregar (U).gba"
fspace	equ	0x7FFBD0

.gba
.open input,"combined.gba",8000000h

.org fspace+8000000h
.align 2

writeStoryFlags:
	;set all the story flags to just after beating Gregar
	ldr r0,=flags			;r0 = addr for flags
	ldr r1,=flagValues		;r1 = addr for flags in ram
	mov r2, 2h
	@@writeloop:
		ldr r3, [r0]
		ldr r4, [r1]
		strb r4, [r3]
		add r0, 4h
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
	.word 0x02001c8e, 0x02001d08
	
flagValues:
	.db 0x6F, 0x7F
	
	
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
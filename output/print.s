	SET PUSH, X
	SET PUSH, Y
	SET PUSH, Z
	SET PUSH, I
	SET PUSH, J
	SET A, SP
	SET PUSH, A
	SET Y, 0x7000
	SUB SP, 2 ; Alloc space on stack
	ADD PC, 6
	:c0 DAT "HELLO", 0
	SET A, c0
	BOR A, 0x8000
	SET [0xffff], A
	ADD PC, 6
	:c1 DAT "WORLD", 0
	SET A, c1
	BOR A, 0x8000
	SET [0xfffe], A
	ADD PC, 6
	:c2 DAT "World", 0
	SET A, c2
	BOR A, 0x8000
	SET [0xffff], A
	ADD PC, 7
	:c3 DAT "Hello ", 0
	SET A, c3
	BOR A, 0x8000
	JSR print
	SET A, [0xffff]
	JSR print
	JSR printnl
	ADD PC, 19
	:c4 DAT "A sentence within ", 0
	SET A, c4
	BOR A, 0x8000
	JSR print
	ADD PC, 14
	:c5 DAT "the same line", 0
	SET A, c5
	BOR A, 0x8000
	JSR print
	JSR printnl
	SET J, POP
	SET I, POP
	SET Z, POP
	SET Y, POP
	SET X, POP
	SET A, POP
	SET SP, A
	SET PC, end
	
	; compiled functions
	:getkey
	SET A, [0x9000]
	SET [0x9000], 0
	SET PC, POP
	:strlen
	SET I, A
	:strlen1
	ADD I, 1
	IFN [I], 0x0
	SET PC, strlen1
	SET A, B
	SET PC, POP
	:printchar
	SET [0x8000+X], A
	BOR [0x8000+X], Y
	ADD X, 1
	IFG X, 0x21f
	SET X, 0
	:pnline
	SET PC, POP
	:printint
	SET I, 0
	:printint1
	SET B, A
	MOD A, 0xa
	ADD A, 0x30
	SET PUSH, A
	SET A, B
	DIV A, 0xa
	ADD I, 1
	IFN A, 0
	SET PC, printint1
	:printint2
	SET A, POP
	JSR printchar
	SUB I, 1
	IFN I, 0
	SET PC, printint2
	SET A, POP
	SET PC, POP
	:printstr
	IFG 0xF000, A
	AND A, 0x7fff
	SET I, A
	:printstr1
	IFE [I], 0
	SET PC, POP
	SET A, [I]
	JSR printchar
	ADD I, 1
	SET PC, printstr1
	:printnl
	DIV X, 32
	ADD X, 1
	MUL X, 32
	SET PC, POP
	:print
	SET B, A
	SHR B, 15
	IFE B, 0
	JSR printint
	IFE B, 1
	JSR printstr
	SET PC, POP
	:end
	IFN SP, 0
	SET PC, POP
	:halt
	SET PC, halt
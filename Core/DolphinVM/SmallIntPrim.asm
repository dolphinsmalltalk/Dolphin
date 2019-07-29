;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Dolphin Smalltalk
;;
;; SmallInteger Primitives
;;	- arithmetic
;;	- relational
;;	- bit manipulation
;;	- byte accessing
;;
;; N.B. It is worth bearing in mind that these primitives are not actually much
;; used, because of the inlined byte code equivalents.

INCLUDE IstAsm.Inc


.LISTALL
;.LALL

.CODE PRIM_SEG

ASSUME	_IP:PTR BYTE			; Interpreters instruction pointer
ASSUME	_BP:PTR Oop				; Interpreters BP (base pointer - points at first arg/temp of method)
ASSUME	_SP:PTR Oop				; Interpreters SP (stack pointer)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Imports

;; Helpers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	SmallInteger arithmetic primitives
;;
;;	These are invoked for the arithmetic selectors by the Interpreter
;;	for any occurrence of the special arithmethic selectors +, -, * etc
;;	regardless of argument types. The primitives are expected to very
;;	quickly fail if the receiver, in particular, is not a SmallInteger.
;;	For this reason, all these primitives test first that the receiver
;;	is a SmallInteger, and subsequently that the argument is a SmallInteger.


;  int __fastcall Interpreter::primitiveMod()
;
; Can only succeed if argument is a SmallInteger
;
BEGINPRIMITIVE primitiveMod
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		ecx, [_SP]						; Load argument from stack
	sar		eax, 1							; Convert from SmallInteger
   	IFDEF _DEBUG
		jc		@F							; Its a SmallInteger, continue
		int		3							; Not a SmallInteger, debug break
	@@:
   	ENDIF

	sar		ecx, 1							; Extract integer value of arg
	mov		edx, eax						; Sign extend part 1
	jnc		localPrimitiveFailureInvalidParameter1	; Arg not a SmallInteger

	sar		edx, 31							; ... complete sign extend into edx		(v)

	idiv	ecx

	test	eax,eax							; test Quotient
	mov		eax, 1
	jg		@F								; If positive, skip adjust
	test	edx,edx							; test remainder
	jz		@F								; if exact skip adjust
	xor		ecx,edx							; test sign of numerator and denominator
	jns		@F								; non-negative, skip adjust
	xor		ecx,edx							; reverse previous XOR
	add		edx,ecx							; adjust remainder by numerator
@@:
	add		eax, edx
	add		eax, edx

	mov		[_SP-OOPSIZE], eax				; Replace stack top integer with remainder

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

LocalPrimitiveFailure PrimitiveFailureInvalidParameter1

ENDPRIMITIVE primitiveMod

;  int __fastcall Interpreter::primitiveDiv()
; 
; This primitive (associated with integer division selector //) does work when
; division is not exact (so this is the same as primitiveDivide, but without check
; for exact division). Note that in Smalltalk integer divide truncates towards
; negative infinity, not zero. This is achieved by exploiting a neat property of
; binary division - we leave the numerator shifted left one place and divide,
; getting the right SmallInteger result (once flag or'd back). This gives us
; rounding in the right direction (toward negative infinity rather than zero)
;
BEGINPRIMITIVE primitiveDiv
	mov		eax, [_SP-OOPSIZE]				; (u) Access receiver at stack top
	mov		ecx, [_SP]						; (v) Load argument from stack
	sar		eax, 1							; (u) Convert from SmallInteger

	sar		ecx, 1							; Extract integer value of arg
	mov		edx, eax						; (v) Sign extend eax ...				(u)
	jnc		localPrimitiveFailureInvalidParameter1	; Arg not a SmallInteger

	sar		edx, 31							; ... complete sign extend into edx		(v)

	idiv	ecx

	test	eax, eax						; Quotient?
	jg		@F								; greater than zero
	test	edx, edx						; Remainder?
	jz		@F								; zero
	xor		ecx,edx							; numerator/remainder signed
	jns		@F								; no, skip
	dec		eax								; adjust negative

@@:
	add		eax, eax						; Convert to SmallInteger
	mov		ecx, eax
	jo		overflow						; Overflow possible if divide by -1
	
	or		eax, 1							; Add SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

overflow:
	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	mov		[_SP-OOPSIZE], eax				; Overwrite receiver with new object
	AddToZct <a>
	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

LocalPrimitiveFailure PrimitiveFailureInvalidParameter1

ENDPRIMITIVE primitiveDiv

;  int __fastcall Interpreter::primitiveQuo()
; 
; As above but with truncation toward zero (like C integer division)
;
BEGINPRIMITIVE primitiveQuo
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		ecx, [_SP]						; Load argument from stack
	sar		eax, 1							; Remove receiver's SmallInteger flags
	sar		ecx, 1							; Extract integer value of arg
	mov		edx, eax						; (v) Sign extend eax ...				(u)

	jnc		localPrimitiveFailureInvalidParameter1	; Arg not a SmallInteger

	sar		edx, 31							; ... complete sign extend into edx		(v)
	idiv	ecx

	mov		ecx, eax
	add		eax, eax
	jo		overflow						; Overflow possible if divide by -1
	
	or		eax, 1							; Add SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

overflow:
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	mov		[_SP-OOPSIZE], eax				; Overwrite stack top with new object
	AddToZct <a>
	lea		eax, [_SP-OOPSIZE]
	ret

LocalPrimitiveFailure PrimitiveFailureInvalidParameter1

ENDPRIMITIVE primitiveQuo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _declspec(naked) int __fastcall Interpreter::primitiveBitShift()
;;
;; N.B. We use _BP to cache stack pointer here because cl needed for shift
;;
;; Can only succeed if argument is a SmallInteger
;;
DECLAREPRIMITIVE primitiveBitShift
public arithmeticBitShift

ALIGNPRIMITIVE
?primitiveBitShift@Interpreter@@SIPAIQAII@Z:
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top

arithmeticBitShift:
	ASSUME	eax:SDWORD						; eax contains SmallInteger receiver's SDWORD value

	mov		ecx, [_SP]						; Load argument from stack
	mov		edx, eax						; Sign extend into edx from eax part 1
	sar		ecx, 1							; Access integer value
	jnc		bsLocalPrimitiveFailureInvalidParameter1	; Not a SmallInteger, primitive failure
	js		rightShift						; If negative, perform right shift (simpler)

	; Perform a left shift (more tricky sadly because of overflow detection)

	sub		eax, 1							; Remove SmallInteger sign bit
	jz		@F								; If receiver is zero, then result always zero

	cmp		ecx, 30							; We can't shift more than 30 places this way, since receiver not zero
	jge		bsLocalPrimitiveFailureIntegerOverflow

	; To avoid using a loop, we use the double precision shift first
	; to detect potential overflow.
	; This overflow check works, but is slow (about 12 cycles)
	; since the majority of shifts are <= 16, perhaps should loop?
	push 	_BP								; We must preserve _BP
	sar		edx, 31							; Sign extend part 2
	inc		ecx								; Need to check space for sign too
	mov		_BP, edx						; Save sign in _BP too
	shld	edx, eax, cl					; May overflow into edx
	dec		ecx
	xor		edx, _BP						; Overflowed?
	pop		_BP
	jnz		bsLocalPrimitiveFailureIntegerOverflow	; Yes, LargeInteger needed

	sal		eax, cl							; No, perform the real shift

@@:
	or		eax, 1							; Replace SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

bsLocalPrimitiveFailureInvalidParameter1:
	PrimitiveFailureCode PrimitiveFailureInvalidParameter1

bsLocalPrimitiveFailureIntegerOverflow:
	PrimitiveFailureCode PrimitiveFailureIntegerOverflow

rightShift:
							
	neg		ecx								; Get shift as absolute value
	.IF (ecx > 31)							; Will the shift remove all significant bits
		mov		ecx, 31
	.ENDIF

	sar		eax, cl							; Perform the shift
	or		eax, 1							; Replace SmallInteger flag

	mov		[_SP-OOPSIZE], eax				; Replace stack top integer

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

END

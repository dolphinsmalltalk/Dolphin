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

LINEWARRAY2 EQU ?liNewArray2@@YIPAVArrayOTE@@II@Z
extern LINEWARRAY2:near32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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


;  int __fastcall Interpreter::primitiveDivide()
;
; Divide fails if the receiver or arg non-SmallInteger, if arg is 0,
; if result inexact (Smalltalk backup code creates a Fraction)
;
; Can only succeed if argument is a SmallInteger
;
BEGINPRIMITIVE primitiveDivide
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	sar		eax, 1							; Convert from SmallInteger
	mov		ecx, [_SP]						; Load argument from stack
	sar		ecx, 1							; Extract integer value of arg
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger
	
	; Division by zero does not fail the primitive, rather we allow an int division fault to be raised and trapped
	
	cdq										; Sign extend into edx
	idiv	ecx
	or		edx, edx						; Test remainder in edx
	jnz		localPrimitiveFailure2			; Inexact, fail primitive

	; N.B. Overflow is possible if min. SmallInteger negated by division by -1
	add		eax, eax
	mov		ecx, eax
	jo		overflow
	
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

localPrimitiveFailure0:
localPrimitiveFailure2:
	xor		eax, eax
	ret

ENDPRIMITIVE primitiveDivide


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
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger

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

localPrimitiveFailure0:
	xor		eax, eax
	ret

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
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger

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

localPrimitiveFailure0:
	xor		eax, eax
	ret

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

	jnc		localPrimitiveFailure0			; Arg not a SmallInteger

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

localPrimitiveFailure0:
	xor		eax, eax
	ret

ENDPRIMITIVE primitiveQuo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _declspec(naked) int __fastcall Interpreter::primitiveBitShift()
;;
;; N.B. We use _BP to cache stack pointer here because cl needed for shift
;;
;; Can only succeed if argument is a SmallInteger
;;
public ?primitiveBitShift@Interpreter@@CIPAIQAII@Z
public arithmeticBitShift

ALIGNPRIMITIVE
?primitiveBitShift@Interpreter@@CIPAIQAII@Z:
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top

arithmeticBitShift:
	ASSUME	eax:SDWORD						; eax contains SmallInteger receiver's SDWORD value

	mov		ecx, [_SP]						; Load argument from stack
	mov		edx, eax						; Sign extend into edx from eax part 1
	sar		ecx, 1							; Access integer value
	jnc		bsLocalPrimitiveFailure0		; Not a SmallInteger, primitive failure
	js		rightShift						; If negative, perform right shift (simpler)

	; Perform a left shift (more tricky sadly because of overflow detection)

	sub		eax, 1							; Remove SmallInteger sign bit
	jz		@F								; If receiver is zero, then result always zero

	cmp		ecx, 30							; We can't shift more than 30 places this way, since receiver not zero
	jge		bsLocalPrimitiveFailure1

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
	jnz		bsLocalPrimitiveFailure1		; Yes, LargeInteger needed

	sal		eax, cl							; No, perform the real shift

@@:
	or		eax, 1							; Replace SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

bsLocalPrimitiveFailure0:
bsLocalPrimitiveFailure1:
	xor		eax, eax
	ret

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

;
; BOOL __fastcall Interpreter::primitiveSmallIntegerAt()
;
; Returns the specified byte (with 1 being least significant, 4 most significant)
; of the absolute value of the receiver
;
; Assumes receiver is SmallInteger
;
; Can only succeed if argument is a SmallInteger
;
BEGINPRIMITIVE primitiveSmallIntegerAt
	mov		ecx, [_SP]						; Load argument from stack
	sar		ecx, 1							; Argument is a SmallInteger?
	jnc		localPrimitiveFailure0			; No, primitive failure
	jz		localPrimitiveFailure1			; Index = 0?
	cmp		ecx, 4							; Index > 4? (treat as unsigned)
	ja		localPrimitiveFailure1			; Yes, out of bounds
	lea		ecx, [ecx*8-8]					; cl := (cl-1)*8 (number of bit shifts)

	mov		eax, [_SP-OOPSIZE]				; Access receiver underneath argument
	or		eax, eax						; Negative eax?
	jns		positive
	sar		eax, 1							; Must be more careful with Negative numbers
	neg		eax
	sar		eax, cl
	and		eax, 0FFh						; 8 bits only
	add		eax, eax						; Shift left 1 bit

	or		eax, 1							; Add SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

positive:
	; Access byte of positive SmallInteger
	sar		eax, cl							; byte :=  (receiver >> ((arg-1)*8)) & 0xFF
	and		eax, 01FEh						; 8 bits only

	or 		eax, 1							; Add SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret										; Succeed, eax is non-zero as a SmallInteger

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1

ENDPRIMITIVE primitiveSmallIntegerAt

END

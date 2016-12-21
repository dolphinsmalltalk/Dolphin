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
;; Exports

public primitiveAdd
public primitiveSubtract
public primitiveLessThan
public primitiveGreaterThan
public primitiveLessOrEqual
public primitiveGreaterOrEqual
public primitiveEqual
;public primitiveNotEqual
public primitiveMultiply
public primitiveDivide
public primitiveMod
public primitiveDiv
public primitiveQuoAndRem
public primitiveQuo
public primitiveBitAnd
public primitiveAnyMask
public primitiveAllMask
public primitiveBitOr
public primitiveBitXor
public primitiveBitShift
public primitiveSmallIntegerAt
public primitiveHighBit
public primitiveLowBit
public NewSigned
public NewUnsigned
public arithmeticBitShift

LINEWARRAY2 EQU ?liNewArray2@@YIPAV?$TOTE@VArray@ST@@@@II@Z
extern LINEWARRAY2:near32

extern primitiveFailure0:near32
extern primitiveFailure1:near32
extern primitiveFailure2:near32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Imports

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers

;; Oop __fastcall NewSigned(SDWORD value)
;; Instantiate a new signed integer object from the 32-bit integer value in ecx
;; Creates either a SmallInteger, or LargePositive/NegativeInteger as appropriate
;;
ALIGNPRIMITIVE
NewSigned PROC
	add		ecx, ecx						; Will it fit into a SmallInteger
	mov		eax, ecx
	jo		@F								; No, more than 31 bits required (will return to my caller)
	inc		eax								; Yes, create SmallInteger to return in EAX
	ret
@@:
	rcr		ecx, 1							; Revert to non-shifted value
	jmp		LINEWSIGNED						; Return to caller with Oop of new Signed Integer in eax
NewSigned ENDP


;; Oop __fastcall NewUnsigned(SDWORD value)
;; Instantiate a new signed integer object from the 32-bit integer value in ecx
;; Creates either a SmallInteger, or LargePositive/NegativeInteger as appropriate
;;
ALIGNPRIMITIVE
NewUnsigned PROC
	add		ecx, ecx						; Will it fit into a SmallInteger
	mov		eax, ecx
	jo		@F								; No, more than 31 bits required (will return to my caller)
	js		@F								; No, won't be positive SmallInteger
	inc		eax								; Yes, create SmallInteger to return in EAX
	ret
@@:
	rcr		ecx, 1										; Revert to non-shifted value
	jmp		LINEWUNSIGNED32
NewUnsigned ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	SmallInteger arithmetic primitives
;;
;;	These are invoked for the arithmetic selectors by the Interpreter
;;	for any occurrence of the special arithmethic selectors +, -, * etc
;;	regardless of argument types. The primitives are expected to very
;;	quickly fail if the receiver, in particular, is not a SmallInteger.
;;	For this reason, all these primitives test first that the receiver
;;	is a SmallInteger, and subsequently that the argument is a SmallInteger.

; _declspec(naked) BOOL __fastcall Interpreter::primitiveAdd()
;
; Send Arithmetic Selector+ is the most commonly occuring instruction, so performance
; very critical here.
; Note that the receiver and arguments do not need to be shifted (though one SmallInteger
; flag bit must be reset).
; No reference counting is necessary because a stack item is only overwritten with a
; SmallInteger, and this can only happen if that item is a SmallInteger.
;
; Leaves stack in a clean state (no ref. counted objects above _SP)
;
BEGINPRIMITIVE primitiveAdd
	mov		ecx, [_SP-OOPSIZE]				; Access receiver underneath argument
   	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
   	ENDIF
	mov		eax, [_SP]						; Load argument from stack
	test	al, 1							; Argument is a SmallInteger?
	jz		localPrimitiveFailure0				; No, primitive failure

	sub		_SP, OOPSIZE					; Pop argument
	dec		ecx								; Clear bottom bit of receiver (arithmetic can then be done without shifting)
	add		ecx, eax						; Perform the actual addition
	jo		@F								; If overflowed SmallInteger bits then create a large integer

	;; Normal, and fastest, case; SmallInteger + SmallInteger yields SmallInteger
	mov		[_SP], ecx						; Replace stack top integer
	ret										; Succeed, eax is non-zero (contains SmallInteger value)

@@:
	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew
	ret										; When called from primitive, eax non-zero, so will succeed

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveAdd


;_declspec(naked) int __fastcall Interpreter::primitiveSubtract()
;
; N.B. Neither SmallInteger needs to be right shifted
;
; Leaves stack in a clean state (no ref. counted objects above _SP)
;
BEGINPRIMITIVE primitiveSubtract
	mov		ecx, [_SP-OOPSIZE]				; Load receiver
	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		eax, [_SP]						; Load argument
	test	al, 1							; Argument is SmallInteger
	jz		localPrimitiveFailure0

	sub		_SP, OOPSIZE
	dec		eax								; Clear args SmallInteger bit
	sub		ecx, eax						; Perform the actual subtraction
	jo		@F								; If underflowed SmallInteger bits then create a large integer

	mov		[_SP], ecx						; Replace stack top integer
	mov		al, 1
	ret										; Succeed (non-zero eax)

@@:
	cmc
	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew					; Replace stack top with new signed, large, integer
	ret										; When called from primitive, eax non-zero, so will succeed

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveSubtract


;  int __fastcall Interpreter::primitiveMultiply()
;
; N.B. Only the argument need be right shifted
;
; Leaves stack in a clean state (no ref. counted objects above _SP)
;
BEGINPRIMITIVE primitiveMultiply
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	IFDEF _DEBUG
		test	al, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		edx, [_SP]						; Load argument from stack
	sar		edx, 1							; Extract integer value of arg
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger
	dec		eax								; Clear SmallInteger flag of receiver
	imul	edx
	jo		localPrimitiveFailure1			; If overflowed SmallInteger bits then primitive failure

	or		eax, 1							; Replace SmallInteger flag bit
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE
	ret										; Succeed (non-zero eax as its a SmallInteger)

localPrimitiveFailure0:
	jmp		primitiveFailure0

localPrimitiveFailure1:
	jmp		primitiveFailure1

ENDPRIMITIVE primitiveMultiply


;  int __fastcall Interpreter::primitiveDivide()
;
; Divide fails if the receiver or arg non-SmallInteger, if arg is 0,
; if result inexact (Smalltalk backup code creates a Fraction)
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveDivide
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	sar		eax, 1							; Convert from SmallInteger
   	IFDEF _DEBUG
		jc		@F							; Its a SmallInteger, continue
		int		3							; Not a SmallInteger, debug break
	@@:
   	ENDIF
	mov		ecx, [_SP]						; Load argument from stack
	sar		ecx, 1							; Extract integer value of arg
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger
	
	; We now allow a fault to occur which we catch
	;jz		localPrimitiveFailure1			; Catch division by zero
	
	cdq										; Sign extend into edx
	idiv	ecx
	or		edx, edx						; Test remainder in edx
	jnz		localPrimitiveFailure2			; Inexact, fail primitive

	; N.B. Overflow is possible if min. SmallInteger negated by division by -1
	add		eax, eax
	mov		ecx, eax
	jo		@F
	inc		eax

	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE
	ret										; Success (eax is non-zero as SmallInteger)

@@:
	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew					; Replace stack top with new signed, large, integer
	ret										; When called from primitive, eax non-zero, so will succeed

localPrimitiveFailure0:
	jmp		primitiveFailure0

localPrimitiveFailure2:
	jmp		primitiveFailure2

ENDPRIMITIVE primitiveDivide


;  int __fastcall Interpreter::primitiveMod()
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
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
	PopStack								; It'll work, pop arg

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
	;lea		eax, [edx+edx+1]				; Recreate SmallInteger from edx
	mov		[_SP], eax						; Replace stack top integer with remainder
	ret

localPrimitiveFailure0:
	jmp		primitiveFailure0

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
   	IFDEF _DEBUG
		jc		@F							; Its a SmallInteger, continue
		int		3							; Not a SmallInteger, debug break
	@@:
   	ENDIF

	sar		ecx, 1							; Extract integer value of arg
	mov		edx, eax						; (v) Sign extend eax ...				(u)
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger

	sar		edx, 31							; ... complete sign extend into edx		(v)

	idiv	ecx
	PopStack								; It worked, pop arg

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
	jo		@F								; Overflow possible if divide by -1
	inc		eax
	mov		[_SP], eax						; Replace stack top integer
	ret										; Succeed (eax contains non-zero (SmallInteger) value)

@@:
	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew					; Replace stack top with new signed, large, integer
	ret										; When called from primitive, eax non-zero, so will succeed

; Nice idea, but although works for -7//2 doesn't work for -11//5. OK as long as divisor is even.
;	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
;	mov		ecx, [_SP]						; Load argument from stack
;	dec		eax								; Remove receiver's SmallInteger flags
;	sar		ecx, 1							; Extract integer value of arg
;	jnc		localPrimitiveFailure0				; Arg not a SmallInteger
;
;	cdq										; Sign extend into edx
;	idiv	ecx
;
;	or		eax, 1							; Quicker even on PII to use whole register (i.e. eax rather than al)
;	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
;	sub		_SP, OOPSIZE					; Pop arg
;	ret										; Succeed (eax is Oop value (i.e. non-zero))

localPrimitiveFailure0:
	jmp		primitiveFailure0

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

	jnc		localPrimitiveFailure0				; Arg not a SmallInteger

	sar		edx, 31							; ... complete sign extend into edx		(v)
	idiv	ecx

	add		eax, eax
	mov		ecx, eax
	jo		@F								; Overflow possible if divide by -1
	inc		eax
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE					; Pop arg
	ret										; Succeed (eax is Oop value (i.e. non-zero))

@@:
	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew					; Replace stack top with new signed, large, integer
	ret										; When called from primitive, eax non-zero, so will succeed

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveQuo

;  int __fastcall Interpreter::primitiveQuoAndRem()
; 
; Yet another division primitive, but this time with truncation towards zero
; which is simple makes this the same as integer division in lesser languages
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveQuoAndRem
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		ecx, [_SP]						; Load argument from stack
	sar		eax, 1							; Convert from SmallInteger
   	IFDEF _DEBUG
		jc		@F							; Its a SmallInteger, continue
		int		3							; Not a SmallInteger, debug break
	@@:
   	ENDIF
	sar		ecx, 1							; Extract integer value of arg
	mov		edx, eax						; (v) Sign extend eax ...				(u)
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger

	sar		edx, 31							; ... complete sign extend into edx		(v)
	idiv	ecx

	sub		_SP, OOPSIZE					; Pop arg
	add		eax, eax						; Quotient is in eax

	jno		@F
	; Overflowed, must be division of -16r40000000 by -1, remainder must be zero
	mov		ecx, eax
	push	edx

	rcr		ecx, 1							; Revert to non-shifted value
	call	LINEWSIGNED						; 

	pop		edx
	jmp		skip
@@:
	inc	eax								; Add flag
skip:
	add		edx, edx						; Convert remainder into SmallInteger
	mov		ecx, eax						; Get quotient into ECX
	inc		edx								; Add flag for SmallInteger remainder

	call	LINEWARRAY2						; Construct 2-element quotient and remainder array
	ASSUME	eax:PTR OTE
	ReplaceStackTopWithNew					; Replace stack top integer with the 2-elem array array
	ret										; Succeed (eax is Oop value (i.e. non-zero))

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveQuoAndRem


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	SmallInteger relational operator primitives

; These relational comparisons are essentially the same, the only
; difference being the conditional jump used, so understand one
; and you understand them all. Most of the code is also the same
; as the SmallInteger arithmetic primitives, since it is mainly
; to check that the receiver and argument are indeed small
; integers.
; The return sequence is deliberately reproduced to avoid the need
; for an unconditional jump (3 cycles)


;  int __fastcall Interpreter::primitiveEqual()
; 
; Here we delay checking that arg is a SmallInteger until after
; equality comparison, since if receiver is a SmallInteger and
; argument compares equal, then the argument must be a SmallInteger.
; This saves us 2 cycles for the True case, costs us no more for
; the False case, but costs us a few extra cycles for the (rare)
; failure case where the argument is not a SmallInteger (more
; normally fails due to receiver not being a SmallInteger).
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveEqual
	mov		ecx, [_SP-OOPSIZE]				; Access receiver at stack top
   	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		eax, [oteTrue]					; Load True as default
	xor		ecx, [_SP]						; Receiver = arg?
	jz		@F								; Yes, result zero if equal

	test	cl, 1							; Arg was a SmallInteger?
	jnz		localPrimitiveFailure0			; No (bit wasn't cleared), primitive failure

	add		eax, OTENTRYSIZE				; Load False, arg was SmallInteger, but not equal
@@:
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer with boolean result
	sub		_SP, OOPSIZE
	ret										; Succeed (eax is non-zero - contains True/False Oop)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveEqual


;  int __fastcall Interpreter::primitiveNotEqual()
;
; Same optimisation as primtiveEqual where test for SmallInteger argument
; is delayed until we know receiver and argument are not equal
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
;BEGINPRIMITIVE primitiveNotEqual
;	mov		ecx, [_SP-OOPSIZE]				; Access receiver at stack top
;   	IFDEF _DEBUG
;		test	cl, 1						; Receiver is a SmallInteger?
;		jnz		@F							; Yes, continue
;		int		3							; No, debug break
;	@@:
;	ENDIF
;	mov		eax, [oteFalse]			; Load False as default
;	xor 	ecx, [_SP]						; receiver == arg? (will be zero)
;	jz		@F								; Yes, skip not equal handling (which must test arg)
;
;	test	cl, 1							; Not equal, but was arg a SmallInteger?
;	jnz		localPrimitiveFailure0				; No, primitive failure
;
;	mov		eax, [oteTrue]			; Yes, arg is SmallInteger, and Not Equal to receiver
;
;@@:
;	sub		_SP, OOPSIZE					; pop arg
;	mov		[_SP], eax						; Replace stack top integer with boolean result
;	ret										; Succeed (eax is non-zero - contains True/False Oop)
;primitiveNotEqual ENDP


;  int __fastcall Interpreter::primitiveLessThan()
; 
; When used in loops, e.g:
;
;	[ i < 1000 ] whileTrue: [ i := i + 1 ].
;
; the TRUE case is the more frequent, so optimise for that 
; (remember conditional jumps that are taken take 3 times 
; as long as those that are not). 13 cycles (+call and return)
; are needed for the TRUE case, 15 (+call&ret) for the FALSE case.
;
; We reproduce the postamble code for both true and false cases
; as though it takes a little more room, it saves a cycle for
; one case (which would be consumed by an unecessary mov instruction)
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveLessThan
	mov		ecx, [_SP-OOPSIZE]				; Access receiver under argument
   	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		edx, [_SP]						; Load argument from stack
	test	dl, 1							; Arg is a SmallInteger?
	jz		localPrimitiveFailure0				; No, primitive failure
				     	
	sub		_SP, OOPSIZE					; pop arg
	cmp		ecx, edx						; receiver < arg?
	mov		eax, [oteFalse]					; Default - not less than arg
	jge		@F
	sub		eax, OTENTRYSIZE				; Yes, receiver < arg
@@:
	mov		[_SP], eax						; Replace stack top integer with True/False
	ret										; Succceed (non-zero eax)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveLessThan


;  int __fastcall Interpreter::primitiveLessOrEqual()
;
; Again when used for loops, we assume the TRUE case is the more
; important
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveLessOrEqual
	mov		ecx, [_SP-OOPSIZE]				; Access receiver at stack top
   	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		edx, [_SP]						; Load argument from stack
	test	dl, 1							; Arg is a SmallInteger?
	jz		localPrimitiveFailure0				; No, primitive failure
				     	
	sub		_SP, OOPSIZE					; pop arg
	cmp		ecx, edx						; receiver <= arg?
	mov		eax, [oteFalse]
	jg		@F								; No, receiver > arg
	sub		eax, OTENTRYSIZE				; Yes, receiver <= arg
@@:
	mov		[_SP], eax						; Replace stack top integer with True/False
	ret										; Yes it worked, in 15 cycles

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveLessOrEqual


;  int __fastcall Interpreter::primitiveGreaterThan()
;
; In this case we make the false case marginally faster, as frequently
; > is used in whileFalse loops
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveGreaterThan
	mov		ecx, [_SP-OOPSIZE]				; Access receiver at stack top
   	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		edx, [_SP]						; Load argument from stack
	test	dl, 1							; Arg is a SmallInteger?
	jz		localPrimitiveFailure0				; No, primitive failure

	sub		_SP, OOPSIZE					; pop arg
	cmp		ecx, edx
	mov		eax, [oteTrue]					; Yes
	jg		@F								; receiver > arg?
	add		eax, OTENTRYSIZE				; No
@@:
	mov		[_SP], eax						; Replace stack top integer with True/False
	ret										; Yes it worked, in 18 cycles

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveGreaterThan


;  int __fastcall Interpreter::primitiveGreaterOrEqual()
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveGreaterOrEqual
	mov		ecx, [_SP-OOPSIZE]				; Access receiver at stack top
   	IFDEF _DEBUG
		test	cl, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	mov		edx, [_SP]						; Load argument from stack
	test	dl, 1							; Arg is a SmallInteger?
	jz		localPrimitiveFailure0					; No, primitive failure

	sub		_SP, OOPSIZE					; pop arg
	cmp		ecx, edx						; receiver >= arg?
	mov		eax, [oteTrue]
	jge		@F								; Yes
	add		eax, OTENTRYSIZE				; No
@@:
	mov		[_SP], eax						; Replace stack top integer with True/False
	ret										; Yes it worked, in 18 cycles

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveGreaterOrEqual


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SmallInteger Bit Manipulation Primitives

; _declspec(naked) int __fastcall Interpreter::primitiveBitAnd()
;
; Here we cleverly make use of the semantics of AND to reduce
; checking of SmallInteger flags. Not also that no shifting is
; necessary. This reduces successful invocations to a mere
; 6 cycles (plus call and return overhead if applicable)
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveBitAnd
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		ecx, [_SP]
	and		eax, ecx						; Perform the bitwise op with arg
	test	al, 1							; Result a SmallInteger
	jz		localPrimitiveFailure0				; No, receiver or Arg not a SmallInt
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE
	ret										; Yes it worked (any bitAnd of two SmallIntegers must have bottom bit set)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveBitAnd


; _declspec(naked) int __fastcall Interpreter::primitiveBitOr()
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveBitOr
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		edx, [_SP]						; Load argument from stack
   	IFDEF _DEBUG
		test	al, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	test	dl, 1							; Arg is a SmallInteger?
	jz		localPrimitiveFailure0				; No, primitive failure
	; There is no need to shift or clear the SmallInteger flag
	or		eax, edx						; Perform the actual bitwise op
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE
	ret										; Yes it worked (eax contains a SmallInteger, so non-zero)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveBitOr

; _declspec(naked) int __fastcall Interpreter::primitiveAnyMask()
;
BEGINPRIMITIVE primitiveAnyMask
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		edx, [_SP]
	mov		ecx, [oteTrue]					; Load True as default answer
	and		eax, edx						; Perform the bitwise op with arg
	test	al, 1							; Result a SmallInteger
	jz		localPrimitiveFailure0				; No, receiver or Arg not a SmallInt
	cmp		eax, SMALLINTZERO
	jne		@F								; Some bits masked in, so skip to answer true
	add		ecx, SIZEOF OTE					; Convert answer to false
@@:
	mov		[_SP-OOPSIZE], ecx				; Overwrite receiving integer with boolean result
	sub		_SP, OOPSIZE
	ret										; Yes it worked (any bitAnd of two SmallIntegers must have bottom bit set)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveAnyMask

; _declspec(naked) int __fastcall Interpreter::primitiveAllMask()
;
BEGINPRIMITIVE primitiveAllMask
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		edx, [_SP]						; Load mask into edx
	mov		ecx, [oteTrue]					; Load True as default answer
	and		eax, edx 						; Perform the bitwise op with arg
	test	al, 1							; Result a SmallInteger
	jz		localPrimitiveFailure0				; No, receiver or Arg not a SmallInt
	cmp		eax, edx						; Does the masked value exactly equal the mask?
	je		@F								; Yes, then skip to answer true
	add		ecx, SIZEOF OTE					; Convert answer to false
@@:
	mov		[_SP-OOPSIZE], ecx				; Overwrite receiving integer with boolean result
	sub		_SP, OOPSIZE
	ret										; Yes it worked (any bitAnd of two SmallIntegers must have bottom bit set)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveAllMask

; _declspec(naked) int __fastcall Interpreter::primitiveBitXor()
;
; As for BitAnd can take advantage of semantics of Xor to reduce
; checking, but not quite so much.
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
;
BEGINPRIMITIVE primitiveBitXor
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
	mov		ecx, [_SP]
   	IFDEF _DEBUG
		test	al, 1						; Receiver is a SmallInteger?
		jnz		@F							; Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF
	xor		eax, ecx						; Perform the actual bitwise op
	test	al, 1							; Bottom bit cleared if both SmallIntegers?
	jnz		localPrimitiveFailure0
	inc		eax								; Replace SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE
	ret										; Succeed (non-zero (SmallInteger) return eax)

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveBitXor


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _declspec(naked) int __fastcall Interpreter::primitiveBitShift()
;;
;; N.B. We use _BP to cache stack pointer here because cl needed for shift
;;
;; Can only succeed if argument is a SmallInteger, so clean stack maintained
;;
ALIGNPRIMITIVE
primitiveBitShift:
	mov		eax, [_SP-OOPSIZE]				; Access receiver at stack top
   	IFDEF _DEBUG
		test	al, 1
		jnz		@F							; SmallInteger? Yes, continue
		int		3							; No, debug break
	@@:
	ENDIF

arithmeticBitShift:
	ASSUME	eax:SDWORD						; eax contains SmallInteger receiver's SDWORD value

	mov		ecx, [_SP]						; Load argument from stack
	mov		edx, eax						; Sign extend into edx from eax part 1
	sar		ecx, 1							; Access integer value
	jnc		bsLocalPrimitiveFailure0				; Not a SmallInteger, primitive failure
	js		rightShift						; If negative, perform right shift (simpler)

	; Perform a left shift (more tricky sadly because of overflow detection)

	cmp		ecx, 30							; We can't shift more than 30 places this way
	jge		bsLocalPrimitiveFailure0

	; To avoid using a loop, we use the double precision shift first
	; to detect potential overflow.
	; This overflow check works, but is slow (about 12 cycles)
	; since the majority of shifts are <= 16, perhaps should loop?
	dec		eax								; Remove SmallInteger sign bit
	push 	_BP								; We must preserve _BP
	sar		edx, 31							; Sign extend part 2
	inc		ecx								; Need to check space for sign too
	mov		_BP, edx						; Save sign in _BP too
	shld	edx, eax, cl					; May overflow into edx
	dec		ecx
	xor		edx, _BP						; Overflowed?
	pop		_BP
	jnz		bsLocalPrimitiveFailure0				; Yes, LargeInteger needed

	sal		eax, cl							; No, perform the real shift

	or		eax, 1							; Replace SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	PopStack
	ret										; Yes it worked (eax is SmallInteger, therefore non-zero)

bsLocalPrimitiveFailure0:
	jmp		primitiveFailure0

rightShift:
	PopStack								; OK, it'll work
							
	neg		ecx								; Get shift as absolute value
	.IF (ecx > 31)							; Will the shift remove all significant bits
		mov		ecx, 31
	.ENDIF

	sar		eax, cl							; Perform the shift
	or		eax, 1							; Replace SmallInteger flag
	mov		[_SP], eax						; Replace stack top integer
	ret										; Yes it worked (eax is non-zero)

;
; BOOL __fastcall Interpreter::primitiveSmallIntegerAt()
;
; Returns the specified byte (with 1 being least significant, 4 most significant)
; of the absolute value of the receiver
;
; Assumes receiver is SmallInteger
;
; Can only succeed if argument is a SmallInteger, so clean stack maintained
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
	jns		@F
	sar		eax, 1							; Must be more careful with Negative numbers
	neg		eax
	sar		eax, cl
	and		eax, 0FFh						; 8 bits only
	add		eax, eax						; Shift left 1 bit

	inc		eax								; Add SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE					; Pop argument
	ret										; Succeed, eax is non-zero as a SmallInteger
@@:
	; Access byte of positive SmallInteger
	sar		eax, cl							; byte :=  (receiver >> ((arg-1)*8)) & 0xFF
	and		eax, 01FEh						; 8 bits only

	inc 	eax								; Add SmallInteger flag
	mov		[_SP-OOPSIZE], eax				; Replace stack top integer
	sub		_SP, OOPSIZE					; Pop argument
	ret										; Succeed, eax is non-zero as a SmallInteger

localPrimitiveFailure0:
	jmp		primitiveFailure0

	
localPrimitiveFailure1:
	jmp		primitiveFailure1

ENDPRIMITIVE primitiveSmallIntegerAt


; Only reason for having a primitive to do this is that there is a single assembler
; instruction to do the job, and its a short easy routine to write.
BEGINPRIMITIVE primitiveHighBit
	mov		ecx, [_SP]
	test	ecx, ecx
	js		localPrimitiveFailure0				; If negative then fail it
	bsr		eax, ecx						; Actually quite handy that shifted left one, as we'll get 1-based index!
	lea		eax, [eax+eax+1]
	mov		[_SP], eax
	ret

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveHighBit

; Ditto
BEGINPRIMITIVE primitiveLowBit
	mov		ecx, [_SP]
	xor		eax, eax						; Must clear in case value is zero
	dec		ecx								; Remove flag bit (as otherwise would always find that)
	bsf		eax, ecx						; Actually quite handy that shifted left one, as we'll get 1-based index!
	lea		eax, [eax+eax+1]
	mov		[_SP], eax
	ret

localPrimitiveFailure0:
	jmp		primitiveFailure0

ENDPRIMITIVE primitiveLowBit

END

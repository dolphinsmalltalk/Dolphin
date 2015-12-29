; Dolphin Smalltalk
; Floating Point Primitive routines and helpers in Assembler for IX86
; (Blair knows how these work, honest)
;
INCLUDE IstAsm.Inc

.CODE FPPRIM_SEG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exports

PRIMPROC EQU PROC PUBLIC			; Export all the primtives defined herein

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imports

extern primitiveFailure0:near32


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helpers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedures

; Converts a SmallInteger to a float, therefore no ref. counting for stack overwrite
BEGINPRIMITIVE primitiveAsFloat
	mov		eax, [_SP]
	sar		eax, 1

	; Use stack as working space to convert integer receiver to Float
	push	eax
	fild	DWORD PTR [esp]
	pop		eax

	; While we're waiting for the result, we can allocate the object to hold it
	call	NEWFLOATOBJ
	ASSUME	eax:PTR OTE					; Return value is OTE of new float
	
	mov		ecx, [eax].m_location
	ASSUME	ecx:PTR Float

	; Finally go and get the value (should now be ready)
	fstp	QWORD PTR [ecx].m_fValue
	ASSUME	ecx:NOTHING

	ReplaceStackTopWithNew
	
	ASSUME	eax:DWORD					; Still contains Oop so will be non-zero for success
	ret

ENDPRIMITIVE primitiveAsFloat


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

PrimitiveFloatOp MACRO op

	BEGINPRIMITIVE primitiveFloat&op
		;mov		[INSTRUCTIONPOINTER], _IP			; Saved down IP in case of FP fault
		mov		edx, [_SP]							; Load arg

		mov		ecx, [_SP-4]						; Load receiver
		ASSUME	ecx:PTR OTE							; Receiver must be float, therefore an OTE

		test	dl, 1								; Arg is SmallInteger
		mov		ecx, [ecx].m_location				; Load pointer to receiver object for later use
		ASSUME	ecx:PTR Float
		
		.IF (ZERO?)
		
			; Arg is not a SmallInteger - only proceed if a Float
			ASSUME	edx:PTR OTE
			mov		eax, [edx].m_oteClass
			ASSUME	eax:PTR OTE

			mov		edx, [edx].m_location				; Load pointer to float contents in anticipation
			ASSUME	edx:PTR Float

			cmp		eax, [Pointers.ClassFloat]
			jne		primitiveFloatOpFailure0

			fld		[ecx].m_fValue
			f&op	[edx].m_fValue						; Perform the operation on the FP stack's two top values

			; Make space on stack to store result			
			sub		esp, SIZEOF QWORD

		.ELSE
			ASSUME	edx:SDWORD
			
			fld		[ecx].m_fValue						; Push receiver on FP stack

			; Now divide by the SmallInteger arg (have to move to memory to do this)
			sar		edx, 1

			push	edx									; Temporarily place integer arg on stack
			fi&op	DWORD PTR [esp]						; Apply op with integer arg (needs to be in memory)
			
			; Make space for result
			push	eax
			;pop		edx
		.ENDIF

		; Note that any FP fault may not occur until we attempt to store down the value, and therefore
		; We must not pop the receiver until after we have done that (sadly)

		; In a debug build, we want to ensure ref. count correctness for our assertion checks
		; and this means we can't allocate the object until after doing the FSTP, as the instruction
		; may raise an FP exception for over/underflow. In the release build, we don't care about
		; leaving around a little garbage for the next GC cycle to deal with when exceptions occur
		IF 1; DEF _DEBUG
			; Make temporary space on the machine stack to store the result
			;sub		esp, SIZEOF QWORD
			fstp	QWORD PTR [esp]
			;fwait								; Overflow is possible at this point if too large
			
			call	NEWFLOAT8
			fwait								; Overflow is possible at this point if too large
		ELSE
			; While we're waiting for the result, we can allocate the object to hold it
			call	NEWFLOATOBJ
			ASSUME	eax:PTR OTE					; Return value is OTE of new float
		
			mov		edx, [eax].m_location
			ASSUME	edx:PTR Float

			fstp	QWORD PTR [edx].m_fValue
			fwait								; Overflow is possible at this point if too large
		ENDIF
		
		; If we get to here, then we know FP fault is not going to occur, so we can adjust ST stack

		mov		[_SP-OOPSIZE], eax							; Overwrite receiver...
		sub		_SP, OOPSIZE
		AddToZct <a>

		ASSUME	eax:Oop
		ret

	primitiveFloatOpFailure0:
		jmp		primitiveFailure0

	ENDPRIMITIVE primitiveFloat&op
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Add, Multiply, Subtract and Divide primitives are identical apart from the
;; machine instruction required to perform the actual operation, so

PrimitiveFloatOp <Add>
PrimitiveFloatOp <Mul>
PrimitiveFloatOp <Sub>
PrimitiveFloatOp <Div>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

PrimitiveFloatCmp MACRO op, mask

	BEGINPRIMITIVE primitiveFloat&op
		mov		ecx, [_SP-OOPSIZE]					; Load receiver
		ASSUME	ecx:PTR OTE
		mov		edx, [_SP]							; Load arg
		test	dl, 1								; Arg is SmallInteger

		mov		[INSTRUCTIONPOINTER], _IP			; Saved down IP in case of FP fault

		mov		ecx, [ecx].m_location				; Load pointer to receiver object
		ASSUME	ecx:PTR Float

		jnz		cmpSmallInteger						; Skip to SmallInteger arg version

		ASSUME	edx:PTR OTE

		mov		eax, [edx].m_oteClass				; Load class of argument
		ASSUME	eax:PTR OTE

		; Arg is not a SmallInteger - only continue if a Float
		mov		edx, [edx].m_location				; Load point to argument body into EDX

		cmp		eax, [Pointers.ClassFloat]
		jne		primitiveFloatCmpFailure0

		ASSUME	edx:PTR Float

		fld		[ecx].m_fValue
		fcomp	[edx].m_fValue
		fstsw	ax										;; Get the fp flags into AX

		;; FP exception can't occur after this point, so we can now adjust stack
		ASSUME	ecx:NOTHING

		test	ah, mask							;; C? set
		mov		eax, [oteTrue]
		jnz		@F
		add		eax, OTENTRYSIZE					;; False immediately follows true
	@@:
		mov		[_SP-OOPSIZE], eax					;; Overwrite receiver
		PopStack									;; Pop arg
		ret

	primitiveFloatCmpFailure0:
		jmp		primitiveFailure0
		
	cmpSmallInteger:
		ASSUME	ecx:PTR Float
		ASSUME	edx:SDWORD

		sar		edx, 1								; Convert to integer value
		PopStack									; Arg is SmallInteger, can't fail from here

		fld		[ecx].m_fValue						; Push receiver on FP stack

		; Now divide by the SmallInteger arg (have to move to memory to do this)

		push	edx									; Temporarily place integer arg on stack
		ficomp	DWORD PTR [esp]						; Apply op with integer arg (needs to be in memory)
		pop		edx									; tidy away temp

		ASSUME	edx:NOTHING
		ASSUME	ecx:NOTHING

	; Same as answerBoolean above
		fnstsw	ax									; Get the fp flags into AX
		test	ah, mask							; C? set
		
		mov		eax, [oteTrue]
		jnz		@F
		add		eax, OTENTRYSIZE					; False immediately follows true
	@@:
		mov		[_SP], eax							; Overwrite receiver
		ret

	ENDPRIMITIVE primitiveFloat&op
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Define the required comparisons using the macro. At present we only
; need #< and #=

PrimitiveFloatCmp <LT>, 1
PrimitiveFloatCmp <EQ>, 64

END

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helpers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedures

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

PrimitiveFloatOp MACRO op

	BEGINPRIMITIVE primitiveFloat&op
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
			
			; Make more space for result
			push	eax
		.ENDIF

		; Note that any FP fault may not occur until we attempt to store down the value, and therefore
		; We must not pop the receiver until after we have done that (sadly)

		; In a debug build, we want to ensure ref. count correctness for our assertion checks
		; and this means we can't allocate the object until after doing the FSTP, as the instruction
		; may raise an FP exception for over/underflow. In the release build, we don't care about
		; leaving around a little garbage for the next GC cycle to deal with when exceptions occur
		IF 1; DEF _DEBUG
			fstp	QWORD PTR [esp]
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
		AddToZct <a>
		lea		eax, [_SP-OOPSIZE]							; primitiveSuccess(1)

		ASSUME	eax:Oop
		ret

	primitiveFloatOpFailure0:
		xor		eax, eax
		ret

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

END

; Dolphin Smalltalk
; Primitive routines and helpers in Assembler for IX86
; (Blair knows how these work, honest)
;
; DEBUG Build syntax:
;		ml /coff /c /Zi /Fr /Fl /Sc /Fo /D_DEBUG /Fo WinDebug\primasm.obj primasm.asm
; RELEASE Build syntax:
;		ml /coff /c /Zi /Fr /Fl /Sc /Fo WinRel\primasm.obj primasm.asm
;
; this will generate debug info (Zi) and full browse info (Fr), and this is
; appropriate for debug and release versions, and a listing with timings

; Notes about __fastcall calling convention:
; - The first two args of DWORD or less size are passed in ecx and edx.
; - Other arguments are placed on the stack in the normal CDecl/Stdcall order
; - Return value is in EAX
; - In addition to preserving the normal set of registers, ESI
;	EDI, EBP, you must also preserve EBX (surprisingly),
;	and ES, FS AND GS (not surprisingly) for 32-bit Mixed language
;	programming
; - ECX, EDX and EAX are destroyed
;
; Other register conventions:
;	- 	ESI is used to hold the Smalltalk stack pointer
;	-	ECX is generally used to hold the Oop of the receiver
;	-	Assembler subroutines obey the fastcall calling convention
;
; N.B.
; I have tended to replicate small common code sequences to reduce jumps, as these
; are relatively expensive (3 cycles if taken) and performance is very important
; for the primitives. I have also used the unpleasant technique of jumping
; to a subroutine when I want it to return to my caller, and even (in at least
; one case) of popping a return address (gasp!). In certain critical places
; this is worth doing because of the high cost of a ret instruction (5 cycles on a 486).
;
; In order to try and keep the Pentium pipeline running at full tilt, instruction ordering is not always
; that you might expect. For example, MOV does not affect the flags, so MOV instructions may appear
; between tests/cmps and conditional jumps.
;

INCLUDE IstAsm.Inc

.CODE PRIM_SEG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exports

; Helpers
public @callPrimitiveValue@8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imports

;; Win32 functions
RaiseException		PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD
longjmp				PROTO C :DWORD, :DWORD

; Imports from byteasm.asm
extern activateBlock:near32
extern shortReturn:near32

; Imports from LargeIntPrim.CPP

normalizeIntermediateResult EQU ?normalizeIntermediateResult@@YGII@Z
extern normalizeIntermediateResult:near32

; C++ Variable imports

RESUSPENDACTIVEON EQU ?ResuspendActiveOn@Interpreter@@SIPAV?$TOTE@VLinkedList@ST@@@@PAV2@@Z
extern RESUSPENDACTIVEON:near32

RESCHEDULE EQU ?Reschedule@Interpreter@@SGHXZ
extern RESCHEDULE:near32

IFDEF _DEBUG
	extern ?checkReferences@ObjectMemory@@SIXXZ:near32
ENDIF

; Other C++ method imports

QUEUEINTERRUPT EQU ?queueInterrupt@Interpreter@@SGXPAV?$TOTE@VProcess@ST@@@@II@Z
extern QUEUEINTERRUPT:near32

; Note this function returns 'bool', i.e. single byte in al; doesn't necessarily set whole of eax
DISABLEINTERRUPTS EQU ?disableInterrupts@Interpreter@@SI_N_N@Z
extern DISABLEINTERRUPTS:near32

; We still need to import the C++ primitives that require a thunk to be called from assembler (the ones that change interpreter context)
IMPORTPRIMITIVE MACRO name
	extern ?&name&@Interpreter@@CIPAIQAII@Z:near32
ENDM

IMPORTPRIMITIVE primitiveAsyncDLL32Call
IMPORTPRIMITIVE primitiveValueWithArgs
IMPORTPRIMITIVE primitivePerform
IMPORTPRIMITIVE primitivePerformWithArgs
IMPORTPRIMITIVE primitivePerformWithArgsAt
IMPORTPRIMITIVE primitivePerformMethod
IMPORTPRIMITIVE primitiveValueWithArgsAt
IMPORTPRIMITIVE primitiveSignal
IMPORTPRIMITIVE primitiveYield
IMPORTPRIMITIVE primitiveResume
IMPORTPRIMITIVE primitiveWait
IMPORTPRIMITIVE primitiveSuspend
IMPORTPRIMITIVE primitiveSetSignals
IMPORTPRIMITIVE primitiveUnwindInterrupt
IMPORTPRIMITIVE primitiveSingleStep
IMPORTPRIMITIVE primitiveSignalAtTick
IMPORTPRIMITIVE primitiveProcessPriority
IMPORTPRIMITIVE primitiveTerminateProcess
IMPORTPRIMITIVE primitiveCoreLeft
IMPORTPRIMITIVE primitiveOopsLeft

; Macro for calling CPP Primitives which can change the interpreter state (i.e. may
; change the context), thus requiring the reloading of the registers which cache interpreter
; state
DEFINECONTEXTPRIM MACRO name
BEGINPRIMITIVE name&Thunk
	call	?&name&@Interpreter@@CIPAIQAII@Z			;; Transfer control to C++ primitive 
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		_BP, [BASEPOINTER]				;; _SP is always reloaded from EAX after executing a primitive
	ret
ENDPRIMITIVE name&Thunk
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data

.DATA

IFDEF _DEBUG
	_primitiveCounters DD	256 DUP (0)
	public _primitiveCounters
ENDIF

.CODE PRIM_SEG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedures

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; System Primitives

BEGINPRIMITIVE primitiveReturnFromInterrupt
	mov		edx, [_SP-OOPSIZE]					; Get return frame offset
	mov		ecx, [_SP]							; Get as return value suspendingList (may want to restore)

	sar		edx, 1								; Frame offset is a SmallInteger?
	jnc		localPrimitiveFailure0				; No - primitive failure 0

	add		edx, [ACTIVEPROCESS]				; Add offset back to active proc. base address to get frame address in edx
	sub		_SP, OOPSIZE*3						; Pop args
	or		edx, 1								; Convert to SmallInteger (addresses aligned on 4-byte boundary)

	call	shortReturn							; Return to interrupted frame (returning the suspendingList at the time of the interrupt)

	mov		ecx, [_SP]							; Pop suspendingList (returned) into ECX...
	sub		_SP, OOPSIZE

	;; State of Process (especially stack) should now be the same as on entry to the interrupt, assuming
	;; that the image's handler for it didn't have any nasty side effects

	cmp		ecx, [oteNil]						; Was it waiting on a list?
	jne		@F

	mov		eax, _SP							; Process was active, succeed and continue
	ret
@@:
	; The interrupted process was waiting/suspended

	mov		[STACKPOINTER], _SP
	mov		[INSTRUCTIONPOINTER], _IP

	;; VM Interrupt mechanism sends a suspending list argument of SmallInteger Zero
	;; if the process is suspended, rather than waiting on a list, so we must test
	;; for this case specially (in fact we just look for any SmallInteger).
	test	cl, 1								; Is the "suspendingList" a SmallInteger?
	jz		@F									; No, skip so "suspend on list"
	call	RESCHEDULE							; Just resuspend the process and schedule another
	; Load interpreter registers for new process
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		eax, [STACKPOINTER]
	mov		_BP, [BASEPOINTER]
	ret
		
@@:
	call	RESUSPENDACTIVEON
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		eax, [STACKPOINTER]
	mov		_BP, [BASEPOINTER]
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveReturnFromInterrupt
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGNPRIMITIVE
@callPrimitiveValue@8 PROC
	push	_SP									; Mustn't destroy for C++ caller
	push	_IP									; Ditto _IP
	push	_BP									; and _BP

	; Load interpreter registers
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		_SP, [STACKPOINTER]
	mov		_BP, [BASEPOINTER]
	call	?primitiveValue@Interpreter@@CIPAIQAII@Z
	mov		[STACKPOINTER], eax	
	pop		_BP									; Restore callers registers
	mov		[INSTRUCTIONPOINTER], _IP
	pop		_IP
	pop		_SP
	ret
@callPrimitiveValue@8 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int __fastcall Interpreter::primitiveValue(void*, unsigned argCount)
;
BEGINPRIMITIVE primitiveValue
	mov		eax, edx								; Get argument count into EAX
	neg		edx
	push	_BP
	lea		_BP, [_SP+edx*OOPSIZE]
	mov		ecx, [_BP]								; Load receiver (hopefully a block, we don't check) into ECX

	CANTBEINTEGEROBJECT<ecx>
	ASSUME	ecx:PTR OTE

	mov		edx, [ecx].m_location					; Load pointer to receiver
	ASSUME	edx:PTR BlockClosure

	cmp		al, [edx].m_info.argumentCount			; Compare arg counts
	jne		localPrimitiveFailure0					; No
	ASSUME	eax:NOTHING								; EAX no longer needed

	pop		eax										; Discard saved _BP which we no longer need

	mov		eax, [edx].m_receiver
	mov		[_BP], eax								; Overwrite receiving block with block receiver (!)

	; Leave SP point at TOS, BP to point at [receiver+1],  ECX contains receiver Oop, EDX pointer to block body
	add		_BP, OOPSIZE

	call	activateBlock							; Pass control to block activation routine in byteasm.asm. Expects ECX=OTE* & EDX = *block
	mov		eax, _SP								; primitiveSuccess(0)
	ret

localPrimitiveFailure0:
	pop	_BP											; Restore saved base pointer
	PrimitiveFailureCode 0

ENDPRIMITIVE primitiveValue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The entry validation is a copy of that from primitiveValue.
; The sender MUST be a MethodContext for this to work (i.e. pHome must point at the sender)
;
BEGINPRIMITIVE primitiveValueOnUnwind
	mov		ecx, [_SP-OOPSIZE]					; Load receiver (under the unwind block)
	CANTBEINTEGEROBJECT <ecx>					; Context not a real object (Blocks should always be objects)!!
	mov		edx, [ecx].m_location				; Load address of receiver into eax
	ASSUME	edx:PTR BlockClosure

	cmp		[edx].m_info.argumentCount, 0		; Must be a zero arg block ...
	jne		localPrimitiveFailure0				; ... if not fail it

	;; Past this point, the primitive is guaranteed to succeed
	;; Make room for the closure receiver on top of the unwind block for activateBlock 
	;; leaving the unwind block and the guarded receiver block on the stack of the caller
	add		_SP, OOPSIZE

	;; Replace the receiver of the calling method context with the special mark object
	;; The receiver's ref. count remains the same because it will be stored into the m_environment
	;; slot of the new stack frame by activateBlock.
	;; There are no arguments to move, because our receiver is a zero arg block
	mov		eax, [Pointers.MarkedBlock]
	push	[ACTIVEFRAME]
	mov		[_BP-OOPSIZE], eax					; Overwrite receiver of calling frame with mark block
	
	lea		_BP, [_SP+OOPSIZE]					; Set up BP for new frame

	; ECX mut be block Oop
	; EDX must be pointer to block body
	; _SP points at TOS
	; _BP points at [receiver+1] (i.e. already set up correctly)

	call	activateBlock
	pop		eax
	ASSUME eax:PStackFrame
	sub		[eax].m_sp, OOPSIZE*2
	mov		eax, _SP							; primitiveSuccess(0)
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveValueOnUnwind

ASSUME	eax:NOTHING
ASSUME	edx:NOTHING

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BEGINPRIMITIVE primitiveBecome
	mov		ecx, [_SP]
	mov		eax, [OBJECTTABLE]
	test	cl, 1
	jnz		localPrimitiveFailure0				; Can't swap SmallIntegers
	ASSUME	ecx:PTR OTE

	add		eax, FIRSTCHAROFFSET+256*OTENTRYSIZE
	cmp		ecx, eax
	jl		localPrimitiveFailure0

	mov		edx, [_SP-OOPSIZE]
	test	dl, 1
	jnz		localPrimitiveFailure0
	ASSUME	edx:PTR OTE

	cmp		edx, eax
	jl		localPrimitiveFailure0

	; THIS MUST BE CHANGED IF OTE LAYOUT CHANGED.
	; Note that we swap the location pointer (obviously), the class pointer (as we
	; aren't swapping the class), and flags. All belong with the object.
	; We don't swap the identity hash or count, as these belong with the pointer (identity)

	push	ebx

	; Exchange body pointers
	mov		ebx, [ecx].m_location
	mov		eax, [edx].m_location
	mov		[ecx].m_location, eax
	mov		[edx].m_location, ebx

	; Exchange class pointers
	mov		ebx, [ecx].m_oteClass
	mov		eax, [edx].m_oteClass
	mov		[ecx].m_oteClass, eax
	mov		[edx].m_oteClass, ebx

	; Exchange object sizes (I think it is right to swap immutability bit over too?)
	mov		ebx, [ecx].m_size
	mov		eax, [edx].m_size
	mov		[ecx].m_size, eax
	mov		[edx].m_size, ebx
	
	; Exchange first 8 bits of flags (exclude identityHash and ref. count)
	mov		bl, [ecx].m_flags
	mov		al, [edx].m_flags
	mov		[ecx].m_flags, al
	mov		[edx].m_flags, bl

	pop		ebx

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveBecome

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Queue an aysnchronous interrupt to the receiving process
BEGINPRIMITIVE primitiveQueueInterrupt
	mov		ecx, [_SP-OOPSIZE*2]				; Load Oop of receiver
	mov		edx, [_SP-OOPSIZE]					; Load interrupt number

	test	dl, 1								; 
	jz		localPrimitiveFailure0				; Not a SmallInteger

	mov		eax, (OTE PTR[ecx]).m_location
	mov		eax, (Process PTR[eax]).m_suspendedFrame
	cmp		eax, [oteNil]						; suspended context is nil if terminated
	mov		eax, [_SP]							; Load TOS (extra arg). Doesn't affect flags
	je		localPrimitiveFailure1

	push	eax									; ARG 3: opaque argument passed on the stack
	push	edx									; ARG 2: Interrupt number
	push	ecx									; ARG 1: Process Oop

	call	QUEUEINTERRUPT

	lea		eax, [_SP-OOPSIZE*2]				; primitiveSuccess(2)
	ret

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1

ENDPRIMITIVE primitiveQueueInterrupt

BEGINPRIMITIVE primitiveEnableInterrupts
	mov		eax, [_SP]							; Access argument
	xor		ecx, ecx
	sub		eax, [oteTrue]
	jz		@F

	cmp		eax, OTENTRYSIZE
	jne		localPrimitiveFailure0				; Non-boolean arg
	
	mov		ecx, 1								; arg=false, so disable interrupts

@@:
	call	DISABLEINTERRUPTS
	; N.B. Returns bool, so only AL will be set, not whole of EAX
	test	al, al								; Interrupts not previously disabled?
	je		@F									; Yes, answer true

	mov		ecx, [oteFalse]
	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	mov		[_SP-OOPSIZE], ecx
	ret

@@:
	mov		ecx, [oteTrue]
	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	mov		[_SP-OOPSIZE], ecx
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveEnableInterrupts

BEGINPRIMITIVE primitiveStructureIsNull
	mov		ecx, [_SP]								; Access argument
	ASSUME	ecx:PTR OTE
	mov		eax, [oteFalse]							; Use EAX for true/false so is non-zero on exit from primitive

	; Ok, it might still be an object whose first inst var might be an address
	mov		edx, [ecx].m_location					; Ptr to object now in edx
	ASSUME	edx:PTR ExternalStructure

	mov		edx, [edx].m_contents					; OK, so lets see if first inst var is the 'address' we seek
	sar		edx, 1									; First of all, is it a SmallInteger
	jc		zeroTest								; Yes, test to see if that is zero

	ASSUME	edx:PTR OTE								; No, its an object
	sal		edx, 1									; so revert to OTE
	test	[edx].m_flags, MASK m_pointer			; Is it bytes?
	je		@F

	mov		eax, [oteTrue]
	cmp		edx, [oteNil]
	jne		localPrimitiveFailure0					; Not nil, a SmallInteger, nor a byte object, so invalid
	jmp		answer									; Answer true (nil is null)
	
@@:
	mov		eax, [edx].m_oteClass					; Get oop of class of bytes into eax
	ASSUME	eax:PTR OTE

	mov		edx, [edx].m_location					; Get ptr to byte object into edx
	ASSUME	edx:PTR ByteArray						; We know we've got a byte object now

	mov		eax, [eax].m_location					; eax is ptr to class of object
	ASSUME	eax:PTR Behavior

	test	[eax].m_instanceSpec, MASK m_indirect	; Is it an indirection class?
	mov		eax, [oteFalse]
	jz		answer									; No, can't be null then

	ASSUME	edx:PTR ExternalAddress
	
	; Otherwise drop through and test the address to see if it is zero
	mov		edx, [edx].m_pointer					; Preload address value

zeroTest:
	ASSUME	edx:DWORD								; Integer pointer value
	ASSUME	ecx:PTR OTE								; Expected to contain pre-loaded "true"

	cmp		edx, 0
	jne		answer
	sub		eax, OTENTRYSIZE						; True immediately preceeds False in the OT

answer:
	mov		[_SP], eax
	mov		eax, _SP								; primitiveSuccess(0)
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveStructureIsNull

BEGINPRIMITIVE primitiveBytesIsNull
	mov		eax, [_SP]								; Access argument
	ASSUME	eax:PTR OTE
	mov		ecx, [oteFalse]							; Load ECX with default answer (false)

	mov		edx, [eax].m_size
	and		edx, 7fffffffh							; Mask out immutability bit
	cmp		edx, SIZEOF DWORD						; Must be exactly 4 bytes (excluding any header)

	jne		localPrimitiveFailure0					; If not 32-bits, fail the primitive

	mov		edx, [eax].m_location					; Ptr to object now in edx
	ASSUME	edx:PTR ByteArray						; We know we've got a byte object now

	mov		eax, _SP								; primitiveSuccess(0)

	.IF (DWORD PTR([edx].m_elements[0]) == 0)
		sub		ecx, OTENTRYSIZE					; True immediately preceeds False in the OT
	.ENDIF
	
	mov		[_SP], ecx
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveBytesIsNull

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LargeInteger primitives
;;
.CODE LIPRIM_SEG

;; Macro for operations for which the result is the receiver if the operand is zero
LIARITHMPRIMR MACRO Op 
	li&Op&Single EQU ?li&Op&Single@@YGIPAV?$TOTE@VLargeInteger@ST@@@@H@Z
	extern li&Op&Single:near32

	li&Op EQU ?li&Op&@@YGIPAV?$TOTE@VLargeInteger@ST@@@@0@Z
	extern li&Op&:near32

	BEGINPRIMITIVE primitiveLargeInteger&Op
		mov		eax, [_SP]
		mov		ecx, [_SP-OOPSIZE]							; Load receiver (under argument)
		ASSUME	ecx:PTR OTE

		.IF	(al & 1)										; SmallInteger?
			ASSUME	eax:Oop
			sar		eax, 1
			jz		noOp									; Operand is zero? - result is receiver
			push	eax
			push	ecx
			; N.B. SP not saved down here, so assumed not used by routine (which is independent)
			call	li&Op&Single
		.ELSE
			ASSUME	eax:PTR OTE

			mov		edx, [eax].m_oteClass
			cmp		edx, [Pointers.ClassLargeInteger]
			jne		localPrimitiveFailure0

			push	eax
			push	ecx
			call	li&Op
		.ENDIF

		; Normalize and return
		push	eax
		call	normalizeIntermediateResult
		test	al, 1
		mov		[_SP-OOPSIZE], eax						; Overwrite receiver class with new object
		jnz		noOp
		AddToZct <a>

	noOp:
		lea		eax, [_SP-OOPSIZE]						; primitiveSuccess(0)
		ret
		
	LocalPrimitiveFailure 0

	ENDPRIMITIVE primitiveLargeInteger&Op
ENDM

;; Macro for operations for which the result is zero if the operand is zero
LIARITHMPRIMZ MACRO Op 
	li&Op&Single EQU ?li&Op&Single@@YGIPAV?$TOTE@VLargeInteger@ST@@@@H@Z
	extern li&Op&Single:near32

	li&Op EQU ?li&Op&@@YGIPAV?$TOTE@VLargeInteger@ST@@@@0@Z
	extern li&Op&:near32

	BEGINPRIMITIVE primitiveLargeInteger&Op
		mov		eax, [_SP]
		ASSUME	eax:Oop
		mov		ecx, [_SP-OOPSIZE]							; Load receiver (under argument)
		ASSUME	ecx:PTR OTE

		.IF	(al & 1)										; SmallInteger?
			sar		eax, 1
			jz		zero
			push	eax
			push	ecx
			; N.B. SP not saved down here, so assumed not used by routine (which is independent)
			call	li&Op&Single
		.ELSE
			ASSUME	eax:PTR OTE

			mov		edx, [eax].m_oteClass
			ASSUME	edx:PTR OTE
			cmp		edx, [Pointers.ClassLargeInteger]
			jne		localPrimitiveFailure0

			push	eax
			push	ecx
			call	li&Op
		.ENDIF

		; Normalize and return
		push	eax
		call	normalizeIntermediateResult
		test	al, 1
		mov		[_SP-OOPSIZE], eax						; Overwrite receiver class with new object
		jnz		@F
		AddToZct <a>
	@@:
		lea		eax, [_SP-OOPSIZE]						; primitiveSuccess(1)
		ret

	zero:
		lea		eax, [_SP-OOPSIZE]						; primitiveSuccess(1)
		mov		[_SP-OOPSIZE], SMALLINTZERO
		ret
		
	LocalPrimitiveFailure 0

	ENDPRIMITIVE primitiveLargeInteger&Op
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
LIARITHMPRIMR Add

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
LIARITHMPRIMR Sub

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
LIARITHMPRIMZ Mul

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
LIARITHMPRIMZ BitAnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
LIARITHMPRIMR BitOr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
LIARITHMPRIMR BitXor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE PRIM_SEG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ Primitive Thunks
;; Thunks for control (context switching) primitives
;; Other C++ primitives no longer need thunks (the convention is to return the
;; adjusted stack pointer on success, or NULL on failure)

DEFINECONTEXTPRIM <primitiveAsyncDLL32Call>
DEFINECONTEXTPRIM <primitiveValueWithArgs>
DEFINECONTEXTPRIM <primitivePerform>
DEFINECONTEXTPRIM <primitivePerformWithArgs>
DEFINECONTEXTPRIM <primitivePerformWithArgsAt>
DEFINECONTEXTPRIM <primitivePerformMethod>
DEFINECONTEXTPRIM <primitiveValueWithArgsAt>
DEFINECONTEXTPRIM <primitiveSignal>
DEFINECONTEXTPRIM <primitiveSingleStep>
DEFINECONTEXTPRIM <primitiveYield>
DEFINECONTEXTPRIM <primitiveResume>
DEFINECONTEXTPRIM <primitiveWait>
DEFINECONTEXTPRIM <primitiveSuspend>
DEFINECONTEXTPRIM <primitiveTerminateProcess>
DEFINECONTEXTPRIM <primitiveSetSignals>
DEFINECONTEXTPRIM <primitiveProcessPriority>
DEFINECONTEXTPRIM <primitiveUnwindInterrupt>

;; The specification primitiveSignalAtTick requires that it immediately signal
;; the specified semaphore if the time has already passed, so we must call
;; it as potentially context switching primitive
DEFINECONTEXTPRIM <primitiveSignalAtTick>

BEGINPRIMITIVE primitiveIndexOfSP
	mov	ecx, [_SP-OOPSIZE]				; Receiver
	mov	eax, [_SP]						; Frame Oop (i.e. frame address + 1)
	test al, 1
	jz	 localPrimitiveFailure0
	
	sub	eax, OFFSET Process.m_stack
	mov	edx, (OTE PTR[ecx]).m_location	; Load address of object
	sub	eax, edx
	shr	eax, 1							; Only div byte offset by 2 as need a SmallInteger
	add	eax, 3							; Add 1 (to convert zero-based offset to 1 based index) and flag as SmallInteger
	mov	[_SP-OOPSIZE], eax
	lea	eax, [_SP - OOPSIZE]			; primitiveSuccess(1)
	ret
	
LocalPrimitiveFailure 0
	
ENDPRIMITIVE primitiveIndexOfSP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

;; This is actually the GC primitive, and it may switch contexts
;; because is synchronously signals a Semaphore (sometimes)
DEFINECONTEXTPRIM <primitiveCoreLeft>

;; This is actually a GC primitive, and it may switch contexts
;; because is synchronously signals a Semaphore (sometimes)
DEFINECONTEXTPRIM <primitiveOopsLeft>

END

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

; C++ Variable imports

RESUSPENDACTIVEON EQU ?ResuspendActiveOn@Interpreter@@SIPAV?$TOTE@VLinkedList@ST@@@@PAV2@@Z
extern RESUSPENDACTIVEON:near32

RESCHEDULE EQU ?Reschedule@Interpreter@@SGHXZ
extern RESCHEDULE:near32

IFDEF _DEBUG
	extern ?checkReferences@ObjectMemory@@SIXXZ:near32
ENDIF

; Other C++ method imports

; We still need to import the C++ primitives that require a thunk to be called from assembler (the ones that change interpreter context)
IMPORTPRIMITIVE MACRO name
	extern ?&name&@Interpreter@@SIPAIQAII@Z:near32
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
	call	?&name&@Interpreter@@SIPAIQAII@Z			;; Transfer control to C++ primitive 
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
	jnc		localPrimitiveFailureInvalidParameter1	; No - primitive failure 0

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

LocalPrimitiveFailure PrimitiveFailureInvalidParameter1

ENDPRIMITIVE primitiveReturnFromInterrupt
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGNPRIMITIVE
@callPrimitiveValue@8 PROC
	push	_SP
	push	_IP
	push	_BP

	; Load interpreter registers
	mov		_BP, [BASEPOINTER]
	mov		_SP, ecx
	mov		_IP, [INSTRUCTIONPOINTER]
	call	?primitiveValue@Interpreter@@SIPAIQAII@Z
	mov		[STACKPOINTER], eax	
	mov		[INSTRUCTIONPOINTER], _IP
	pop		_BP
	pop		_IP
	pop		_SP
	ret
@callPrimitiveValue@8 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int PRIMCALL Interpreter::primitiveValue(void*, primargcount_t argCount)
;
BEGINPRIMITIVE primitiveValue
	mov		eax, edx								; Get argument count into EAX
	neg		edx
	push	_BP										; Save base pointer in case we need it (if fail)
	lea		_BP, [ecx+edx*OOPSIZE]
	mov		ecx, [_BP]								; Load receiver (hopefully a block, we don't check) into ECX

	CANTBEINTEGEROBJECT<ecx>
	ASSUME	ecx:PTR OTE

	mov		edx, [ecx].m_location					; Load pointer to receiver
	ASSUME	edx:PTR BlockClosure

	cmp		al, [edx].m_info.argumentCount			; Compare arg counts
	jne		localPrimitiveFailureWrongNumberOfArgs	; No
	ASSUME	eax:NOTHING								; EAX no longer needed

	pop		eax										; Discard saved ebx which we no longer need

	; Leave SP point at TOS, BP to point at [receiver+1],  ECX contains receiver Oop, EDX pointer to block body
	add		_BP, OOPSIZE

	call	activateBlock							; Pass control to block activation routine in byteasm.asm. Expects ECX=OTE* & EDX = *block
	mov		eax, _SP								; primitiveSuccess(0)
	ret

localPrimitiveFailureWrongNumberOfArgs:
	pop	_BP											; Restore saved base pointer
	PrimitiveFailureCode PrimitiveFailureWrongNumberOfArgs

ENDPRIMITIVE primitiveValue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The entry validation is a copy of that from primitiveValue.
; The sender MUST be a MethodContext for this to work (i.e. pHome must point at the sender)
;
BEGINPRIMITIVE primitiveValueOnUnwind
	mov		ecx, [_SP-OOPSIZE]					; Load receiver block (under the unwind block)
	CANTBEINTEGEROBJECT <ecx>					; Context not a real object (Blocks should always be objects)!!
	mov		edx, [ecx].m_location				; Load address of receiver block into eax
	ASSUME	edx:PTR BlockClosure

	cmp		[edx].m_info.argumentCount, 0		; Must be a zero arg block ...
	jne		localPrimitiveFailureWrongNumberOfArgs		; ... if not fail it

	;; Past this point, the primitive is guaranteed to succeed
	;; The unwind block and the guarded receiver block are left on the stack of the caller
	;; with the new frame following these. activateBlock expects the block being activate
	;; to be in the receiver slot of that frame, so we copy the block there
	mov		[_SP+OOPSIZE], ecx
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

LocalPrimitiveFailure PrimitiveFailureWrongNumberOfArgs

ENDPRIMITIVE primitiveValueOnUnwind

ASSUME	eax:NOTHING
ASSUME	edx:NOTHING

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

;; This is actually the GC primitive, and it may switch contexts
;; because is synchronously signals a Semaphore (sometimes)
DEFINECONTEXTPRIM <primitiveCoreLeft>

;; This is actually a GC primitive, and it may switch contexts
;; because is synchronously signals a Semaphore (sometimes)
DEFINECONTEXTPRIM <primitiveOopsLeft>

END

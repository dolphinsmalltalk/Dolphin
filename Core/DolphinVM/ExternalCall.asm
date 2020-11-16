;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Dolphin Smalltalk
;;
;; External call function. Dynamically invoke external functions, converting
;; and pushing 32-bit values from objects on the Smalltalk stack
;;

INCLUDE IstAsm.Inc


.LISTALL
.LALL

.CODE FFI_SEG


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imports

NewExternalStructurePointer EQU ?NewPointer@ExternalStructure@ST@@SIPAV?$TOTE@VObject@ST@@@@PAV?$TOTE@VBehavior@ST@@@@PAX@Z
extern NewExternalStructurePointer:near32
NewExternalStructure EQU ?New@ExternalStructure@ST@@SIPAV?$TOTE@VObject@ST@@@@PAV?$TOTE@VBehavior@ST@@@@PAX@Z
extern NewExternalStructure:near32

NewAnsiString EQU ?New@?$ByteStringT@$0A@$0FE@VAnsiStringOTE@@D@ST@@SIPAVAnsiStringOTE@@PBD@Z
extern NewAnsiString:near32

NewAnsiStringFromUtf16 EQU ?New@?$ByteStringT@$0A@$0FE@VAnsiStringOTE@@D@ST@@SIPAVAnsiStringOTE@@PB_W@Z
extern NewAnsiStringFromUtf16:near32

NewUtf16String EQU ?New@Utf16String@ST@@SIPAVUtf16StringOTE@@PB_W@Z
extern NewUtf16String:near32
NewUtf16StringFromString EQU ?New@Utf16String@ST@@SIPAVUtf16StringOTE@@PAV?$TOTE@VObject@ST@@@@@Z
extern NewUtf16StringFromString:near32

NewBSTR EQU ?NewBSTR@@YIPAV?$TOTE@VExternalAddress@ST@@@@PAV?$TOTE@VObject@ST@@@@@Z
extern NewBSTR:near32

NewGUID EQU ?NewGUID@@YIPAV?$TOTE@VVariantByteObject@ST@@@@PAU_GUID@@@Z
extern NewGUID:near32

NewSigned64 EQU ?NewSigned64@Integer@ST@@SGI_J@Z
extern NewSigned64:near32
NewUnsigned64 EQU ?NewUnsigned64@Integer@ST@@SGI_K@Z
extern NewUnsigned64:near32

REQUESTCOMPLETION EQU ?OnCallReturned@OverlappedCall@@AAEXXZ
extern REQUESTCOMPLETION:near32

CharacterGetCodePoint EQU ?getCodePoint@Character@ST@@QBE_UXZ
extern CharacterGetCodePoint:near32

; We need to test the structure type specially
ArgSTRUCT	EQU		50

getDllCallAddress EQU ?GetDllCallProcAddress@Interpreter@@CIP6GHXZPAUExternalMethodDescriptor@DolphinX@@PAV?$TOTE@VExternalLibrary@ST@@@@@Z
extern getDllCallAddress:near32

atoi PROTO C :DWORD
GetProcAddress  PROTO STDCALL :HINSTANCE, :LPCSTR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exports

public callExternalFunction
public @asyncDLL32Call@16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Call Descriptor layout
	
CallDescriptor STRUCT 1t
	m_proc		DWORD	?
	m_callConv	BYTE	?
	m_argsLen	BYTE	?				; Length of the argument types part of the descriptor
	m_returnParm BYTE	?				; Return type parameter literal frame index (if required)
	m_return	BYTE	?				; Return type
	m_args		BYTE	0t DUP (?)		; Argument types
CallDescriptor ENDS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Macros

;; We'll use the accumulator to hold the argument we're currently processing
ARG		EQU		eax
RESULTR	EQU		a
RESULT	EQU		eax						; by convention EAX used for return value/result
RESULTB	EQU		al
RESULTW EQU		ax

ASSUME	eax:DWORD
;; And the ECX register as a general temp
TEMP	EQU		ecx
TEMPB	EQU		cl
TEMPW	EQU		cx
TEMP2	EQU		edx

DESCRIPTOR EQU	ebx
;; And the _IP register as the loop counter
INDEX	EQU		edi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These must all be different
ASSERTNEQU %_SP, %ARG
ASSERTNEQU %_SP, %INDEX
ASSERTNEQU %_SP, %TEMP
ASSERTNEQU %_SP, %TEMP2
ASSERTNEQU %_SP, %DESCRIPTOR

ASSERTNEQU %TEMP, %ARG
ASSERTNEQU %TEMP, %INDEX
ASSERTNEQU %TEMP, %TEMP2
ASSERTNEQU %TEMP, %DESCRIPTOR

ASSERTNEQU %TEMP2, %ARG
ASSERTNEQU %TEMP2, %INDEX
ASSERTNEQU %TEMP2, %TEMP
ASSERTNEQU %TEMP2, %DESCRIPTOR

ASSERTNEQU %INDEX, %ARG
ASSERTNEQU %INDEX, %TEMP
ASSERTNEQU %INDEX, %TEMP2
ASSERTNEQU %INDEX, %DESCRIPTOR

ASSERTEQU	%RESULT, <eax>				; We rely on this convention when answering the result


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
BEGINPRIMITIVE primitiveVirtualCall
	ASSUME	edx:DWORD

	mov		ecx, [NEWMETHOD]

	mov		eax, edx
	neg		eax

	mov		ecx, (OTE PTR[ecx]).m_location
	ASSUME	ecx:PTR CompiledCodeObj

	lea		eax, [_SP+eax*OOPSIZE]						; EAX now points at receiver in stack
	mov		eax, [eax]									; load receiver from stack into EAX

	ASSUME	eax:PTR OTE
	test	[eax].m_flags, MASK m_pointer
	jz		@F

	; TODO: Could the receiver ever be an immutable object here?
	cmp		[eax].m_size, OOPSIZE						; Must contain at least one pointer/address
	
	mov		eax, [eax].m_location
	ASSUME	eax:PTR ExternalStructure
	jb		localPrimitiveFailureInvalidPointer

	mov		eax, [eax].m_contents
	test	al, 1
	jnz		localPrimitiveFailureInvalidPointer
	ASSUME	eax:PTR OTE

	test	[eax].m_flags, MASK m_pointer
	jnz		localPrimitiveFailureInvalidPointer

@@:
	ASSUME	eax:PTR OTE									; At this point, EAX is OTE of 'this' pointer

	;; The primitive can no longer fail due to simple reasons, so start pushing args for call helper

	push	0											; ARG6: Overlapped? (no)
	push	OFFSET INTERPCONTEXT						; ARG5: Pointer to interpreters thread context
	push	ecx											; ARG4: Ptr to method

	mov		ecx, [ecx].m_aLiterals[0*OOPSIZE]			; Get descriptor Oop into ecx
	ASSUME	ecx:PTR OTE

	mov		ecx, [ecx].m_location
	ASSUME	ecx:PTR CallDescriptor						; ECX points at the descriptor

	push	ecx											; ARG3: descriptor
	push	edx											; ARG2: arg count
	
	; edx now free for other purposes
	ASSUME	edx:NOTHING

	; At this point EAX is the Oop of a byte object
	mov		edx, [eax].m_oteClass
	mov		eax, [eax].m_location
	ASSUME	eax:PTR ByteArray

	mov		edx, (OTE PTR[edx]).m_location
	ASSUME	edx:PTR Behavior
	.IF ([edx].m_instanceSpec & MASK m_indirect)
		mov		eax, (ExternalAddress PTR[eax]).m_pointer
;	.ELSE
;		add		eax, HEADERSIZE
	.ENDIF

	mov		ecx, [ecx].m_proc							; Get virtual call offset out of descriptor
	ASSUME	ecx:NOTHING

	mov		eax, DWORD PTR[eax]							; Load address of virtual function table from object
	push	DWORD PTR[eax+ecx]							; ARG1: Address of virtual function at offset in table

	; Can't jmp direct to callExternalFunction as needs its own stack frame for local vars
	call	callExternalFunction
	ret

	ASSUME	eax:NOTHING
	ASSUME	edx:NOTHING

LocalPrimitiveFailure PrimitiveFailureInvalidPointer

ENDPRIMITIVE primitiveVirtualCall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A fastcall function (ecx is pMethod, edx is argCount)
;; There is also an extra argument on the stack (the thread context) which we just
;; let pass through

@asyncDLL32Call@16:
asyncDLL32Call PROC STDCALL PUBLIC USES edi esi ebx,
	pOverlapped:DWORD,
	callContext:PTR InterpRegisters

	ASSUME	ecx:PTR CompiledCodeObj
	ASSUME	edx:DWORD

	mov		eax, callContext									; Load pointer to context from stack top
	ASSUME	eax:PTR InterpRegisters

	push	pOverlapped										; ARG6: Overlapped? (yes)
	push	eax												; ARG5: Pointer to thread context already atop of stack
	push	ecx												; ARG4: Ptr to compiled method (may need literals)

	; Needed to push args from process stack
	mov		_SP, [eax].m_stackPointer
	ASSUME	eax:NOTHING										; No longer required

	mov		ecx, [ecx].m_aLiterals[0*OOPSIZE]				; Get descriptor Oop into ecx
	mov		ecx, (OTE PTR[ecx]).m_location					; ObjectMemory::GetObj
	lea		ecx, (ByteArray PTR[ecx]).m_elements			; ecx points at the descriptor bytes

	push	ecx												; ARG3: argTypes

	mov		eax, DWORD PTR[ecx]								; Get proc address out of descriptor cache
	test	eax, eax										; Zero?

	push	edx												; ARG2: argCount
	jz		procAddressNotCached							; Proc address cached?

performCall:
	push	eax												; ARG1: cached proc address
	call	callExternalFunction
	ret														; eax will be non-zero as otherwise we'd not be here

procAddressNotCached:
	neg		edx
	mov		edx, [_SP+edx*OOPSIZE]
	call	getDllCallAddress								; Cache value 0, so lookup the proc address
	test	eax, eax										; Returns null if not a valid proc name
	jnz		performCall

	mov		edx, callContext
	ASSUME	edx:PTR InterpRegisters
	add		esp, 16											; Remove args pushed for aborted call
	mov		edx, [edx].m_pActiveProcess
	PrimitiveFailureCode PrimitiveFailureProcNotFound

asyncDLL32Call ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A fastcall function (ecx is pMethod, edx is argCount)
BEGINPRIMITIVE primitiveDLL32Call
	ASSUME	edx:DWORD

	mov		ecx, [NEWMETHOD]
	ASSUME	ecx:PTR OTE

	push	0												; ARG6: Overlapped? (no)
	push	OFFSET INTERPCONTEXT							; ARG5: Pointer to interpreters thread context

	mov		ecx, [ecx].m_location
	ASSUME	ecx:PTR CompiledCodeObj
	
	push	ecx												; ARG4: Ptr to compiled method (may need literals)

	mov		ecx, [ecx].m_aLiterals[0*OOPSIZE]				; Get descriptor Oop into ecx
	mov		ecx, (OTE PTR[ecx]).m_location					; ObjectMemory::GetObj
	lea		ecx, (ByteArray PTR[ecx]).m_elements			; ecx points at the descriptor bytes

	push	ecx												; ARG3: argTypes

	mov		eax, DWORD PTR[ecx]								; Get proc address out of descriptor cache
	test	eax, eax										; Zero?

	push	edx												; ARG2: argCount
	jz		procAddressNotCached							; Non-zero cache, no need to lookup the proc address

performCall:
	push	eax												; ARG1: cached proc address
	call	callExternalFunction
	ret

procAddressNotCached:
	neg		edx
	mov		edx, [_SP+edx*OOPSIZE]
	call	getDllCallAddress								; Cache value 0, so lookup the proc address
	test	eax, eax										; Returns null if not a valid proc name
	jnz		performCall

	add		esp, 20											; Remove args pushed for aborted call
	
	PrimitiveFailureCode PrimitiveFailureProcNotFound

ENDPRIMITIVE primitiveDLL32Call

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Process the next argument
;
LoopNext MACRO
	ASSUME	INDEX:DWORD
	ASSUME	ARG:Oop
	ASSUME	_SP:PTR Oop
	ASSUME	TEMP:DWORD

	dec		INDEX									; i--
	js		performCall								; No more args to push

	movzx	TEMP, ([DESCRIPTOR].m_args[INDEX])		; Load arg type from descriptor
	mov		ARG, [_SP]
	sub		_SP, OOPSIZE							; Point at next arg in stack
	jmp		pushOopTable[TEMP*SIZEOF DWORD]
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Push the specified value on the stack (32-bit) and process the next arg
;
PushLoopNext MACRO arg
	; pushes <arg> (contains 32-bit value from conversion case)
	push	arg
	LoopNext
ENDM

_AnswerResult MACRO
	ASSERTEQU	%_IP, <edi>						; May need to visit this if changed
	ASSERTNEQU	%_IP, %RESULT
	ASSERTNEQU	%TEMP, %RESULT
	ASSERTEQU %RESULT, <eax>

	;; Pop the arguments as the last action
	mov		edx, argCount
	ASSUME	edx:DWORD
	mov		ecx, callContext
	ASSUME	ecx:PTR InterpRegisters

	shl		edx, 2
	
	; Reload interpreter context registers
	mov		_IP, [ecx].m_instructionPointer
	mov		_SP, [ecx].m_stackPointer
	mov		_BP, [ecx].m_basePointer
	ASSUME	ecx:NOTHING

	sub _SP, edx								; Pop off the arguments, AFTER A COMPLETED CALL
	
	mov		[_SP], RESULT						; Answer the result
ENDM
	
AnswerResult MACRO
	_AnswerResult
	mov	eax, _SP								; primitiveSuccess(0)
	ret
ENDM

AnswerObjectResult MACRO
	ASSUME	eax:PTR OTE

	_AnswerResult
	AddToZct <a>
	mov	eax, _SP								; primitiveSuccess(0)
	ret	
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Answer an Integer result (could be SmallInteger, or a NEW LargeInteger)
;
AnswerOopResult MACRO
	ASSUME	eax:Oop									;; EAX contains SmallInteger or OTE*
	ASSERTEQU %RESULT, <eax>

	_AnswerResult
	.IF (!(al & 1))
		AddToZct <a>
	.ENDIF

	mov	eax, _SP								; primitiveSuccess(0)
	ret
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Invoke any function, pushing args from the Smalltalk stack according to the
;; argTypes descriptor. Fail if argument coercion fails, or if a function returns
;; an HRESULT failure code.
;;
;; This function should not be called from C++
;;	It modifies:
;;		_SP		(pops args, or on unwind loads from global)
;;		_IP		(reloads from interpreter register, value may change on unwind)
;;		_BP		(ditto)
;;

; N.B. I NO LONGER SAVE DOWN ESP, RELYING ON IT BEING RESET FROM EBP ON RETURN
; THIS MEANS THAT ANYTHING PUSHED BEFORE THE CALL MAY NOT BE ACCESSIBLE AFTER IT
; AS IF ITS A CDECL CALL (OR A CALL FAILURE) IT WILL STILL BE UNDERNEATH THE
; ARGUMENTS. FOR THIS REASON IT IS NECESSARY TO USE BP BASED ADDRESS TO SAVE THE
; ACTIVE FRAME (RATHER THAN JUST PUSHING IT ON THE STACK). IF YOU WANT TO SAVE
; THINGS ON THE STACK, THEN YOU MUST REINSTATE THE SAVING AND RESTORING OF ESP
; TO A VARIABLE REFERENCEABLE OFF EBP

callExternalFunction PROC NEAR STDCALL,
	pProc:PTR DWORD, 
	argCount:DWORD, 
	argTypes:PTR CallDescriptor, 
	method:PTR CompiledCodeObj,
	callContext:PTR InterpRegisters,
	pOverlapped:DWORD

	
	; We need EBP based address for these as we'll be modifying ESP
	LOCAL activeFrame:PStackFrame, returnStructure:PTR DWORD

	; Save off active frame, etc
	mov		eax, callContext
	mov		DESCRIPTOR, argTypes					; N.B. DESTROY VALUE OF _BP SO MUST RELOAD
	ASSUME	DESCRIPTOR:PTR CallDescriptor			; Use _IP to point at arg type in descriptor
	mov		eax, (InterpRegisters PTR[eax]).m_pActiveFrame
	mov		returnStructure, 0
	mov		activeFrame, eax

	cmp		[DESCRIPTOR].m_return, 40
	je		retStruct										; If not returning a >8 byte struct, then no need to make space for return on stack
	cmp		[DESCRIPTOR].m_return, ArgSTRUCT
	jne		@F
	
retStruct:

	; We're going to overwrite ECX and EDX so we mustn't ovewrite the one register we've established
	ASSERTNEQU %DESCRIPTOR, <ecx>
	ASSERTNEQU %DESCRIPTOR, <edx>

	;; Returning a 9+ byte structure by value, so we must make space for it on the stack!
	movzx	ecx, [DESCRIPTOR].m_returnParm			; Get return parm literal frame index into ECX
	
	; N.B. Before we need the INDEX, we'll use it as a temp
	mov		edx, [method]							; Load the method (NOT Interpreter::m_pMethod)
	ASSUME	edx:PTR CompiledCodeObj

	mov		edx, [edx].m_aLiterals[ecx*OOPSIZE]		; Load literal from frame
	ASSUME	edx:PTR OTE								; Now we have the ExternalStructure class in ecx

	mov		edx, [edx].m_location					; TEMP is pointer to class of object
	ASSUME	edx:PTR Behavior

	mov		cx, [edx].m_instanceSpec.m_extraSpec
	sub		esp, ecx								; Make the space
	mov		returnStructure, esp					; Save down the address for push as hidden parm

@@:
	; FROM NOW ON WE RESPECT USE OF THE REGISTER DEFINES FOR SAFETY

	ASSERTNEQU %INDEX, %DESCRIPTOR

	movzx	INDEX, [DESCRIPTOR].m_argsLen	; Get the length of the argument descriptor

	LoopNext								; Process the first arg

performCall:
	mov		eax, returnStructure
	test	eax, eax
	jz		@F							; If not returning a >8 byte struct, then no need pass hidden parameter

	; Push the extra hidden parm which points at the buffer for the return value
	push	eax

@@:
	call	DWORD PTR pProc				; Perform the actual call. Win32 exception may occur (e.g. GP fault)

	ASSERTNEQU	%TEMP, eax				; These registers potentially contain the return value
	ASSERTNEQU	%TEMP, edx

	cmp		pOverlapped, 0
	jz		@F

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Handle overlapped call return

	; Save the return value
	push	eax
	push	edx
	
	mov		ecx, pOverlapped					;; thiscall calling convention has "this" in ecx
	call	REQUESTCOMPLETION					;; Will not return if thread is unwound

	pop		edx
	pop		eax

	jmp		returnSwitch
@@:

	;; If not overlapped, must test for unwind
	mov		TEMP, callContext			; Get the current interpreter context
	mov		TEMP, (InterpRegisters PTR[TEMP]).m_pActiveFrame
	cmp		TEMP, activeFrame			; Is it still the active frame
	jne		unwindExit					; If not an unwind has been requested as this process had an error

returnSwitch:	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Dispatch via the return type lookup table
	;
	; N.B. CERTAIN RETURN ROUTINES ASSUME THAT TEMP IS CLEARED HERE AND LOAD ONLY THE BOTTOM BYTE!!
	;
	xor		TEMP, TEMP
	mov		TEMPB, [DESCRIPTOR].m_return
	jmp		[returnOopTable+TEMP*SIZEOF DWORD]


unwindExit:
	mov		eax, callContext
	ASSUME	eax:PTR InterpRegisters

	; Reload interpreter context registers - we must load them all (they'll have changed)
	mov		_SP, [eax].m_stackPointer
	mov		_IP, [eax].m_instructionPointer
	mov		_BP, [eax].m_basePointer
	ASSUME	eax:NOTHING
	
	; We succeed so as not to run Smalltalk code after primitive
	mov		eax, _SP									; primitiveSuccess(0)
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Typed pointer argument. Currently not implemented to do anything interesting.
;; Could access the class from the literal frame and compare it. We could then
;; implement a less complex coercion as we could be more strict about the allowable
;; argument types.
ExtCallArgCOMPTR:
ExtCallArgLP:
	dec		INDEX								; Ignore the argument type (could validate here)
	; Deliberately drop through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is one of the most complex types because we must allow
;;		SmallIntegers
;;		Nil
;;		Byte objects (whose address is passed)
;;		Indirection byte objects (whose contents are passed)
;;		Pointer objects whose first instance variable is a SmallInteger
;;		or byte object
;;
ExtCallArgLPVOID:
	ASSUME	ARG:Oop

	sar		ARG, 1									; Commonly pass SmallIntegers, so try to convert
	jc		pushLPVOIDLoopNext						; Yes, just push its integer value

	sal		ARG, 1									; No, revert to Oop
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer			; Is it a pointer object
	jz		@F										; No, skip to byte object handling

	cmp		ARG, [oteNil]							; OK its pointers, but is it nil?
	mov		TEMP, [ARG].m_size						; Preload size
	je		pushNil									; Yes, push as NULL

	and		TEMP, 7fffffffh
	cmp		TEMP, OOPSIZE							; Must have at least one inst var?

	; Ok, it might still be an object whose first inst var might be an address
	mov		ARG, [ARG].m_location					; Ptr to object now in ARG
	ASSUME	ARG:PTR ExternalStructure

	jl		preCallFail								; No, not big enough (zero inst vars)

	mov		ARG, [ARG].m_contents					; OK, so lets see if first inst var is the 'address' we seek
	sar		ARG, 1									; First of all, is it a SmallInteger
	jc		pushLPVOIDLoopNext						; Yes, push that as the address

	ASSUME	ARG:PTR OTE								; No, its an object
	sal		ARG, 1									; so revert to OTE
	test	[ARG].m_flags, MASK m_pointer			; Is it bytes?
	jne		preCallFail								; No, inst var not a byte object, which exhausts all the options

	; Drop though to byte object handling...

@@:	
	; Byte object handling

	mov		TEMP, [ARG].m_oteClass					; Get oop of class of bytes into TEMP
	ASSUME	TEMP:PTR OTE

	mov		ARG, [ARG].m_location					; Get ptr to byte object into ARG
	ASSUME	ARG:PTR ByteArray						; We know we've got a byte object now

;	add		ARG, HEADERSIZE							; ARG now points at first non-header byte of object
	mov		TEMP, [TEMP].m_location					; TEMP is ptr to class of object
	ASSUME	TEMP:PTR Behavior

	test	[TEMP].m_instanceSpec, MASK m_indirect	; Is it an indirection class?
	jz		pushLPVOIDLoopNext						; No, push pointer to object itself if not indirection
	
	mov		ARG, DWORD PTR[ARG]						; Yes, perform implicit indirection for ExternalAddresses (etc)

pushLPVOIDLoopNext:
	ASSUME	ARG:PTR BYTE							; On entry ARG contains the pointer we're pushing
	PushLoopNext <ARG>								; else push pointer out of object

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple. Permit only Characters

extCallArgCHAR:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	test	ARG, 1										; Is it a SmallInteger?
	jnz		preCallFail									; Yes, not valid (only Characters)
	ASSUME	ARG:PTR OTE									; No, its an object of unknown type

	mov		TEMP2, [ARG].m_oteClass
	ASSUME	TEMP:PTR OTE
	
	mov		TEMP, [ARG].m_location
	cmp		TEMP2, [Pointers.ClassCharacter]				; Is it a Character?

	jne		preCallFail									; No? Fail it
	ASSUME	ARG:PTR Character							; Yes

	call	CharacterGetCodePoint

	ASSUME	ARG:DWORD
	PushLoopNext <ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple permit only SmallIntegers in the range 0..255

extCallArgBYTE:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; Is is a SmallInteger?
	jnc		preCallFail									; No, fail it
	ASSUME	ARG:DWORD									; Yes, integer value now in ARG

	cmp		ARG, 0ffH									; 0..255?
	ja		preCallFail									; No too big (or negative), fail it

	PushLoopNext <ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple - permit only SmallIntegers in the range -128..127
extCallArgSBYTE:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; Is it a SmallInteger
	jnc		preCallFail									; No fail it
	ASSUME	ARG:DWORD									; Yes, integer value now in ARG

	cmp		ARG, 127									; Too large positively?
	jg		preCallFail									; Yes, fail it
	cmp		ARG, -128									; Too large negatively?
	jl		preCallFail									; Yes, fail it

	PushLoopNext <ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; #word - permit only SmallIntegers in the range 0..65535, and two byte objects

extCallArgWORD:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; Is it a SmallInteger
	jnc		@F											; Not Smallinteger, try for byte object/nil
	ASSUME	ARG:DWORD									; Yes, integer value now in ARG

	cmp		ARG, 65535									; 0..65535
	ja		preCallFail									; No, too big (or negative)

	PushLoopNext <ARG>

@@:
	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer				; Is it pointers?
	mov		TEMP, [ARG].m_size
	jnz		tryNil										; Yes, probably fail, but could be nil (passes as 0)

	and		TEMP, 7fffffffh								; Ignore immutability bit
	cmp		TEMP, SIZEOF WORD							; Consists of two bytes only?

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR ByteArray							; Yes, its a byte object

	jne		preCallFail									; No, wrong size
	movzx	ARG, WORD PTR([ARG].m_elements)				; Yes, zero extend to 32-bit value

	PushLoopNext <ARG>


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; #sword - permit SmallIntegers in the range 0..65535, and two byte objects

extCallArgSWORD:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; Is it a SmallInteger
	jnc		@F											; Not Smallinteger, try for byte object/nil
	ASSUME	ARG:DWORD									; Yes, integer value now in ARG

	cmp		ARG, -32768
	jl		preCallFail									; Too large negatively
	cmp		ARG, 32767
	jg		preCallFail									; Too large positively

	PushLoopNext <ARG>

@@:
	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer				; Is it pointers?
	mov		TEMP, [ARG].m_size
	jnz		tryNil										; Yes, probably fail, but could be nil (passes as 0)

	and		TEMP, 7fffffffh
	cmp		TEMP, SIZEOF WORD							; Consists of two bytes only?

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR ByteArray							; Yes, its a byte object

	jne		preCallFail									; No, wrong size

	movsx	ARG, WORD PTR([ARG].m_elements)				; Sign extend to 32-bit value in ECX

	PushLoopNext <ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Assume that most commonly SmallInteger will be passed, so shift in anticipation
; of that.

extCallArgINTPTR:
extCallArgSDWORD:
extCallArgHRESULT:
extCallArgNTSTATUS:
extCallArgErrno:
	ASSUME	ARG:Oop											; ARG is input Oop from dispatch loop
	
	sar		ARG, 1											; Is it a SmallInteger?
	.IF (!CARRY?)
		; Try for byte object/nil
		sal		ARG, 1										; Revert to OTE
		ASSUME	ARG:PTR OTE

		test	[ARG].m_flags, MASK m_pointer				; Is it pointers?
		mov		TEMP, [ARG].m_size
		jnz		tryNil										; Yes, probably fail, but could be nil (passes as 0)

		and		TEMP, 7fffffffh								; ignore immutability bit
		cmp		TEMP, SIZEOF DWORD							; Consists of four bytes only?

		mov		ARG, [ARG].m_location
		ASSUME	ARG:PTR LargeInteger						; 

		jne		preCallFail									; No, wrong size

		;; LargeInteger case requires no special treatment because 4-byte LIs have 
		;; same range and representation as a 2's complement SDWORD

		; Get the value out of the large integer
		mov		ARG, [ARG].m_digits[0]						; Load the value
		ASSUME	ARG:DWORD

	.ENDIF
	PushLoopNext	<ARG>


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Push 32-bit two's complement integer as unsigned value 
;
; N.B. This should be similar to the above, except that it permits a wider
; range of positive large integers.
;
extCallArgUINTPTR:
extCallArgDWORD:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop
	
	sar		ARG, 1										; Is it a SmallInteger?
	.IF (!CARRY?)
		; Try for byte object/nil
		sal		ARG, 1										; Revert to OTE
		ASSUME	ARG:PTR OTE

		test	[ARG].m_flags, MASK m_pointer				; Is it pointers?
		jnz		tryNil										; Yes, probably fail, but could be nil (passes as 0)

		mov		TEMP, [ARG].m_size
		and		TEMP, 7fffffffh								; Mask out the immutability bit

		mov		ARG, [ARG].m_location
		ASSUME	ARG:PTR LargeInteger

		cmp		TEMP, SIZEOF DWORD							; Consists of four bytes only?
		je		@F											; Yes, correct size

		; Might still be an acceptable positive LargeInteger value
		cmp		TEMP, SIZEOF QWORD							; Consists of eight bytes only?
		jne		preCallFail									; No, wrong size

		; Now we need to check that the high dword is zero
		cmp		[ARG].m_digits[SIZEOF DWORD], 0
		jnz		preCallFail									; Top dword not 0, so can't be 32-bit
	@@:
		; Get the value out of the large integer
		mov		ARG, [ARG].m_digits[0]						; Load the value
		ASSUME	ARG:DWORD
	.ENDIF

	PushLoopNext	<ARG>


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Push any 32-bit value as if it is some unsigned handle
;
extCallArgHANDLE:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop
	
	sar		ARG, 1										; Is it a SmallInteger?
	jc		pushHANDLELoopNext							; Yes, push integer value now in ARG and continue

	; Try for byte object/nil
	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer				; Is it pointers?
	jnz		tryNil										; Yes, probably fail, but could be nil (passes as 0)

	mov		TEMP, [ARG].m_size
	and		TEMP, 7fffffffh								; Mask out the immutability (sign) bit

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR LargeInteger

	cmp		TEMP, SIZEOF DWORD							; Consists of four bytes only?
	je		@F											; Yes, correct size

	cmp		TEMP, SIZEOF QWORD							; Consists of eight bytes only?
	jne		preCallFail									; No, wrong size

	; Now we need to check that the high dword is zero
	cmp		[ARG].m_digits[SIZEOF DWORD], 0
	jnz		preCallFail									; Top dword not 0, so can't be 32-bit

@@:
	mov		ARG, [ARG].m_digits[0]						; Load the value
	ASSUME	ARG:DWORD

pushHANDLELoopNext:
	PushLoopNext	<ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

extCallArgBOOL:
	ASSUME	ARG:Oop											; ARG is input Oop from dispatch loop

	sar		ARG, 1											; SmallInteger?
	jc		pushBoolLoopNext								; SmallIntegers acceptable for boolean args

	sal		ARG, 1											; Revert to OTE
	ASSUME	ARG:PTR OTE

	; Convert true to -1
	.IF	(ARG == [oteTrue])
		mov		ARG, 1										; Pass true as 1
	.ELSE
		; Convert false to 0
		cmp		ARG, [oteFalse]
		jne		preCallFail									; Not either true or false, so fail it
		xor		ARG, ARG									; Pass false as 0
	.ENDIF

pushBoolLoopNext:
	PushLoopNext <ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallArgDATE:
extCallArgDOUBLE:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; Often pass SmallInteger?
	jnc		@F											; but not this time
	ASSUME	ARG:DWORD

	sub		esp, SIZEOF QWORD							; Make space on stack for double
	mov		[esp], ARG									; We must store down integer into mem before converting
	fild	DWORD PTR[esp]								; load int from stack to FP stack
	fstp	QWORD PTR[esp]								; store back as double
	LoopNext											; we've nothing further to push

@@:	
	; Not a SmallInteger
	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE
	mov		TEMP, [ARG].m_size

	.IF ([ARG].m_flags & MASK m_pointer)
		and		TEMP, 7fffffffh							; Ignore the immutability bit
		cmp		TEMP, OOPSIZE
		mov		ARG, [ARG].m_location					; Load ptr to object into ARG
		ASSUME	ARG:PTR Object							; 
		
		jl		preCallFail								; Not big enough - must have at least one inst var

		ASSUME	ARG:PTR ExternalStructure				; OK so it appears to be an external structure
		mov		ARG, [ARG].m_contents					; Get contents bytes into ARG
		ASSUME	ARG:Oop

		test	ARG, 1									; Contents is immediate object
		jnz		preCallFail								; Yes, fail it
		ASSUME	ARG:PTR OTE								; No, ARG is OTE of object

		test	[ARG].m_flags, MASK m_pointer			; Contents bytes or pointers?
		jnz		preCallFail								; Inst var not a byte object, fail it

		; Now we've got a byte object, needs to be handled differently if it is an indirection
		mov		TEMP2, [ARG].m_oteClass					; Get the class of the bytes into TEMP2
		ASSUME	TEMP2:PTR OTE

		mov		TEMP2, [TEMP2].m_location
		ASSUME	TEMP2:PTR Behavior						; TEMP2 is pointer to class of byte object

		.IF	([TEMP2].m_instanceSpec & MASK m_indirect)	; Is it an indirection class?
			mov		ARG, [ARG].m_location				
			ASSUME	ARG:PTR ExternalAddress
			
			mov		ARG, [ARG].m_pointer
			;; ARG is pointing at the bytes to push
			ASSUME	ARG:PTR DWORD
			push	[ARG+SIZEOF DWORD]					; Push second DWORD of double value
			push	[ARG]								; Push first DWORD of double value
			LoopNext									; and loop (nothing further to push)
		.ELSE
			ASSUME	ARG:PTR OTE
			mov		TEMP, [ARG].m_size
			and		TEMP, 7fffffffh						; Ignore immutability (sign) bit
			mov		ARG, [ARG].m_location				
			cmp		TEMP, SIZEOF QWORD
			jl		preCallFail
		.ENDIF
	
	.ELSE
		ASSUME	ARG:PTR OTE

		mov		TEMP, [ARG].m_oteClass
		ASSUME	TEMP:PTR OTE

		mov		ARG, [ARG].m_location					; Load ptr to argument bytes
		ASSUME	ARG:PTR Object							; 
		
		cmp		TEMP, [Pointers.ClassFloat]				; OK, is it a Float?
		jne		preCallFail								; No, fail it
	.ENDIF

	;; ARG is pointing at the bytes to push
	ASSUME	ARG:PTR QWORDValue
	push	[ARG].m_dwHigh								; Push second DWORD of double value
	push	[ARG].m_dwLow								; Push first DWORD of double value
	LoopNext											; and loop (nothing further to push)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallArgBSTR:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	test	ARG, 1										; SmallInteger?
	jz		@F											; No, its an object

	sar		ARG, 1
	jmp		pushBSTRAddressLoopNext
	
@@:
	ASSUME	ARG:PTR OTE									; No, its an object

	test	[ARG].m_flags, MASK m_pointer				; Pointer object?
	jnz		tryNil										; Yes, nil passes as null, but other Pointer objects invalid

	mov		TEMP, [ARG].m_oteClass						; Get class of ARG into TEMP
	ASSUME	TEMP:PTR OTE

	.IF (TEMP != [Pointers.ClassBSTR] && TEMP != [Pointers.ClassLargeInteger])
		mov			ecx, ARG
		call		NewBSTR
		ASSUME	eax:PTR OTE
		test		eax, eax
		jz			preCallFail

		;; Now we need some way to ensure this is destroyed, and the easiest way is to stuff
		;; it on the ST stack in the slot occuppied by the UnicodeString argument
		mov		[_SP+OOPSIZE], eax								; Replace string arg with BSTR object
		AddToZctNoSP <a>

		mov		eax, [_SP+OOPSIZE]
	.ENDIF

	mov		ARG, [ARG].m_location
	; ARG now contains address of bytes
	ASSUME	ARG:PTR ByteArray

	; Load the address out of the object
	mov		ARG, DWORD PTR[ARG].m_elements
	ASSUME	ARG:PTR BYTE

pushBSTRAddressLoopNext:
	PushLoopNext<ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
ExtCallArgLPWSTR:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	test	ARG, 1										; SmallInteger?
	jnz		preCallFail									; Yes, invalid
	ASSUME	ARG:PTR OTE									; No, its an object

	test	[ARG].m_flags, MASK m_pointer				; Pointer object?
	jnz		tryNil										; Yes, nil passes as null, but other Pointer objects invalid

	mov		TEMP, [ARG].m_oteClass						; Get class of ARG into TEMP
	ASSUME	TEMP:PTR OTE

	test	[ARG].m_flags, MASK m_weakOrZ				; It is a null terminated class?
	jz		preCallFail									; No, only null terminated objects can be passed as #lpwstr

	cmp		TEMP, [Pointers.ClassUtf16String]
	jne		@F

	mov		ARG, [ARG].m_location

	; ARG now contains address of wide chars
	PushLoopNext<ARG>

@@:
	mov		ecx, ARG
	call	NewUtf16StringFromString					; Create new Utf16String instance from the byte string using the ANSI or UTF8 code page as appropriate
	ASSUME	eax:PTR OTE

	;; Now we need some way to ensure this is ref'd and destroyed, and the easiest way is to stuff
	;; it on the ST stack in the slot occuppied by the byte string argument and add it to the ZCT
	mov		[_SP+OOPSIZE], eax
	AddToZctNoSP <a>

	mov		eax, [_SP+OOPSIZE]
	mov		ARG, [eax].m_location
	; ARG now contains address of bytes
	ASSUME	ARG:PTR ByteArray
	PushLoopNext<ARG>

ExtCallArgLPSTR:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	test	ARG, 1										; SmallInteger?
	jnz		preCallFail									; Yes, invalid
	ASSUME	ARG:PTR OTE									; No, its an object

	test	[ARG].m_flags, MASK m_pointer				; Pointer object?
	jnz		tryNil										; Yes, nil passes as null, but other Pointer objects invalid

	mov		TEMP, [ARG].m_oteClass						; Get class of ARG into TEMP
	ASSUME	TEMP:PTR OTE

	test	[ARG].m_flags, MASK m_weakOrZ				; It is a null terminated object?
	jz		preCallFail									; No, only null terminated objects can be passed as #lpstr

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR String

	cmp		TEMP, [Pointers.ClassUtf16String]			; If its a wide string it will need conversion. We assume the API is expecting an ANSI string
	je		@F

	PushLoopNext <ARG>									; ByteString of some sort, just push that pointer. Note we assume encoding is as expected

@@:
	mov		ecx, ARG
	call	NewAnsiStringFromUtf16						; Assume its an ANSI API and will not understand Utf8 (which is generally true of byte string APIs on Windows, unfortunately)
	ASSUME	ARG:PTR OTE

	mov		[_SP+OOPSIZE], eax
	AddToZctNoSP <a>

	mov		eax, [_SP+OOPSIZE]
	mov		ARG, [eax].m_location
	ASSUME	ARG:PTR String
	PushLoopNext<ARG>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
tryNil:
	ASSUME	ARG:PTR OTE									; We shouldn't get here for SmallIntegers

	cmp		ARG, [oteNil]
	jne		preCallFail

	; Deliberately drop though

pushNil:
	PushLoopNext <0>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallArgOTE:
	test	ARG,1										; SmallInteger?
	jnz		preCallFail									; Yes, not valid
	; Deliberately drop through

extCallArgOOP:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	PushLoopNext <ARG>


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallArgFLOAT:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; Often pass SmallInteger
	jnc		@F											; but not this time
	ASSUME	ARG:DWORD
	
	push	ARG											; Make space for float, and integer value on stack too
	fild	DWORD PTR[esp]								; Load int to FP stack
	fstp	DWORD PTR[esp]								; and store float back
	LoopNext											; No more to do, so process next arg

@@:	
	; Not a SmallInteger

	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	mov		TEMP, [ARG].m_oteClass
	ASSUME	TEMP:PTR OTE								; OTE of ARG class now in TEMP

	mov		ARG, [ARG].m_location						; Load ptr to object
	ASSUME	ARG:PTR Object

	cmp		TEMP, [Pointers.ClassFloat]					; OK, is it a Float?
	jne		preCallFail									; No, fail it
	ASSUME	ARG:PTR Float								; Yes

	push	ARG											; Make space for the FP value on machine stack (push quicker)
	fld		[ARG].m_fValue								; Load Float value to FP stack
	fstp	DWORD PTR [esp]								; And store it back
	fwait												; Under/overflow is possible since double pushed as single
	
	LoopNext

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Typed pointer argument. Currently not implemented to do anything interesting.
;; Could access the class from the literal frame and compare it. We could then
;; implement a less complex coercion as we could be more strict about the allowable
;; argument types.

ExtCallArgLPP:
	dec		INDEX								; Ignore the argument type (could validate here)
	; Deliberately drop through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
ExtCallArgLPPVOID:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	test	ARG,1										; SmallInteger?
	jz		@F

	sar		ARG, 1										; Pass SmallInteger as the actual address
	PushLoopNext <ARG>									; else push pointer out of object

@@:
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer				; It it a pointer object
	jz		@F											; No, skip handling for external structures

	cmp		ARG, [oteNil]								; OK its pointers, but is it nil?
	mov		TEMP, [ARG].m_size
	je		pushNil										; Yes, push as NULL

	and		TEMP, 7fffffffh								; The struct itself can be constant
	cmp		TEMP, OOPSIZE								; Has at least one inst var?

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR Object								; ARG points at pointer object

	jl		preCallFail									; No, fail it
	ASSUME	ARG:PTR ExternalStructure					; Yes, assume format

	mov		ARG, [ARG].m_contents						; Load first inst var
	ASSUME	ARG:Oop
	
	test	ARG, 1										; Inst var smallInteger?
	jnz		preCallFail									; Yes, fail it
	ASSUME	ARG:PTR OTE									; No, its an object

	test	[ARG].m_flags, MASK m_pointer				; Pointer object?
	jne		preCallFail									; Yes, so fail it

@@:
	ASSUME	ARG:PTR OTE

	mov		TEMP, [ARG].m_oteClass
	ASSUME	TEMP:PTR OTE

	mov		ARG, [ARG].m_location

	cmp		TEMP, [Pointers.ClassLargeInteger]	
	je		@F
	PushLoopNext <ARG>									; Yes, push pointer to the ExternalAddress obj, so can be written back into
@@:
	ASSUME	ARG:PTR LargeInteger
	mov		ARG, DWORD PTR[ARG].m_digits
	PushLoopNext <ARG>									; Yes, push pointer to the ExternalAddress obj, so can be written back into

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Push a LARGE_INTEGER, i.e. an unsigned 64-bit value using the following rules
;;	- Negative SmallIntegers are pushed as 16rFFFFFFFF <value>
;;	- Positive SmallIntegers are pushed as 16r00000000 <value>
;;	- 32-bit LargeIntegers are sign extended to 64-bits
;;	- 64-bit LargeIntegers are passed as is.
;;	- Byte structures must have >=4 and <=8 bytes of data (they are sign extended if necessary)
;;	- nil is a synonym for 0

extCallArgSQWORD:
	ASSUME	ARG:Oop
	ASSERTEQU	%ARG, <eax>								; We use CDQ expecting to sign extend EAX into EDX

	sar		ARG, 1										; Convert from SmallInteger?
	.IF (CARRY?)
		cdq
		push		edx
		PushLoopNext <ARG>
	.ENDIF

	; Try for byte object/nil
	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer
	jnz		tryNilQWORD									; Nil passes as 0

	mov		TEMP, [ARG].m_size
	and		TEMP, 7fffffffh								; Mask out the immutability (sign) bit

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR ByteArray							; Its a byte object of some sort
	
	.IF	(TEMP == SIZEOF DWORD)
		; Get the value out of the 32-bit large integer
		ASSUME	ARG:PTR DWORDBytes
		mov		ARG, [ARG].m_value							; Load the value
		ASSUME	ARG:DWORD
		ASSERTEQU	%ARG, <eax>
		cdq													; Sign extend to 64-bits
	.ELSE													; Not 4 bytes
		jl		preCallFail									; Less than 32-bits so fail it
		
		; Its > 4 bytes, lets see if <= 8
		cmp		TEMP, SIZEOF QWORD
		jg		preCallFail									; Too big
		ASSUME	ARG:PTR QWORDBytes

		mov		edx, [ARG].m_highPart
		mov		ARG, [ARG].m_lowPart
	.ENDIF

	; Drop through (EAX is QWORD low part, EDX is QWORD high part [0 or -1])
	push	edx											; Push high DWORD
	PushLoopNext	<ARG>								; Push low DWORD and loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
tryNilQWORD:
	ASSUME	ARG:PTR OTE									; We shouldn't get here for SmallIntegers

	cmp		ARG, [oteNil]
	jne		preCallFail
	push	0
	PushLoopNext <0>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Push a ULARGE_INTEGER, i.e. an unsigned 64-bit value using the following rules
;; N.B. THIS IS AN EXACT COPY OF THE ABOVE, EXCEPT THAT WE ZERO, RATHER THAN SIGN,
;; EXTEND

extCallArgQWORD:
	ASSUME	ARG:Oop
	ASSERTEQU	%ARG, <eax>								; We use CDQ expecting to sign extend EAX into EDX

	sar		ARG, 1										; Convert from SmallInteger?
	.IF (CARRY?)
		cdq
		push	edx
		PushLoopNext <ARG>
	.ENDIF

	; Try for byte object/nil
	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	test	[ARG].m_flags, MASK m_pointer
	jnz		tryNilQWORD									; Nil passes as 0

	mov		TEMP, [ARG].m_size
	and		TEMP, 7fffffffh								; Mask out the immutability (sign) bit

	mov		ARG, [ARG].m_location
	ASSUME	ARG:PTR ByteArray							; Its a byte object of some sort
	
	.IF	(TEMP == SIZEOF DWORD)
		; Get the value out of the 32-bit large integer
		ASSUME	ARG:PTR DWORDBytes
		mov		ARG, [ARG].m_value							; Load the value
		mov		edx, 0										; Zero extend (always)
	.ELSE													; Not 4 bytes
		; Its > 4 bytes, lets see if = 8
		cmp		TEMP, SIZEOF QWORD
		je		pushIt									; Too big

		; Might still be an acceptable positive LargeInteger value if 12 bytes long
		; and top 4 bytes all zero
		cmp		TEMP, SIZEOF QWORD + SIZEOF DWORD
		jne		preCallFail									; No, wrong size (not 4, 8 or 12 bytes)

		ASSUME	ARG:PTR LargeInteger

		; Now we need to check that the high dword is zero
		cmp		[ARG].m_digits[SIZEOF QWORD], 0
		jnz		preCallFail									; Top dword not 0, so can't be 64-bit

	pushIt:
		ASSUME	ARG:PTR QWORDBytes
		mov		edx, [ARG].m_highPart
		mov		ARG, [ARG].m_lowPart
	.ENDIF

	; Drop through (EAX is QWORD low part, EDX is QWORD high part [0 or -1])
	push	edx											; Push high DWORD
	PushLoopNext	<ARG>								; Push low DWORD and loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

extCallArgGUID:
extCallArgVARIANT:
	ASSUME	ARG:Oop
	
	test	ARG, 1										; SmallInteger?
	jnz		preCallFail									; Yes fail it
	ASSUME	ARG:PTR OTE									; No, ARG is an object

	; We still perform checking here, because it isn't terribly expensive, and we don't trust the
	; compiler to ensure that the class has the correct shape (even if it could)

	.IF ([ARG].m_flags & MASK m_pointer)
		mov		TEMP, [ARG].m_size
		mov		TEMP2, [ARG].m_location					; Load ptr to argument bytes into TEMP2
		ASSUME	TEMP2:PTR ExternalStructure				; OK so it might be an external structure

		and		TEMP, 7fffffffh							; Ignore immutability bit
		cmp		TEMP, OOPSIZE
		jl		preCallFail								; Not big enough - must have at least one inst var

		mov		ARG, [TEMP2].m_contents					; Get contents bytes into ARG
		ASSUME	ARG:Oop

		test	ARG, 1									; Contents is SmallInteger
		jnz		preCallFail								; Yes, fail it
		ASSUME	ARG:PTR OTE								; No, ARG is OTE of object

		test	[ARG].m_flags, MASK m_pointer			; Contents bytes or pointers?
		jnz		preCallFail								; Inst var not a byte object, fail it

		; Drop though...
	.ENDIF

	mov		TEMP2, [ARG].m_oteClass						; Get the class of the bytes into TEMP2
	ASSUME	TEMP2:PTR OTE

	; Now we've got a byte object, needs to be handled differently if it is an indirection
	mov		ARG, [ARG].m_location						; Get pObj into ARG
	ASSUME	ARG:PTR ByteArray							; We know its bytes, if nothing else
	
	mov		TEMP2, [TEMP2].m_location
	ASSUME	TEMP2:PTR Behavior							; TEMP is pointer to class of byte object

	.IF	([TEMP2].m_instanceSpec & MASK m_indirect)		; Is it an indirection class?
		ASSUME	ARG:PTR ExternalAddress
		mov		ARG, [ARG].m_pointer
	.ENDIF

	ASSUME	ARG:DWORD
	
	;; ARG is pointing at the bytes to push
	mov		TEMP, [ARG+12]
	mov		TEMP2, [ARG+8]
	push	TEMP
	push	TEMP2
	mov		TEMP, [ARG+4]
	mov		TEMP2, [ARG]
	push	TEMP
	push	TEMP2

	LoopNext										; No further pushing required. Process next arg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

extCallArgVARBOOL:
	ASSUME	ARG:Oop										; ARG is input Oop from dispatch loop

	sar		ARG, 1										; SmallInteger?
	jc		pushBoolLoopNext							; SmallIntegers acceptable for boolean args

	sal		ARG, 1										; Revert to OTE
	ASSUME	ARG:PTR OTE

	; Convert true to -1
	.IF	(ARG == [oteTrue])
		mov		ARG, -1									; true == 1
	.ELSE
		; Convert false to 0
		cmp		ARG, [oteFalse]
		jne		preCallFail									; Not either true or false, so fail it
		xor		ARG, ARG									; false == 0
	.ENDIF

pushVarBoolLoopNext:
	PushLoopNext <ARG>
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Pass a structure by value. Works for byte objects and ExternalStructures
;;	containing byte objects

ExtCallArgSTRUCT4:
ExtCallArgSTRUCT8:
ExtCallArgSTRUCT:
	ASSUME	ARG:Oop
	
	test	ARG, 1											; SmallInteger?
	jnz		preCallFail										; Yes fail it
	ASSUME	ARG:PTR OTE										; No, ARG is an object

	xor		TEMP, TEMP										; Clear TEMP
	mov		TEMPB, [DESCRIPTOR].m_args[INDEX-1]				; Get index of 'type' in literal frame

	mov		TEMP2, [method]									; Load the method (NOT Interpreter::m_pMethod)
	ASSUME	TEMP2:PTR CompiledCodeObj

	mov		TEMP, [TEMP2].m_aLiterals[TEMP*OOPSIZE]			; Load literal from frame
	ASSUME	TEMP2:Oop										; TEMP2 is now the class of object expected OR the size

	.IF (TEMP & 1)
		; Its a SmallInteger literal, so compare the size for correctness (if possible)
		sar		TEMP, 1										; Convert to integer
		.IF ([ARG].m_flags & MASK m_pointer)					; Pointer object?

			mov		TEMP2, [ARG].m_size
			and		TEMP2, 7fffffffh						; Ignore the immutability bit
			cmp		TEMP2, OOPSIZE							; At least one inst var?
			
			; Yes, but it might still be an object whose first inst var might be a byte array
			mov		ARG, [ARG].m_location
			ASSUME	ARG:PTR Object

			jl		preCallFail								; No, fail it
			ASSUME	ARG:PTR ExternalStructure				; Yes, could be structure

			mov		ARG, [ARG].m_contents
			ASSUME	ARG:Oop									; ARG is now unknown inst var oop

			test	ARG, 1									; First inst var is SmallInteger?
			jnz		preCallFail								; Yes, no good
			ASSUME	ARG:PTR OTE								; No, its an object

			test	[ARG].m_flags, MASK m_pointer				; First inst var is a pointer object?
			jnz		preCallFail								; Inst var not a byte object, no good
			; Drop though...
		.ENDIF

		; Now we've got a byte object in ARG, verify that it is not an indirection

		mov		TEMP2, [ARG].m_oteClass						; Get OTE of class into TEMP2
		ASSUME	TEMP2:PTR OTE

		mov		TEMP2, [TEMP2].m_location					; Get ptr to class into TEMP2
		ASSUME	TEMP2:PTR Behavior							; TEMP2 is pointer to class of object

		.IF ([TEMP2].m_instanceSpec & MASK m_indirect)		; Is it an indirection class?
			mov		ARG, [ARG].m_location						; Get pointer to byte object into ARG
			ASSUME	ARG:PTR ExternalAddress					; Yes, assume it points at a struct of the correct size!
			mov		ARG, [ARG].m_pointer					; implicit indirection
		.ELSE
			ASSUME	ARG:PTR OTE
			mov		TEMP2, [ARG].m_size						; Load the size of the object attempting to pass by value into TEMP
			and		TEMP2, 7fffffffh						; Allow immutable objects to be passed by value
			
			ASSUME	TEMP2:DWORD
			mov		ARG, [ARG].m_location					; Get pointer to byte object into ARG
			ASSUME	ARG:PTR ByteArray

			cmp		TEMP2, TEMP								; Verify correct size (TEMP2 contains size expected)
			jne		preCallFail								; No, fail it (avoid stack fault!)
		.ENDIF

		ASSUME	ARG:PTR BYTE								; ARG points at start of bytes to push
		ASSUME	TEMP:DWORD									; TEMP is number of bytes to push
		ASSUME	TEMP2:NOTHING								; TEMP2 no longer needed

		;; TEMP still contains the size of the struct we're pushing by value
		;; ARG is pointing at the bytes to push

	.ELSE		; Literal is not a SmallInteger, so assume its a Class to compare with

		ASSUME	ARG:PTR OTE									; ARG is OTE of argument
		ASSUME	TEMP:PTR OTE								; TEMP is OTE of class expected

		cmp		TEMP, [ARG].m_oteClass						; Is it EXACTLY the correct class of object?
		jne		preCallFail									; No, sorry old fruit, you'll have to be more specific

		mov		TEMP2, [ARG].m_location						; Load ptr to argument bytes into TEMP2
		ASSUME	TEMP2:PTR Object							; it should be a kind of ExternalStructure (usually)

		; Get the structure size into TEMP
		mov		TEMP, [TEMP].m_location
		ASSUME	TEMP:PTR Behavior
		movzx	TEMP, [TEMP].m_instanceSpec.m_extraSpec
		ASSUME	TEMP:DWORD								; TEMP is size of struct expected
		
		; We still perform checking here, because it isn't terribly expensive, and we don't trust the
		; compiler to ensure that the class has the correct shape (even if it could)

		.IF ([ARG].m_flags & MASK m_pointer)
			mov		TEMP2, [ARG].m_size
			and		TEMP2, 7fffffffh						; Ignore immutability bit
			cmp		TEMP2, OOPSIZE
			mov		TEMP2, [ARG].m_location					; Reload ptr to argument bytes into TEMP2
			jl		preCallFail								; Not big enough - must have at least one inst var

			ASSUME	TEMP2:PTR ExternalStructure				; OK so it appears to be an external structure
			mov		ARG, [TEMP2].m_contents					; Get contents bytes into ARG
			ASSUME	ARG:Oop

			test	ARG, 1									; Contents is SmallInteger
			jnz		preCallFail								; Yes, fail it
			ASSUME	ARG:PTR OTE								; No, ARG is OTE of object

			test	[ARG].m_flags, MASK m_pointer				; Contents bytes or pointers?
			jnz		preCallFail								; Inst var not a byte object, fail it

			; Drop though...
		.ENDIF

		mov		TEMP2, [ARG].m_oteClass						; Get the class of the bytes into TEMP2
		ASSUME	TEMP2:PTR OTE

		; Now we've got a byte object, needs to be handled differently if it is an indirection
		mov		ARG, [ARG].m_location						; Get pObj into ARG
		ASSUME	ARG:PTR ByteArray							; We know its bytes, if nothing else
		
		mov		TEMP2, [TEMP2].m_location
		ASSUME	TEMP2:PTR Behavior							; TEMP is pointer to class of byte object

		ASSUME	ARG:PTR DWORD 
		.IF	([TEMP2].m_instanceSpec & MASK m_indirect)		; Is it an indirection class?
			mov		ARG, [ARG]
		.ENDIF
		
		;; TEMP still contains the size of the struct we're pushing by value
		;; ARG is pointing at the bytes to push
	.ENDIF

	; At this point TEMP now contains the size of the object to copy, and ARG is pointing at the byte
	; object to copy and furthermore.
	ASSUME	TEMP:DWORD								
	
	;;N.B. It is important that TEMP EQU ECX as otherwise need to rewrite above, or move into ecx
	;;here so that count is correct for the REP MOVS
	ASSERTEQU %TEMP, <ecx>
	sub		esp, TEMP								; Make room for the structure to be passed by value

	; We're not going to fail from here, so we can adjust the index to
	; account for the extra byte without fear of upsetting error reporting
	dec		INDEX									; Adjust for extra parm literal index

	; We need the ESI, EDI and ECX registers for the copy. We don't bother to preserve ECX
	; but we do preserve ESI and EDI
	; IF YOU PUSH ANY MORE, ADJUST THE 'lea edi, [esp+8]' INSTRUCTION appropriately
	push	esi										; Preserve value of ESI
	push	edi										; Preserve value of EDI

	; We assume that ARG is not already esi
	ASSERTNEQU	%ARG, <esi>
	mov		esi, ARG								; Get source address into ESI
	lea		edi, [esp+8]							; destination is stack (below saved ESI and EDI)
	rep		movsb									; Copy structure into the stack buffer

	pop		edi										; Restore value of EDI
	pop		esi										; Restore value of ESI

	LoopNext										; No further pushing required. Process next arg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Invalid argument type or coercion failure

extCallArgReserved:
extCallArgVOID:									; Not valid argument types
preCallFail:
	; NOTE IF SAVING STUFF ON THE STACK BEFORE PUSHING ARGUMENTS MAY NEED TO SAVE/
	; RESTORE STACK POINTER DEPENDING ON THE CALLING CONVENTION, AT MOMENT WE 
	; ARE BP BASED ADDRESSING FOR LOCALS, SO DON'T NEED TO BOTHER (RESTORING
	; ESP FROM EBP CORRECTLY ON EXIT IS HANDLED BY MASM)

	cmp		INDEX, 12
	lea		eax, [INDEX*2+(PrimitiveFailureInvalidParameter1*2)+1]
	mov		ecx, PrimitiveFailureInvalidParameter*2+1
	cmovge	eax, ecx

	mov		edx, callContext
	ASSUME	edx:PTR InterpRegisters

	mov		ecx, [edx].m_pActiveProcess
	ASSUME	ecx:PTR Process

	mov		_SP, [edx].m_stackPointer
	mov		_BP, [edx].m_basePointer

	;; Must load _IP after last use of INDEX, as shares register 
	ASSERTEQU %INDEX, %_IP
	mov		_IP, [edx].m_instructionPointer

	ASSUME	edx:NOTHING

	ret											; Failure return, args not popped

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Return value instantiators

extCallRetOop:
	AnswerOopResult

extCallRetOTE:
	AnswerObjectResult
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetLPVOID:
	ASSERTNEQU	%RESULT, <edx>
	mov		edx, [Pointers.ClassExternalAddress]
	mov		ecx, RESULT
	call	NEWDWORD
	AnswerObjectResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetCHAR:
	and		RESULT, 0ffh
	mov		TEMP, [OBJECTTABLE]

	; Fast mult by 16 (the size of an OT entry)
	shl		RESULT, 4
	add		TEMP, FIRSTCHAROFFSET
	add		RESULT, TEMP

	AnswerResult


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetBYTE:
	and		RESULT, 0ffh
	lea		RESULT, [RESULT*2+1]
	AnswerResult


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetSBYTE:
	movsx	TEMP, RESULTB
	lea		RESULT, [TEMP*2+1]
	AnswerResult

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetWORD:
	and		RESULT, 0ffffh
	lea		RESULT, [RESULT*2+1]
	AnswerResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetSWORD:
	movsx	TEMP, RESULTW
	lea		RESULT, [TEMP*2+1]
	AnswerResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetHRESULT:
extCallRetNTSTATUS:
	test	RESULT, RESULT
	jge		extCallRetDWORD					; If successful return code, return as DWORD

	; FAILED(HRESULT)
	ASSERTNEQU %RESULT, <ecx>
	ASSERTEQU %RESULT, <eax>

	; Bit 27 is not used in a true HRESULT, so we can pack the remainder into 31 bits without loss
	mov		ecx, RESULT
	and		ecx, 7ffffffh
	add		ecx, ecx
	inc		ecx
	and		RESULT, 0f0000000h
	or		RESULT, ecx

	mov		ecx, callContext
	ASSUME	ecx:PTR InterpRegisters

	mov		_SP, [ecx].m_stackPointer
	mov		_IP, [ecx].m_instructionPointer
	mov		_BP, [ecx].m_basePointer

	ret

extCallRetErrno:
	test	RESULT, RESULT
	jnz		@F
	mov		RESULT, SMALLINTZERO
	AnswerResult

@@:
	lea		RESULT, [RESULT*2+1]

	mov		ecx, callContext
	ASSUME	ecx:PTR InterpRegisters

	mov		_SP, [ecx].m_stackPointer
	mov		_IP, [ecx].m_instructionPointer
	mov		_BP, [ecx].m_basePointer

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetUINTPTR:
extCallRetDWORD:
	ASSUME RESULT:DWORD

	mov		ecx, RESULT
	add		RESULT, RESULT					; Will it fit into a SmallInteger
	jo		dwordOverflow					; No, more than 31 bits required (will return to my caller)
	js		dwordOverflow					; No, won't be positive SmallInteger
	or		RESULT, 1						; Yes, create SmallInteger to return in EAX
	AnswerResult

dwordOverflow:
	call	LINEWUNSIGNED32
	AnswerObjectResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetINTPTR:
extCallRetSDWORD:
	ASSUME RESULT:SDWORD

	mov		ecx, RESULT
	add		RESULT, RESULT					; Will it fit into a SmallInteger
	jo		sdwordOverflow					; No, more than 31 bits required (will return to my caller)
	or		RESULT, 1						; Yes, create SmallInteger to return in EAX
	AnswerResult

sdwordOverflow:
	call	LINEWSIGNED	
	AnswerObjectResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetBOOL:
	ASSUME	RESULT:BOOL

	test	RESULT, RESULT
	mov		RESULT, [oteTrue]
	jnz		answerResult
	add		RESULT, SIZEOF OTE
answerResult:
	AnswerResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetHANDLE:
	ASSUME RESULT:HANDLE

	test	RESULT, RESULT
	jz		returnNil
	
	mov		edx, [Pointers.ClassExternalHandle]
	mov		ecx, RESULT
	call	NEWDWORD

	AnswerObjectResult

returnNil:
	mov		RESULT, [oteNil]
	AnswerResult


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetFLOAT:
extCallRetDOUBLE:
	;; Result is on FP stack
	call	NEWFLOATOBJ
	ASSUME	eax:PTR OTE
	
	mov		ecx, [eax].m_location
	ASSUME	ecx:PTR Float
	fstp	[ecx].m_fValue						; Write value into new object

	AnswerObjectResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
extCallRetBSTR:
	ASSERTNEQU	%RESULT, <edx>
	mov		edx, [Pointers.ClassBSTR]
	mov		ecx, RESULT
	call	NEWDWORD
	AnswerObjectResult

extCallRetLPWSTR:
	test	RESULT, RESULT
	jz		returnNil

	mov		ecx, RESULT
	call	NewUtf16String
	AnswerObjectResult

extCallRetLPSTR:
	test	RESULT, RESULT
	jz		returnNil

	mov		ecx, RESULT							; Pass RESULT in ECX
	call	NewAnsiString
	AnswerObjectResult

extCallRetLPPVOID:
	mov		edx, RESULT							; Load return value for use as pointer parm
	mov		ecx, [Pointers.ClassLPVOID]			; Create an LPVOID instance ...
	call	NewExternalStructurePointer			; ... containing a pointer (i.e. void**)
	AnswerObjectResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

extCallRetReserved:
extCallRetVOID:									; Returning void just leaves receiver on stack
	mov		ecx, callContext
	ASSUME	ecx:PTR InterpRegisters

	;; Need to pop the arguments, so reload the argument count
	mov		edx, argCount
	neg		edx
	
	; Reload interpreter context registers
	mov		_SP, [ecx].m_stackPointer
	mov		_IP, [ecx].m_instructionPointer
	mov		_BP, [ecx].m_basePointer
 
	lea		eax, [_SP+edx*OOPSIZE]				; primitiveSuccess(argumentCount)
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Returning a QWORD uses the 8-byte structure return convention (i.e. in
; the EDX:EAX register pair

extCallRetQWORD:
	push	edx
	push	eax
	call	NewUnsigned64
	AnswerOopResult

extCallRetSQWORD:
	push	edx
	push	eax
	call	NewSigned64
	AnswerOopResult

extCallRetVARIANT:
	mov		edx, RESULT							; Load return value for use as pointer parm
	mov		ecx, [Pointers.ClassVARIANT]
	call	NewExternalStructure
	AnswerObjectResult

extCallRetDATE:
	;; Result is on FP stack, so temporarily copy off onto main stack
	fstp	QWORD PTR[esp-8]					; Store double to stack
	sub		esp, 8								; Make the space
	mov		edx, esp
	mov		ecx, [Pointers.ClassDATE]
	call	NewExternalStructure
	add		esp, 8								; Pop
	AnswerObjectResult

extCallRetVARBOOL:
	ASSUME	RESULT:DWORD

	;; Mask out any extraneous bits
	and		RESULT, 0FFFFh
	mov		RESULT, [oteTrue]
	jnz		@F
	add		RESULT, SIZEOF OTE
@@:
	AnswerResult

extCallRetGUID:
	mov		ecx, RESULT							; Load return value for use as pointer parm
	call	NewGUID
	AnswerObjectResult
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; N.B. WE ASSUME THAT TEMP WAS USED FOR RETURN TYPE JUMP TABLE AND THAT THE TOP THREE BYTES
; ARE THEREFORE CLEAR
;
extCallRetCOMPTR:		; N.B. Should really handle separately and AddRef this one
extCallRetLPP:
extCallRetLP:
	mov		TEMPB, [DESCRIPTOR].m_returnParm	; Get return parm literal frame index into ECX
	mov		edx, RESULT							; Load return value for use as pointer parm
	mov		eax, [method]						; Load the method (NOT Interpreter::m_pMethod)
	ASSUME	eax:PTR CompiledCodeObj
	mov		ecx, [eax].m_aLiterals[TEMP*OOPSIZE]; Load literal from frame
	call	NewExternalStructurePointer
	AnswerObjectResult

extCallRetSTRUCT4:
	push	RESULT								; Push result on stack, so can pass address to NewExternalStructure
	mov		TEMPB, [DESCRIPTOR].m_returnParm	; Get return parm literal frame index into ECX
	mov		eax, [method]						; Load the method (NOT Interpreter::m_pMethod)
	ASSUME	eax:PTR CompiledCodeObj
	mov		ecx, [eax].m_aLiterals[TEMP*OOPSIZE]; Load literal from frame
	mov		edx, esp							; Load return value for use as pointer parm
	call	NewExternalStructure
	pop		edx									; Fix the stack
	AnswerObjectResult

extCallRetSTRUCT8:
	push	edx									; Push result on stack, so can pass address to NewExternalStructure
	push	eax
	mov		TEMPB, [DESCRIPTOR].m_returnParm	; Get return parm literal frame index into ECX
	mov		eax, [method]						; Load the method (NOT Interpreter::m_pMethod)
	ASSUME	eax:PTR CompiledCodeObj
	mov		ecx, [eax].m_aLiterals[TEMP*OOPSIZE]; Load literal from frame
	mov		edx, esp							; Load return value for use as pointer parm
	call	NewExternalStructure
	add		esp, 8								; Pop temp result from stack
	AnswerObjectResult

extCallRetSTRUCT:
	mov		TEMPB, [DESCRIPTOR].m_returnParm	; Get return parm literal frame index into ECX
	mov		edx, RESULT							; Load return value for use as pointer parm
												; This should be the same value as 'returnStructure'
	mov		eax, [method]						; Load the method (NOT Interpreter::m_pMethod)
	ASSUME	eax:PTR CompiledCodeObj
	mov		ecx, [eax].m_aLiterals[TEMP*OOPSIZE]; Load literal from frame
	call	NewExternalStructure
	AnswerObjectResult

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
.data
pushOopTable	DD	OFFSET FLAT:extCallArgVOID			; 0
	DD	OFFSET FLAT:ExtCallArgLPVOID		; 1
	DD	OFFSET FLAT:extCallArgCHAR			; 2
	DD	OFFSET FLAT:extCallArgBYTE			; 3
	DD	OFFSET FLAT:extCallArgSBYTE			; 4
	DD	OFFSET FLAT:extCallArgWORD			; 5
	DD	OFFSET FLAT:extCallArgSWORD			; 6
	DD	OFFSET FLAT:extCallArgDWORD			; 7
	DD	OFFSET FLAT:extCallArgSDWORD		; 8
	DD	OFFSET FLAT:extCallArgBOOL			; 9
	DD	OFFSET FLAT:extCallArgHANDLE		; 10
	DD	OFFSET FLAT:extCallArgDOUBLE		; 11
	DD	OFFSET FLAT:ExtCallArgLPSTR			; 12
	DD	OFFSET FLAT:extCallArgOOP			; 13
	DD	OFFSET FLAT:extCallArgFLOAT			; 14
	DD	OFFSET FLAT:ExtCallArgLPPVOID		; 15
	DD	OFFSET FLAT:extCallArgHRESULT		; 16
	DD	OFFSET FLAT:ExtCallArgLPWSTR		; 17
	DD	OFFSET FLAT:extCallArgQWORD			; 18
	DD	OFFSET FLAT:extCallArgSQWORD		; 19
	DD	OFFSET FLAT:extCallArgOTE			; 20
	DD	OFFSET FLAT:extCallArgBSTR			; 21
	DD	OFFSET FLAT:extCallArgVARIANT		; 22
	DD	OFFSET FLAT:extCallArgDATE			; 23
	DD	OFFSET FLAT:extCallArgVARBOOL		; 24
	DD	OFFSET FLAT:extCallArgGUID			; 25
	DD	OFFSET FLAT:extCallArgUINTPTR		; 26
	DD	OFFSET FLAT:extCallArgINTPTR		; 27
	DD	OFFSET FLAT:extCallArgNTSTATUS		; 28
	DD	OFFSET FLAT:extCallArgErrno			; 29
	DD	OFFSET FLAT:extCallArgReserved		; 30
	DD	OFFSET FLAT:extCallArgReserved		; 31
	DD	OFFSET FLAT:extCallArgReserved		; 32
	DD	OFFSET FLAT:extCallArgReserved		; 33
	DD	OFFSET FLAT:extCallArgReserved		; 34
	DD	OFFSET FLAT:extCallArgReserved		; 35
	DD	OFFSET FLAT:extCallArgReserved		; 36
	DD	OFFSET FLAT:extCallArgReserved		; 37
	DD	OFFSET FLAT:extCallArgReserved		; 38
	DD	OFFSET FLAT:extCallArgReserved		; 39
	DD	OFFSET FLAT:ExtCallArgSTRUCT		; 40
	DD	OFFSET FLAT:ExtCallArgSTRUCT4		; 41
	DD	OFFSET FLAT:ExtCallArgSTRUCT8		; 42
	DD	OFFSET FLAT:ExtCallArgLP			; 43
	DD	OFFSET FLAT:ExtCallArgLPP			; 44
	DD	OFFSET FLAT:ExtCallArgCOMPTR		; 45
	DD	OFFSET FLAT:extCallArgReserved	    ; 46
	DD	OFFSET FLAT:extCallArgReserved	    ; 47
	DD	OFFSET FLAT:extCallArgReserved	    ; 48
	DD	OFFSET FLAT:extCallArgReserved	    ; 49
	DD	OFFSET FLAT:ExtCallArgSTRUCT		; 50
	DD	OFFSET FLAT:ExtCallArgSTRUCT4		; 51
	DD	OFFSET FLAT:ExtCallArgSTRUCT8		; 52
	DD	OFFSET FLAT:ExtCallArgLP			; 53
	DD	OFFSET FLAT:ExtCallArgLPP			; 54
	DD	OFFSET FLAT:ExtCallArgCOMPTR		; 55
	DD	OFFSET FLAT:extCallArgReserved	    ; 56
	DD	OFFSET FLAT:extCallArgReserved	    ; 57
	DD	OFFSET FLAT:extCallArgReserved	    ; 58
	DD	OFFSET FLAT:extCallArgReserved	    ; 59
	DD	OFFSET FLAT:extCallArgReserved	    ; 60
	DD	OFFSET FLAT:extCallArgReserved	    ; 61
	DD	OFFSET FLAT:extCallArgReserved	    ; 62
	DD	OFFSET FLAT:extCallArgReserved	    ; 63
	
returnOopTable	DD	OFFSET FLAT:extCallRetVOID			; 0
	DD	OFFSET FLAT:extCallRetLPVOID		; 1
	DD	OFFSET FLAT:extCallRetCHAR			; 2
	DD	OFFSET FLAT:extCallRetBYTE			; 3
	DD	OFFSET FLAT:extCallRetSBYTE			; 4
	DD	OFFSET FLAT:extCallRetWORD			; 5
	DD	OFFSET FLAT:extCallRetSWORD			; 6
	DD	OFFSET FLAT:extCallRetDWORD			; 7
	DD	OFFSET FLAT:extCallRetSDWORD		; 8
	DD	OFFSET FLAT:extCallRetBOOL			; 9
	DD	OFFSET FLAT:extCallRetHANDLE		; 10
	DD	OFFSET FLAT:extCallRetDOUBLE		; 11
	DD	OFFSET FLAT:extCallRetLPSTR			; 12
	DD	OFFSET FLAT:extCallRetOop			; 13
	DD	OFFSET FLAT:extCallRetFLOAT			; 14
	DD	OFFSET FLAT:extCallRetLPPVOID		; 15
	DD	OFFSET FLAT:extCallRetHRESULT		; 16
	DD	OFFSET FLAT:extCallRetLPWSTR		; 17
	DD	OFFSET FLAT:extCallRetQWORD			; 18
	DD	OFFSET FLAT:extCallRetSQWORD		; 19
	DD	OFFSET FLAT:extCallRetOTE			; 20
	DD	OFFSET FLAT:extCallRetBSTR			; 21
	DD	OFFSET FLAT:extCallRetVARIANT		; 22
	DD	OFFSET FLAT:extCallRetDATE			; 23
	DD	OFFSET FLAT:extCallRetVARBOOL		; 24
	DD	OFFSET FLAT:extCallRetGUID			; 25
	DD	OFFSET FLAT:extCallRetUINTPTR		; 26
	DD	OFFSET FLAT:extCallRetINTPTR		; 27
	DD	OFFSET FLAT:extCallRetNTSTATUS		; 28
	DD	OFFSET FLAT:extCallRetErrno			; 29
	DD	OFFSET FLAT:extCallRetReserved		; 30
	DD	OFFSET FLAT:extCallRetReserved		; 31
	DD	OFFSET FLAT:extCallRetReserved	    ; 32
	DD	OFFSET FLAT:extCallRetReserved	    ; 33
	DD	OFFSET FLAT:extCallRetReserved	    ; 34
	DD	OFFSET FLAT:extCallRetReserved	    ; 35
	DD	OFFSET FLAT:extCallRetReserved	    ; 36
	DD	OFFSET FLAT:extCallRetReserved	    ; 37
	DD	OFFSET FLAT:extCallRetReserved	    ; 38
	DD	OFFSET FLAT:extCallRetReserved	    ; 39
	DD	OFFSET FLAT:extCallRetSTRUCT		; 40
	DD	OFFSET FLAT:extCallRetSTRUCT4		; 41
	DD	OFFSET FLAT:extCallRetSTRUCT8		; 42
	DD	OFFSET FLAT:extCallRetLP			; 43
	DD	OFFSET FLAT:extCallRetLPP			; 44
	DD	OFFSET FLAT:extCallRetCOMPTR		; 45
	DD	OFFSET FLAT:extCallRetReserved	    ; 46
	DD	OFFSET FLAT:extCallRetReserved	    ; 47
	DD	OFFSET FLAT:extCallRetReserved	    ; 48
	DD	OFFSET FLAT:extCallRetReserved	    ; 49
	DD	OFFSET FLAT:extCallRetSTRUCT		; 50
	DD	OFFSET FLAT:extCallRetSTRUCT4		; 51
	DD	OFFSET FLAT:extCallRetSTRUCT8		; 52
	DD	OFFSET FLAT:extCallRetLP			; 53
	DD	OFFSET FLAT:extCallRetLPP			; 54
	DD	OFFSET FLAT:extCallRetCOMPTR		; 55
	DD	OFFSET FLAT:extCallRetReserved	    ; 56
	DD	OFFSET FLAT:extCallRetReserved	    ; 57
	DD	OFFSET FLAT:extCallRetReserved	    ; 58
	DD	OFFSET FLAT:extCallRetReserved	    ; 59
	DD	OFFSET FLAT:extCallRetReserved	    ; 60
	DD	OFFSET FLAT:extCallRetReserved	    ; 61
	DD	OFFSET FLAT:extCallRetReserved	    ; 62
	DD	OFFSET FLAT:extCallRetReserved	    ; 63
.CODE FFI_SEG

callExternalFunction ENDP

END

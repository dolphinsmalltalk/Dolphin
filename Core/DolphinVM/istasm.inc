;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ISTASM.INC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.686
.XMM
.MODEL FLAT
OPTION CASEMAP:NONE
OPTION NOLJMP
OPTION PROC:PRIVATE
OPTION READONLY

Oop			TYPEDEF		DWORD
UINT		TYPEDEF		WORD
HINSTANCE	TYPEDEF		UINT 
LPCSTR		TYPEDEF		PTR SBYTE
HANDLE		TYPEDEF		DWORD
BOOL		TYPEDEF		DWORD

CP_ACP		EQU 0
CP_UTF8		EQU 65001

;; These should match definitions in segdefs.h
IF 0
	BYTECODES_SEG	EQU		_text$1_Bytecodes
	RAREBC_SEG		EQU		_text$7_RareBytecodes
	PRIM_SEG		EQU		_text$2_Primitives
	FPPRIM_SEG		EQU		_text$5_PrimitivesFP
	LIPRIM_SEG		EQU		_text$6_PrimitivesLI
	FFI_SEG			EQU		_text$C_FFI
	FFIPRIM_SEG		EQU		_text$D_PrimitivesFFI
ELSE
	BYTECODES_SEG	EQU		
	RAREBC_SEG		EQU		
	PRIM_SEG		EQU		
	FPPRIM_SEG		EQU		
	LIPRIM_SEG		EQU		
	FFI_SEG			EQU		
	FFIPRIM_SEG		EQU		
ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Object layout (header)

Object		STRUCT 2t;
	fields			Oop				0t DUP (?)
Object ENDS

PObject		TYPEDEF 	PTR Object

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Object Table

OTEFlags RECORD	m_space		:3,
				m_weakOrZ	:1,
				m_finalize	:1,
				m_mark		:1,
				m_pointer	:1,
				m_free		:1

;; Structure for Object Table Entries. These are eight byte structures containing
;; a pointer to the actual object, a reference count (16-bit), a space index (where
;; the object lives, and therefore to where its memory should be returned when garbage
;; collected) and a set of flags which describe important details about the object
OTE		STRUCT 2t
	m_location	PObject		?
	m_oteClass	Oop			?
	m_size		DWORD		?		; The size is now stored in the OTE. Note the sign bit is used to mark immutable objects
	m_flags		OTEFlags	<>
	; These MUST be last to simplify swapping become (these are not swapped as they are part of the object identity, not body)
	m_count		BYTE		?
	m_idHash	WORD		?
OTE		ENDS

POTE		TYPEDEF 	PTR OTE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shared pointers (shared between VM and Smalltalk code)

; Should contain 150 pointers
VMPointers		STRUCT 2t
;	hdr									ObjectHeader		<>

	; Some fundamental objects
	Nil									POTE	?
	True								POTE	?
	False								POTE	?
	EmptyString							POTE	?
	LineDelimString						POTE	?
	EmptyArray							POTE	?
	EmptyBlock							POTE	?
										POTE	?		; Unused

	SmalltalkDictionary					POTE	?
	Scheduler							POTE	?

	; Selectors sent by the VM to Smalltalk
	DoesNotUnderstandSelector			POTE	?
	MustBeBooleanSelector				POTE	?
	CannotReturnSelector				POTE	?
	vmInterruptSymbol					POTE	?
	InternSelector						POTE	?	; Compiler only

	; Special selectors which cannot be changed
	plusSelector						POTE	?
	minusSelector						POTE	?
	lessThanSelector					POTE	?
	greaterThanSelector					POTE	?
	lessOrEqualSelector					POTE	?
	greaterOrEqualSelector				POTE	?
	equalSelector						POTE	?
	notEqualSelector					POTE	?
	multiplySelector					POTE	?
	divideSelector						POTE	?
	modSelector							POTE	?
	bitShiftSelector					POTE	?
	divSelector							POTE	?
	bitAndSelector						POTE	?
	bitOrSelector						POTE	?
	identicalSelector					POTE	?
	valueSelector						POTE	?
	valueColonSelector					POTE	?

	; Special selectors which can be changed
	specialSelectors					POTE	4t DUP (?)

	; These cannot be changed
	atSelector							POTE	?
	atPutSelector						POTE	?
	valueValueSelector					POTE	?
	basicNewSelector					POTE	?
	yourselfSelector					POTE	?
	basicSizeSelector					POTE	?
	basicAtSelector						POTE	?
	basicAtPutSelector					POTE	?
	isNilSelector						POTE	?
	notNilSelector						POTE	?

	; Other selectors sent by the VM (for callbacks and the compiler mainly)
	callbackPerformSymbol				POTE	?			; 48
	callbackPerformWithSymbol			POTE	?			; 49
	callbackPerformWithWithSymbol		POTE	?			; 50
	callbackPerformWithWithWithSymbol	POTE	?
	callbackPerformWithArgumentsSymbol	POTE	?
										POTE	?			; Unused
	subclassWindowSymbol				POTE	?			; 54
	instVarAtPutSymbol					POTE	?			; 55

	lookupKeySymbol						POTE	?			; 56 #bindingFor - compiler only
	wndProcSelector						POTE	?			; 57

										POTE	6t DUP (?)	; Compiler only
										POTE	2t DUP (?)	; Unused
										POTE	2t DUP (?)	; Compiler only

	genericCallbackSymbol				POTE	?			; 68
										POTE	?			; Unused
	virtualCallbackSymbol				POTE	?			; 70
	notIdenticalSymbol					POTE	?			; 71, #~~
	notSymbol							POTE	?			; 72, #not
										POTE	?			; 72 reserved ex special send
										POTE	?			; 73 reserved ex special send
										POTE	6t DUP (?)	; Unused & reserved for more symbols/selectors

	ClassMetaclass						POTE	?			; 81
	ClassCharacter						POTE	?
	ClassArray							POTE	?
	ClassAnsiString						POTE	?
	ClassSymbol							POTE	?
	ClassSmallInteger					POTE	?
	ClassProcess						POTE	?
	ClassCompiledMethod					POTE	?
	ClassMethodContext					POTE	?
	ClassBlockClosure					POTE	?			; 90

	ClassMessage						POTE	?			; 91
	ClassByteArray						POTE	?			; 92
	ClassUtf16String					POTE	?			; 93 Was LPI
	ClassCompiledExpression				POTE	?			; 94 Was LNI
	ClassExternalMethod					POTE	?			; 95
	ClassFloat							POTE	?			; 96
	ClassUndefinedObject				POTE	?			; 97
	ClassVariableBinding				POTE	?			; 98 ClassVariableBinding for AFX & debug stack trace version
	ClassSemaphore						POTE	?			; 99
	ClassExternalAddress				POTE	?			; 100

	ClassExternalHandle					POTE	?			; 101
	Dispatcher							POTE	?			; 102 (InputState instance)
	ClassLPVOID							POTE	?			; 103 (see ExternalCall.asm, LPVOID return type)
	ClassUtf8String						POTE	?			; 104
	ClassPoolConstantsDictionary		POTE	?			; 105
										POTE	?			; 106 Unused (was CompilationResult)
	ClassLargeInteger					POTE	?			; 107

	;; Automation types
	ClassVARIANT						POTE	?			; 108	(see Externalcall.asm, VARIANT ret type)
	ClassBSTR							POTE	?			; 109	(see ExternalCall.asm, BSTR arg type)
	ClassDATE							POTE	?			; 110	(see ExternalCall.asm, DATE ret type)

	;; Special objects
	Corpse								Oop		?			; 111
	InputSemaphore						POTE	?			; 112
	FinalizeSemaphore					POTE	?			; 113
	BereavementSemaphore				POTE	?			; 114
	MarkedBlock							POTE	?			; 115
	SignalQueue							POTE	?			; 116
	InterruptQueue						POTE	?			; 117
	FinalizeQueue						POTE	?
	BereavementQueue					POTE	?			; 119
										POTE	?			; 120
	KernelHandle						POTE	?			; 121
	VMHandle							POTE	?			; 122
	DolphinHandle						POTE	?			; 123
	UnderConstruction					POTE	?			; 124
	WakupEvent							POTE	?			; 125	
										Oop		?			; Unused
	RTFStyles							POTE	?			; 127 - Compiler only
										Oop		?			; Unused
	ImageVersionMajor					Oop		?			; 129
	ImageVersionMinor					Oop		?			; 130
										Oop		?			; 131
	CRTHandle							Oop		?			; 132
	MemoryManager						POTE	?			; 133

	; Types used by VARIANT>>value primitive (see oleprim.cpp)
										POTE	?			; 134 (ClassBYTE)
										POTE	?			; 135 (ClassSBYTE)
										POTE	?			; 136 (ClassWORD)
										POTE	?			; 137 (ClassSWORD)
										POTE	?			; 138 (ClassDWORD)
										POTE	?			; 139 (ClassSDWORD)
										POTE	?			; 140 (ClassFLOAT)
										POTE	?			; 141 (ClassDOUBLE)
										POTE	?			; 142 (ClassVARBOOL)
										POTE	?			; 143 (ClassCURRENCY)
										POTE	?			; 144 (ClassDECIMAL)
										POTE	?			; 145 (ClassLPBSTR)
										POTE	?			; 146 (ClassQWORD)
										POTE	?			; 147 (ClassSQWORD)
										POTE	?			; 148 (ClassUINT_PTR)
										POTE	?			; 149 (ClassINT_PTR)
										POTE	?			; 150 (TimingSemaphore)
VMPointers		ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Behavior objects

InstanceSpecFlags		RECORD	m_nullTerminated:1,
			m_pointers:1,
			m_indexable:1,
			m_indirect:1,
			m_mourner:1,
			m_nonInstantiable:1,
			m_unusedSpecBits:1,
			m_fixedFields:8,
			m_isInt:1

SHAPEMASK		EQU		(NOT MASK m_indirect)

;; Structure for Instance Shape Specification of Classes
InstanceSpec		STRUCT 2t
	flags			InstanceSpecFlags	<>
	m_extraSpec		WORD				?
InstanceSpec		ENDS

Behavior		STRUCT 2t
	m_superclass		Oop		?
	m_methodDictionary	Oop		?
	m_instanceSpec		InstanceSpec		<>
Behavior		ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Contexts

StackFrame		STRUCT 2t
	m_method				POTE	?	; Oop of home method
	m_environment			Oop		?	; Oop of environment object, if used
	;; All further fields are always assumed to be SmallIntegers, and not ref. counted
	m_caller				Oop		?	; Process frame offset of sender frame (or nil?)
	m_ip					Oop		?	; Instruction Pointer offset from start of method
	m_sp					Oop		?	; SP (stack pointer) SmallInteger pointer into stack
	m_bp					Oop		?	; BP (base pointer). SmallInteger pointer into stack 
StackFrame		ENDS
PStackFrame TYPEDEF		PTR StackFrame

Context		STRUCT 2t
	m_outer			Oop				?
	m_block			POTE			?
	m_tempFrame		Oop				0t DUP (?)
Context				ENDS

BlockClosureInfo STRUCT 1t
	isInteger			BYTE	?	; Note that this includes the SmallInteger flag in the bottom bit
	argumentCount		BYTE	?
	stackTempsCount		BYTE	?
	envTempsCount		BYTE	?
BlockClosureInfo ENDS

BlockClosure STRUCT 2t
	m_outer			POTE			?
	m_method		POTE			?
	m_initialIP		Oop				?
	m_info			BlockClosureInfo <>
	m_receiver		Oop				?
	m_copiedValues	Oop				0t DUP (?)
BlockClosure ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compiled Methods

MethodHeaderFlags	RECORD	envTempCount:6,
							isPrivate	:1,
							isInt		:1	

MethodHeader STRUCT 2t
	flags				MethodHeaderFlags <>
	stackTempCount		BYTE		?
	argumentCount		BYTE		?
	primitiveIndex		BYTE		?
MethodHeader ENDS

CompiledCodeObj STRUCT 2t
	m_header		MethodHeader	<>
	m_methodClass	Oop				?
	m_selector		Oop				?
	m_source		Oop				?
	m_byteCodes		Oop				?
	m_aLiterals		Oop				0t DUP (?)
CompiledCodeObj ENDS

PCompiledCode TYPEDEF PTR CompiledCodeObj


Process	STRUCT 2t
;	hdr						ObjectHeader	<>
	m_nextLink				POTE			?
	m_suspendedFrame		Oop				?			; SmallInteger
	m_priority				Oop				?			; SmallInteger
	m_myList				POTE			?			; Link
	m_callbackDepth			Oop				?			; SmallInteger
							Oop				?			; SmallInteger?
							Oop				?			;
	m_fpControl				Oop				?			; SmallInteger
	m_threadSync			POTE			?			; Semaphore
	m_thread				Oop				?
	m_exceptionEnv			POTE			?
	m_alreadyPrinnted		Oop				?
							Oop				?
	m_debugger				POTE			?
	m_name					Oop				?
							Oop				?
	m_stack					Oop				0t DUP (?)
Process	ENDS

PProcess TYPEDEF 	PTR Process

ExternalStructure STRUCT 2t
	m_contents			Oop				?
ExternalStructure ENDS

ExternalLibrary STRUCT 2t
	m_handle			Oop				?
ExternalLibrary ENDS

ExternalHandle STRUCT 2t
	m_handle			Oop				?
ExternalHandle ENDS

ExternalAddress STRUCT 2t
	m_pointer			DWORD			?
ExternalAddress ENDS

Float STRUCT 2t
	m_fValue			QWORD			?
Float ENDS

DWORDBytes STRUCT 2t
	m_value				DWORD			?
DWORDBytes ENDS

QWORDBytes STRUCT 2t
	m_lowPart			DWORD			?
	m_highPart			DWORD			?
QWORDBytes ENDS

QWORDValue STRUCT 2t
	m_dwLow				DWORD			?
	m_dwHigh			DWORD			?
QWORDValue ENDS

Character STRUCT 2t
	m_codePoint		Oop				?
Character ENDS

ByteArray		STRUCT 2t
	m_elements		BYTE			0t DUP (?)
ByteArray		ENDS

StringA		STRUCT 2t
	m_elements		SBYTE			0t DUP (?)
StringA		ENDS

VariantObject		STRUCT 2t
	m_elements		Oop				0t DUP (?)
VariantObject		ENDS

LargeInteger		STRUCT 2t
	m_digits		DWORD			0t DUP (?)
LargeInteger		ENDS

VariableBindingObj STRUCT 2t
	m_key			Oop			?
	m_value			Oop			?
VariableBindingObj ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ member imports

OBJECTTABLE EQU ?m_pOT@ObjectMemory@@2PAV?$TOTE@VObject@ST@@@@A
EXTERN OBJECTTABLE:PTR OTE
ZCT EQU ?m_pZct@ObjectMemory@@0PAPAV?$TOTE@VObject@ST@@@@A
EXTERN ZCT:near32
ZCTENTRIES EQU ?m_nZctEntries@ObjectMemory@@0HA
EXTERN ZCTENTRIES:near32
ZCTHIGHWATER EQU ?m_nZctHighWater@ObjectMemory@@0HA
EXTERN ZCTHIGHWATER:near32

ASYNCPENDING			EQU		?m_bAsyncPending@Interpreter@@0JC
EXTERN ASYNCPENDING:DWORD
NEWDWORD				EQU		?NewUint32@Interpreter@@SIPAV?$TOTE@VVariantByteObject@ST@@@@IPAV?$TOTE@VBehavior@ST@@@@@Z
extern NEWDWORD:near32
LINEWSIGNED				EQU		?liNewSigned32@LargeInteger@ST@@SIPAV?$TOTE@VLargeInteger@ST@@@@H@Z
extern LINEWSIGNED:near32
NEWFLOATOBJ				EQU		?New@Float@ST@@SGPAV?$TOTE@VFloat@ST@@@@XZ
extern NEWFLOATOBJ:near32
NEWFLOAT8				EQU		?New@Float@ST@@SGPAV?$TOTE@VFloat@ST@@@@N@Z
extern NEWFLOAT8:near32

LINEWUNSIGNED32 EQU ?liNewUnsigned@LargeInteger@ST@@SIPAV?$TOTE@VLargeInteger@ST@@@@I@Z
extern LINEWUNSIGNED32:near32

oteNil					EQU		Pointers.Nil
oteTrue					EQU		Pointers.True
oteFalse				EQU		Pointers.False

; N.B. Must be kept in sync with interpret.h

PBYTE TYPEDEF PTR BYTE

InterpRegisters STRUCT 2t
	m_pActiveProcess		PProcess		?
	m_pMethod				PCompiledCode ?
	m_instructionPointer	PBYTE ?
	m_pActiveFrame			PStackFrame ?
	m_stackPointer			DWORD ?
	m_basePointer			DWORD ?

	m_oopNewMethod			DWORD ?
	m_oopActiveProcess		POTE  ?
InterpRegisters ENDS

INTERPCONTEXT			EQU ?m_registers@Interpreter@@2UInterpreterRegisters@@A
extern INTERPCONTEXT:InterpRegisters

MESSAGE					EQU		?m_oopMessageSelector@Interpreter@@0PAV?$TOTE@VSymbol@ST@@@@A
extern MESSAGE:PTR OTE
NEWMETHOD				EQU		INTERPCONTEXT.m_oopNewMethod

ACTIVEPROCESS			EQU		INTERPCONTEXT.m_pActiveProcess
STACKPOINTER			EQU		INTERPCONTEXT.m_stackPointer
BASEPOINTER				EQU		INTERPCONTEXT.m_basePointer
INSTRUCTIONPOINTER		EQU		INTERPCONTEXT.m_instructionPointer
ACTIVEFRAME				EQU		INTERPCONTEXT.m_pActiveFrame
BASEPOINTER				EQU		INTERPCONTEXT.m_basePointer
pMethod					EQU		INTERPCONTEXT.m_pMethod
OTEACTIVEPROCESS		EQU		INTERPCONTEXT.m_oopActiveProcess

; C++ method imports
FALSE					EQU		0
TRUE					EQU		1

PPROC					EQU		PROC PUBLIC
MAXCOUNT				EQU		-1

METHODCACHEENTRIES		EQU		4096		; Number of entries in method cache

;; N.B. if the OTE size is changed, then this mask should be adjusted, and also hash algorithm in byteasm.asm

; This mask is appropriate for 8-byte OTEs (bottom 3 bits zero, so should be ignored)
;METHODCACHEMASK			EQU		(METHODCACHEENTRIES-1)*8
; This mask is appropriate for 12-byte OTEs (bottom 2 bits zero, so should be ignored)
;METHODCACHEMASK			EQU		(METHODCACHEENTRIES-1)*4
; This mask is appropriate for 16-byte OTEs (bottom 4 bits zero, so should be ignored)
METHODCACHEMASK			EQU		(METHODCACHEENTRIES-1)*16

OOPSIZE					EQU		SIZEOF Oop
OOPSHIFT				EQU		2							; Assumes OOPSIZE == 4

Pointers				EQU		?Pointers@@3UVMPointers@@A	; Non-const
;Pointers				EQU		?Pointers@@3UVMPointers@@B	; const

EXTERN Pointers:VMPointers
METHODHDRFLAGSMASK		EQU		0Eh
POINTERBITMASK			EQU		2
SMALLINTZERO			EQU		1
SMALLINTONE				EQU		3						;; (1 << 1) | 1
SMALLINTTWO				EQU		5						;; (2 << 1) | 1

OTENTRYSIZE				EQU		(SIZEOF OTE)
FIRSTCHAROFFSET			EQU		(7*OTENTRYSIZE)

;; Special mask for calculating instance size in bytes
SIZEMASK				EQU		8FFEh

INSTPTRBMASK			EQU		040h
INSTPTRWMASK			EQU		04000h
INDEXABLEWMASK			EQU		02000h

HALTINTERRUPT			EQU		(3*2+1)
DEBUGINTERRUPT			EQU		(4*2+1)

SE_VMCALLBACKEXIT		EQU		20000000h

; Global Register allocation
_SP						EQU		esi
_IP						EQU		edi
_BP						EQU		ebx

ASSUME _SP:Ptr Oop
ASSUME _IP:Ptr byte
ASSUME _BP:Ptr Oop

ASSERTEQU MACRO arg1, arg2
	.ERRDIF <&arg1>, <&arg2>
ENDM

ASSERTNEQU MACRO arg1, arg2
	.ERRIDN <&arg1>, <&arg2>
ENDM

ASSERT MACRO condition
	IFDEF _DEBUG
		.IF (!!&condition&)
			int		3
		.ENDIF
	ENDIF
ENDM

IACA_START MACRO
	mov ebx, 111
	db 64h, 67h, 90h
ENDM

IACA_END MACRO
	mov ebx, 222
	db 64h, 67h, 90h
ENDM

;; Increase the reference count of a known non-SmallInteger
CountUpObjectIn MACRO oopRegLetter	;;, countRegLetter
	LOCAL	fini

	;; Although theoretically involving fewer cycles when overflowed, the following code sequence
	;; results in slightly lower VM performance (perhaps due to pipelining or somesuch)
	;; AND requires the use of an additional register
	;; Cycles 1+1+1+1 (normal), 1+1+1 (overflowed)
	;;mov		&countRegLetter&l, (OTE PTR[e&oopRegLetter&x]).m_count
	;;inc		&countRegLetter&l
	;;jz		fini
	;;mov		(OTE PTR[e&oopRegLetter&x]).m_count, &countRegLetter&l

	;; Alternative which requires 1 extra cycle, but does not need an extra register
	;; and which seems to be faster
	;; Cycles 3+1 (normal), 3+1+1 (overflowed)
	inc			(OTE PTR[e&oopRegLetter&x]).m_count
	; TODO: Can we use setcc here?
	jnz			fini
	mov			(OTE PTR[e&oopRegLetter&x]).m_count, MAXCOUNT

	fini:
ENDM

;; Standard countUp Macro - increase the reference count of an
;; unknown object type.
CountUpOopIn MACRO oopRegLetter	;; , countRegLetter
	LOCAL	fini
	test	&oopRegLetter&l, 1				;; Is the Oop a SmallInteger
	jnz		fini							;; Can't count up SmallIntegers

	CountUpObjectIn oopRegLetter	;;, countRegLetter

	fini:
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CallCPP MACRO mangledName
	mov		[INSTRUCTIONPOINTER], _IP
	mov		[STACKPOINTER], _SP
	call	mangledName
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		_SP, [STACKPOINTER]
	mov		_BP, [BASEPOINTER]
ENDM

RECONCILEZCT EQU ?ReconcileZct@ObjectMemory@@SIPAIXZ
extern RECONCILEZCT:near32

AddToZct MACRO oopRegLetter, stackP:=<_SP>
	LOCAL	fini
	IFDIFI <e&oopRegLetter&x>, <eax>				;; Don't move eax onto itself
		mov		eax, e&oopRegLetter&x
	ENDIF

	IFDIFI <&stackP&>, <_SP>						;; Preserve the stack pointer value for later
		push	stackP
	ENDIF
	;; Only add OBJECTs (not SmallIntegers) with ref. count of zero to the Zct
	mov		ecx, DWORD PTR[ZCTENTRIES]
	mov		edx, DWORD PTR[ZCT]
	mov		DWORD PTR[edx+ecx*4], eax
	inc		ecx
	mov		DWORD PTR[ZCTENTRIES], ecx
	IFDIFI <&stackP&>, <_SP>
		pop	stackP
	ENDIF
	IFDEF _DEBUG
		mov		[STACKPOINTER], stackP			 	;; Save down interpreter stack pointer, e.g. for C routine
		call	RECONCILEZCT
	ELSE
		.IF	(ecx == DWORD PTR[ZCTHIGHWATER])			;; ZCT full?
			mov		[STACKPOINTER], stackP			 	;; Save down interpreter stack pointer, e.g. for C routine
			call	RECONCILEZCT
		.ENDIF
	ENDIF
fini:
ENDM

;; Exactly the same as AddToZct, but doesn't do any stack pointer stuff, since the 
;; memory register is assumed to hold the correct value already.
;; I'd like to have achieved this using conditional assembly, but couldn't work out
;; how to do it in a reasonable amount of time.
AddToZctNoSP MACRO oopRegLetter
	LOCAL	fini
	IFDIFI <e&oopRegLetter&x>, <eax>				;; Don't move eax onto itself
		mov		eax, e&oopRegLetter&x
	ENDIF
	;; Only add OBJECTs (not SmallIntegers) with ref. count of zero to the Zct
	mov		ecx, DWORD PTR[ZCTENTRIES]
	mov		edx, DWORD PTR[ZCT]
	mov		DWORD PTR[edx+ecx*4], eax
	inc		ecx
	mov		DWORD PTR[ZCTENTRIES], ecx
	IFDEF _DEBUG
		call	RECONCILEZCT
	ELSE
		.IF	(ecx == DWORD PTR[ZCTHIGHWATER])			;; ZCT full?
			call	RECONCILEZCT
		.ENDIF
	ENDIF
fini:
ENDM

;; Macro to count down an object in specified register
;; but object may have been deleted.
;; Destroys ECX and EDX
CountDownOopIn MACRO oopRegLetter:=<c>
	LOCAL	fini
	ASSUME	e&oopRegLetter&x:PTR OTE
	test 	oopRegLetter&l, 1						;; Is is a SmallInteger
	jnz 	fini									;; Yes, no further processing
	ASSERTNEQU d, &oopRegLetter						;; Macro only works for count down of ECX, EAX, not EDX
	mov		dl, [e&oopRegLetter&x].m_count
	cmp		dl, 0ffh								;; Has count overflowed?
	je		fini									;; Yes, do nothing
	dec		dl
	mov		[e&oopRegLetter&x].m_count, dl

	ASSUME	e&oopRegLetter&x:NOTHING
	jnz		fini								;; Count not reduced to zero, skip deallocation
	AddToZct oopRegLetter
fini:
ENDM

;; Macro to count down a known non-integer object in specified register - leaves Oop in eax, 
;; but object may have been deleted.
;; Destroys ECX and EDX, and returns input in EAX
CountDownObjectIn MACRO oopRegLetter:=<c>
	LOCAL	unRefdOop
	ASSERTNEQU d, &oopRegLetter						;; If so, then it'll be trashed
	mov		dl, (OTE PTR[e&oopRegLetter&x]).m_count
	cmp		dl, 0ffh								;; Has count overflowed?
	je		unRefdOop								;; Yes, do nothing
	dec		dl										;; Two instructions = 2 cycles, dec [mem] = 3 cycles
	IFDIFI <e&oopRegLetter&x>, <ecx>				;; Don't move ecx onto itself
		mov		ecx, e&oopRegLetter&x
	ENDIF
	mov		(OTE PTR[e&oopRegLetter&x]).m_count, dl
	jnz		unRefdOop								;; Count not reduced to zero, skip deallocation
	AddToZct oopRegLetter
unRefdOop:
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CANTBEINTEGEROBJECT MACRO oopReg
	IFDEF _DEBUG
		.IF (oopReg & 1)
			int		3						;; If this fires, its a SmallInteger
		.ENDIF
	ENDIF
	ASSUME oopReg:PTR OTE
ENDM

MUSTBEINTEGEROBJECT MACRO oopReg
	IFDEF _DEBUG
		.IF !(oopReg & 1)
			int		3						;; If this fires, its not a SmallInteger
		.ENDIF
	ENDIF
ENDM

ASSERTISBYTES MACRO oopReg
	LOCAL ok
	IFDEF _DEBUG
		CANTBEINTEGEROBJECT oopReg
		test	(OTE PTR[oopReg]).m_flags, MASK m_pointer
		jz		ok
		int		3			;; ******** Its a Pointer (non-byte) Object ********
	ENDIF
	ok:
ENDM

GetIPOffsetUsing MACRO tempRegister
	mov		tempRegister, [pMethod]
	add		tempRegister, CompiledCodeObj.m_byteCodes
	.IF (!(BYTE PTR[tempRegister] & 1))
		mov		tempRegister, [tempRegister]
		mov		tempRegister, (OTE PTR[tempRegister]).m_location	;; Include the object header
	.ENDIF
	IFDEF _DEBUG
		.IF (_IP < tempRegister)
			int	3											;; Probably a bug - _IP should always be >= base of method bytecodes
		.ENDIF
	ENDIF
	sub		_IP, tempRegister								;; Convert _IP to offset into object
;	IFDEF _DEBUG
;		.IF (_IP > 8192)
;			int	3											;; Probably a bug - _IP index very large
;		.ENDIF
;	ENDIF
ENDM

PrimitiveFailureInvalidParameter EQU 06800000Dh
PrimitiveFailureInvalidParameter1 EQU 0680000EFh
PrimitiveFailureWrongNumberOfArgs EQU 040028CA1h
PrimitiveFailureAssertionFailure EQU 068000420h
PrimitiveFailureProcNotFound EQU 04007007Fh
PrimitiveFailureIntegerOverflow EQU 068000095h
PrimitiveFailureInvalidPointer EQU 040004003h

PrimitiveFailureCode MACRO failureCode
	ASSUME	eax:NOTHING
	mov		eax, failureCode*2+1			; We now return a SmallInteger failure code
	ret
ENDM
	
LocalPrimitiveFailure MACRO failureCode

%local&failureCode&:
	PrimitiveFailureCode failureCode
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Declare primitives

ALIGNPRIMITIVE MACRO
	ALIGN 16
ENDM

PRIMPROC EQU PROC PUBLIC

DECLAREPRIMITIVE MACRO name
	public ?&name&@Interpreter@@SIPAIQAII@Z
ENDM

BEGINPRIMITIVE MACRO name
	; P6 likes branch targets to be aligned, it especially doesn't like them to be split over
	; more than one cache line
	ALIGNPRIMITIVE
	?&name&@Interpreter@@SIPAIQAII@Z PRIMPROC
	IFDEF PENTER
		call __penter
	ENDIF
ENDM

ENDPRIMITIVE MACRO name
	?&name&@Interpreter@@SIPAIQAII@Z ENDP
ENDM


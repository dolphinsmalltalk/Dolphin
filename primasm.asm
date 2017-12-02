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

; Macro for calling CPP Primitives which can change the interpreter state (i.e. may
; change the context), thus requiring the reloading of the registers which cache interpreter
; state
CallContextPrim MACRO mangledName
	call	mangledName						;; Transfer control to primitive 
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		_BP, [BASEPOINTER]				;; _SP is always reloaded from EAX after executing a primitive
	ret
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exports

; Helpers
public @callPrimitiveValue@8

; Entry points for byte code dispatcher (see primasm.asm)
public _primitivesTable

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imports

;; Win32 functions
RaiseException		PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD
longjmp				PROTO C :DWORD, :DWORD

; Imports from byteasm.asm
extern primitiveReturn:near32
extern activateBlock:near32
extern shortReturn:near32

extern primitiveReturnSelf:near32
extern primitiveReturnTrue:near32
extern primitiveReturnFalse:near32
extern primitiveReturnNil:near32
extern primitiveReturnLiteralZero:near32
extern primitiveReturnStaticZero:near32
extern primitiveActivateMethod:near32
extern primitiveReturnInstVar:near32
extern primitiveSetInstVar:near32

; Imports from flotprim.cpp
primitiveTruncated EQU ?primitiveTruncated@Interpreter@@CIPAIQAI@Z
extern primitiveTruncated:near32
primitiveAsFloat EQU ?primitiveAsFloat@Interpreter@@CIPAIQAI@Z
extern primitiveAsFloat:near32
primitiveFloatAdd EQU ?primitiveFloatAdd@Interpreter@@CIPAIQAI@Z
extern primitiveFloatAdd:near32
primitiveFloatSub EQU ?primitiveFloatSubtract@Interpreter@@CIPAIQAI@Z
extern primitiveFloatSub:near32
primitiveFloatMul EQU ?primitiveFloatMultiply@Interpreter@@CIPAIQAI@Z
extern primitiveFloatMul:near32
primitiveFloatDiv EQU ?primitiveFloatDivide@Interpreter@@CIPAIQAI@Z
extern primitiveFloatDiv:near32
primitiveFloatEQ EQU ?primitiveFloatEqual@Interpreter@@CIPAIQAI@Z
extern primitiveFloatEQ:near32
primitiveFloatLT EQU ?primitiveFloatLessThan@Interpreter@@CIPAIQAI@Z
extern primitiveFloatLT:near32
primitiveFloatLE EQU ?primitiveFloatLessOrEqual@Interpreter@@CIPAIQAI@Z
extern primitiveFloatLE:near32
primitiveFloatGT EQU ?primitiveFloatGreaterThan@Interpreter@@CIPAIQAI@Z
extern primitiveFloatGT:near32
primitiveFloatGE EQU ?primitiveFloatGreaterOrEqual@Interpreter@@CIPAIQAI@Z
extern primitiveFloatGE:near32
primitiveFloatSin EQU ?primitiveFloatSin@Interpreter@@CIPAIQAI@Z
extern primitiveFloatSin:near32
primitiveFloatCos EQU ?primitiveFloatCos@Interpreter@@CIPAIQAI@Z
extern primitiveFloatCos:near32
primitiveFloatTan EQU ?primitiveFloatTan@Interpreter@@CIPAIQAI@Z
extern primitiveFloatTan:near32
primitiveFloatArcSin EQU ?primitiveFloatArcSin@Interpreter@@CIPAIQAI@Z
extern primitiveFloatArcSin:near32
primitiveFloatArcCos EQU ?primitiveFloatArcCos@Interpreter@@CIPAIQAI@Z
extern primitiveFloatArcCos:near32
primitiveFloatArcTan EQU ?primitiveFloatArcTan@Interpreter@@CIPAIQAI@Z
extern primitiveFloatArcTan:near32
primitiveFloatArcTan2 EQU ?primitiveFloatArcTan2@Interpreter@@CIPAIQAI@Z
extern primitiveFloatArcTan2:near32
primitiveFloatExp EQU ?primitiveFloatExp@Interpreter@@CIPAIQAI@Z
extern primitiveFloatExp:near32
primitiveFloatLog EQU ?primitiveFloatLog@Interpreter@@CIPAIQAI@Z
extern primitiveFloatLog:near32
primitiveFloatSqrt EQU ?primitiveFloatSqrt@Interpreter@@CIPAIQAI@Z
extern primitiveFloatSqrt:near32
primitiveFloatLog10 EQU ?primitiveFloatLog10@Interpreter@@CIPAIQAI@Z
extern primitiveFloatLog10:near32
primitiveFloatTimesTwoPower EQU ?primitiveFloatTimesTwoPower@Interpreter@@CIPAIQAI@Z
extern primitiveFloatTimesTwoPower:near32
primitiveFloatAbs EQU ?primitiveFloatAbs@Interpreter@@CIPAIQAI@Z
extern primitiveFloatAbs:near32
primitiveFloatRaisedTo EQU ?primitiveFloatRaisedTo@Interpreter@@CIPAIQAI@Z
extern primitiveFloatRaisedTo:near32
primitiveFloatFloor EQU ?primitiveFloatFloor@Interpreter@@CIPAIQAI@Z
extern primitiveFloatFloor:near32
primitiveFloatCeiling EQU ?primitiveFloatCeiling@Interpreter@@CIPAIQAI@Z
extern primitiveFloatCeiling:near32
primitiveFloatExponent EQU ?primitiveFloatExponent@Interpreter@@CIPAIQAI@Z
extern primitiveFloatExponent:near32
primitiveFloatNegated EQU ?primitiveFloatNegated@Interpreter@@CIPAIQAI@Z
extern primitiveFloatNegated:near32
primitiveFloatClassify EQU ?primitiveFloatClassify@Interpreter@@CIPAIQAI@Z
extern primitiveFloatClassify:near32
primitiveFloatFractionPart EQU ?primitiveFloatFractionPart@Interpreter@@CIPAIQAI@Z
extern primitiveFloatFractionPart:near32
primitiveFloatIntegerPart EQU ?primitiveFloatIntegerPart@Interpreter@@CIPAIQAI@Z
extern primitiveFloatIntegerPart:near32
primitiveDoublePrecisionFloatAt EQU ?primitiveDoublePrecisionFloatAt@Interpreter@@CIPAIQAI@Z
extern ?primitiveDoublePrecisionFloatAt@Interpreter@@CIPAIQAI@Z:near32
primitiveDoublePrecisionFloatAtPut EQU ?primitiveDoublePrecisionFloatAtPut@Interpreter@@CIPAIQAI@Z
extern ?primitiveDoublePrecisionFloatAtPut@Interpreter@@CIPAIQAI@Z:near32
primitiveLongDoubleAt EQU ?primitiveLongDoubleAt@Interpreter@@CIPAIQAI@Z
extern primitiveLongDoubleAt:near32
primitiveSinglePrecisionFloatAt EQU ?primitiveSinglePrecisionFloatAt@Interpreter@@CIPAIQAI@Z
extern primitiveSinglePrecisionFloatAt:near32
primitiveSinglePrecisionFloatAtPut EQU ?primitiveSinglePrecisionFloatAtPut@Interpreter@@CIPAIQAI@Z
extern primitiveSinglePrecisionFloatAtPut:near32

; Imports from ExternalBytes.asm
extern primitiveAddressOf:near32
extern primitiveDWORDAt:near32
extern primitiveDWORDAtPut:near32
extern primitiveSDWORDAt:near32
extern primitiveSDWORDAtPut:near32
extern primitiveWORDAt:near32
extern primitiveWORDAtPut:near32
extern primitiveSWORDAt:near32
extern primitiveSWORDAtPut:near32
extern primitiveIndirectDWORDAt:near32
extern primitiveIndirectDWORDAtPut:near32
extern primitiveIndirectSDWORDAt:near32
extern primitiveIndirectSDWORDAtPut:near32
extern primitiveIndirectWORDAt:near32
extern primitiveIndirectWORDAtPut:near32
extern primitiveIndirectSWORDAt:near32
extern primitiveIndirectSWORDAtPut:near32
extern primitiveByteAtAddress:near32
extern primitiveByteAtAddressPut:near32

primitiveQWORDAt EQU ?primitiveQWORDAt@Interpreter@@CIPAIQAI@Z
extern primitiveQWORDAt:near32
primitiveSQWORDAt EQU ?primitiveSQWORDAt@Interpreter@@CIPAIQAI@Z
extern primitiveSQWORDAt:near32

; Imports from ExternalCall.asm
extern primitiveDLL32Call:near32
extern primitiveVirtualCall:near32

; Imports from SmallIntPrim.asm
extern primitiveAdd:near32
extern primitiveSubtract:near32
extern primitiveLessThan:near32
extern primitiveGreaterThan:near32
extern primitiveLessOrEqual:near32
extern primitiveGreaterOrEqual:near32
extern primitiveEqual:near32
;extern primitiveNotEqual:near32
extern primitiveMultiply:near32
extern primitiveDivide:near32
extern primitiveMod:near32
extern primitiveDiv:near32
extern primitiveQuoAndRem:near32
extern primitiveQuo:near32
extern primitiveBitAnd:near32
extern primitiveAnyMask:near32
extern primitiveAllMask:near32
extern primitiveBitOr:near32
extern primitiveBitXor:near32
extern primitiveBitShift:near32
extern primitiveSmallIntegerAt:near32
extern primitiveHighBit:near32
extern primitiveLowBit:near32

; Imports from LargeIntPrim.CPP

normalizeIntermediateResult EQU ?normalizeIntermediateResult@@YGII@Z
extern normalizeIntermediateResult:near32

; C++ Variable imports
CALLBACKSPENDING EQU ?m_nCallbacksPending@Interpreter@@0IA
extern CALLBACKSPENDING:DWORD

CURRENTCALLBACK EQU ?currentCallbackContext@@3IA
extern CURRENTCALLBACK:DWORD

; C++ Primitive method imports
primitiveClass EQU ?primitiveClass@Interpreter@@CIPAIQAI@Z
extern primitiveClass:near32
primitiveSize EQU ?primitiveSize@Interpreter@@CIPAIQAI@Z
extern primitiveSize:near32
primitiveIsKindOf EQU ?primitiveIsKindOf@Interpreter@@CIPAIQAI@Z
extern primitiveIsKindOf:near32
primitiveIdentical EQU ?primitiveIdentical@Interpreter@@CIPAIQAI@Z
extern primitiveIdentical:near32
primitiveShallowCopy EQU ?primitiveShallowCopy@Interpreter@@CIPAIQAI@Z
extern primitiveShallowCopy:near32
primitiveAllInstances EQU ?primitiveAllInstances@Interpreter@@CIPAIQAI@Z
extern primitiveAllInstances:near32
primitiveAllSubinstances EQU ?primitiveAllSubinstances@Interpreter@@CIPAIQAI@Z
extern primitiveAllSubinstances:near32
primitiveInstanceCounts EQU ?primitiveInstanceCounts@Interpreter@@CIPAIQAI@Z
extern primitiveInstanceCounts:near32
primitiveNext EQU ?primitiveNext@Interpreter@@CIPAIQAI@Z
extern primitiveNext:near32
primitiveNextSDWORD EQU ?primitiveNextSDWORD@Interpreter@@CIPAIQAI@Z
extern primitiveNextSDWORD:near32
primitiveNextPut EQU ?primitiveNextPut@Interpreter@@CIPAIQAI@Z
extern primitiveNextPut:near32
primitiveNextPutAll EQU ?primitiveNextPutAll@Interpreter@@CIPAIQAI@Z	
extern primitiveNextPutAll:near32
primitiveAtEnd EQU ?primitiveAtEnd@Interpreter@@CIPAIQAI@Z
extern primitiveAtEnd:near32

primitiveValueWithArgs EQU ?primitiveValueWithArgs@Interpreter@@CIPAIQAI@Z
extern primitiveValueWithArgs:near32
primitivePerform EQU ?primitivePerform@Interpreter@@CIPAIQAII@Z
extern primitivePerform:near32
primitivePerformWithArgs EQU ?primitivePerformWithArgs@Interpreter@@CIPAIQAI@Z
extern primitivePerformWithArgs:near32
primitivePerformMethod EQU ?primitivePerformMethod@Interpreter@@CIPAIQAI@Z
extern primitivePerformMethod:near32
primitivePerformWithArgsAt EQU ?primitivePerformWithArgsAt@Interpreter@@CIPAIQAI@Z
extern primitivePerformWithArgsAt:near32
primitiveValueWithArgsAt EQU ?primitiveValueWithArgsAt@Interpreter@@CIPAIQAI@Z
extern primitiveValueWithArgsAt:near32
primitiveVariantValue EQU ?primitiveVariantValue@Interpreter@@CIPAIQAI@Z
extern primitiveVariantValue:near32

PRIMUNWINDINTERRUPT EQU ?primitiveUnwindInterrupt@Interpreter@@CIPAIQAI@Z
extern PRIMUNWINDINTERRUPT:near32

RESUSPENDACTIVEON EQU ?ResuspendActiveOn@Interpreter@@SIPAV?$TOTE@VLinkedList@ST@@@@PAV2@@Z
extern RESUSPENDACTIVEON:near32

RESCHEDULE EQU ?Reschedule@Interpreter@@SGHXZ
extern RESCHEDULE:near32

primitiveSignal EQU ?primitiveSignal@Interpreter@@CIPAIQAI@Z
extern primitiveSignal:near32

primitiveSetSignals EQU ?primitiveSetSignals@Interpreter@@CIPAIQAI@Z
extern primitiveSetSignals:near32
primitiveSignalAtTick EQU ?primitiveSignalAtTick@Interpreter@@CIPAIQAI@Z
extern primitiveSignalAtTick:near32
primitiveInputSemaphore EQU ?primitiveInputSemaphore@Interpreter@@CIPAIQAI@Z
extern primitiveInputSemaphore:near32
primitiveSampleInterval EQU ?primitiveSampleInterval@Interpreter@@CIPAIQAI@Z
extern primitiveSampleInterval:near32

PRIMITIVEWAIT EQU ?primitiveWait@Interpreter@@CIPAIQAI@Z
extern PRIMITIVEWAIT:near32

primitiveFlushCache EQU ?primitiveFlushCache@Interpreter@@CIPAIQAI@Z
extern primitiveFlushCache:near32

PRIMITIVERESUME EQU ?primitiveResume@Interpreter@@CIPAIQAII@Z
extern PRIMITIVERESUME:near32

PRIMITIVESINGLESTEP EQU ?primitiveSingleStep@Interpreter@@CIPAIQAII@Z
extern PRIMITIVESINGLESTEP:near32

primitiveSuspend EQU ?primitiveSuspend@Interpreter@@CIPAIQAI@Z
extern primitiveSuspend:near32
primitiveTerminateProcess EQU ?primitiveTerminateProcess@Interpreter@@CIPAIQAI@Z
extern primitiveTerminateProcess:near32
primitiveProcessPriority EQU ?primitiveProcessPriority@Interpreter@@CIPAIQAI@Z
extern primitiveProcessPriority:near32
primitiveSnapshot EQU ?primitiveSnapshot@Interpreter@@CIPAIQAI@Z
extern primitiveSnapshot:near32
primitiveReplaceBytes EQU ?primitiveReplaceBytes@Interpreter@@CIPAIQAI@Z
extern primitiveReplaceBytes:near32
primitiveIndirectReplaceBytes EQU ?primitiveIndirectReplaceBytes@Interpreter@@CIPAIQAI@Z
extern primitiveIndirectReplaceBytes :near32
primitiveReplacePointers EQU ?primitiveReplacePointers@Interpreter@@CIPAIQAI@Z
extern primitiveReplacePointers:near32
primitiveCoreLeft EQU ?primitiveCoreLeft@Interpreter@@CIPAIQAII@Z
extern primitiveCoreLeft:near32
primitiveQuit EQU ?primitiveQuit@Interpreter@@CIXQAI@Z
extern primitiveQuit:near32
primitiveOopsLeft EQU ?primitiveOopsLeft@Interpreter@@CIPAIQAI@Z
extern primitiveOopsLeft:near32
primitiveResize EQU ?primitiveResize@Interpreter@@CIPAIQAI@Z
extern primitiveResize:near32
primitiveNextIndexOfFromTo EQU ?primitiveNextIndexOfFromTo@Interpreter@@CIPAIQAI@Z
extern primitiveNextIndexOfFromTo:near32
primitiveDeQBereavement EQU ?primitiveDeQBereavement@Interpreter@@CIPAIQAI@Z
extern primitiveDeQBereavement:near32
primitiveHookWindowCreate EQU ?primitiveHookWindowCreate@Interpreter@@CIPAIQAI@Z
extern primitiveHookWindowCreate:near32

primitiveSmallIntegerPrintString EQU ?primitiveSmallIntegerPrintString@Interpreter@@CIPAIQAI@Z
extern primitiveSmallIntegerPrintString:near32

; Storage prims imported from memprim.cpp
primitiveNew EQU ?primitiveNew@Interpreter@@CIPAIQAI@Z
extern primitiveNew:near32
primitiveNewWithArg EQU ?primitiveNewWithArg@Interpreter@@CIPAIQAI@Z
extern primitiveNewWithArg:near32
primitiveNewPinned EQU ?primitiveNewPinned@Interpreter@@CIPAIQAI@Z
extern primitiveNewPinned:near32
primitiveNewInitializedObject EQU ?primitiveNewInitializedObject@Interpreter@@CIPAIPAII@Z
extern primitiveNewInitializedObject:near32
primitiveNewFromStack EQU ?primitiveNewFromStack@Interpreter@@CIPAIPAI@Z
extern primitiveNewFromStack:near32
primitiveNewVirtual EQU ?primitiveNewVirtual@Interpreter@@CIPAIQAI@Z
extern primitiveNewVirtual:near32

primitiveLargeIntegerNormalize EQU ?primitiveLargeIntegerNormalize@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerNormalize:near32
primitiveLargeIntegerBitInvert EQU ?primitiveLargeIntegerBitInvert@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerBitInvert:near32
primitiveLargeIntegerNegate EQU ?primitiveLargeIntegerNegate@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerNegate:near32
primitiveLargeIntegerDivide EQU ?primitiveLargeIntegerDivide@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerDivide:near32
primitiveLargeIntegerDiv EQU ?primitiveLargeIntegerDiv@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerDiv:near32
primitiveLargeIntegerMod EQU ?primitiveLargeIntegerMod@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerMod:near32
primitiveLargeIntegerQuoAndRem EQU ?primitiveLargeIntegerQuoAndRem@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerQuoAndRem:near32
primitiveLargeIntegerBitShift EQU ?primitiveLargeIntegerBitShift@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerBitShift:near32

primitiveLargeIntegerGreaterThan EQU ?primitiveLargeIntegerGreaterThan@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerGreaterThan:near32
primitiveLargeIntegerLessThan EQU ?primitiveLargeIntegerLessThan@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerLessThan:near32
primitiveLargeIntegerGreaterOrEqual EQU ?primitiveLargeIntegerGreaterOrEqual@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerGreaterOrEqual:near32
primitiveLargeIntegerLessOrEqual EQU ?primitiveLargeIntegerLessOrEqual@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerLessOrEqual:near32
primitiveLargeIntegerEqual EQU ?primitiveLargeIntegerEqual@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerEqual:near32

primitiveLargeIntegerAsFloat EQU ?primitiveLargeIntegerAsFloat@Interpreter@@CIPAIQAI@Z
extern primitiveLargeIntegerAsFloat:near32

primitiveAsyncDLL32Call EQU ?primitiveAsyncDLL32Call@Interpreter@@CIPAIPAXI@Z
extern primitiveAsyncDLL32Call:near32

primitiveAllReferences EQU ?primitiveAllReferences@Interpreter@@CIPAIQAI@Z
extern primitiveAllReferences:near32

IFDEF _DEBUG
	extern ?checkReferences@ObjectMemory@@SIXXZ:near32
ENDIF

; Other C++ method imports
NEWPOINTEROBJECT		EQU	?newPointerObject@ObjectMemory@@SIPAV?$TOTE@VVariantObject@ST@@@@PAV?$TOTE@VBehavior@ST@@@@I@Z
extern NEWPOINTEROBJECT:near32
NEWBYTEOBJECT			EQU	?newByteObject@ObjectMemory@@SIPAV?$TOTE@VVariantByteObject@ST@@@@PAV?$TOTE@VBehavior@ST@@@@I@Z
extern NEWBYTEOBJECT:near32
ALLOCATEBYTESNOZERO		EQU	?newUninitializedByteObject@ObjectMemory@@SIPAV?$TOTE@VVariantByteObject@ST@@@@PAV?$TOTE@VBehavior@ST@@@@I@Z
extern ALLOCATEBYTESNOZERO:near32

DQFORFINALIZATION EQU ?dequeueForFinalization@Interpreter@@CIPAV?$TOTE@VObject@ST@@@@XZ
extern DQFORFINALIZATION:near32

QUEUEINTERRUPT EQU ?queueInterrupt@Interpreter@@SGXPAV?$TOTE@VProcess@ST@@@@II@Z
extern QUEUEINTERRUPT:near32
ONEWAYBECOME EQU ?oneWayBecome@ObjectMemory@@SIXPAV?$TOTE@VObject@ST@@@@0@Z
extern ONEWAYBECOME:near32

OOPSUSED EQU ?OopsUsed@ObjectMemory@@SIHXZ
extern OOPSUSED:near32

YIELD EQU ?yield@Interpreter@@CIHXZ
extern YIELD:near32												; See process.cpp

PRIMSTRINGSEARCH EQU ?primitiveStringSearch@Interpreter@@CIPAIQAI@Z
extern PRIMSTRINGSEARCH:near32

primitiveStringNextIndexOfFromTo EQU ?primitiveStringNextIndexOfFromTo@Interpreter@@CIPAIQAI@Z
extern primitiveStringNextIndexOfFromTo:near32
primitiveStringAt EQU ?primitiveStringAt@Interpreter@@CIPAIPAI@Z
extern primitiveStringAt:near32
primitiveStringAtPut EQU ?primitiveStringAtPut@Interpreter@@CIPAIPAI@Z
extern primitiveStringAtPut:near32
primitiveStringCollate EQU ?primitiveStringCollate@Interpreter@@CIPAIQAI@Z
extern primitiveStringCollate:near32
primitiveStringCmp EQU ?primitiveStringCmp@Interpreter@@CIPAIQAI@Z
extern primitiveStringCmp:near32
primitiveBytesEqual EQU ?primitiveBytesEqual@Interpreter@@CIPAIQAI@Z
extern primitiveBytesEqual:near32

; Note this function returns 'bool', i.e. single byte in al; doesn't necessarily set whole of eax
DISABLEINTERRUPTS EQU ?disableInterrupts@Interpreter@@SI_N_N@Z
extern DISABLEINTERRUPTS:near32

primitiveStackAtPut EQU ?primitiveStackAtPut@Interpreter@@CIPAIQAI@Z
extern primitiveStackAtPut:near32

primitiveMillisecondClockValue EQU  ?primitiveMillisecondClockValue@Interpreter@@CIPAIQAI@Z
extern primitiveMillisecondClockValue:near32

primitiveMicrosecondClockValue EQU  ?primitiveMicrosecondClockValue@Interpreter@@CIPAIQAI@Z
extern primitiveMicrosecondClockValue:near32

primitiveBasicIdentityHash EQU ?primitiveBasicIdentityHash@Interpreter@@CIPAIQAI@Z
extern primitiveBasicIdentityHash:near32
primitiveIdentityHash EQU ?primitiveIdentityHash@Interpreter@@CIPAIQAI@Z
extern primitiveIdentityHash:near32
primitiveHashBytes EQU ?primitiveHashBytes@Interpreter@@CIPAIQAI@Z
extern primitiveHashBytes:near32
primitiveLookupMethod EQU ?primitiveLookupMethod@Interpreter@@CIPAIQAI@Z
extern primitiveLookupMethod:near32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Constants
;; Table of primitives for normal primitive dispatching
.DATA
ALIGN 16
_primitivesTable DD			primitiveActivateMethod			; case 0
DWORD		primitiveReturnSelf								; case 1
DWORD		primitiveReturnTrue								; case 2	
DWORD		primitiveReturnFalse							; case 3
DWORD		primitiveReturnNil								; case 4	
DWORD		primitiveReturnLiteralZero						; case 5
DWORD		primitiveReturnInstVar							; case 6
DWORD		primitiveSetInstVar								; case 7
DWORD		primitiveReturnStaticZero						; case 8	Was SmallInteger>>~= (redundant)
DWORD		primitiveMultiply								; case 9
DWORD		primitiveDivide									; case 10
DWORD		primitiveMod									; case 11
DWORD		primitiveDiv									; case 12
DWORD		primitiveQuoAndRem								; case 13
DWORD		primitiveSubtract								; case 14
DWORD		primitiveAdd									; case 15
DWORD		primitiveEqual									; case 16
DWORD		primitiveGreaterOrEqual							; case 17
DWORD		primitiveLessThan								; case 18	Number>>#@
DWORD		primitiveGreaterThan							; case 19	Not Used in Smalltalk-80
DWORD		primitiveLessOrEqual							; case 20	Not used in Smalltalk-80
DWORD		primitiveLargeIntegerAdd						; case 21	LargeInteger>>#+
DWORD		primitiveLargeIntegerSub						; case 22	LargeInteger>>#-
DWORD		primitiveLargeIntegerLessThan					; case 23	LargeInteger>>#<
DWORD		primitiveLargeIntegerGreaterThan				; case 24	LargeInteger>>#>
DWORD		primitiveLargeIntegerLessOrEqual				; case 25	LargeInteger>>#<=
DWORD		primitiveLargeIntegerGreaterOrEqual				; case 26	LargeInteger>>#>=
DWORD		primitiveLargeIntegerEqual						; case 27	LargeInteger>>#=
DWORD		primitiveLargeIntegerNormalize					; case 28	LargeInteger>>normalize. LargeInteger>>#~= in Smalltalk-80 (redundant)
DWORD		primitiveLargeIntegerMul						; case 29	LargeInteger>>#*
DWORD		primitiveLargeIntegerDivide						; case 30	LargeInteger>>#/
DWORD		primitiveLargeIntegerMod						; case 31	LargeInteger>>#\\
DWORD		primitiveLargeIntegerDiv						; case 32	LargeInteger>>#//
DWORD		primitiveLargeIntegerQuoAndRem					; case 33	Was LargeInteger>>#quo:
DWORD		primitiveLargeIntegerBitAnd						; case 34	LargeInteger>>#bitAnd:
DWORD		primitiveLargeIntegerBitOr						; case 35	LargeInteger>>#bitOr:
DWORD		primitiveLargeIntegerBitXor						; case 36	LargeInteger>>#bitXor:
DWORD		primitiveLargeIntegerBitShift					; case 37	LargeInteger>>#bitShift
DWORD		primitiveLargeIntegerBitInvert					; case 38	Not used in Smalltalk-80
DWORD		primitiveLargeIntegerNegate						; case 39	Not used in Smalltalk-80
DWORD		primitiveBitAnd									; case 40	SmallInteger>>asFloat
DWORD		primitiveBitOr									; case 41	Float>>#+
DWORD		primitiveBitXor									; case 42	Float>>#-
DWORD		primitiveBitShift								; case 43	Float>>#<
DWORD		primitiveSmallIntegerPrintString				; case 44	Float>>#> in Smalltalk-80
DWORD		primitiveFloatGT								; case 45	Float>>#<= in Smalltalk-80
DWORD		primitiveFloatGE								; case 46	Float>>#>= in Smalltalk-80
DWORD		primitiveFloatEQ								; case 47	Float>>#= in Smalltalk-80
DWORD		primitiveAsyncDLL32CallThunk					; case 48	Float>>#~= in Smalltalk-80
DWORD		primitiveBasicAt								; case 49	Float>>#* in Smalltalk-80
DWORD		primitiveBasicAtPut								; case 50	Float>>#/ in Smalltalk-80
DWORD		primitiveStringCmp								; case 51	Float>>#truncated
DWORD		primitiveStringNextIndexOfFromTo				; case 52	Float>>#fractionPart in Smalltalk-80
DWORD		primitiveQuo									; case 53	Float>>#exponent in Smalltalk-80
DWORD		primitiveHighBit								; case 54	Float>>#timesTwoPower: in Smalltalk-80
DWORD		primitiveBytesEqual								; case 55	Not used in Smalltalk-80
DWORD		primitiveStringCollate							; case 56
DWORD		primitiveIsKindOf								; case 57	Not used in Smalltalk-80
DWORD		primitiveAllSubinstances						; case 58	Not used in Smalltalk-80
DWORD		primitiveNextIndexOfFromTo						; case 59	Not used in Smalltalk-80
DWORD		primitiveBasicAt								; case 60	Note that the #at: primitive is now the same as #basicAt:
DWORD		primitiveBasicAtPut								; case 61	
DWORD		primitiveSize									; case 62	LargeInteger>>#digitLength
DWORD		primitiveStringAt								; case 63	
DWORD		primitiveStringAtPut							; case 64
DWORD		primitiveNext									; case 65	
DWORD		primitiveNextPut								; case 66
DWORD		primitiveAtEnd									; case 67
DWORD		primitiveReturnFromInterrupt					; case 68	Was CompiledMethod>>#objectAt: (reserve for upTo:)
DWORD		primitiveSetSpecialBehavior						; case 69	Was CompiledMethod>>#objectAt:put:
DWORD		primitiveNew									; case 70	
DWORD		primitiveNewWithArg								; case 71
DWORD		primitiveBecome									; case 72
DWORD		primitiveInstVarAt								; case 73
DWORD		primitiveInstVarAtPut							; case 74
DWORD		primitiveBasicIdentityHash						; case 75	Object>>basicIdentityHash
DWORD		primitiveNewPinned								; case 76
DWORD		primitiveAllInstances							; case 77	was Behavior>>someInstance
DWORD		primitiveReturn									; case 78	was Object>>nextInstance
DWORD		primitiveValueOnUnwind							; case 79	CompiledMethod class>>newMethod:header:
DWORD		primitiveVirtualCall							; case 80	Was ContextPart>>blockCopy:
DWORD		primitiveValue									; case 81
DWORD		primitiveValueWithArgsThunk						; case 82
DWORD		primitivePerformThunk							; case 83
DWORD		primitivePerformWithArgsThunk					; case 84
DWORD		primitiveSignalThunk							; case 85
DWORD		primitiveWaitThunk								; case 86	N.B. DON'T CHANGE, ref'd from signalSemaphore() in process.cpp 
DWORD		primitiveResumeThunk							; case 87
DWORD		primitiveSuspendThunk							; case 88
DWORD		primitiveFlushCache								; case 89	Behavior>>flushCache
DWORD		primitiveNewVirtual								; case 90	Was InputSensor>>primMousePt, InputState>>primMousePt
DWORD		primitiveTerminateThunk							; case 91	Was InputState>>primCursorLocPut:, InputState>>primCursorLocPutAgain:
DWORD		primitiveProcessPriorityThunk					; case 92	Was Cursor class>>cursorLink:
DWORD		primitiveInputSemaphore							; case 93	Is InputState>>primInputSemaphore:
DWORD		primitiveSampleInterval							; case 94	Is InputState>>primSampleInterval:
DWORD		primitiveEnableInterrupts						; case 95	Was InputState>>primInputWord
DWORD		primitiveDLL32Call								; case 96	Was BitBlt>>copyBits
DWORD		primitiveSnapshot								; case 97	Is SystemDictionary>>snapshotPrimitive
DWORD		primitiveQueueInterrupt							; case 98	Was Time class>>secondClockInto:
DWORD		primitiveSetSignalsThunk						; case 99	Was Time class>>millisecondClockInto:
DWORD		primitiveSignalAtTickThunk						; case 100	Is ProcessorScheduler>>signal:atMilliseconds:
DWORD		primitiveResize									; case 101	Was Cursor>>beCursor
DWORD		primitiveChangeBehavior							; case 102	Was DisplayScreen>>beDisplay
DWORD		primitiveAddressOf								; case 103	Was CharacterScanner>>scanCharactersFrom:to:in:rightX:stopConditions:di_SPlaying:
DWORD		primitiveReturnFromCallback						; case 104	Was BitBlt drawLoopX:Y:
DWORD		primitiveSingleStepThunk						; case 105
DWORD		primitiveHashBytes								; case 106	Not used in Smalltalk-80
DWORD		primitiveUnwindCallback							; case 107	ProcessorScheduler>>primUnwindCallback
DWORD		primitiveHookWindowCreate						; case 108	Not used in Smalltalk-80
DWORD		unusedPrimitive									; case 109	Not used in Smalltalk-80
DWORD		primitiveIdentical								; case 110	Character =, Object ==
DWORD		primitiveClass									; case 111	Object class
DWORD		primitiveCoreLeftThunk							; case 112	Was SystemDictionary>>coreLeft - This is now the basic, non-compacting, incremental, garbage collect
DWORD		primitiveQuit									; case 113	SystemDictionary>>quitPrimitive
DWORD		primitivePerformWithArgsAtThunk					; case 114	SystemDictionary>>exitToDebugger
DWORD		primitiveOopsLeftThunk							; case 115	SystemDictionary>>oopsLeft - Use this for a compacting garbage collect
DWORD		primitivePerformMethodThunk						; case 116	This was primitiveSignalAtOopsLeftWordsLeft (low memory signal)
DWORD		primitiveValueWithArgsAtThunk					; case 117	Not used in Smalltalk-80
DWORD		primitiveDeQForFinalize							; case 118	Not used in Smalltalk-80 - Dequeue an object from the VM's finalization queue
DWORD		primitiveDeQBereavement							; case 119	Not used in Smalltalk-80 - Dequeue a weak object which has new Corpses and notify it
DWORD		primitiveDWORDAt								; case 120	Not used in Smalltalk-80
DWORD		primitiveDWORDAtPut								; case 121	Not used in Smalltalk-80
DWORD		primitiveSDWORDAt								; case 122	Not used in Smalltalk-80
DWORD		primitiveSDWORDAtPut							; case 123	Not used in Smalltalk-80
DWORD		primitiveWORDAt									; case 124	Not used in Smalltalk-80
DWORD		primitiveWORDAtPut								; case 125	Not used in Smalltalk-80
DWORD		primitiveSWORDAt								; case 126	Not used in Smalltalk-80
DWORD		primitiveSWORDAtPut								; case 127	Not used in Smalltalk-80

;; Smalltalk-80 used 7-bits for primitive numbers, so last was 127

DWORD		primitiveDoublePrecisionFloatAt					; case 128
DWORD		primitiveDoublePrecisionFloatAtPut				; case 129
DWORD		primitiveSinglePrecisionFloatAt					; case 130
DWORD		primitiveSinglePrecisionFloatAtPut				; case 131
DWORD		primitiveByteAtAddress							; case 132
DWORD		primitiveByteAtAddressPut						; case 133
DWORD		primitiveIndirectDWORDAt						; case 134
DWORD		primitiveIndirectDWORDAtPut						; case 135
DWORD		primitiveIndirectSDWORDAt						; case 136
DWORD		primitiveIndirectSDWORDAtPut					; case 137
DWORD		primitiveIndirectWORDAt							; case 138
DWORD		primitiveIndirectWORDAtPut						; case 139
DWORD		primitiveIndirectSWORDAt						; case 140
DWORD		primitiveIndirectSWORDAtPut						; case 141
DWORD		primitiveReplaceBytes							; case 142
DWORD		primitiveIndirectReplaceBytes					; case 143
DWORD		primitiveNextSDWORD								; case 144
DWORD		primitiveAnyMask								; case 145
DWORD		primitiveAllMask								; case 146
DWORD		primitiveIdentityHash							; case 147
DWORD		primitiveLookupMethod							; case 148
DWORD		PRIMSTRINGSEARCH								; case 149
DWORD		primitiveUnwindInterruptThunk					; case 150
DWORD		primitiveExtraInstanceSpec						; case 151
DWORD		primitiveLowBit									; case 152
DWORD		primitiveAllReferences							; case 153
DWORD		primitiveOneWayBecome							; case 154
DWORD		primitiveShallowCopy							; case 155
DWORD		primitiveYield									; case 156
DWORD		primitiveNewInitializedObject					; case 157
DWORD		primitiveSmallIntegerAt							; case 158
DWORD		primitiveLongDoubleAt							; case 159
DWORD		primitiveFloatAdd								; case 160
DWORD		primitiveFloatSub								; case 161
DWORD		primitiveFloatLT								; case 162
DWORD		primitiveFloatEQ								; case 163
DWORD		primitiveFloatMul								; case 164
DWORD		primitiveFloatDiv								; case 165
DWORD		primitiveTruncated								; case 166
DWORD		primitiveLargeIntegerAsFloat					; case 167
DWORD		primitiveAsFloat								; case 168
DWORD		primitiveObjectCount							; case 169
DWORD		primitiveStructureIsNull						; case 170
DWORD		primitiveBytesIsNull							; case 171
DWORD		primitiveVariantValue							; case 172
DWORD		primitiveNextPutAll								; case 173
DWORD		primitiveMillisecondClockValue					; case 174
DWORD		primitiveIndexOfSP								; case 175
DWORD		primitiveStackAtPut								; case 176
DWORD		primitiveGetImmutable							; case 177
DWORD		primitiveSetImmutable							; case 178
DWORD		primitiveInstanceCounts							; case 179
DWORD		primitiveDWORDAt								; case 180	Will be primitiveUIntPtrAt
DWORD		primitiveDWORDAtPut								; case 181	Will be primitiveUIntPtrAtPut
DWORD		primitiveSDWORDAt								; case 182	Will be primitiveIntPtrAt
DWORD		primitiveSDWORDAtPut							; case 183	Will be primitiveIntPtrAtPut
DWORD		primitiveIndirectDWORDAt						; case 184  Will be primitiveIndirectUIntPtrAt
DWORD		primitiveIndirectDWORDAtPut						; case 185  Will be primitiveIndirectUIntPtrAtPut
DWORD		primitiveIndirectSDWORDAt						; case 186  Will be primitiveIndirectIntPtrAt
DWORD		primitiveIndirectSDWORDAtPut					; case 187  Will be primitiveIndirectIntPtrAtPut
DWORD		primitiveReplacePointers						; case 188
DWORD		primitiveMicrosecondClockValue					; case 189
DWORD		primitiveNewFromStack							; case 190
DWORD		primitiveQWORDAt								; case 191
DWORD		primitiveSQWORDAt								; case 192
DWORD		primitiveFloatSin								; case 193
DWORD		primitiveFloatTan								; case 194
DWORD		primitiveFloatCos								; case 195
DWORD		primitiveFloatArcSin							; case 196
DWORD		primitiveFloatArcTan							; case 197
DWORD		primitiveFloatArcCos							; case 198
DWORD		primitiveFloatArcTan2							; case 199
DWORD		primitiveFloatLog								; case 200
DWORD		primitiveFloatExp								; case 201
DWORD		primitiveFloatSqrt								; case 202
DWORD		primitiveFloatLog10								; case 203
DWORD		primitiveFloatTimesTwoPower						; case 204
DWORD		primitiveFloatAbs								; case 205
DWORD		primitiveFloatRaisedTo							; case 206
DWORD		primitiveFloatFloor								; case 207
DWORD		primitiveFloatCeiling							; case 208
DWORD		primitiveFloatExponent							; case 209
DWORD		primitiveFloatNegated							; case 210
DWORD		primitiveFloatClassify							; case 211
DWORD		primitiveFloatFractionPart						; case 212
DWORD		primitiveFloatIntegerPart						; case 213
DWORD		primitiveFloatLE								; case 214
DWORD		unusedPrimitive									; case 215
DWORD		unusedPrimitive									; case 216
DWORD		unusedPrimitive									; case 217
DWORD		unusedPrimitive									; case 218
DWORD		unusedPrimitive									; case 219
DWORD		unusedPrimitive									; case 220
DWORD		unusedPrimitive									; case 221
DWORD		unusedPrimitive									; case 222
DWORD		unusedPrimitive									; case 223
DWORD		unusedPrimitive									; case 224
DWORD		unusedPrimitive									; case 225
DWORD		unusedPrimitive									; case 226
DWORD		unusedPrimitive									; case 227
DWORD		unusedPrimitive									; case 228
DWORD		unusedPrimitive									; case 229
DWORD		unusedPrimitive									; case 230
DWORD		unusedPrimitive									; case 231
DWORD		unusedPrimitive									; case 232
DWORD		unusedPrimitive									; case 233
DWORD		unusedPrimitive									; case 234
DWORD		unusedPrimitive									; case 235
DWORD		unusedPrimitive									; case 236
DWORD		unusedPrimitive									; case 237
DWORD		unusedPrimitive									; case 238
DWORD		unusedPrimitive									; case 239
DWORD		unusedPrimitive									; case 240
DWORD		unusedPrimitive									; case 241
DWORD		unusedPrimitive									; case 242
DWORD		unusedPrimitive									; case 243
DWORD		unusedPrimitive									; case 244
DWORD		unusedPrimitive									; case 245
DWORD		unusedPrimitive									; case 246
DWORD		unusedPrimitive									; case 247
DWORD		unusedPrimitive									; case 248
DWORD		unusedPrimitive									; case 249
DWORD		unusedPrimitive									; case 250
DWORD		unusedPrimitive									; case 251
DWORD		unusedPrimitive									; case 252
DWORD		unusedPrimitive									; case 253
DWORD		unusedPrimitive									; case 254
DWORD		unusedPrimitive									; case 255

IFDEF _DEBUG
	_primitiveCounters DD	256 DUP (0)
	public _primitiveCounters
ENDIF

.CODE PRIM_SEG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedures

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; System Primitives


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; String/variable byte objects primitives

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BOOL __fastcall Interpreter::primitiveBasicAt()
;;
;; Primitive for getting elements of indexed objects
;;
;; The receiver MUST not be a SmallInteger, or a crash will result when attempting
;; the line marked with a '*'
;;
BEGINPRIMITIVE primitiveBasicAt
	mov		ecx, [_SP-OOPSIZE]					; Access receiver under argument
	mov		edx, [_SP]							; Load argument from stack
   	ASSUME	ecx:PTR OTE							; ecx is pointer to receiver for rest of primitive

	sar		edx, 1								; Argument is a SmallInteger?
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger, primitive failure 0
	jle		localPrimitiveFailure1

	mov		eax, [ecx].m_oteClass				; Get class Oop from OTE into EAX for later use
	ASSUME	eax:PTR OTE

	test	[ecx].m_flags, MASK m_pointer		; Test pointer bit of object table entry
	jz		byteObjectAt						; Contains bytes? Yes, skip to byte access code

pointerAt:
	; ASSUME ecx:PTR OTE						; ECX is receiver Oop
	; ASSUME eax:PTR OTE						; EAX is class Oop
	; ASSUEM edx:DWORD							; EDX is offset

	; Array of pointers?

	mov		ecx, [ecx].m_size					; Load size into ecx (not overwriting receiver Oop)
	ASSUME	ecx:DWORD

	mov		eax, [eax].m_location				; Load address of class object into eax from OTE at eax
	ASSUME	eax:PTR Behavior
	
	and		ecx, 7fffffffh						; Mask out the immutability bit
	shr		ecx, 2								; ecx = total Oop size
	
	mov		eax, [eax].m_instanceSpec			; Load Instancespecification into edx
	ASSUME	eax:DWORD

	and		eax, MASK m_fixedFields				; Mask off flags
	shr		eax, 1								; Convert from SmallInteger
	add		edx, eax							; Add fixed offset for inst vars

	cmp		edx, ecx							; Index <= size (still in ecx)?

	mov		ecx, [_SP-OOPSIZE]					; Reload receiver into ecx
	ASSUME 	ecx:PTR OTE

	ja		localPrimitiveFailure1				; No, out of bounds

	mov		eax, [ecx].m_location				; Reload address of receiver into eax
	
	mov		eax, [eax+edx*OOPSIZE-OOPSIZE]		; Load Oop of element at required index
	mov		[_SP-OOPSIZE], eax					; And overwrite receiver in stack with it
	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)

	ret
	
byteObjectAt:
	ASSUME	ecx:PTR OTE							; ECX is Oop of receiver, but not needed
	ASSUME	edx:DWORD							; EDX is the index
	ASSUME	eax:PTR OTE							; EAX is the Oop of the receiver's class

	mov		eax, [ecx].m_location				; Load object address into eax
	ASSUME	eax:PTR ByteArray					; EAX points at receiver

	mov		ecx, [ecx].m_size					
	and		ecx, 7fffffffh						; Mask out the immutability bit
	
	cmp		edx, ecx							; Index out of bounds (>= size) ?
	ja		localPrimitiveFailure1				; 
	
	movzx	ecx, BYTE PTR[eax+edx-1]			; Load required byte, zero extending

	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	lea		ecx, [ecx+ecx+1]					; Convert to SmallInteger
	mov		[_SP-OOPSIZE], ecx					; Overwrite receiver with result. 
	ret

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1

ENDPRIMITIVE primitiveBasicAt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BOOL __fastcall Interpreter::primitiveInstVarAt()
;;
;; Primitive for getting elements of objects
;;
BEGINPRIMITIVE primitiveInstVarAt
	mov		ecx, [_SP-OOPSIZE]					; Access receiver under argument
	mov		edx, [_SP]							; Load argument from stack
	sar		edx, 1								; Argument is a SmallInteger?
   	ASSUME	ecx:PTR OTE							; ecx is pointer to receiver for rest of primitive
	jnc		localPrimitiveFailure0				; Arg not a SmallInteger, primitive failure 0
	jle		localPrimitiveFailure1				; Arg <= 0?

	mov		eax, [ecx].m_location				; Load object address into eax *Will fail if receiver is SmallInteger*
	ASSUME	eax:PTR VariantObject
				     	
	test	[ecx].m_flags, MASK m_pointer		; Test pointer bit of object table entry
	jz		byteObjectAt						; Contains pointers? No, skip to byte access code

	; Array of pointers?
	mov		ecx, [ecx].m_size					; Load byte size into ECX
	and		ecx, 7fffffffh						; Mask out immutability (sign) bit
	shr		ecx, 2								; Div 4 gives pointer count
	cmp		edx, ecx							; index <= size?
	ja		localPrimitiveFailure1				; No, out of bounds (>=)

	mov		ecx, [eax].m_elements[edx*OOPSIZE-OOPSIZE]	; Load Oop from inst var
	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	mov		[_SP-OOPSIZE], ecx					; Overwrite receiver with inst var value

	ret

byteObjectAt:
	ASSUME	ecx:PTR OTE							; ECX is Oop of receiver, but not needed
	ASSUME	edx:DWORD							; EDX is the index
	ASSUME	eax:PTR OTE							; EAX is the Oop of the receiver's class

	mov		eax, [ecx].m_location				; Load object address into eax
	ASSUME	eax:PTR ByteArray					; EAX points at receiver

	mov		ecx, [ecx].m_size					
	and		ecx, 7fffffffh						; Mask out the immutability bit
	
	cmp		edx, ecx							; Index out of bounds (> size) ?
	ja		localPrimitiveFailure1				; 
	
	movzx	ecx, BYTE PTR[eax+edx-1]			; Load required byte, zero extending

	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	lea		ecx, [ecx+ecx+1]					; Convert to SmallInteger
	mov		[_SP-OOPSIZE], ecx					; Overwrite receiver with result. 
	ret

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1

ENDPRIMITIVE primitiveInstVarAt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	BOOL __fastcall Interpreter::primitiveBasicAtPut()
;;
;; Primitive for setting elements of indexed objects without using cache
;; This primitive answers its value argument, so it moves it down
;; the stack, overwriting the receiver. The other argument must be a
;; SmallInteger for the primitive to succeed.
;;
BEGINPRIMITIVE primitiveBasicAtPut
	mov		ecx, [_SP-OOPSIZE*2]				; Access receiver under arguments
	mov		edx, [_SP-OOPSIZE]					; Load index argument from stack
	ASSUME	ecx:PTR OTE

	sar		edx, 1								; Argument is a SmallInteger?
	jnc		localPrimitiveFailure0 				; No, primitive failure
	jle		localPrimitiveFailure1				; Index <= 0?

	test	[ecx].m_flags, MASK m_pointer		; Pointer object?
	jz		byteObjectAtPut						; No, skip to code for storing bytes

	mov		eax, [ecx].m_oteClass				; Get class Oop	from OTE into eax
	ASSUME	eax:PTR OTE
	
	mov		ecx, [ecx].m_size					; Load size into ecx (negative if immutable)
	ASSUME	ecx:SDWORD
	sar		ecx, 2								; ecx = total Oop size

	mov		eax, [eax].m_location				; Load address of class object into eax
	ASSUME	eax:PTR Behavior

	mov		eax, [eax].m_instanceSpec			; Load Instancespecification flags into edx
	ASSUME	eax:DWORD

	and		eax, MASK m_fixedFields				; Mask off flags
	shr		eax, 1								; Convert from SmallInteger
	add		edx, eax							; Add fixed offset for inst vars to offset argument

	mov		eax, [_SP-OOPSIZE*2]				; Reload receiver under arguments
	ASSUME	eax:PTR OTE

	cmp		edx, ecx							; Index <= size (still in ecx)?

	mov		eax, [eax].m_location				; Reload address of receiver into eax
	ASSUME	eax:PTR VariantObject
	
	jg		localPrimitiveFailure1				; No, out of bounds
		
	lea		eax, [eax+edx*OOPSIZE-OOPSIZE]	

	mov		edx, [_SP]							; Reload value to write
	ASSUME	edx:PTR OTE

	; We must inc ref. count, as we are storing into a heap allocated object here
	CountUpOopIn <d>

	; Exchange Oop of overwritten value with new value
	mov		ecx, [eax]				 			; Load value to overwrite into ECX
	mov		[eax], edx							; and overwrite with new value in edx

	; Must count down overwritten value, as it was in a heap object slot
	CountDownOopIn <c>		

	; count down destroys eax, ecx, and edx

	mov		eax, [_SP]							; Reload new value into eax again
	mov		[_SP-OOPSIZE*2], eax				; And overwrite receiver in stack with new value

	lea		eax, [_SP-OOPSIZE*2]				; primitiveSuccess(2)
	ret

byteObjectAtPut:
	ASSUME	ecx:PTR OTE						; ECX is byte object Oop
	ASSUME	edx:DWORD						; EDX is index

	mov		eax, [ecx].m_location			; Load object address into eax
	ASSUME	eax:PTR ByteArray				; EAX is pointer to byte object

	cmp		edx, [ecx].m_size				; Compare index+HEADERSIZE with object size (latter -ve if immutable)
	jg		localPrimitiveFailure1			; Index out of bounds (>= size)

	mov		ecx, [_SP]						; Load value to store/return

	add		eax, edx
	ASSUME	eax:PTR BYTE
	ASSUME	edx:NOTHING						; EDX is now free

	mov		edx, ecx
	ASSUME	ecx:DWORD
	sar		ecx, 1							; Convert to real integer value
	jnc		localPrimitiveFailure2			; Not a SmallInteger

	cmp		ecx, 0FFh						; Too large?
	ja		localPrimitiveFailure2			; Used unsigned comparison for 0<=ecx<=255

	mov		[eax-1], cl						; Store byte into receiver
	ASSUME	eax:NOTHING

	lea		eax, [_SP-OOPSIZE*2]			; primitiveSuccess(2)
	mov		[_SP-OOPSIZE*2], edx			; ...and overwrite with value for return (still in EAX)

	ret

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1
LocalPrimitiveFailure 2

ENDPRIMITIVE primitiveBasicAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	BOOL __fastcall Interpreter::primitiveInstVarAtPut()
;;
;; Primitive for setting elements of any object
;;
BEGINPRIMITIVE primitiveInstVarAtPut
	mov		edx, [_SP-OOPSIZE]					; Load index argument from stack
	mov		ecx, [_SP-OOPSIZE*2]				; Access receiver under arguments
	ASSUME	ecx:PTR OTE

	sar		edx, 1								; Argument is a SmallInteger?
	jnc		localPrimitiveFailure0				; No, primitive failure
	jle		localPrimitiveFailure1

	mov		eax, [ecx].m_location				; Load object address into eax

	test	[ecx].m_flags, MASK m_pointer
	jz		byteObjectAtPut						; Skip to code for storing bytes

	; Array of pointers
	ASSUME	eax:PTR VariantObject

	mov		ecx, [ecx].m_size					; Load size into ecx (-ve if immutable)
	sar		ecx, 2								; ecx = total Oop size

	cmp		edx, ecx							; Index <= size (still in ecx)?
	jg		localPrimitiveFailure1				; No, out of bounds
	
	lea		eax, [eax].m_elements[edx*OOPSIZE-OOPSIZE]

	mov		edx, [_SP]							; Load value to write
	mov		ecx, [eax]							; Exchange Oop of overwritten value with new value
	mov		[eax], edx
	ASSUME	eax:NOTHING
	CountDownOopIn <c>							; Count down overwritten value

	; count down destroys eax, ecx, and edx
	mov		ecx, [_SP-OOPSIZE*2]				; Reload receiver
	mov		eax, [_SP]							; Reload new value into eax
	mov		[_SP-OOPSIZE*2], eax				; And overwrite receiver in stack with new value

	; Must count up arg, because written into a heap object
	CountUpOopIn <a>

	lea		eax, [_SP-OOPSIZE*2]				; primitiveSuccess(2)
	ret

byteObjectAtPut:
	ASSUME	ecx:PTR OTE						; ECX is byte object Oop
	ASSUME	edx:DWORD						; EDX is index
	ASSUME	eax:PTR ByteArray				; EAX is point to byte object

	cmp		edx, [ecx].m_size				; Compare offset+HEADERSIZE with object size (latter -ve if immutable)
	jg		localPrimitiveFailure1			; Index out of bounds (>= size)

	mov		ecx, [_SP]						; Load value to store from stack top
	ASSUME	ecx:DWORD

	add		eax, edx
	ASSUME	eax:PTR BYTE

	mov		edx, ecx						; EDX is now free, so store return value for later
	ASSUME	edx:DWORD

	sar		ecx, 1							; Convert value to real integer value
	jnc		localPrimitiveFailure2			; Not a SmallInteger

	cmp		ecx, 0FFh						; Too large?
	ja		localPrimitiveFailure2			; Used unsigned comparison for 0<=ecx<=255

	mov		[eax-1], cl						; Store byte into receiver
	ASSUME	eax:NOTHING

	lea		eax, [_SP-OOPSIZE*2]			; primitiveSuccess(2)
	mov		[_SP-OOPSIZE*2], edx			; ...and overwrite with value for return (still in EAX)

	ret

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1
LocalPrimitiveFailure 2

ENDPRIMITIVE primitiveInstVarAtPut


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Raise a special exception caught by the callback entry point routine - the result will still be on top
; of the stack
BEGINPRIMITIVE primitiveReturnFromCallback
	mov		eax, [_SP]								; Pop off the VM's callback cookie
	mov		ecx, [ACTIVEPROCESS]
	ASSUME	ecx:PTR Process

	mov		ecx, [ecx].m_callbackDepth				; Don't want to do anything if callbackDepth = 0
	cmp		ecx, 1									; Zero callbacks?
	je		fail									; Yes, then just fail the prim (no retry)

	cmp		eax, [CURRENTCALLBACK]					; Is it current callback?
	jne		@F										; No, skip longjmp

	sub		_SP, OOPSIZE							; Pop off the jmp_buf pointer
	xor		eax, 1									; Convert from a SmallInteger
	pushd	SE_VMCALLBACKEXIT						; Return SE_VMCALLBACKEXIT code as the setjmp retval
	mov		[STACKPOINTER], _SP						; Store down IP/SP for C++ we're about to jump back to
	mov		[INSTRUCTIONPOINTER], _IP
	
	pushd	eax										; &jmp_buf
	call	longjmp									; jump out back to C++ - cannot return here

@@:
	cmp		eax, SMALLINTZERO						; Passed zero?
	jne		failRetry								; No, then not current callback so need to retry it

	; Raise SE_VMCALLBACKEXIT exception
	sub		_SP, OOPSIZE
	pushd	eax										; Build "Array" of args on stack
	pushd	esp										; Push address of arg array
	pushd	1										; One argument (the VM's cookie)
	mov		[STACKPOINTER], _SP
	mov		[INSTRUCTIONPOINTER], _IP
	pushd	0										; No flags
	pushd	SE_VMCALLBACKEXIT						; User defined exception code
	call 	RaiseException

	; Push the cookie argument back on the stack
	pop		[_SP+OOPSIZE]
	add		_SP, OOPSIZE

	; The exception filter will specify continued execution if the current active process is not the
	; process active when the last callback was entered, so we fail the primitive. The backup Smalltalk
	; will yield and recursively try again
failRetry:
	inc		[CALLBACKSPENDING]						; VM needs to know callbacks waiting to exit
fail:
	xor		eax, eax
	ret
ENDPRIMITIVE primitiveReturnFromCallback


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Raise a special exception caught by the callback entry point routine and propagate
BEGINPRIMITIVE primitiveUnwindCallback
	mov		eax, [_SP]								; Pop off the VM's callback cookie
	mov		ecx, [ACTIVEPROCESS]
	ASSUME	ecx:PTR Process
	
	mov		ecx, [ecx].m_callbackDepth
	cmp		ecx, 1									; Zero callbacks?
	je		fail									; Yes, then just fail the prim (no retry)

	cmp		eax, [CURRENTCALLBACK]					; Otherwise only if current callback
	je		@F										; 
	cmp		eax, SMALLINTZERO
	jne		failRetry								; Not zero or current callback, so retry later

@@:
	sub		_SP, OOPSIZE										; Cookie is an Oop (actually SmallInteger _address_), but must NOT be ref. counted
	pushd	eax										; Build "Array" of args on stack
	pushd	esp										; Push address of arg array
	pushd	1										; One argument (the VM's cookie)
	mov		[STACKPOINTER], _SP						;  We must save down _SP as used by exception handler, 
	mov		[INSTRUCTIONPOINTER], _IP				; _IP needed if unwinding callbacks on termination
	pushd	0										; No flags
	pushd	20000001h								; User defined exception code for unwind
	call 	RaiseException
	
	; Note that the exception handler never executes handler, but may return here (if not continues search)

	; Push the cookie argument back on the stack
	pop		[_SP+OOPSIZE]
	add		_SP, OOPSIZE

	; The exception filter will specify continued execution if the current active process is not the
	; process active when the last callback was entered, so we fail the primitive. The backup Smalltalk
	; will yield and recursively try again
failRetry:
	inc		[CALLBACKSPENDING]						; VM needs to know callbacks waiting to exit
fail:
	xor		eax, eax
	ret
ENDPRIMITIVE primitiveUnwindCallback

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
	call	primitiveValue
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


IF 0
;; Under construction
?primitivePerformInterpreter@@CIPAIAAVCompiledMethod@ST@@I@Z:
	mov		eax, [MESSAGE]							; Load current message selector (#perform:???) ...
	push	eax										; ... and save in case need to restore
	lea		eax, [edx*4]
	neg		eax
	mov		ecx, [_SP+eax]							; Load receiver from stack
	mov		ecx, (OTE PTR[ecx]).m_location
	mov		ecx, (Object PTR[ecx]).m_class
	mov		eax, [_SP+eax+OOPSIZE]					; Load selector from stack
	mov		[MESSAGE], eax							; Store down as new message selector
	StoreSPRegister									; Save down stack pointer (in case of DNU)
	push	dl										; Save the arg count (0.255)
	call	FINDMETHODINCLASS
	pop		dl										; Pop off the saved arg count ...
	dec		dl										; ... and deduct 1 for the selector
	mov		_SP, [STACKPOINTER]						; Restore stack pointer (in case of does not understand)
	mov		ecx, (OTE PTR[eax]).m_location			; Load address of new method object into eax
	cmp		dl, (CompiledMethod PTR[ecx]).m_header.m_argumentCount	; Arg counts match ?
	je		@F										; Yes, ok to perform it
	mov		ecx, [MESSAGE]
	cmp		ecx, [Pointers.DoesNotUnderstandSelector]
	je		@F										; We also allow any doesNotUnderstand: to continue
	jmp		failPrimitivePerform					; Fail the primitive due to arg count mismatch
@@:
	;; So now we know the perform can proceed
	pop		ecx										; Pop off the #perform:??? selector

	;; We must reduce the arg count of the selector, because we're going
	;; to shuffle the args down over the top of it
	;; We can safely count down the selector by a simple decrement, since
	;; we know it can't go away (its a Symbol).
	mov		ecx, [MESSAGE]
	cmp		(OTE PTR[ecx]).m_count, 0ffh			; Overflowed - very unlikely?
	je		@F										; Yes, skip the decrement
	dec		(OTE PTR[ecx]).m_count
@@:
	;; Now we can shuffle the args down over the selector


failPrimitivePerform:
	pop		eax										; Pop off current message selector (#perform: or similar)
	mov		[MESSAGE], eax							; Restore old message selector into global
	xor		eax, eax								; Return FALSE
	ret

ENDIF

;  BOOL __fastcall Interpreter::primitiveObjectCount()
;
BEGINPRIMITIVE primitiveObjectCount
	call	OOPSUSED
	lea		ecx, [eax+eax+1]				; Convert result to SmallInteger
	mov		eax, _SP						; primitiveSuccess(0)
	mov		[_SP], ecx						; Overwrite receiver class with new object
	ret
ENDPRIMITIVE primitiveObjectCount

BEGINPRIMITIVE primitiveExtraInstanceSpec
	mov		ecx, [_SP]						; Load receiver class at stack top
	mov		edx, (OTE PTR[ecx]).m_location
	ASSUME	edx:PTR Behavior

	mov		ecx, [edx].m_instanceSpec
	shr		ecx, 15							; Shift to get the high 16 bits
	or		ecx, 1							; Set SmallInteger flag
	mov		eax, _SP						; primitiveSuccess(0)
	mov		[_SP], ecx						; Overwrite receiver class with new object (receiver's ref. count remains same)
	ret
ENDPRIMITIVE primitiveExtraInstanceSpec

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the special behavior bits of an object according to the mask
; Takes a SmallInteger argument, of which only the low order word is significant.
; The high order byte of the low order word specifies the AND mask, used to mask out bits,
; The low order byte of the low order word specifies the OR mask, used to mask in bits.
; The current value of the special behavior bits is then answered.
; The primitive ensures that the current values of bits which may affect the stability of the
; system cannot be modified.
; To query the current value of the special bits, pass in 16rFF00.
BEGINPRIMITIVE primitiveSetSpecialBehavior
	mov		edx, [_SP]							; Load integer mask argument
	sar		edx, 1								; Get the integer value
	jnc		localPrimitiveFailure0						; Not a SmallInteger
	
	; No other failures after this point
	mov		ecx, [_SP-OOPSIZE]					; Load Oop of receiver
	
	test	cl, 1
	jnz		localPrimitiveFailure1				; SmallIntegers can't have special behavior
	ASSUME ecx:PTR OTE							; ECX is now an Oop

	; Ensure the masks cannot affect the critical bits of the flags
	; dh, the AND mask, must have the pointer, mark, and free bits set, to keep these bits
	; dl, the OR mask, must have those bits reset so as not to add them
	or		dh, (MASK m_pointer OR MASK m_mark OR MASK m_free OR MASK m_space)
	and		dl, NOT (MASK m_pointer OR MASK m_mark OR MASK m_free OR MASK m_space)

	xor		eax, eax
	mov		al, [ecx].m_flags
	push	eax									; Save for later
	and		al, dh								; Mask out the desired bits
	or		al, dl								; Mask in the desired bits
	mov		[ecx].m_flags, al
	ASSUME	ecx:NOTHING
	pop		ecx
	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	lea		ecx, [ecx+ecx+1]					; Convert old mask to SmallInteger
	mov		[_SP-OOPSIZE], ecx					; Store old mask as return value

	ret

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1

ENDPRIMITIVE primitiveSetSpecialBehavior


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  BOOL __fastcall Interpreter::primitiveChangeBehavior()
;
; Receiver becomes an instance of the class specified as the argument - neither
; receiver or arg may be SmallIntegers, and the shape of the receivers current class
; must be identical to its new class.
;
BEGINPRIMITIVE primitiveChangeBehavior
	mov		edx, [_SP]								; Load arg Oop into edx
	test	dl, 1									; Is it a SmallInteger
	jnz		localPrimitiveFailure0					; Yes, fail it (must be a Class object)
	
	ASSUME	edx:PTR OTE								; Its an object

	; We must determine if the argument is a Class - get the head strap out and
	; then remember:
	;	A class' class is an instance of Metaclass (e.g. if we send #class to
	;	to Object, then we get the Metaclass instance 'Object class') THEREFORE
	; The class of the class of a Class is Metaclass!
	; Because of our use of an Object table, we've got 5 indirections here!
	
	mov		ecx, [edx].m_oteClass					; Load class Oop of new class into ecx
	ASSUME	ecx:PTR OTE

	mov		edx, (OTE PTR[edx]).m_location
	ASSUME	edx:PTR Behavior						; EDX is now pointer to new class object

	mov		ecx, [ecx].m_oteClass					; Load new Oop of class' class' class
	cmp		ecx, [Pointers.ClassMetaclass]			; Is the new class argument a class? (i.e. it's an instance of Metaclass)
	jne		localPrimitiveFailure1					; No not a class, fail the primitive

	; We have established that the argument is indeed a Class object, now
	; lets examine the receiver
	mov		eax, [_SP-OOPSIZE]						; Access receiver under class arg
	test	al, 1									; Receiver is a SmallInteger?
	jz		@F										; No, skip to normal object mutation

	; The receiver is a SmallInteger, and can be mutated to a variable byte object
	; which we have to allocate
	
	; Do instances of the new class contain pointers
	test    [edx].m_instanceSpec, MASK m_pointers
	jnz		localPrimitiveFailure2					; Yes, fail the primitive

	ASSUME	edx:NOTHING

	mov		ecx, [_SP]								; Reload Oop of new class
	sub		_SP, OOPSIZE
	ASSUME	ecx:PTR OTE
	
	mov		edx, SIZEOF DWORD				; 4-byte integer (32 bits)
	ASSUME	edx:DWORD

	call	ALLOCATEBYTESNOZERO
	ASSUME	eax:PTR OTE
	mov		edx, [_SP]						; Reload SmallInteger receiver before overwritten
	mov		[_SP], eax						; Replace SmallInteger at ToS receiver with new object
	mov		ecx, [eax].m_location			; Load address of new object
	ASSUME	ecx:PTR DWORDBytes
	sar		edx, 1							; Convert receiver to real integer value
	mov		[ecx].m_value, edx				; Save receivers integer value into new object
	AddToZct <a>
	mov		eax, _SP						; primitiveSuccess(0)
	ret
	ASSUME	eax:NOTHING

LocalPrimitiveFailure 0
LocalPrimitiveFailure 1

@@:
	;; The receiver is a non-immediate object

	ASSUME	edx:PTR Behavior					; EDX is still pointer to new class object
	ASSUME	eax:PTR OTE							; EAX is OTE of receiver

	;; The receiver is not a SmallInteger, check class shapes the same
	
	mov		ecx, [eax].m_oteClass				; Load class Oop of receiver into ecx
	ASSUME	ecx:PTR OTE

	mov		ecx, [ecx].m_location				; Load address of receiver's class into ecx
	ASSUME	ecx:PTR Behavior					; ECX is now pointer to the receiver's class

	; Compare instance _SPec. of receivers class with that of new class
	mov		ecx, [ecx].m_instanceSpec
	ASSUME	ecx:DWORD
	xor		ecx, [edx].m_instanceSpec			; Get shape differences into ecx

	test	ecx, SHAPEMASK						; Test to see if any significant bits differ
	jnz		localPrimitiveFailure2				; Some significant bits differenct, fail the primitive

	mov		edx, [_SP]							; Reload the new class Oop
	sub		_SP, OOPSIZE

	mov		ecx, [eax].m_oteClass				; Save current class Oop of receiver in ecx (ready for count down)
	mov		[eax].m_oteClass, edx				; Set new class of receiver (which is left on top of stack)
	
	; We must reduce the count on the class, since it has been overwritten in the object, and count up the new class
	CountUpObjectIn <d>
	CountDownObjectIn <c>
	
	mov		eax, _SP							; primitiveSuccess(0)

	ret

LocalPrimitiveFailure 2

ENDPRIMITIVE primitiveChangeBehavior

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
BEGINPRIMITIVE primitiveOneWayBecome
	mov		ecx, [_SP-OOPSIZE]
	mov		edx, [_SP]
	mov		eax, [OBJECTTABLE]
	test	cl, 1
	lea		eax, [eax+FIRSTCHAROFFSET+256*OTENTRYSIZE]
	jnz		localPrimitiveFailure0
	cmp		ecx, eax
	jl		localPrimitiveFailure0

	; oneWayBecome deallocates the become'd object, which flushes it from the at(put) caches
	call	ONEWAYBECOME

	lea		eax, [_SP-OOPSIZE]				; primitiveSuccess(1)
	ret

LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveOneWayBecome


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dequeue an entry from the finalization queue, and answer it. Answers nil if the queue is empty
BEGINPRIMITIVE primitiveDeQForFinalize
	call	DQFORFINALIZATION							; Answers nil, or an Oop with raised ref.count
	mov		[_SP], eax									; Overwrite TOS with answer, and count it down
	CountDownObjectIn <a>								; Remove the ref from the queue - will probably place object in the Zct
	mov		eax, _SP									; primitiveSuccess(0)
	ret
ENDPRIMITIVE primitiveDeQForFinalize

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

BEGINPRIMITIVE primitiveYield
	call	YIELD
	
	mov		eax, [STACKPOINTER]					; primitiveSuccess(0)
	mov		_IP, [INSTRUCTIONPOINTER]
	mov		_BP, [BASEPOINTER]

	ret
ENDPRIMITIVE primitiveYield

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

; Note that the failure code is not set.
BEGINPRIMITIVE unusedPrimitive
	xor		eax, eax
	ret
ENDPRIMITIVE unusedPrimitive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ Primitive Thunks
;; Thunks for control (context switching) primitives
;; Other C++ primitives no longer need thunks (the convention is to return the
;; adjusted stack pointer on success, or NULL on failure)

BEGINPRIMITIVE primitiveAsyncDLL32CallThunk
	CallContextPrim <primitiveAsyncDLL32Call>
ENDPRIMITIVE primitiveAsyncDLL32CallThunk

BEGINPRIMITIVE primitiveValueWithArgsThunk
	CallContextPrim <primitiveValueWithArgs>
ENDPRIMITIVE primitiveValueWithArgsThunk

BEGINPRIMITIVE primitivePerformThunk
	CallContextPrim <primitivePerform>
ENDPRIMITIVE primitivePerformThunk

BEGINPRIMITIVE primitivePerformWithArgsThunk
	CallContextPrim <primitivePerformWithArgs>
ENDPRIMITIVE primitivePerformWithArgsThunk

BEGINPRIMITIVE primitivePerformWithArgsAtThunk
	CallContextPrim <primitivePerformWithArgsAt>
ENDPRIMITIVE primitivePerformWithArgsAtThunk

BEGINPRIMITIVE primitivePerformMethodThunk
	CallContextPrim <primitivePerformMethod>
ENDPRIMITIVE primitivePerformMethodThunk

BEGINPRIMITIVE primitiveValueWithArgsAtThunk
	CallContextPrim <primitiveValueWithArgsAt>
ENDPRIMITIVE primitiveValueWithArgsAtThunk

BEGINPRIMITIVE primitiveSignalThunk
	CallContextPrim <primitiveSignal>
ENDPRIMITIVE primitiveSignalThunk

BEGINPRIMITIVE primitiveSingleStepThunk
	CallContextPrim	<PRIMITIVESINGLESTEP>
ENDPRIMITIVE primitiveSingleStepThunk

BEGINPRIMITIVE primitiveResumeThunk
	CallContextPrim	<PRIMITIVERESUME>
ENDPRIMITIVE primitiveResumeThunk

BEGINPRIMITIVE primitiveWaitThunk
	CallContextPrim <PRIMITIVEWAIT>
ENDPRIMITIVE primitiveWaitThunk

BEGINPRIMITIVE primitiveSuspendThunk
	CallContextPrim <primitiveSuspend>
ENDPRIMITIVE primitiveSuspendThunk

BEGINPRIMITIVE primitiveTerminateThunk
	CallContextPrim <primitiveTerminateProcess>
ENDPRIMITIVE primitiveTerminateThunk

BEGINPRIMITIVE primitiveSetSignalsThunk
	CallContextPrim <primitiveSetSignals>
ENDPRIMITIVE primitiveSetSignalsThunk

BEGINPRIMITIVE primitiveProcessPriorityThunk
	CallContextPrim <primitiveProcessPriority>
ENDPRIMITIVE primitiveProcessPriorityThunk

BEGINPRIMITIVE primitiveUnwindInterruptThunk
	CallContextPrim <PRIMUNWINDINTERRUPT>
ENDPRIMITIVE primitiveUnwindInterruptThunk

;; The specification primitiveSignalAtTick requires that it immediately signal
;; the specified semaphore if the time has already passed, so we must call
;; it as potentially context switching primitive
BEGINPRIMITIVE primitiveSignalAtTickThunk
	CallContextPrim <primitiveSignalAtTick>
ENDPRIMITIVE primitiveSignalAtTickThunk

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
BEGINPRIMITIVE primitiveCoreLeftThunk
	CallContextPrim <primitiveCoreLeft>
ENDPRIMITIVE primitiveCoreLeftThunk

;; This is actually a GC primitive, and it may switch contexts
;; because is synchronously signals a Semaphore (sometimes)
BEGINPRIMITIVE primitiveOopsLeftThunk
	CallContextPrim <primitiveOopsLeft>
ENDPRIMITIVE primitiveOopsLeftThunk

BEGINPRIMITIVE primitiveGetImmutable
	mov		eax, [_SP]								; Load receiver into eax
	mov		ecx, [oteTrue]
	test	al, 1
	jnz		@F
	
	ASSUME	ecx:PTR OTE								; ecx points at receiver OTE
	cmp		[eax].m_size, 0							; size < 0 ?
	jl		@F
	add		ecx, OTENTRYSIZE
@@:
	mov		[_SP], ecx								; Replace stack top with true/false

	mov		eax, _SP								; primitiveSuccess(0)
	ret

	ASSUME	ecx:NOTHING
ENDPRIMITIVE primitiveGetImmutable

BEGINPRIMITIVE primitiveSetImmutable
	mov		eax, [_SP-OOPSIZE]				; Receiver
	mov		ecx, [_SP]						; Boolean arg
	
	cmp	ecx, [oteTrue]
	jne	@F

	.IF (!(al & 1))
		ASSUME	eax:PTR OTE						; ecx points at receiver OTE

		or		[eax].m_size, 80000000h
	.ENDIF

	lea		eax, [_SP - OOPSIZE]				; primitiveSuccess(1)
	ret

@@:
	; Marking object as mutable - cannot do this for SmallIntegers as these are always immutable
	test	al, 1
	jnz		localPrimitiveFailure0
	
	ASSUME	eax:PTR OTE							; ecx points at receiver OTE
	and		[eax].m_size, 7FFFFFFFh		
	
	lea		eax, [_SP-OOPSIZE]					; primitiveSuccess(1)
	ret											; eax is non-zero so will succeed
	
	ASSUME	eax:NOTHING
	
LocalPrimitiveFailure 0

ENDPRIMITIVE primitiveSetImmutable

END

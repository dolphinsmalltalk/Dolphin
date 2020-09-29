#include "Ist.h"
#include "ObjMem.h"
#include "Interprt.h"
#include "FloatPrim.h"
#include "IntPrim.h"
#include "LargeIntPrim.h"
#include "StrgPrim.h"
#include "ExternalBuf.h"
#include "VMPointers.h"

extern "C" PRIMTABLEDECL Interpreter::PrimitiveFp primitivesTable[256] = {
	Interpreter::primitiveActivateMethod										, // case 0:   All methods without specific primitive
	Interpreter::primitiveReturnSelf											, // case 1:    ^self
	Interpreter::primitiveReturnConst<2>										, // case 2:    ^false
	Interpreter::primitiveReturnConst<3>										, // case 3:    ^true
	Interpreter::primitiveReturnConst<1>										, // case 4:    ^nil
	Interpreter::primitiveReturnLiteralZero										, // case 5:    ^<literal>
	Interpreter::primitiveReturnInstVar											, // case 6:    ^<inst-var>
	Interpreter::primitiveSetInstVar											, // case 7:    <inst-var> := <arg>
	Interpreter::primitiveReturnStaticZero										, // case 8:    ^<static-var>
	Interpreter::primitiveMultiply												, // case 9:   SmallInteger>>#*
	Interpreter::primitiveDivide												, // case 10:  SmallInteger>>#/
	Interpreter::primitiveMod													, // case 11:  SmallInteger>>#'\\'
	Interpreter::primitiveDiv													, // case 12:  SmallInteger>>#//
	Interpreter::primitiveQuo													, // case 13:  SmallInteger>>#quo:
	Interpreter::primitiveSubtract												, // case 14:  SmallInteger>>#-
	Interpreter::primitiveAdd													, // case 15:  SmallInteger>>#+
	Interpreter::primitiveEqual													, // case 16:  SmallInteger>>#=
	Interpreter::primitiveIntegerCmp<std::greater_equal<SmallInteger>, true>	, // case 17:  SmallInteger>>#>=
	Interpreter::primitiveIntegerCmp<std::less<SmallInteger>, false>			, // case 18:  SmallInteger>>#<
	Interpreter::primitiveIntegerCmp<std::greater<SmallInteger>, true>			, // case 19:  SmallInteger>>#>
	Interpreter::primitiveIntegerCmp<std::less_equal<SmallInteger>, false>		, // case 20:  SmallInteger>>#<=
	Interpreter::primitiveLargeIntegerOpR<Li::Add, Li::AddSingle>				, // case 21:  LargeInteger>>#+
	Interpreter::primitiveLargeIntegerOpR<Li::Sub, Li::SubSingle>				, // case 22:  LargeInteger>>#-
	Interpreter::primitiveLargeIntegerCmp<true,false>							, // case 23:  LargeInteger>>#<
	Interpreter::primitiveLargeIntegerCmp<false,false>							, // case 24:  LargeInteger>>#>
	Interpreter::primitiveLargeIntegerCmp<true, true>							, // case 25:  LargeInteger>>#<=
	Interpreter::primitiveLargeIntegerCmp<false,true>							, // case 26:  LargeInteger>>#>=
	Interpreter::primitiveLargeIntegerEqual										, // case 27:  LargeInteger>>#=
	Interpreter::primitiveLargeIntegerUnaryOp<Li::Normalize>					, // case 28:  LargeInteger>>normalize
	Interpreter::primitiveLargeIntegerOpZ<Li::Mul, Li::MulSingle>				, // case 29:  LargeInteger>>#*
	Interpreter::primitiveLargeIntegerDivide									, // case 30:  LargeInteger>>#/
	Interpreter::unusedPrimitive /* Reserved for LargeIntegerMod */				, // case 31:  LargeInteger#\\ 
	Interpreter::unusedPrimitive /* Reserved for LargeIntegerDiv */				, // case 32:  LargeInteger>>#//
	Interpreter::primitiveLargeIntegerQuo										, // case 33:  LargeInteger>>#quo:
	Interpreter::primitiveLargeIntegerOpZ<Li::BitAnd, Li::BitAndSingle>			, // case 34:  LargeInteger>>#bitAnd:
	Interpreter::primitiveLargeIntegerOpR<Li::BitOr, Li::BitOrSingle>			, // case 35:  LargeInteger>>#bitOr:
	Interpreter::primitiveLargeIntegerOpR<Li::BitXor, Li::BitXorSingle>			, // case 36:  LargeInteger>>#bitXor:
	Interpreter::primitiveLargeIntegerBitShift									, // case 37:  LargeInteger>>#bitShift
	Interpreter::primitiveLargeIntegerBitInvert									, // case 38:  LargeInteger>>#bitInvert
	Interpreter::primitiveLargeIntegerUnaryOp<Li::Negate>						, // case 39:  LargeInteger>>#negate
	Interpreter::primitiveIntegerOp<std::bit_and<Oop>>							, // case 40:  SmallInteger>>#bitAnd:
	Interpreter::primitiveIntegerOp<std::bit_or<Oop>>							, // case 41:  SmallInteger>>#bitOr:
	Interpreter::primitiveIntegerOp<bit_xor>									, // case 42:  SmallInteger>>#bitXor:
	Interpreter::primitiveBitShift												, // case 43:  SmallInteger>>#bitShift:
	Interpreter::primitiveSmallIntegerPrintString								, // case 44:  SmallInteger>>#printString
	Interpreter::primitiveFloatCompare<std::greater<double>>					, // case 45:  Float>>#>
	Interpreter::primitiveFloatCompare<std::greater_equal<double>>				, // case 46:  Float>>#>=
	Interpreter::primitiveFloatCompare<std::equal_to<double>>					, // case 47:  Float>>#=
	Interpreter::primitiveAsyncDLL32CallThunk									, // case 48:  Overlapped FFI call primitive
	Interpreter::primitiveSetMutableInstVar										, // case 49:  <mutable inst var> := arg
	Interpreter::primitiveCopyFromTo											, // case 50:  ArrayedCollection>>#copyFrom:to:
	Interpreter::primitiveStringComparison<CmpA,CmpW>							, // case 51:  String>>#trueCompare:
	Interpreter::primitiveStringNextIndexOfFromTo								, // case 52:  String>>#nextIdentityIndexOf:from:to:
	Interpreter::primitiveLargeIntegerHighBit									, // case 53:  LargeInteger>>#highBit
	Interpreter::primitiveHighBit												, // case 54:  SmallInteger>>#highBit
	Interpreter::primitiveBytesEqual											, // case 55:  ByteArray>>#=
	Interpreter::primitiveStringComparison<CmpIA,CmpIW>							, // case 56:  String>>#_collate:
	Interpreter::primitiveIsKindOf												, // case 57:  Object>>#isKindOf:
	Interpreter::primitiveAllSubinstances										, // case 58:  Behavior>>#primAllSubinstances
	Interpreter::primitiveNextIndexOfFromTo										, // case 59:  Object>>#basicIdentityIndexOf:from:to:, ArrayedCollection>>#nextIdentityIndexOf:from:to:
	Interpreter::primitiveBasicAt												, // case 60:  Object>>#at:, Object>>#basicAt:, String>>#byteAt:, ArrayedCollection>>#at:, ArrayedCollection>>#lookup:
	Interpreter::primitiveBasicAtPut											, // case 61:  Object>>#at:put:, Object>>#basicAt:put:, String>>#byteAt:put:, ArrayedCollection>>#at:put:
	Interpreter::primitiveSize													, // case 62:  Object>>#size, Object>>#basicSize, ArrayedCollection>>#size
	Interpreter::primitiveStringAt												, // case 63:  String>>#at:
	Interpreter::primitiveStringAtPut											, // case 64:  String>>#at:put:
	Interpreter::primitiveNext													, // case 65:  ReadStream>>#next[Available], FileStream>>#next[Available], ReadWriteStream>>#next[Available]
	Interpreter::primitiveNextPut												, // case 66:  WriteStream>>#nextPut:, FileStream>>#primitiveNextPut:, WriteStream>>#primitiveNextPut:
	Interpreter::primitiveAtEnd													, // case 67:  PositionableStream>>#atEnd
	Interpreter::primitiveReturnFromInterrupt									, // case 68:  ProcessorScheduler>>iret:list:
	Interpreter::primitiveSetSpecialBehavior									, // case 69:  Object>>#setSpecialBehavior:
	Interpreter::primitiveNew													, // case 70:  Behavior>>#new, Behavior>>#basicNew
	Interpreter::primitiveNewWithArg											, // case 71:  Behavior>>#new:, Behavior>>#basicNew:, String class>>#new:
	Interpreter::primitiveBecome												, // case 72:  Object>>#become:, Object>>#swappingBecome:
	Interpreter::primitiveInstVarAt												, // case 73:  Object>>#instVarAt:
	Interpreter::primitiveInstVarAtPut											, // case 74:  Object>>#instVarAt:put:
	Interpreter::primitiveBasicIdentityHash										, // case 75:  Object>>#basicIdentityHash
	Interpreter::primitiveNewPinned												, // case 76:  Behavior>>#newFixed:, Behavior>>#basicNewFixed:, String class>>#newFixed:
	Interpreter::primitiveAllInstances											, // case 77:  Behavior>>#primAllInstances
	Interpreter::primitiveReturn												, // case 78:  ProcessorScheduler>>#returnValue:toFrame:
	Interpreter::primitiveValueOnUnwind											, // case 79:  BlockClosure>>#valueOnUnwind:
	Interpreter::primitiveVirtualCall											, // case 80:  C++ virtual (and COM method) FFI calls
	Interpreter::primitiveValue													, // case 81:  BlockClosure>>#value, BlockClosure>>(value:)+
	Interpreter::primitiveValueWithArgsThunk									, // case 82:  BlockClosure>>#valueWithArguments:
	Interpreter::primitivePerformThunk											, // case 83:  Object>>#perform:(with:)*
	Interpreter::primitivePerformWithArgsThunk									, // case 84:  Object>>#perform:withArguments:
	Interpreter::primitiveSignalThunk											, // case 85:  Semaphore>>#signal
	Interpreter::primitiveWaitThunk												, // case 86:  Semaphore>>#wait:ret:
	Interpreter::primitiveResumeThunk											, // case 87:  Process>>#resume[:]
	Interpreter::primitiveSuspendThunk											, // case 88:  Process>>#suspend
	Interpreter::primitiveFlushCache											, // case 89:  Behavior>>#flushCache
	Interpreter::primitiveNewVirtual											, // case 90:  Behavior>>#new:max:
	Interpreter::primitiveTerminateProcessThunk									, // case 91:  Process>>#primTerminate
	Interpreter::primitiveProcessPriorityThunk									, // case 92:  Process>>#priority:
	Interpreter::primitiveInputSemaphore										, // case 93:  VMLibrary>>#primRegistryAt:put:
	Interpreter::primitiveSampleInterval										, // case 94:  InputState>>#primSampleInterval:
	Interpreter::primitiveEnableInterrupts										, // case 95:  ProcessorScheduler>>#enableAsyncEvents:
	Interpreter::primitiveDLL32Call												, // case 96:  FFI call primitive
	Interpreter::primitiveSnapshot												, // case 97:  SessionManager>>#primSnapshot:backup:type:maxObjects:
	Interpreter::primitiveQueueInterrupt										, // case 98:  Process>queueInterrupt:with:
	Interpreter::primitiveSetSignalsThunk										, // case 99:  Semaphore>>#primSetSignals:
	Interpreter::primitiveSignalAtTickThunk										, // case 100: Delay class>>signalTimerAfter:
	Interpreter::primitiveResize												, // case 101: Object>>resize:, Object>>#basicResize:, ArrayedCollection>>#resize:
	Interpreter::primitiveChangeBehavior										, // case 102: Object>>#becomeA:, Object>>#becomeAn:
	Interpreter::primitiveAddressOf												, // case 103: Object>>#yourAddress
	Interpreter::primitiveReturnFromCallback									, // case 104: ProcessorScheduler>>#primReturn:callback:
	Interpreter::primitiveSingleStepThunk										, // case 105: Process>>#primStep:
	Interpreter::primitiveHashBytes												, // case 106: ByteArray>>#hash, String>>#hash, LargeInteger>>#hash
	Interpreter::primitiveUnwindCallback										, // case 107: ProcessorScheduler>>#primUnwindCallback
	Interpreter::primitiveHookWindowCreate										, // case 108: View>>primHookWindowCreate:
	Interpreter::primitiveHashMultiply											, // case 109: Integer>>#hashMultiply, SmallInteger>>#identityHash, SmallInteger>>#hash
	Interpreter::primitiveIdentical												, // case 110: Object>#==, Object>>#=
	Interpreter::primitiveClass													, // case 111: Object>>#class, Object>>#basicClass
	Interpreter::primitiveCoreLeftThunk											, // case 112: MemoryManager>>#primCollectGarbage:
	(Interpreter::PrimitiveFp)&Interpreter::primitiveQuit						, // case 113: SessionManager>>#primQuit:
	Interpreter::primitivePerformWithArgsAtThunk								, // case 114: Object>>#perform:withArgumentsAt:descriptor:
	Interpreter::primitiveOopsLeftThunk											, // case 115: MemoryManager>>#primCompact
	Interpreter::primitivePerformMethodThunk									, // case 116: CompiledCode>>#value:withArguments:
	Interpreter::primitiveValueWithArgsAtThunk									, // case 117: BlockClosure>>#valueWithArgumentsAt:descriptor:
	Interpreter::primitiveDeQForFinalize										, // case 118: MemoryManager>>#dequeueForFinalization
	Interpreter::primitiveDeQBereavement										, // case 119: MemoryManager>>#dequeueBereavementInto:
	Interpreter::primitiveIntegerAtOffset<uint32_t, StoreUnsigned32>			, // case 120: ByteArray>>#dwordAtOffset:
	Interpreter::primitiveUint32AtPut											, // case 121: ByteArray>>#dwordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<int32_t, StoreSigned32>				, // case 122: ByteArray>>#sdwordAtOffset:
	Interpreter::primitiveInt32AtPut											, // case 123: ByteArray>>#sdwordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<uint16_t, StoreSmallInteger>			, // case 124: ByteArray>>#wordAtOffset:
	Interpreter::primitiveAtOffsetPutInteger<uint16_t, 0x0, 0xffff>				, // case 125: ByteArray>>#wordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<int16_t, StoreSmallInteger>			, // case 126: ByteArray>>#swordAtoffset:
	Interpreter::primitiveAtOffsetPutInteger<uint16_t, -0x8000, 0x7fff>			, // case 127: ByteArray>>#swordAtOffset:put:
																							 
	Interpreter::primitiveFloatAtOffset<double>									, // case 128: ByteArray>>#doubleAtOffset:
	Interpreter::primitiveFloatAtOffsetPut<double>								, // case 129: ByteArray>>#doubleAtOffset:put:
	Interpreter::primitiveFloatAtOffset<float>									, // case 130: ByteArray>>#floatAtOffset:
	Interpreter::primitiveFloatAtOffsetPut<float>								, // case 131: ByteArray>>#floatAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uint8_t, StoreSmallInteger>	, // case 132: External.Address>>#byteAtOffset:
	Interpreter::primitiveIndirectAtOffsetPutInteger<uint8_t, 0, 255>			, // case 133: External.Address>>#byteAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uint32_t, StoreUnsigned32>	, // case 134: External.Address>>#dwordAtOffset:
	Interpreter::primitiveIndirectUint32AtPut									, // case 135: External.Address>>#dwordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<int32_t, StoreSigned32>		, // case 136: External.Address>>#sdwordAtOffset:
	Interpreter::primitiveIndirectInt32AtPut									, // case 137: External.Address>>#sdwordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uint16_t, StoreSmallInteger>	, // case 138: External.Address>>#wordAtOffset:
	Interpreter::primitiveIndirectAtOffsetPutInteger<uint16_t, 0, 0xffff>		, // case 139: External.Address>>#wordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<int16_t, StoreSmallInteger>	, // case 140: External.Address>>#swordAtOffset:
	Interpreter::primitiveIndirectAtOffsetPutInteger<int16_t, -0x8000, 0x7fff>	, // case 141: External.Address>>#swordAtOffset:put:
	Interpreter::primitiveReplaceBytes											, // case 142: ByteArray|String>>#replaceBytesOf:from:to:startingAt:
	Interpreter::primitiveIndirectReplaceBytes									, // case 143: ExternalAddress>>#replaceBytesOf:from:to:startingAt:
	Interpreter::primitiveNextInt32												, // case 144: PositionableStream>>#newSDWORD
	Interpreter::primitiveAnyMask												, // case 145: SmallInteger>>#anyMask:
	Interpreter::primitiveAllMask												, // case 146: SmallInteger>>#allMask:
	Interpreter::primitiveIdentityHash											, // case 147: Object>>#identityHash
	Interpreter::primitiveLookupMethod											, // case 148: Behavior>>#lookupMethod:
	Interpreter::primitiveStringSearch											, // case 149: String>>#findString:startingAt:
	Interpreter::primitiveUnwindInterruptThunk									, // case 150: ProcessorScheduler>>#primUnwindInterrupt
	Interpreter::primitiveExtraInstanceSpec										, // case 151: Behavior>>#extraInstanceSpec
	Interpreter::primitiveLowBit												, // case 152: SmallInteger>>#lowBit
	Interpreter::primitiveAllReferences											, // case 153: Object>>#allReferences
	Interpreter::primitiveOneWayBecome											, // case 154: Object>>#oneWayBecome:
	Interpreter::primitiveShallowCopy											, // case 155: Object>>#shallowCopy, Object>>#basicShallowCopy
	Interpreter::primitiveYieldThunk											, // case 156: ProcessorScheduler>>#yield
	Interpreter::primitiveNewInitializedObject									, // case 157: e.g. Point class>>#x:y:
	Interpreter::primitiveSmallIntegerAt										, // case 158: SmallInteger>>#byteAt:
	Interpreter::primitiveLongDoubleAt											, // case 159: ByteArray>>#longDoubleAtOffset:
	Interpreter::primitiveFloatBinaryOp<std::plus<double>>						, // case 160: Float>>#+
	Interpreter::primitiveFloatBinaryOp<std::minus<double>>						, // case 161: Float>>#-
	Interpreter::primitiveFloatCompare<std::less<double>>						, // case 162: Float>>#<
	Interpreter::unusedPrimitive												, // case 163:
	Interpreter::primitiveFloatBinaryOp<std::multiplies<double>>				, // case 164: Float>>#*
	Interpreter::primitiveFloatBinaryOp<std::divides<double>>					, // case 165: Float>>#/
	Interpreter::primitiveFloatTruncationOp<Truncate>							, // case 166: Float>>#truncated
	Interpreter::primitiveLargeIntegerAsFloat									, // case 167: LargeInteger>>#asFloat
	Interpreter::primitiveAsFloat												, // case 168: SmallInteger>>#asFloat
	Interpreter::primitiveObjectCount											, // case 169: MemoryManager>>#objectCount
	Interpreter::primitiveStructureIsNull										, // case 170: External.Structure>>#isNull
	Interpreter::primitiveBytesIsNull											, // case 171: External.IntegerBytes>>isNull
	Interpreter::primitiveVariantValue											, // case 172: Variant>>#value
	Interpreter::primitiveNextPutAll											, // case 173: WriteStream>>#basicNextPutAll:, WriteStream>>#nextPutAll:
	Interpreter::primitiveMillisecondClockValue									, // case 174: MemoryManager>>#millisecondClock, InputState>>#millisecondClodkValue, Delay class>>#millisecondClockValue
	Interpreter::primitiveIndexOfSP												, // case 175: Process>>#indexOfSP:
	Interpreter::primitiveStackAtPut											, // case 176: Process>>#at:put:, Process>>#basicAt:put:
	Interpreter::primitiveGetImmutable											, // case 177: Object>>#isImmutable
	Interpreter::primitiveSetImmutable											, // case 178: Object>>#isImmutable:
	Interpreter::primitiveInstanceCounts										, // case 179: MemoryManager>>#primInstanceStats:
	Interpreter::primitiveIntegerAtOffset<uintptr_t, StoreUIntPtr>				, // case 180: ByteArray>>#uintPtrAtOffset:
	Interpreter::primitiveUint32AtPut											, // case 181: ByteArray>>#dwordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<intptr_t, StoreIntPtr>				, // case 182: ByteArray>>#intptrAtOffset:
	Interpreter::primitiveInt32AtPut											, // case 183: ByteArray>>#sdwordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uintptr_t, StoreUIntPtr>		, // case 184: External.Address>>#intptrAtOffset:
	Interpreter::primitiveIndirectUint32AtPut									, // case 185: External.Address>>#dwordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<intptr_t, StoreIntPtr>		, // case 186: External.Address>>#intptrAtOffset:
	Interpreter::primitiveIndirectInt32AtPut									, // case 187: External.Address>>#sdwordAtOffset:put:
	Interpreter::primitiveReplacePointers										, // case 188: Array>>#replaceElementsOf:from:to:startingAt:
	Interpreter::primitiveMicrosecondClockValue									, // case 189: Delay>>#microsecondClockValue, Delay class>>#microsecondClockValue
	Interpreter::primitiveNewFromStack											, // case 190: Array class>>#newFromStack:
	Interpreter::primitiveIntegerAtOffset<uint64_t, StoreUnsigned64>			, // case 191: ByteArray>>#qwordAtOffset:
	Interpreter::primitiveIntegerAtOffset<int64_t, StoreSigned64>				, // case 192: ByteArray>>#sqwordAtOffset:
	Interpreter::primitiveFloatUnaryOp<Sin>										, // case 193: Float>>#sin
	Interpreter::primitiveFloatUnaryOp<Tan>										, // case 194: Float>>#tan
	Interpreter::primitiveFloatUnaryOp<Cos>										, // case 195: Float>>#cos
	Interpreter::primitiveFloatUnaryOp<ArcSin>									, // case 196: Float>>#arcSin
	Interpreter::primitiveFloatUnaryOp<ArcTan>									, // case 197: Float>>#arcTan
	Interpreter::primitiveFloatUnaryOp<ArcCos>									, // case 198: Float>>#arcCos
	Interpreter::primitiveFloatBinaryOp<Atan2>									, // case 199: Float>>#acTan:
	Interpreter::primitiveFloatUnaryOp<Log>										, // case 200: Float>>#ln
	Interpreter::primitiveFloatUnaryOp<Exp>										, // case 201: Float>>#exp
	Interpreter::primitiveFloatUnaryOp<Sqrt>									, // case 202: Float>>#sqrt
	Interpreter::primitiveFloatUnaryOp<Log10>									, // case 203: Float>>#log
	Interpreter::primitiveFloatTimesTwoPower									, // case 204: Float>>#timesTwoPower:
	Interpreter::primitiveFloatUnaryOp<Abs>										, // case 205: Float>>#abs
	Interpreter::primitiveFloatBinaryOp<Pow>									, // case 206: Float>>#raisedTo:
	Interpreter::primitiveFloatTruncationOp<Floor>								, // case 207: Float>>#floor
	Interpreter::primitiveFloatTruncationOp<Ceiling>							, // case 208: Float>>#ceiling
	Interpreter::primitiveFloatExponent											, // case 209: Float>>#exponent
	Interpreter::primitiveFloatUnaryOp<Negated>									, // case 210: Float>>#negated
	Interpreter::primitiveFloatClassify											, // case 211: Float>>#fpClass
	Interpreter::primitiveFloatUnaryOp<FractionPart>							, // case 212: Float>>#fractionPart
	Interpreter::primitiveFloatUnaryOp<IntegerPart>								, // case 213: Float>>#integerPart
	Interpreter::primitiveFloatCompare<std::less_equal<double>>					, // case 214: Float>>#<=
	Interpreter::primitiveStringAsUtf16String									, // case 215: String>>#asUtf16String
	Interpreter::primitiveStringAsUtf8String									, // case 216: String>>#asUtf8String
	Interpreter::primitiveStringAsByteString									, // case 217: String>>#asAnsiString
	Interpreter::primitiveStringConcatenate										, // case 218: String>>#,
	Interpreter::primitiveStringEqual											, // case 219: String>>#=
	Interpreter::primitiveStringComparison<CmpOrdinalA, CmpOrdinalW>			, // case 220: String>>#_cmp:
	Interpreter::primitiveBasicNext												, // case 221: ReadStream|FileStream|ReadWriteStream>>#basicNext, ReadStream>>#basicNextAvailable
	Interpreter::primitiveBasicNextPut											, // case 222: WriteStream>>#basicNextPut:, FileStream|WriteStream>>#primitiveBasicNextPut:
	Interpreter::primitiveStringAsUtf32String									, // case 223: Currently unimplemented/unused
	Interpreter::primitiveBeginsWith											, // case 224:
	Interpreter::unusedPrimitive												, // case 225:
	Interpreter::unusedPrimitive												, // case 226:
	Interpreter::unusedPrimitive												, // case 227:
	Interpreter::unusedPrimitive												, // case 228:
	Interpreter::unusedPrimitive												, // case 229:
	Interpreter::unusedPrimitive												, // case 230:
	Interpreter::unusedPrimitive												, // case 231:
	Interpreter::unusedPrimitive												, // case 232:
	Interpreter::unusedPrimitive												, // case 233:
	Interpreter::unusedPrimitive												, // case 234:
	Interpreter::unusedPrimitive												, // case 235:
	Interpreter::unusedPrimitive												, // case 236:
	Interpreter::unusedPrimitive												, // case 237:
	Interpreter::unusedPrimitive												, // case 238:
	Interpreter::unusedPrimitive												, // case 239:
	Interpreter::unusedPrimitive												, // case 240:
	Interpreter::unusedPrimitive												, // case 241:
	Interpreter::unusedPrimitive												, // case 242:
	Interpreter::unusedPrimitive												, // case 243:
	Interpreter::unusedPrimitive												, // case 244:
	Interpreter::unusedPrimitive												, // case 245:
	Interpreter::unusedPrimitive												, // case 246:
	Interpreter::unusedPrimitive												, // case 247:
	Interpreter::unusedPrimitive												, // case 248:
	Interpreter::unusedPrimitive												, // case 249:
	Interpreter::unusedPrimitive												, // case 250:
	Interpreter::unusedPrimitive												, // case 251:
	Interpreter::unusedPrimitive												, // case 252:
	Interpreter::unusedPrimitive												, // case 253:
	Interpreter::unusedPrimitive												, // case 254:
	Interpreter::unusedPrimitive												, // case 255:
};

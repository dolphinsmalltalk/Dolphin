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
	Interpreter::primitiveActivateMethod										, // case 0
	Interpreter::primitiveReturnSelf											, // case 1
	Interpreter::primitiveReturnConst<2>										, // case 2	
	Interpreter::primitiveReturnConst<3>										, // case 3
	Interpreter::primitiveReturnConst<1>										, // case 4	
	Interpreter::primitiveReturnLiteralZero										, // case 5
	Interpreter::primitiveReturnInstVar											, // case 6
	Interpreter::primitiveSetInstVar											, // case 7
	Interpreter::primitiveReturnStaticZero										, // case 8	Was SmallInteger>>~= (redundant)
	Interpreter::primitiveMultiply												, // case 9
	Interpreter::primitiveDivide												, // case 10
	Interpreter::primitiveMod													, // case 11
	Interpreter::primitiveDiv													, // case 12
	Interpreter::primitiveQuo													, // case 13
	Interpreter::primitiveSubtract												, // case 14
	Interpreter::primitiveAdd													, // case 15
	Interpreter::primitiveEqual													, // case 16
	Interpreter::primitiveIntegerCmp<std::greater_equal<SMALLINTEGER>, true>	, // case 17
	Interpreter::primitiveIntegerCmp<std::less<SMALLINTEGER>, false>			, // case 18	Number>>#@
	Interpreter::primitiveIntegerCmp<std::greater<SMALLINTEGER>, true>			, // case 19	Not Used in Smalltalk-80
	Interpreter::primitiveIntegerCmp<std::less_equal<SMALLINTEGER>, false>		, // case 20	Not used in Smalltalk-80
	Interpreter::primitiveLargeIntegerOpR<Li::Add, Li::AddSingle>				, // case 21	LargeInteger>>#+
	Interpreter::primitiveLargeIntegerOpR<Li::Sub, Li::SubSingle>				, // case 22	LargeInteger>>#-
	Interpreter::primitiveLargeIntegerCmp<true,false>							, // case 23	LargeInteger>>#<
	Interpreter::primitiveLargeIntegerCmp<false,false>							, // case 24	LargeInteger>>#>
	Interpreter::primitiveLargeIntegerCmp<true, true>							, // case 25	LargeInteger>>#<=
	Interpreter::primitiveLargeIntegerCmp<false,true>							, // case 26	LargeInteger>>#>=
	Interpreter::primitiveLargeIntegerEqual										, // case 27	LargeInteger>>#=
	Interpreter::primitiveLargeIntegerUnaryOp<Li::Normalize>					, // case 28	LargeInteger>>normalize. LargeInteger>>#~= in Smalltalk-80 (redundant)
	Interpreter::primitiveLargeIntegerOpZ<Li::Mul, Li::MulSingle>				, // case 29	LargeInteger>>#*
	Interpreter::primitiveLargeIntegerDivide									, // case 30	LargeInteger>>#/
	Interpreter::unusedPrimitive /* LargeIntegerMod */							, // case 31	LargeInteger#\\ 
	Interpreter::unusedPrimitive /* LargeIntegerDiv */							, // case 32	LargeInteger>>#//
	Interpreter::primitiveLargeIntegerQuo										, // case 33	LargeInteger>>#quo:
	Interpreter::primitiveLargeIntegerOpZ<Li::BitAnd, Li::BitAndSingle>			, // case 34	LargeInteger>>#bitAnd:
	Interpreter::primitiveLargeIntegerOpR<Li::BitOr, Li::BitOrSingle>			, // case 35	LargeInteger>>#bitOr:
	Interpreter::primitiveLargeIntegerOpR<Li::BitXor, Li::BitXorSingle>			, // case 36	LargeInteger>>#bitXor:
	Interpreter::primitiveLargeIntegerBitShift									, // case 37	LargeInteger>>#bitShift
	Interpreter::primitiveLargeIntegerBitInvert									, // case 38	Not used in Smalltalk-80
	Interpreter::primitiveLargeIntegerUnaryOp<Li::Negate>						, // case 39	Not used in Smalltalk-80
	Interpreter::primitiveIntegerOp<std::bit_and<Oop>>							, // case 40	SmallInteger>>asFloat
	Interpreter::primitiveIntegerOp<std::bit_or<Oop>>							, // case 41	Float>>#+
	Interpreter::primitiveIntegerOp<bit_xor>									, // case 42	Float>>#-
	Interpreter::primitiveBitShift												, // case 43	Float>>#<
	Interpreter::primitiveSmallIntegerPrintString								, // case 44	Float>>#> in Smalltalk-80
	Interpreter::primitiveFloatCompare<std::greater<double>>					, // case 45	Float>>#<= in Smalltalk-80
	Interpreter::primitiveFloatCompare<std::greater_equal<double>>				, // case 46	Float>>#>= in Smalltalk-80
	Interpreter::primitiveFloatCompare<std::equal_to<double>>					, // case 47	Float>>#= in Smalltalk-80
	Interpreter::primitiveAsyncDLL32CallThunk									, // case 48	Float>>#~= in Smalltalk-80
	Interpreter::unusedPrimitive												, // case 49	Float>>#* in Smalltalk-80
	Interpreter::primitiveCopyFromTo											, // case 50	Float>>#/ in Smalltalk-80
	Interpreter::primitiveStringComparison<CmpA,CmpW>							, // case 51	Float>>#truncated
	Interpreter::primitiveStringNextIndexOfFromTo								, // case 52	Float>>#fractionPart in Smalltalk-80
	Interpreter::primitiveLargeIntegerHighBit									, // case 53	Float>>#exponent in Smalltalk-80
	Interpreter::primitiveHighBit												, // case 54	Float>>#timesTwoPower: in Smalltalk-80
	Interpreter::primitiveBytesEqual											, // case 55	Not used in Smalltalk-80
	Interpreter::primitiveStringComparison<CmpIA,CmpIW>							, // case 56	String collation
	Interpreter::primitiveIsKindOf												, // case 57	Not used in Smalltalk-80
	Interpreter::primitiveAllSubinstances										, // case 58	Not used in Smalltalk-80
	Interpreter::primitiveNextIndexOfFromTo										, // case 59	Not used in Smalltalk-80
	Interpreter::primitiveBasicAt												, // case 60	Note that the #at: primitive is now the same as #basicAt:
	Interpreter::primitiveBasicAtPut											, // case 61	
	Interpreter::primitiveSize													, // case 62	LargeInteger>>#digitLength
	Interpreter::primitiveStringAt												, // case 63	
	Interpreter::primitiveStringAtPut											, // case 64
	Interpreter::primitiveNext													, // case 65	
	Interpreter::primitiveNextPut												, // case 66
	Interpreter::primitiveAtEnd													, // case 67
	Interpreter::primitiveReturnFromInterrupt									, // case 68	Was CompiledMethod>>#objectAt: (reserve for upTo:)
	Interpreter::primitiveSetSpecialBehavior									, // case 69	Was CompiledMethod>>#objectAt:put:
	Interpreter::primitiveNew													, // case 70	
	Interpreter::primitiveNewWithArg											, // case 71
	Interpreter::primitiveBecome												, // case 72
	Interpreter::primitiveInstVarAt												, // case 73
	Interpreter::primitiveInstVarAtPut											, // case 74
	Interpreter::primitiveBasicIdentityHash										, // case 75	Object>>basicIdentityHash
	Interpreter::primitiveNewPinned												, // case 76
	Interpreter::primitiveAllInstances											, // case 77	was Behavior>>someInstance
	Interpreter::primitiveReturn												, // case 78	was Object>>nextInstance
	Interpreter::primitiveValueOnUnwind											, // case 79	CompiledMethod class>>newMethod:header:
	Interpreter::primitiveVirtualCall											, // case 80	Was ContextPart>>blockCopy:
	Interpreter::primitiveValue													, // case 81
	Interpreter::primitiveValueWithArgsThunk									, // case 82
	Interpreter::primitivePerformThunk											, // case 83
	Interpreter::primitivePerformWithArgsThunk									, // case 84
	Interpreter::primitiveSignalThunk											, // case 85
	Interpreter::primitiveWaitThunk												, // case 86	N.B. DON'T CHANGE, ref'd from signalSemaphore() in process.cpp 
	Interpreter::primitiveResumeThunk											, // case 87
	Interpreter::primitiveSuspendThunk											, // case 88
	Interpreter::primitiveFlushCache											, // case 89	Behavior>>flushCache
	Interpreter::primitiveNewVirtual											, // case 90	Was InputSensor>>primMousePt, InputState>>primMousePt
	Interpreter::primitiveTerminateProcessThunk									, // case 91	Was InputState>>primCursorLocPut:, InputState>>primCursorLocPutAgain:
	Interpreter::primitiveProcessPriorityThunk									, // case 92	Was Cursor class>>cursorLink:
	Interpreter::primitiveInputSemaphore										, // case 93	VMLibrary>>primRegistryAt:put:
	Interpreter::primitiveSampleInterval										, // case 94	Is InputState>>primSampleInterval:
	Interpreter::primitiveEnableInterrupts										, // case 95	Was InputState>>primInputWord
	Interpreter::primitiveDLL32Call												, // case 96	Was BitBlt>>copyBits
	Interpreter::primitiveSnapshot												, // case 97	Is SystemDictionary>>snapshotPrimitive
	Interpreter::primitiveQueueInterrupt										, // case 98	Was Time class>>secondClockInto:
	Interpreter::primitiveSetSignalsThunk										, // case 99	Was Time class>>millisecondClockInto:
	Interpreter::primitiveSignalAtTickThunk										, // case 100	Is Delay>>signalTimerAfter:
	Interpreter::primitiveResize												, // case 101	Was Cursor>>beCursor
	Interpreter::primitiveChangeBehavior										, // case 102	Was DisplayScreen>>beDisplay
	Interpreter::primitiveAddressOf												, // case 103	Was CharacterScanner>>scanCharactersFrom:to:in:rightX:stopConditions:di_SPlaying:
	Interpreter::primitiveReturnFromCallback									, // case 104	Was BitBlt drawLoopX:Y:
	Interpreter::primitiveSingleStepThunk										, // case 105
	Interpreter::primitiveHashBytes												, // case 106	Not used in Smalltalk-80
	Interpreter::primitiveUnwindCallback										, // case 107	ProcessorScheduler>>primUnwindCallback
	Interpreter::primitiveHookWindowCreate										, // case 108	Not used in Smalltalk-80
	Interpreter::primitiveHashMultiply											, // case 109	Not used in Smalltalk-80
	Interpreter::primitiveIdentical												, // case 110	Character =, Object ==
	Interpreter::primitiveClass													, // case 111	Object class
	Interpreter::primitiveCoreLeftThunk											, // case 112	Was SystemDictionary>>coreLeft - This is now the basic, non-compacting, incremental, garbage collect
	(Interpreter::PrimitiveFp)&Interpreter::primitiveQuit						, // case 113	SystemDictionary>>quitPrimitive
	Interpreter::primitivePerformWithArgsAtThunk								, // case 114	SystemDictionary>>exitToDebugger
	Interpreter::primitiveOopsLeftThunk											, // case 115	SystemDictionary>>oopsLeft - Use this for a compacting garbage collect
	Interpreter::primitivePerformMethodThunk									, // case 116	This was primitiveSignalAtOopsLeftWordsLeft (low memory signal)
	Interpreter::primitiveValueWithArgsAtThunk									, // case 117	Not used in Smalltalk-80
	Interpreter::primitiveDeQForFinalize										, // case 118	Not used in Smalltalk-80 - Dequeue an object from the VM's finalization queue
	Interpreter::primitiveDeQBereavement										, // case 119	Not used in Smalltalk-80 - Dequeue a weak object which has new Corpses and notify it
	Interpreter::primitiveIntegerAtOffset<uint32_t, StoreUnsigned32>			, // case 120	ByteArray>>dwordAtOffset:
	Interpreter::primitiveDWORDAtPut											, // case 121	ByteArray>>dwordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<int32_t, StoreSigned32>				, // case 122	ByteArray>>sdwordAtOffset:
	Interpreter::primitiveSDWORDAtPut											, // case 123	ByteArray>>sdwordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<uint16_t, StoreSmallInteger>			, // case 124	ByteArray>>wordAtOffset:
	Interpreter::primitiveAtOffsetPutInteger<uint16_t, 0x0, 0xffff>				, // case 125	ByteArray>>wordAtOffset:put:
	Interpreter::primitiveIntegerAtOffset<int16_t, StoreSmallInteger>			, // case 126	ByteArray>>swordAtoffset:
	Interpreter::primitiveAtOffsetPutInteger<uint16_t, -0x8000, 0x7fff>			, // case 127	ByteArray>>swordAtOffset:put:

	Interpreter::primitiveFloatAtOffset<double>									, // case 128 #doubleAtOffset:
	Interpreter::primitiveFloatAtOffsetPut<double>								, // case 129 #doubleAtOffset:put:
	Interpreter::primitiveFloatAtOffset<float>									, // case 130 #floatAtOffset:
	Interpreter::primitiveFloatAtOffsetPut<float>								, // case 131 #floatAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uint8_t, StoreSmallInteger>	, // case 132 ExternalAddress>>byteAtOffset:
	Interpreter::primitiveIndirectAtOffsetPutInteger<uint8_t, 0, 255>			, // case 133 ExternalAddress>>byteAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uint32_t, StoreUnsigned32>	, // case 134 ExternalAddress>>dwordAtOffset:
	Interpreter::primitiveIndirectDWORDAtPut									, // case 135 ExternalAddress>>dwordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<int32_t, StoreSigned32>		, // case 136 ExternalAddress>>sdwordAtOffset:
	Interpreter::primitiveIndirectSDWORDAtPut									, // case 137 ExternalAddress>>sdwordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<uint16_t, StoreSmallInteger>	, // case 138 ExternalAddress>>wordAtOffset:
	Interpreter::primitiveIndirectAtOffsetPutInteger<uint16_t, 0, 0xffff>		, // case 139 ExternalAddress>>wordAtOffset:put:
	Interpreter::primitiveIndirectIntegerAtOffset<int16_t, StoreSmallInteger>	, // case 140 ExternalAddress>>swordAtOffset:
	Interpreter::primitiveIndirectAtOffsetPutInteger<int16_t, -0x8000, 0x7fff>	, // case 141 ExternalAddress>>swordAtOffset:put:
	Interpreter::primitiveReplaceBytes											, // case 142
	Interpreter::primitiveIndirectReplaceBytes									, // case 143
	Interpreter::primitiveNextSDWORD											, // case 144
	Interpreter::primitiveAnyMask												, // case 145
	Interpreter::primitiveAllMask												, // case 146
	Interpreter::primitiveIdentityHash											, // case 147
	Interpreter::primitiveLookupMethod											, // case 148
	Interpreter::primitiveStringSearch											, // case 149
	Interpreter::primitiveUnwindInterruptThunk									, // case 150
	Interpreter::primitiveExtraInstanceSpec										, // case 151
	Interpreter::primitiveLowBit												, // case 152
	Interpreter::primitiveAllReferences											, // case 153
	Interpreter::primitiveOneWayBecome											, // case 154
	Interpreter::primitiveShallowCopy											, // case 155
	Interpreter::primitiveYieldThunk											, // case 156
	Interpreter::primitiveNewInitializedObject									, // case 157
	Interpreter::primitiveSmallIntegerAt										, // case 158
	Interpreter::primitiveLongDoubleAt											, // case 159
	Interpreter::primitiveFloatBinaryOp<std::plus<double>>						, // case 160
	Interpreter::primitiveFloatBinaryOp<std::minus<double>>						, // case 161
	Interpreter::primitiveFloatCompare<std::less<double>>						, // case 162
	Interpreter::unusedPrimitive												, // case 163
	Interpreter::primitiveFloatBinaryOp<std::multiplies<double>>				, // case 164
	Interpreter::primitiveFloatBinaryOp< std::divides<double>>					, // case 165
	Interpreter::primitiveFloatTruncationOp<Truncate>							, // case 166
	Interpreter::primitiveLargeIntegerAsFloat									, // case 167
	Interpreter::primitiveAsFloat												, // case 168
	Interpreter::primitiveObjectCount											, // case 169
	Interpreter::primitiveStructureIsNull										, // case 170
	Interpreter::primitiveBytesIsNull											, // case 171
	Interpreter::primitiveVariantValue											, // case 172
	Interpreter::primitiveNextPutAll											, // case 173
	Interpreter::primitiveMillisecondClockValue									, // case 174
	Interpreter::primitiveIndexOfSP												, // case 175
	Interpreter::primitiveStackAtPut											, // case 176
	Interpreter::primitiveGetImmutable											, // case 177
	Interpreter::primitiveSetImmutable											, // case 178
	Interpreter::primitiveInstanceCounts										, // case 179
	Interpreter::primitiveIntegerAtOffset<uintptr_t, StoreUIntPtr>				, // case 180
	Interpreter::primitiveDWORDAtPut											, // case 181	Will be primitiveUIntPtrAtPut
	Interpreter::primitiveIntegerAtOffset<intptr_t, StoreIntPtr>				, // case 182	Will be primitiveIntPtrAt
	Interpreter::primitiveSDWORDAtPut											, // case 183	Will be primitiveIntPtrAtPut
	Interpreter::primitiveIndirectIntegerAtOffset<uintptr_t, StoreUIntPtr>		, // case 184	Will be primitiveIndirectUIntPtrAt
	Interpreter::primitiveIndirectDWORDAtPut									, // case 185	Will be primitiveIndirectUIntPtrAtPut
	Interpreter::primitiveIndirectIntegerAtOffset<intptr_t, StoreIntPtr>		, // case 186	Will be primitiveIndirectIntPtrAt
	Interpreter::primitiveIndirectSDWORDAtPut									, // case 187	Will be primitiveIndirectIntPtrAtPut
	Interpreter::primitiveReplacePointers										, // case 188
	Interpreter::primitiveMicrosecondClockValue									, // case 189
	Interpreter::primitiveNewFromStack											, // case 190
	Interpreter::primitiveIntegerAtOffset<uint64_t, StoreUnsigned64>			, // case 191
	Interpreter::primitiveIntegerAtOffset<int64_t, StoreSigned64>				, // case 192
	Interpreter::primitiveFloatUnaryOp<Sin>										, // case 193
	Interpreter::primitiveFloatUnaryOp<Tan>										, // case 194
	Interpreter::primitiveFloatUnaryOp<Cos>										, // case 195
	Interpreter::primitiveFloatUnaryOp<ArcSin>									, // case 196
	Interpreter::primitiveFloatUnaryOp<ArcTan>									, // case 197
	Interpreter::primitiveFloatUnaryOp<ArcCos>									, // case 198
	Interpreter::primitiveFloatBinaryOp<Atan2>									, // case 199
	Interpreter::primitiveFloatUnaryOp<Log>										, // case 200
	Interpreter::primitiveFloatUnaryOp<Exp>										, // case 201
	Interpreter::primitiveFloatUnaryOp<Sqrt>									, // case 202
	Interpreter::primitiveFloatUnaryOp<Log10>									, // case 203
	Interpreter::primitiveFloatTimesTwoPower									, // case 204
	Interpreter::primitiveFloatUnaryOp<Abs>										, // case 205
	Interpreter::primitiveFloatBinaryOp<Pow>									, // case 206
	Interpreter::primitiveFloatTruncationOp<Floor>								, // case 207
	Interpreter::primitiveFloatTruncationOp<Ceiling>							, // case 208
	Interpreter::primitiveFloatExponent											, // case 209
	Interpreter::primitiveFloatUnaryOp<Negated>									, // case 210
	Interpreter::primitiveFloatClassify											, // case 211
	Interpreter::primitiveFloatUnaryOp<FractionPart>							, // case 212
	Interpreter::primitiveFloatUnaryOp<IntegerPart>								, // case 213
	Interpreter::primitiveFloatCompare<std::less_equal<double>>					, // case 214
	Interpreter::primitiveStringAsUtf16String									, // case 215
	Interpreter::primitiveStringAsUtf8String									, // case 216
	Interpreter::primitiveStringAsByteString									, // case 217
	Interpreter::primitiveStringConcatenate										, // case 218
	Interpreter::primitiveStringEqual											, // case 219
	Interpreter::primitiveStringComparison<CmpOrdinalA, CmpOrdinalW>			, // case 220 - String ordinal cmp
	Interpreter::primitiveBasicNext												, // case 221
	Interpreter::primitiveBasicNextPut											, // case 222
	Interpreter::primitiveStringAsUtf32String									, // case 223
	Interpreter::unusedPrimitive												, // case 224
	Interpreter::unusedPrimitive												, // case 225
	Interpreter::unusedPrimitive												, // case 226
	Interpreter::unusedPrimitive												, // case 227
	Interpreter::unusedPrimitive												, // case 228
	Interpreter::unusedPrimitive												, // case 229
	Interpreter::unusedPrimitive												, // case 230
	Interpreter::unusedPrimitive												, // case 231
	Interpreter::unusedPrimitive												, // case 232
	Interpreter::unusedPrimitive												, // case 233
	Interpreter::unusedPrimitive												, // case 234
	Interpreter::unusedPrimitive												, // case 235
	Interpreter::unusedPrimitive												, // case 236
	Interpreter::unusedPrimitive												, // case 237
	Interpreter::unusedPrimitive												, // case 238
	Interpreter::unusedPrimitive												, // case 239
	Interpreter::unusedPrimitive												, // case 240
	Interpreter::unusedPrimitive												, // case 241
	Interpreter::unusedPrimitive												, // case 242
	Interpreter::unusedPrimitive												, // case 243
	Interpreter::unusedPrimitive												, // case 244
	Interpreter::unusedPrimitive												, // case 245
	Interpreter::unusedPrimitive												, // case 246
	Interpreter::unusedPrimitive												, // case 247
	Interpreter::unusedPrimitive												, // case 248
	Interpreter::unusedPrimitive												, // case 249
	Interpreter::unusedPrimitive												, // case 250
	Interpreter::unusedPrimitive												, // case 251
	Interpreter::unusedPrimitive												, // case 252
	Interpreter::unusedPrimitive												, // case 253
	Interpreter::unusedPrimitive												, // case 254
	Interpreter::unusedPrimitive												, // case 255
};

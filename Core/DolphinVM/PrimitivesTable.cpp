#include "Ist.h"
#include "ObjMem.h"
#include "Interprt.h"

Interpreter::PrimitiveFp Interpreter::primitivesTable[256] = {
	Interpreter::primitiveActivateMethod						, // case 0
	Interpreter::primitiveReturnSelf							, // case 1
	Interpreter::primitiveReturnTrue							, // case 2	
	Interpreter::primitiveReturnFalse							, // case 3
	Interpreter::primitiveReturnNil								, // case 4	
	Interpreter::primitiveReturnLiteralZero						, // case 5
	Interpreter::primitiveReturnInstVar							, // case 6
	Interpreter::primitiveSetInstVar							, // case 7
	Interpreter::primitiveReturnStaticZero						, // case 8	Was SmallInteger>>~= (redundant)
	Interpreter::primitiveMultiply								, // case 9
	Interpreter::primitiveDivide								, // case 10
	Interpreter::primitiveMod									, // case 11
	Interpreter::primitiveDiv									, // case 12
	Interpreter::primitiveQuoAndRem								, // case 13
	Interpreter::primitiveSubtract								, // case 14
	Interpreter::primitiveAdd									, // case 15
	Interpreter::primitiveEqual									, // case 16
	Interpreter::primitiveGreaterOrEqual						, // case 17
	Interpreter::primitiveLessThan								, // case 18	Number>>#@
	Interpreter::primitiveGreaterThan							, // case 19	Not Used in Smalltalk-80
	Interpreter::primitiveLessOrEqual							, // case 20	Not used in Smalltalk-80
	Interpreter::primitiveLargeIntegerAdd						, // case 21	LargeInteger>>#+
	Interpreter::primitiveLargeIntegerSub						, // case 22	LargeInteger>>#-
	Interpreter::primitiveLargeIntegerLessThan					, // case 23	LargeInteger>>#<
	Interpreter::primitiveLargeIntegerGreaterThan				, // case 24	LargeInteger>>#>
	Interpreter::primitiveLargeIntegerLessOrEqual				, // case 25	LargeInteger>>#<=
	Interpreter::primitiveLargeIntegerGreaterOrEqual			, // case 26	LargeInteger>>#>=
	Interpreter::primitiveLargeIntegerEqual						, // case 27	LargeInteger>>#=
	Interpreter::primitiveLargeIntegerNormalize					, // case 28	LargeInteger>>normalize. LargeInteger>>#~= in Smalltalk-80 (redundant)
	Interpreter::primitiveLargeIntegerMul 						, // case 29	LargeInteger>>#*
	Interpreter::primitiveLargeIntegerDivide					, // case 30	LargeInteger>>#/
	Interpreter::primitiveLargeIntegerMod						, // case 31	LargeInteger#\\ 
	Interpreter::primitiveLargeIntegerDiv						, // case 32	LargeInteger>>#//
	Interpreter::primitiveLargeIntegerQuoAndRem					, // case 33	Was LargeInteger>>#quo:
	Interpreter::primitiveLargeIntegerBitAnd					, // case 34	LargeInteger>>#bitAnd:
	Interpreter::primitiveLargeIntegerBitOr						, // case 35	LargeInteger>>#bitOr:
	Interpreter::primitiveLargeIntegerBitXor					, // case 36	LargeInteger>>#bitXor:
	Interpreter::primitiveLargeIntegerBitShift					, // case 37	LargeInteger>>#bitShift
	Interpreter::primitiveLargeIntegerBitInvert					, // case 38	Not used in Smalltalk-80
	Interpreter::primitiveLargeIntegerNegate					, // case 39	Not used in Smalltalk-80
	Interpreter::primitiveBitAnd								, // case 40	SmallInteger>>asFloat
	Interpreter::primitiveBitOr									, // case 41	Float>>#+
	Interpreter::primitiveBitXor								, // case 42	Float>>#-
	Interpreter::primitiveBitShift								, // case 43	Float>>#<
	Interpreter::primitiveSmallIntegerPrintString				, // case 44	Float>>#> in Smalltalk-80
	Interpreter::primitiveFloatGreaterThan						, // case 45	Float>>#<= in Smalltalk-80
	Interpreter::primitiveFloatGreaterOrEqual					, // case 46	Float>>#>= in Smalltalk-80
	Interpreter::primitiveFloatEqual							, // case 47	Float>>#= in Smalltalk-80
	Interpreter::primitiveAsyncDLL32CallThunk					, // case 48	Float>>#~= in Smalltalk-80
	Interpreter::primitiveLargeIntegerHighBit					, // case 49	Float>>#* in Smalltalk-80
	Interpreter::primitiveCopyFromTo							, // case 50	Float>>#/ in Smalltalk-80
	Interpreter::primitiveStringCmp								, // case 51	Float>>#truncated
	Interpreter::primitiveStringNextIndexOfFromTo				, // case 52	Float>>#fractionPart in Smalltalk-80
	Interpreter::primitiveQuo									, // case 53	Float>>#exponent in Smalltalk-80
	Interpreter::primitiveHighBit								, // case 54	Float>>#timesTwoPower: in Smalltalk-80
	Interpreter::primitiveBytesEqual							, // case 55	Not used in Smalltalk-80
	Interpreter::primitiveStringCollate							, // case 56
	Interpreter::primitiveIsKindOf								, // case 57	Not used in Smalltalk-80
	Interpreter::primitiveAllSubinstances						, // case 58	Not used in Smalltalk-80
	Interpreter::primitiveNextIndexOfFromTo						, // case 59	Not used in Smalltalk-80
	Interpreter::primitiveBasicAt								, // case 60	Note that the #at: primitive is now the same as #basicAt:
	Interpreter::primitiveBasicAtPut							, // case 61	
	Interpreter::primitiveSize									, // case 62	LargeInteger>>#digitLength
	Interpreter::primitiveStringAt								, // case 63	
	Interpreter::primitiveStringAtPut							, // case 64
	Interpreter::primitiveNext									, // case 65	
	Interpreter::primitiveNextPut								, // case 66
	Interpreter::primitiveAtEnd									, // case 67
	Interpreter::primitiveReturnFromInterrupt					, // case 68	Was CompiledMethod>>#objectAt: (reserve for upTo:)
	Interpreter::primitiveSetSpecialBehavior					, // case 69	Was CompiledMethod>>#objectAt:put:
	Interpreter::primitiveNew									, // case 70	
	Interpreter::primitiveNewWithArg							, // case 71
	Interpreter::primitiveBecome								, // case 72
	Interpreter::primitiveInstVarAt								, // case 73
	Interpreter::primitiveInstVarAtPut							, // case 74
	Interpreter::primitiveBasicIdentityHash						, // case 75	Object>>basicIdentityHash
	Interpreter::primitiveNewPinned								, // case 76
	Interpreter::primitiveAllInstances							, // case 77	was Behavior>>someInstance
	Interpreter::primitiveReturn								, // case 78	was Object>>nextInstance
	Interpreter::primitiveValueOnUnwind							, // case 79	CompiledMethod class>>newMethod:header:
	Interpreter::primitiveVirtualCall							, // case 80	Was ContextPart>>blockCopy:
	Interpreter::primitiveValue									, // case 81
	Interpreter::primitiveValueWithArgsThunk					, // case 82
	Interpreter::primitivePerformThunk							, // case 83
	Interpreter::primitivePerformWithArgsThunk					, // case 84
	Interpreter::primitiveSignalThunk							, // case 85
	Interpreter::primitiveWaitThunk								, // case 86	N.B. DON'T CHANGE, ref'd from signalSemaphore() in process.cpp 
	Interpreter::primitiveResumeThunk							, // case 87
	Interpreter::primitiveSuspendThunk							, // case 88
	Interpreter::primitiveFlushCache							, // case 89	Behavior>>flushCache
	Interpreter::primitiveNewVirtual							, // case 90	Was InputSensor>>primMousePt, InputState>>primMousePt
	Interpreter::primitiveTerminateProcessThunk					, // case 91	Was InputState>>primCursorLocPut:, InputState>>primCursorLocPutAgain:
	Interpreter::primitiveProcessPriorityThunk					, // case 92	Was Cursor class>>cursorLink:
	Interpreter::primitiveInputSemaphore						, // case 93	Is InputState>>primInputSemaphore:
	Interpreter::primitiveSampleInterval						, // case 94	Is InputState>>primSampleInterval:
	Interpreter::primitiveEnableInterrupts						, // case 95	Was InputState>>primInputWord
	Interpreter::primitiveDLL32Call								, // case 96	Was BitBlt>>copyBits
	Interpreter::primitiveSnapshot								, // case 97	Is SystemDictionary>>snapshotPrimitive
	Interpreter::primitiveQueueInterrupt						, // case 98	Was Time class>>secondClockInto:
	Interpreter::primitiveSetSignalsThunk						, // case 99	Was Time class>>millisecondClockInto:
	Interpreter::primitiveSignalAtTickThunk						, // case 100	Is ProcessorScheduler>>signal:atMilliseconds:
	Interpreter::primitiveResize								, // case 101	Was Cursor>>beCursor
	Interpreter::primitiveChangeBehavior						, // case 102	Was DisplayScreen>>beDisplay
	Interpreter::primitiveAddressOf								, // case 103	Was CharacterScanner>>scanCharactersFrom:to:in:rightX:stopConditions:di_SPlaying:
	Interpreter::primitiveReturnFromCallback					, // case 104	Was BitBlt drawLoopX:Y:
	Interpreter::primitiveSingleStepThunk						, // case 105
	Interpreter::primitiveHashBytes								, // case 106	Not used in Smalltalk-80
	Interpreter::primitiveUnwindCallback						, // case 107	ProcessorScheduler>>primUnwindCallback
	Interpreter::primitiveHookWindowCreate						, // case 108	Not used in Smalltalk-80
	Interpreter::unusedPrimitive								, // case 109	Not used in Smalltalk-80
	Interpreter::primitiveIdentical								, // case 110	Character =, Object ==
	Interpreter::primitiveClass									, // case 111	Object class
	Interpreter::primitiveCoreLeftThunk							, // case 112	Was SystemDictionary>>coreLeft - This is now the basic, non-compacting, incremental, garbage collect
	(Interpreter::PrimitiveFp)&Interpreter::primitiveQuit		, // case 113	SystemDictionary>>quitPrimitive
	Interpreter::primitivePerformWithArgsAtThunk				, // case 114	SystemDictionary>>exitToDebugger
	Interpreter::primitiveOopsLeftThunk							, // case 115	SystemDictionary>>oopsLeft - Use this for a compacting garbage collect
	Interpreter::primitivePerformMethodThunk					, // case 116	This was primitiveSignalAtOopsLeftWordsLeft (low memory signal)
	Interpreter::primitiveValueWithArgsAtThunk					, // case 117	Not used in Smalltalk-80
	Interpreter::primitiveDeQForFinalize						, // case 118	Not used in Smalltalk-80 - Dequeue an object from the VM's finalization queue
	Interpreter::primitiveDeQBereavement						, // case 119	Not used in Smalltalk-80 - Dequeue a weak object which has new Corpses and notify it
	Interpreter::primitiveDWORDAt								, // case 120	Not used in Smalltalk-80
	Interpreter::primitiveDWORDAtPut							, // case 121	Not used in Smalltalk-80
	Interpreter::primitiveSDWORDAt								, // case 122	Not used in Smalltalk-80
	Interpreter::primitiveSDWORDAtPut							, // case 123	Not used in Smalltalk-80
	Interpreter::primitiveWORDAt								, // case 124	Not used in Smalltalk-80
	Interpreter::primitiveWORDAtPut								, // case 125	Not used in Smalltalk-80
	Interpreter::primitiveSWORDAt								, // case 126	Not used in Smalltalk-80
	Interpreter::primitiveSWORDAtPut							, // case 127	Not used in Smalltalk-80

	Interpreter::primitiveDoublePrecisionFloatAt				, // case 128
	Interpreter::primitiveDoublePrecisionFloatAtPut				, // case 129
	Interpreter::primitiveSinglePrecisionFloatAt				, // case 130
	Interpreter::primitiveSinglePrecisionFloatAtPut				, // case 131
	Interpreter::primitiveByteAtAddress							, // case 132
	Interpreter::primitiveByteAtAddressPut						, // case 133
	Interpreter::primitiveIndirectDWORDAt						, // case 134
	Interpreter::primitiveIndirectDWORDAtPut					, // case 135
	Interpreter::primitiveIndirectSDWORDAt						, // case 136
	Interpreter::primitiveIndirectSDWORDAtPut					, // case 137
	Interpreter::primitiveIndirectWORDAt						, // case 138
	Interpreter::primitiveIndirectWORDAtPut						, // case 139
	Interpreter::primitiveIndirectSWORDAt						, // case 140
	Interpreter::primitiveIndirectSWORDAtPut					, // case 141
	Interpreter::primitiveReplaceBytes							, // case 142
	Interpreter::primitiveIndirectReplaceBytes					, // case 143
	Interpreter::primitiveNextSDWORD							, // case 144
	Interpreter::primitiveAnyMask								, // case 145
	Interpreter::primitiveAllMask								, // case 146
	Interpreter::primitiveIdentityHash							, // case 147
	Interpreter::primitiveLookupMethod							, // case 148
	Interpreter::primitiveStringSearch							, // case 149
	Interpreter::primitiveUnwindInterruptThunk					, // case 150
	Interpreter::primitiveExtraInstanceSpec						, // case 151
	Interpreter::primitiveLowBit								, // case 152
	Interpreter::primitiveAllReferences							, // case 153
	Interpreter::primitiveOneWayBecome							, // case 154
	Interpreter::primitiveShallowCopy							, // case 155
	Interpreter::primitiveYieldThunk							, // case 156
	Interpreter::primitiveNewInitializedObject					, // case 157
	Interpreter::primitiveSmallIntegerAt						, // case 158
	Interpreter::primitiveLongDoubleAt							, // case 159
	Interpreter::primitiveFloatAdd								, // case 160
	Interpreter::primitiveFloatSubtract							, // case 161
	Interpreter::primitiveFloatLessThan							, // case 162
	Interpreter::primitiveFloatEqual							, // case 163
	Interpreter::primitiveFloatMultiply							, // case 164
	Interpreter::primitiveFloatDivide							, // case 165
	Interpreter::primitiveTruncated								, // case 166
	Interpreter::primitiveLargeIntegerAsFloat					, // case 167
	Interpreter::primitiveAsFloat								, // case 168
	Interpreter::primitiveObjectCount							, // case 169
	Interpreter::primitiveStructureIsNull						, // case 170
	Interpreter::primitiveBytesIsNull							, // case 171
	Interpreter::primitiveVariantValue							, // case 172
	Interpreter::primitiveNextPutAll							, // case 173
	Interpreter::primitiveMillisecondClockValue					, // case 174
	Interpreter::primitiveIndexOfSP								, // case 175
	Interpreter::primitiveStackAtPut							, // case 176
	Interpreter::primitiveGetImmutable							, // case 177
	Interpreter::primitiveSetImmutable							, // case 178
	Interpreter::primitiveInstanceCounts						, // case 179
	Interpreter::primitiveDWORDAt								, // case 180	Will be primitiveUIntPtrAt
	Interpreter::primitiveDWORDAtPut							, // case 181	Will be primitiveUIntPtrAtPut
	Interpreter::primitiveSDWORDAt								, // case 182	Will be primitiveIntPtrAt
	Interpreter::primitiveSDWORDAtPut							, // case 183	Will be primitiveIntPtrAtPut
	Interpreter::primitiveIndirectDWORDAt						, // case 184  Will be primitiveIndirectUIntPtrAt
	Interpreter::primitiveIndirectDWORDAtPut					, // case 185  Will be primitiveIndirectUIntPtrAtPut
	Interpreter::primitiveIndirectSDWORDAt						, // case 186  Will be primitiveIndirectIntPtrAt
	Interpreter::primitiveIndirectSDWORDAtPut					, // case 187  Will be primitiveIndirectIntPtrAtPut
	Interpreter::primitiveReplacePointers						, // case 188
	Interpreter::primitiveMicrosecondClockValue					, // case 189
	Interpreter::primitiveNewFromStack							, // case 190
	Interpreter::primitiveQWORDAt								, // case 191
	Interpreter::primitiveSQWORDAt								, // case 192
	Interpreter::primitiveFloatSin								, // case 193
	Interpreter::primitiveFloatTan								, // case 194
	Interpreter::primitiveFloatCos								, // case 195
	Interpreter::primitiveFloatArcSin							, // case 196
	Interpreter::primitiveFloatArcTan							, // case 197
	Interpreter::primitiveFloatArcCos							, // case 198
	Interpreter::primitiveFloatArcTan2							, // case 199
	Interpreter::primitiveFloatLog								, // case 200
	Interpreter::primitiveFloatExp								, // case 201
	Interpreter::primitiveFloatSqrt								, // case 202
	Interpreter::primitiveFloatLog10							, // case 203
	Interpreter::primitiveFloatTimesTwoPower					, // case 204
	Interpreter::primitiveFloatAbs								, // case 205
	Interpreter::primitiveFloatRaisedTo							, // case 206
	Interpreter::primitiveFloatFloor							, // case 207
	Interpreter::primitiveFloatCeiling							, // case 208
	Interpreter::primitiveFloatExponent							, // case 209
	Interpreter::primitiveFloatNegated							, // case 210
	Interpreter::primitiveFloatClassify							, // case 211
	Interpreter::primitiveFloatFractionPart						, // case 212
	Interpreter::primitiveFloatIntegerPart						, // case 213
	Interpreter::primitiveFloatLessOrEqual						, // case 214
	Interpreter::primitiveStringAsUtf16String					, // case 215
	Interpreter::primitiveStringAsUtf8String					, // case 216
	Interpreter::primitiveStringAsByteString					, // case 217
	Interpreter::primitiveStringConcatenate						, // case 218
	Interpreter::primitiveStringEqual							, // case 219
	Interpreter::primitiveStringCmpOrdinal						, // case 220
	Interpreter::primitiveBasicNext								, // case 221
	Interpreter::primitiveBasicNextPut							, // case 222
	Interpreter::unusedPrimitive								, // case 223
	Interpreter::unusedPrimitive								, // case 224
	Interpreter::unusedPrimitive								, // case 225
	Interpreter::unusedPrimitive								, // case 226
	Interpreter::unusedPrimitive								, // case 227
	Interpreter::unusedPrimitive								, // case 228
	Interpreter::unusedPrimitive								, // case 229
	Interpreter::unusedPrimitive								, // case 230
	Interpreter::unusedPrimitive								, // case 231
	Interpreter::unusedPrimitive								, // case 232
	Interpreter::unusedPrimitive								, // case 233
	Interpreter::unusedPrimitive								, // case 234
	Interpreter::unusedPrimitive								, // case 235
	Interpreter::unusedPrimitive								, // case 236
	Interpreter::unusedPrimitive								, // case 237
	Interpreter::unusedPrimitive								, // case 238
	Interpreter::unusedPrimitive								, // case 239
	Interpreter::unusedPrimitive								, // case 240
	Interpreter::unusedPrimitive								, // case 241
	Interpreter::unusedPrimitive								, // case 242
	Interpreter::unusedPrimitive								, // case 243
	Interpreter::unusedPrimitive								, // case 244
	Interpreter::unusedPrimitive								, // case 245
	Interpreter::unusedPrimitive								, // case 246
	Interpreter::unusedPrimitive								, // case 247
	Interpreter::unusedPrimitive								, // case 248
	Interpreter::unusedPrimitive								, // case 249
	Interpreter::unusedPrimitive								, // case 250
	Interpreter::unusedPrimitive								, // case 251
	Interpreter::unusedPrimitive								, // case 252
	Interpreter::unusedPrimitive								, // case 253
	Interpreter::unusedPrimitive								, // case 254
	Interpreter::unusedPrimitive								, // case 255
};

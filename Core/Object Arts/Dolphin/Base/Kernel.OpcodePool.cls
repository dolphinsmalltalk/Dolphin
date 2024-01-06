"Filed out from Dolphin Smalltalk"!

Kernel.SharedPool
	subclass: #'Kernel.OpcodePool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'BlockCopy' -> 16rFC.
			'Break' -> 16r0.
			'DecPushTemp' -> 16rFB.
			'Decrement' -> 16r63.
			'DecTemp' -> 16rFA.
			'Dup' -> 16r64.
			'ExLongPushImmediate' -> 16rFF.
			'ExLongSend' -> 16rFD.
			'ExLongSupersend' -> 16rFE.
			'FirstDoubleByte' -> 16rCC.
			'FirstMultiByte' -> 16rFC.
			'FirstTripleByte' -> 16rEA.
			'IncPushTemp' -> 16rF9.
			'Increment' -> 16r62.
			'IncTemp' -> 16rF8.
			'IsZero' -> 16rC6.
			'LongJump' -> 16rF1.
			'LongJumpIfFalse' -> 16rF3.
			'LongJumpIfNil' -> 16rF4.
			'LongJumpIfNotNil' -> 16rF5.
			'LongJumpIfTrue' -> 16rF2.
			'LongPopStoreStatic' -> 16rED.
			'LongPushConst' -> 16rEA.
			'LongPushImmediate' -> 16rEE.
			'LongPushStatic' -> 16rEB.
			'LongSend' -> 16rEF.
			'LongStoreStatic' -> 16rEC.
			'LongSupersend' -> 16rF0.
			'NearJump' -> 16rDB.
			'NearJumpIfFalse' -> 16rDD.
			'NearJumpIfNil' -> 16rDE.
			'NearJumpIfNotNil' -> 16rDF.
			'NearJumpIfTrue' -> 16rDC.
			'Nop' -> 16r6D.
			'Pop' -> 16r61.
			'PopContextTemp' -> 16r4D.
			'PopDup' -> 16r4C.
			'PopInstVar' -> 16rD3.
			'PopOuterTemp' -> 16rE6.
			'PopPushSelf' -> 16r4B.
			'PopReturnSelf' -> 16r6C.
			'PopStatic' -> 16rD5.
			'PopTemp' -> 16rD4.
			'PushActiveFrame' -> 16rC7.
			'PushChar' -> 16rD7.
			'PushConst' -> 16rCE.
			'PushContextTemp' -> 16r19.
			'PushImmediate' -> 16rD6.
			'PushInstVar' -> 16rCC.
			'PushOuter' -> 16rF6.
			'PushOuterTemp' -> 16rE4.
			'PushPseudo' -> 16r3A.
			'PushSelf' -> 16r39.
			'PushSelfAndTemp' -> 16rE3.
			'PushStatic' -> 16rCF.
			'PushTemp' -> 16rCD.
			'PushTempPair' -> 16rE9.
			'ReturnFalse' -> 16r67.
			'ReturnFromBlock' -> 16r6A.
			'ReturnFromBlockHome' -> 16r6B.
			'ReturnFromMessage' -> 16r69.
			'ReturnNil' -> 16r68.
			'ReturnPseudo' -> 16r66.
			'ReturnSelf' -> 16r65.
			'Send' -> 16rD8.
			'SendSelfZeroArgs' -> 16rE7.
			'SendTempZeroArgs' -> 16rE2.
			'ShortJump' -> 16r6E.
			'ShortJumpIfFalse' -> 16r76.
			'ShortPopInstVar' -> 16r51.
			'ShortPopOuterTemp' -> 16r4F.
			'ShortPopPushTemp' -> 16r49.
			'ShortPopTemp' -> 16r59.
			'ShortPushConst' -> 16r1D.
			'ShortPushFalse' -> 16r3B.
			'ShortPushImmediate' -> 16r3D.
			'ShortPushInstVar' -> 16r1.
			'ShortPushMinusOne' -> 16r3D.
			'ShortPushNil' -> 16r3C.
			'ShortPushOne' -> 16r3F.
			'ShortPushOuterTemp' -> 16r1B.
			'ShortPushSelfAndTemp' -> 16r41.
			'ShortPushStatic' -> 16r2D.
			'ShortPushTemp' -> 16r11.
			'ShortPushTrue' -> 16r3A.
			'ShortPushTwo' -> 16r40.
			'ShortPushZero' -> 16r3E.
			'ShortSendIsNil' -> 16r9C.
			'ShortSendNotNil' -> 16r9D.
			'ShortSendOneArg' -> 16rB0.
			'ShortSendSelfZeroArgs' -> 16rAB.
			'ShortSendTwoArgs' -> 16rBE.
			'ShortSendZeroArgs' -> 16r9E.
			'ShortSpecialSend' -> 16r7E.
			'ShortSpecialSendEx' -> 16rC8.
			'ShortStoreTemp' -> 16r45.
			'SpecialSend' -> 16rDA.
			'StoreInstVar' -> 16rD0.
			'StoreOuter' -> 16rF7.
			'StoreOuterTemp' -> 16rE5.
			'StoreStatic' -> 16rD2.
			'StoreTemp' -> 16rD1.
			'Supersend' -> 16rD9
		}!
Kernel.OpcodePool guid: (Core.GUID fromString: '{1913f573-a07c-4ca8-8ab7-8afbd024a785}')!
Kernel.OpcodePool isNonInstantiable: true!
Kernel.OpcodePool comment: ''!
!Kernel.OpcodePool categoriesForClass!System-Compiler! !

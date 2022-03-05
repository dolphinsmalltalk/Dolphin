"Filed out from Dolphin Smalltalk"!

Object subclass: #InstructionInterpreter
	instanceVariableNames: 'dispatcher'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InstructionInterpreter guid: (GUID fromString: '{369fe97b-c73c-4283-9e17-ff09c8bac2d8}')!
InstructionInterpreter isAbstract: true!
InstructionInterpreter comment: 'InstructionInterpreter is the abstract class of <bytecodeInterpreter>s that can act as the client of a <ByteCodeDispatcher>.

Instance Variables:
	dispatcher		<ByteCodeDispatcher>

'!
!InstructionInterpreter categoriesForClass!System-Support! !
!InstructionInterpreter methodsFor!

blockCopy: argc stack: stack env: env copy: copy offset1: offset1 offset2: offset2 
	"Interpret a Block Copy instruction."
!

break
	"Interpret a Debug Break instruction."

	!

decodeNearOffset: extensionByte1 
	^extensionByte1 >= 128 ifTrue: [extensionByte1 - 256] ifFalse: [extensionByte1]!

decPushTemp: arg1 temp: offset
	"Private - Interpret an Decremement & Push Temporary Variable instruction."

	self
		pushTemp: offset;
		decrementStackTop;
		storeTemp: offset!

decrementStackTop
	"Interpret a Decrement Stack Top instruction."
!

decTemp: arg1 temp: offset 
	"Private - Interpret an Decremement Temporary Variable instruction."

	self
		pushTemp: offset;
		decrementStackTop;
		popTemp: offset!

dispatcher
	^dispatcher!

dispatcher: aByteCodeDispatcher 
	dispatcher := aByteCodeDispatcher.
	aByteCodeDispatcher interpreter: self!

duplicateStackTop
	"Interpret a Dup instruction."
!

exLongPushImmediate: extensionByte1 byte2: extensionByte2 byte3: extensionByte3 byte4: anInteger4
	"Interpret a PushSmallInteger instruction. The SmallInteger is encoded in the extension
	bytes in little endian order"

	!

exLongSend: extensionByte1 with: extensionByte2 with: extensionByte3 
	"Interpret an extended long send instruction."

	self send: extensionByte2 + (extensionByte3 bitShift: 8) args: extensionByte1!

exLongSupersend: extensionByte1 with: extensionByte2 with: extensionByte3 
	"Interpret an Extended Long Supersend instruction."

	self supersend: extensionByte2 + (extensionByte3 bitShift: 8) args: extensionByte1!

incPushTemp: arg1 temp: offset
	"Private - Interpret an Incremement & Push Temporary Variable instruction."

	self
		pushTemp: offset;
		incrementStackTop;
		storeTemp: offset!

incrementStackTop
	"Interpret an Increment Stack Top instruction."
!

incTemp: arg1 temp: offset 
	"Private - Interpret an Incremement Temporary Variable instruction."

	self
		pushTemp: offset;
		incrementStackTop;
		popTemp: offset!

interpret
	"Interpret all the instructions in the method."

	dispatcher dispatchAll!

isZero
	"Interpret an IsZero instruction (compares for identity with SmallInteger zero)."
!

jump: anInteger 
	"Private - Interpret an unconditional Jump instruction to the specified offset from the current IP
	(i.e. the IP after fetching the jump instruction)."
	!

jumpIfFalse: anInteger 
	"Private - Interpret a conditional Jump If False instruction to the specified offset from the current IP
	(i.e. the IP after fetching the jump instruction)."!

jumpIfNil: anInteger 
	"Private - Interpret a conditional Jump If Nil instruction to the specified offset from the current IP
	(i.e. the IP after fetching the jump instruction)."!

jumpIfNotNil: anInteger 
	"Private - Interpret a conditional Jump If Not Nil instruction to the specified offset from the current IP
	(i.e. the IP after fetching the jump instruction)."!

jumpIfTrue: anInteger 
	"Private - Interpret a conditional Jump If True instruction to the specified offset from the current IP
	(i.e. the IP after fetching the jump instruction)."!

longJump: extensionByte1 with: extensionByte2 
	"Interpret a long jump instruction of the offset specified by the arguments."

	self jump: (ByteCodeDispatcher decodeLongJump: extensionByte1 byte2: extensionByte2)!

longJumpIfFalse: extensionByte1 with: extensionByte2 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jumpIfFalse: (ByteCodeDispatcher decodeLongJump: extensionByte1 byte2: extensionByte2)!

longJumpIfNil: extensionByte1 with: extensionByte2 
	self jumpIfNil: (ByteCodeDispatcher decodeLongJump: extensionByte1 byte2: extensionByte2)!

longJumpIfNotNil: extensionByte1 with: extensionByte2 
	self jumpIfNotNil: (ByteCodeDispatcher decodeLongJump: extensionByte1 byte2: extensionByte2)!

longJumpIfTrue: extensionByte1 with: extensionByte2 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jumpIfTrue: (ByteCodeDispatcher decodeLongJump: extensionByte1 byte2: extensionByte2)!

longPopStoreStatic: byte1 with: byte2 
	"Interpret a Long Pop And Store Literal Variable instruction."

	self popStatic: (byte2 * 256) + byte1!

longPushConst: extensionByte1 with: extensionByte2 
	"Interpret a Long Push Const instruction."

	self pushConst: extensionByte2 * 256 + extensionByte1!

longPushImmediate: extensionByte1 with: extensionByte2 
	"Interpret a Push Immediate Word instruction."

	self 
		pushImmediateInteger: (extensionByte2 >= 128 
				ifTrue: [extensionByte2 - 256]
				ifFalse: [extensionByte2]) * 256 
				+ extensionByte1!

longPushStatic: extensionByte1 with: extensionByte2 
	"Interpret a Long Push Literal Variable instruction."

	self pushStatic: extensionByte2 * 256 + extensionByte1!

longSend: extensionByte1 with: extensionByte2 
	"Interpret a Long Send instruction."

	self send: extensionByte2 args: extensionByte1!

longStoreStatic: byte1 with: byte2
	"Interpret a Long Store Literal Variable instruction."

	self storeStatic:  byte2 * 256 + byte1!

longSupersend: extensionByte1 with: extensionByte2 
	"Interpret a Long Supersend instruction."

	self supersend: extensionByte2 args: extensionByte1!

macroInstructionPart2
	"Sent between the first and second parts of a macro instruction."

	!

method
	"Answer the <CompiledMethod> which the receiver is decoding."

	^dispatcher method!

method: aCompiledMethod 
	"Set the method to be decoded by the receiver to aCompiledMethod."

	self dispatcher: (aCompiledMethod byteCodeDispatcherClass on: aCompiledMethod for: self)!

nearJump: extensionByte1 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jump: (self decodeNearOffset: extensionByte1)!

nearJumpIfFalse: extensionByte1 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jumpIfFalse: (self decodeNearOffset: extensionByte1)!

nearJumpIfNil: extensionByte1 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jumpIfNil: (self decodeNearOffset: extensionByte1)!

nearJumpIfNotNil: extensionByte1 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jumpIfNotNil: (self decodeNearOffset: extensionByte1)!

nearJumpIfTrue: extensionByte1 
	"Interpret a long jump instruction of the offset specified by the argument."

	self jumpIfTrue: (self decodeNearOffset: extensionByte1)!

nop
	"Interpret a Nop (no-operation) instruction."
!

popContextTemp: anInteger 
	"Interpret a Short Pop And Store Context Temp instruction."

	self popOuter: 0 temp: anInteger!

popDup
	"Interpret a Pop & Dup instruction.
	This instruction is commonly used in cascaded sends."

	self
		popStackTop;
		macroInstructionPart2;
		duplicateStackTop!

popInstVar: instVarIndex 
	"Interpret a Pop And Store Instance Variable instruction."

	self
		storeInstVar: instVarIndex;
		macroInstructionPart2;
		popStackTop!

popOuter: contextDepth temp: envTempIndex 
	"Private - Interpret a Pop & Store Outer [M] Temp [N] instruction."

	self
		storeOuter: contextDepth temp: envTempIndex;
		macroInstructionPart2;
		popStackTop!

popOuterTemp: arg 
	"Interpret a Pop And Store Instance Environment Temporary instruction."

	self popOuter: (arg bitShift: -5) temp: (arg bitAnd: 16r1F)!

popPushSelf
	"Interpret a Pop & Push Self instruction.
	This instruction is commonly used in sequences of statements that are uncascaded
	sends to self."

	self
		popStackTop;
		macroInstructionPart2;
		pushSelf!

popPushTemp: tempIndex 
	"Interpret a Pop & Push Temp [N] instruction."

	self
		popStackTop;
		macroInstructionPart2;
		pushTemp: tempIndex!

popReturnSelf
	"Interpret a Pop & Return Self instruction. 
	This is commonly used in methods with no explicit return to pop the value
	of the last statement from the stack and return in one operation."

	self
		popStackTop;
		macroInstructionPart2;
		returnSelf!

popStackTop
	"Interpret a Pop instruction."

	!

popStatic: literalIndex 
	"Interpret a Pop And Store Literal Variable instruction."

	self
		storeStatic: literalIndex;
		macroInstructionPart2;
		popStackTop!

popTemp: tempIndex 
	"Interpret a Pop And Store Stack Temporary instruction."

	self
		storeTemp: tempIndex;
		macroInstructionPart2;
		popStackTop!

pushActiveFrame
	"Interpret a Push Active Frame instruction."
!

pushChar: asciiValue 
	"Interpret a Push Char instruction."

	self pushCharacter: (Character value: asciiValue)!

pushCharacter: aCharacter 
!

pushConst: literalIndex 
	"Interpret a Push Literal Constant instruction."
!

pushContextTemp: anInteger 
	"Interpret a short Push Context Temporary Variable instruction.
	This is equivalent to a Push Outer[0] Temp[N] instruction."

	self pushOuter: 0 temp: anInteger!

pushImmediate: offset
	"Interpret a Push Immediate Byte instruction."

	self pushImmediateInteger: (offset >= 128 ifTrue: [ offset - 256 ] ifFalse: [ offset ])!

pushImmediateInteger: anInteger 
	"Private - Interpret a Push Immediate N instruction."!

pushInstVar: instVarIndex 
	"Interpret a Push Instance Variable instruction."

	!

pushOuter: contextDepth temp: envTempIndex
	"Interpret a Push Outer [M] Temp [N] instruction."!

pushOuterTemp: arg 
	"Interpret a Push Environment Temporary Variable instruction."

	self pushOuter: (arg bitShift: -5) temp: (arg bitAnd: 16r1F)!

pushPseudo: offset 
	"Interpret a Push nil/true/false/self instruction."

	!

pushSelf
	"Interpret a Push Self instruction."

	!

pushSelfAndTemp: tempIndex 
	"Interpret a Push Self And Temporary Variable instruction.
	Commonly used in sends to self of one argument messages."

	self
		pushSelf;
		macroInstructionPart2;
		pushTemp: tempIndex!

pushStatic: offset
	"Interpret a Short Push Literal Variable instruction."

!

pushTemp: offset
	"Interpret a Push Temporary Variable instruction."

!

pushTempPair: anInteger 
	"Interpret a Push Pair of Temporary Variables instruction.
	Commonly used when pushing the arguments to muli-keyword messages,
	or in sends of one-argument messages to a temporary."

	self
		pushTemp: anInteger >> 4;
		macroInstructionPart2;
		pushTemp: (anInteger bitAnd: 16rF)!

reset
	dispatcher reset!

returnFromBlock
	"Interpret a return from block to its caller."

	!

returnFromBlockHome
	"Interpret a return from block's home method (i.e. a ^-return inside a block)."

	!

returnFromMessage
	"Interpret a return from message (^-return in a method)."

	!

returnPseudo: offset
	"Interpret a Return nil/true/false/self instruction."
!

returnSelf
	"Interpret a Return Self instruction."!

send: extensionByte
	"Interpret a Send instruction."

	self send: (extensionByte bitAnd: 31) args: (extensionByte bitShift: -5)!

send: literalIndex args: argumentCount 
	"Private - Interpret a Send [N]with M args instruction."

	self sendSelector: (self method literalAt: literalIndex + 1) args: argumentCount!

sendSelector: aSymbol args: anObject 
	!

sendSelf: literalIndex args: argumentCount 
	"Private - Interpret a Send Self [N] with M args instruction."

	self
		pushSelf;
		macroInstructionPart2;
		send: literalIndex args: argumentCount!

sendSelfSelector: aSymbol args: anInteger 
	!

sendSelfZeroArgs: anInteger 
	"Interpret a Send Self [N] with 0 Args instruction."

	self sendSelf: anInteger args: 0!

sendTempZeroArgs: anInteger 
	"Interpret a Send [N] to Temp [M] with 0 Args instruction."

	self sendZeroArgs: (anInteger bitAnd: 16r1F) toTemp: (anInteger bitShift: -5)!

sendZeroArgs: literalInteger toTemp: tempInteger 
	"Private - Interpret a Send [N] to Temp [M] with 0 Args instruction."

	self
		pushTemp: tempInteger;
		macroInstructionPart2;
		send: literalInteger args: 0!

shortJump: offset 
	"Interpret a short jump instruction of the offset specified by the argument."

	self jump: offset+1!

shortJumpIfFalse: offset 
	"Interpret a short jump instruction of the offset specified by the argument."

	self jumpIfFalse: offset+1!

shortPopInstVar: instVarIndex 
	"Interpret a Short Pop And Store Instance Variable instruction."

	self popInstVar: instVarIndex!

shortPopOuterTemp: anInteger 
	"Interpret a Short Pop And Store Outer Temp instruction."

	self popOuter: 1 temp: anInteger!

shortPopPushTemp: offset 
	"Interpret a Short Pop & Push Temporary Variable instruction."

	self popPushTemp: offset!

shortPopTemp: offset 
	"Interpret a Short Pop And Store Instance Variable instruction."

	self popTemp: offset!

shortPushConst: offset 
	"Interpret a Short Push Literal Constant instruction."

	self pushConst: offset!

shortPushImmediate: offset 
	"Interpret a Short Push -1/0/1/2 instruction."

	self pushImmediateInteger: offset - 1!

shortPushInstVar: instVarIndex 
	"Interpret a Short Push Instance Variable instruction."

	self pushInstVar: instVarIndex!

shortPushOuterTemp: anInteger 
	"Interpret a short Push Outer Temporary Variable instruction."

	self pushOuter: 1 temp: anInteger!

shortPushSelfAndTemp: anInteger 
	"Interpret a Short Push Self & Temp[N] instruction."

	self pushSelfAndTemp: anInteger!

shortPushStatic: literalIndex 
	"Interpret a Short Push Literal Variable instruction."

	self pushStatic: literalIndex!

shortPushTemp: tempIndex 
	"Interpret a Short Push Temporary Variable instruction."

	self pushTemp: tempIndex!

shortSendOneArg: literalIndex 
	"Interpret a Short Send instruction."

	self send: literalIndex args: 1!

shortSendSelfZeroArgs: anInteger 
	"Interpret a Short Send Self [N] with 0 Args instruction."

	self sendSelfZeroArgs: anInteger!

shortSendTwoArgs: literalIndex
	"Interpret a Short Send [N] with 2 Args instruction."

	self send: literalIndex args: 2!

shortSendZeroArgs: literalIndex 
	"Interpret a Short Send instruction."

	self send: literalIndex args: 0!

shortSpecialSend: anInteger
	"Interpret a Short Special Send instruction."

	| selector |
	selector := dispatcher selectorOfSpecialSend: anInteger.
	self sendSelector: selector args: selector argumentCount!

shortSpecialSendEx: anInteger
	"Interpret a Short Special Send Ex instruction."

	| selector |
	selector := dispatcher selectorOfSpecialSendEx: anInteger.
	self sendSelector: selector args: selector argumentCount!

shortStoreTemp: anInteger
	"Interpret a short Store Temporary Variable instruction."

	self storeTemp: anInteger!

storeInstVar: offset 
	"Interpret a Store Instance Variable instruction."

	!

storeOuter: contextDepth temp: envTempIndex 
	"Interpret a Store Outer [M] Temp [N] instruction."

	!

storeOuterTemp: arg 
	"Interpret a Store Environment Temporary Variable instruction."

	self storeOuter: (arg bitShift: -5) temp: (arg bitAnd: 16r1F)!

storeStatic: literalIndex 
	"Interpret a Store Literal Variable instruction."

	!

storeTemp: tempIndex 
	"Interpret a Store Temporary Variable instruction."

	!

supersend: extensionByte 
	"Interpret a Supersend instruction."

	self supersend: (extensionByte bitAnd: 31) args: (extensionByte bitShift: -5)!

supersend: literalIndex args: argumentCount 
	"Private - Interpret a Supersend [N] with M args instruction."

	self supersendSelector: (self method literalAt: literalIndex+1)!

supersendSelector: aSymbol 
!

unused
	"Interpret an unused short instruction."

	!

unused: extensionByte 
	"Interpret an unused double byte instruction."

	!

unused: extensionByte1 with: extensionByte2 
	"Interpret an unused triple byte instruction."

	!

unused: extensionByte1 with: extensionByte2 with: extensionByte3
	"Interpret an unused quad byte instruction."
! !
!InstructionInterpreter categoriesForMethods!
blockCopy:stack:env:copy:offset1:offset2:!instructions-miscellaneous!public! !
break!instructions-miscellaneous!public! !
decodeNearOffset:!helpers!public! !
decPushTemp:temp:!instructions-stack ops!public! !
decrementStackTop!instructions-miscellaneous!public! !
decTemp:temp:!instructions-miscellaneous!public! !
dispatcher!accessing!public! !
dispatcher:!accessing!public! !
duplicateStackTop!instructions-stack ops!public! !
exLongPushImmediate:byte2:byte3:byte4:!instructions-stack ops!public! !
exLongSend:with:with:!instructions-sending!public! !
exLongSupersend:with:with:!instructions-sending!public! !
incPushTemp:temp:!instructions-stack ops!public! !
incrementStackTop!instructions-miscellaneous!public! !
incTemp:temp:!instructions-miscellaneous!public! !
interpret!interpreting!public! !
isZero!instructions-miscellaneous!public! !
jump:!interpreting!private! !
jumpIfFalse:!interpreting!private! !
jumpIfNil:!interpreting!private! !
jumpIfNotNil:!interpreting!private! !
jumpIfTrue:!interpreting!private! !
longJump:with:!instructions-jumping!public! !
longJumpIfFalse:with:!instructions-jumping!public! !
longJumpIfNil:with:!instructions-jumping!public! !
longJumpIfNotNil:with:!instructions-jumping!public! !
longJumpIfTrue:with:!instructions-jumping!public! !
longPopStoreStatic:with:!instructions-stack ops!public! !
longPushConst:with:!instructions-stack ops!public! !
longPushImmediate:with:!instructions-stack ops!public! !
longPushStatic:with:!instructions-stack ops!public! !
longSend:with:!instructions-sending!public! !
longStoreStatic:with:!instructions-stack ops!public! !
longSupersend:with:!instructions-sending!public! !
macroInstructionPart2!interpreting!private! !
method!accessing!public! !
method:!accessing!public! !
nearJump:!instructions-jumping!public! !
nearJumpIfFalse:!instructions-jumping!public! !
nearJumpIfNil:!instructions-jumping!public! !
nearJumpIfNotNil:!instructions-jumping!public! !
nearJumpIfTrue:!instructions-jumping!public! !
nop!instructions-miscellaneous!public! !
popContextTemp:!instructions-stack ops!public! !
popDup!instructions-stack ops!public! !
popInstVar:!instructions-stack ops!public! !
popOuter:temp:!interpreting!private! !
popOuterTemp:!instructions-stack ops!public! !
popPushSelf!instructions-stack ops!public! !
popPushTemp:!instructions-stack ops!public! !
popReturnSelf!instructions-returning!public! !
popStackTop!instructions-stack ops!public! !
popStatic:!instructions-stack ops!public! !
popTemp:!instructions-stack ops!public! !
pushActiveFrame!instructions-stack ops!public! !
pushChar:!instructions-stack ops!public! !
pushCharacter:!interpreting!private! !
pushConst:!instructions-stack ops!public! !
pushContextTemp:!instructions-stack ops!public! !
pushImmediate:!instructions-stack ops!public! !
pushImmediateInteger:!interpreting!private! !
pushInstVar:!instructions-stack ops!public! !
pushOuter:temp:!instructions-stack ops!public! !
pushOuterTemp:!instructions-stack ops!public! !
pushPseudo:!instructions-stack ops!public! !
pushSelf!instructions-stack ops!public! !
pushSelfAndTemp:!instructions-stack ops!public! !
pushStatic:!instructions-stack ops!public! !
pushTemp:!instructions-stack ops!public! !
pushTempPair:!instructions-stack ops!public! !
reset!positioning!public! !
returnFromBlock!instructions-returning!public! !
returnFromBlockHome!instructions-returning!public! !
returnFromMessage!instructions-returning!public! !
returnPseudo:!instructions-returning!public! !
returnSelf!instructions-returning!public! !
send:!instructions-sending!public! !
send:args:!interpreting!private! !
sendSelector:args:!interpreting!private! !
sendSelf:args:!interpreting!private! !
sendSelfSelector:args:!interpreting!private! !
sendSelfZeroArgs:!instructions-sending!public! !
sendTempZeroArgs:!instructions-sending!public! !
sendZeroArgs:toTemp:!interpreting!private! !
shortJump:!instructions-jumping!public! !
shortJumpIfFalse:!instructions-jumping!public! !
shortPopInstVar:!instructions-stack ops!public! !
shortPopOuterTemp:!instructions-stack ops!public! !
shortPopPushTemp:!instructions-stack ops!public! !
shortPopTemp:!instructions-stack ops!public! !
shortPushConst:!instructions-stack ops!public! !
shortPushImmediate:!instructions-stack ops!public! !
shortPushInstVar:!instructions-stack ops!public! !
shortPushOuterTemp:!instructions-stack ops!public! !
shortPushSelfAndTemp:!instructions-stack ops!public! !
shortPushStatic:!instructions-stack ops!public! !
shortPushTemp:!instructions-stack ops!public! !
shortSendOneArg:!instructions-sending!public! !
shortSendSelfZeroArgs:!instructions-sending!public! !
shortSendTwoArgs:!instructions-sending!public! !
shortSendZeroArgs:!instructions-sending!public! !
shortSpecialSend:!instructions-sending!public! !
shortSpecialSendEx:!instructions-sending!public! !
shortStoreTemp:!instructions-stack ops!public! !
storeInstVar:!instructions-stack ops!public! !
storeOuter:temp:!instructions-stack ops!public! !
storeOuterTemp:!instructions-stack ops!public! !
storeStatic:!instructions-stack ops!public! !
storeTemp:!instructions-stack ops!public! !
supersend:!instructions-sending!public! !
supersend:args:!interpreting!private! !
supersendSelector:!interpreting!private! !
unused!instructions-unused!public! !
unused:!instructions-unused!public! !
unused:with:!instructions-unused!public! !
unused:with:with:!instructions-unused!public! !
!

InstructionInterpreter methodProtocol: #bytecodeInterpreter attributes: #() selectors: #(#blockCopy:stack:env:copy:offset1:offset2: #break #decPushTemp:temp: #decrementStackTop #decTemp:temp: #duplicateStackTop #exLongSend:with:with: #exLongSupersend:with:with: #incPushTemp:temp: #incrementStackTop #incTemp:temp: #isZero #longJump:with: #longJumpIfFalse:with: #longJumpIfNil:with: #longJumpIfNotNil:with: #longJumpIfTrue:with: #longPopStoreStatic:with: #longPushConst:with: #longPushImmediate:with: #longPushStatic:with: #longSend:with: #longStoreStatic:with: #longSupersend:with: #nearJump: #nearJumpIfFalse: #nearJumpIfNil: #nearJumpIfNotNil: #nearJumpIfTrue: #nop #popContextTemp: #popDup #popInstVar: #popOuterTemp: #popPushSelf #popReturnSelf #popStackTop #popStatic: #popTemp: #pushActiveFrame #pushChar: #pushConst: #pushContextTemp: #pushImmediate: #pushInstVar: #pushOuter:temp: #pushOuterTemp: #pushPseudo: #pushSelfAndTemp: #pushStatic: #pushTemp: #pushTempPair: #returnFromBlock #returnFromBlockHome #returnFromMessage #returnPseudo: #returnSelf #send: #sendSelfZeroArgs: #sendTempZeroArgs: #shortJump: #shortJumpIfFalse: #shortPopInstVar: #shortPopOuterTemp: #shortPopPushTemp: #shortPopTemp: #shortPushConst: #shortPushImmediate: #shortPushInstVar: #shortPushOuterTemp: #shortPushSelfAndTemp: #shortPushStatic: #shortPushTemp: #shortSendOneArg: #shortSendSelfZeroArgs: #shortSendTwoArgs: #shortSendZeroArgs: #shortSpecialSend: #shortStoreTemp: #storeInstVar: #storeOuter:temp: #storeOuterTemp: #storeStatic: #storeTemp: #supersend: #unused #unused: #unused:with: #unused:with:with:)!

!InstructionInterpreter class methodsFor!

dispatcher: aByteCodeDispatcher 
	^(self new)
		dispatcher: aByteCodeDispatcher;
		yourself!

method: aCompiledMethod 
	"Answer a String containing a disassembly listing for aMethod."

	^(self new)
		method: aCompiledMethod;
		yourself!

new
	^self basicNew initialize! !
!InstructionInterpreter class categoriesForMethods!
dispatcher:!instance creation!public! !
method:!instance creation!public! !
new!instance creation!public! !
!


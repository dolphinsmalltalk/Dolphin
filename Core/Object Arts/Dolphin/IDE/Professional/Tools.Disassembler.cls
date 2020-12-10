"Filed out from Dolphin Smalltalk 7"!

Kernel.InstructionInterpreter subclass: #'Tools.Disassembler'
	instanceVariableNames: 'stream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Disassembler guid: (Core.GUID fromString: '{87b4c47e-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.Disassembler comment: 'Disassembler is an <InstructionInterpreter> for disassembling Dolphin <CompiledMethod>s.

Instance Variables:
	stream		<puttableStream>. The stream to which disassembled instructions are written.

'!
!Tools.Disassembler categoriesForClass!System-Support! !
!Tools.Disassembler methodsFor!

blockCopy: argc stack: stack env: env copy: copy offset1: offset1 offset2: offset2 
	"Private - Interpret a Block copy instruction."

	| envSize copiedValues offset |
	stream
		nextPutAll: 'Block Copy, ';
		print: argc;
		nextPutAll: ' args, '.
	stack > 0 
		ifTrue: 
			[stream
				print: stack;
				nextPutAll: ' stack temps, '].
	envSize := env >> 1.
	copiedValues := copy >> 1.
	envSize > 0 
		ifTrue: 
			[stream
				print: envSize;
				nextPutAll: ' env temps, '].
	copiedValues > 0 
		ifTrue: 
			[stream
				print: copiedValues;
				nextPutAll: ' copied values, '].
	(copy allMask: 1) ifTrue: [stream nextPutAll: 'needs self, '].
	(env allMask: 1) ifTrue: [stream nextPutAll: 'needs outer, '].
	stream nextPutAll: 'skip '.
	offset := ByteCodeDispatcher decodeLongJump: offset1 byte2: offset2.
	self printJumpOffset: offset!

break
	"Private - Interpret a debug break instruction."

	stream nextPutAll: '*Break'!

decodeHeaderOn: aStream 
	"Private - Answer a String describing the method header."

	| method |
	method := self method.
	aStream 
		nextPutAll: (#('Normal' 'Return self' 'Return true' 'Return false' 'Return nil' 'Return literal constant 0' 'Return instance variable' 'Set instance variable' 'Return literal static 0') 
				at: method extraIndex + 1
				ifAbsent: ['Primitive: ']).
	method isPrimitive ifTrue: [aStream print: method primitiveIndex].
	aStream
		nextPutAll: ', ';
		print: method argumentCount;
		nextPutAll: ' args, '.
	method stackTempCount > 0 
		ifTrue: 
			[aStream
				print: method stackTempCount;
				nextPutAll: ' stack temps, '].
	method envInfo > 0 
		ifTrue: 
			[aStream
				print: method envTempCount;
				nextPutAll: ' env temps, '].
	aStream
		print: method literalCount;
		nextPutAll: ' literals'.
	method needsContext ifTrue: [aStream nextPutAll: ', needs context'].
	method isDebugMethod ifTrue: [aStream nextPutAll: ', debug']!

decPushTemp: suffix temp: offset 
	"Private - Interpret an Incremement & Push Temporary Variable instruction."

	stream nextPutAll: 'Decrement & Push '.
	self printTempSuffix: offset!

decrementStackTop
	"Private - Interpret a Decrement Stack Top instruction."

	stream nextPutAll: 'Decrement'!

decTemp: suffix temp: offset 
	"Private - Interpret an Incremement Temporary Variable instruction."

	stream nextPutAll: 'Decrement '.
	self printTempSuffix: offset!

disassemble
	"Append a text decoding of the method to aStream."

	self reset.
	dispatcher atEnd ifTrue: [^String new].
	self disassembleUntil: [dispatcher atEnd].
	^self listing!

disassembleUntil: discriminator 
	
	[stream
		tab;
		print: dispatcher ip;
		tab.
	dispatcher dispatchNext.
	discriminator value] 
			whileFalse: [stream cr]!

duplicateStackTop
	"Private - Interpret a duplicate stack top instruction."

	stream nextPutAll: 'Dup'!

exLongPushImmediate: extensionByte1 byte2: extensionByte2 byte3: extensionByte3 byte4: extensionByte4
	self
		pushImmediateInteger: ((((extensionByte4 >= 128
				ifTrue: [extensionByte4 - 256]
				ifFalse: [extensionByte4]) << 8)
				+ extensionByte3 << 8)
				+ extensionByte2 << 8)
				+ extensionByte1 >> 1!

fullDisassembly
	self reset.
	self decodeHeaderOn: stream.
	stream
		cr;
		cr.
	dispatcher atEnd ifFalse: [self disassembleUntil: [dispatcher atEnd]].
	^self listing!

incPushTemp: suffix temp: offset 
	"Private - Interpret an Incremement & Push Temporary Variable instruction."

	stream nextPutAll: 'Increment & Push '.
	self printTempSuffix: offset!

incrementStackTop
	"Private - Interpret an Increment Stack Top instruction."

	stream nextPutAll: 'Increment'!

incTemp: suffix temp: offset 
	"Private - Interpret an Incremement Temporary Variable instruction."

	stream nextPutAll: 'Increment '.
	self printTempSuffix: offset!

initialize
	stream := String smalltalkWriteStream: 256!

isZero
	"Private - Interpret an IsZero instruction (compares for identity with SmallInteger zero)."

	stream nextPutAll: 'IsZero'!

jump: offset 
	"Private - Interpret an unconditional Jump instruction."

	stream nextPutAll: 'Jump '.
	self printJumpOffset: offset!

jumpIfFalse: anInteger 
	stream nextPutAll: 'Jump If False '.
	self printJumpOffset: anInteger!

jumpIfNil: anInteger 
	stream nextPutAll: 'Jump If Nil '.
	self printJumpOffset: anInteger!

jumpIfNotNil: anInteger 
	stream nextPutAll: 'Jump If Not Nil '.
	self printJumpOffset: anInteger!

jumpIfTrue: anInteger 
	stream nextPutAll: 'Jump If True '.
	self printJumpOffset: anInteger!

listing
	^stream contents!

macroInstructionPart2
	stream nextPutAll: '; '!

maxLiteralPrint
	^60!

methodClass
	"Answer the class which the receivers method belongs to."

	^self method methodClass!

nop
	"Private - Interpret a Nop instruction."

	stream nextPutAll: 'Nop'!

popInstVar: instVarIndex 
	"Interpret a Pop And Store Instance Variable instruction."

	self printPopPrefix.
	self printInstVarSuffix: instVarIndex!

popOuter: contextDepth temp: envTempIndex 
	"Private - Interpret a Pop & Store Outer [M] Temp [N] instruction."

	self printPopPrefix.
	self printOuter: contextDepth temp: envTempIndex!

popStackTop
	"Private - Interpret a Pop instruction."

	stream nextPutAll: 'Pop'!

popStatic: literalIndex 
	"Interpret a Pop And Store Literal Variable instruction."

	self printPopPrefix.
	self printStaticSuffix: literalIndex!

popTemp: tempIndex 
	"Interpret a Pop And Store Stack Temporary instruction."

	self printPopPrefix.
	self printTempSuffix: tempIndex!

printConstSuffix: offset 
	"Private - Append the literal constant access suffic to the stream."

	stream
		nextPutAll: 'Const[';
		print: offset;
		nextPutAll: ']: '.
	self printLiteral: offset!

printExLongPrefix
	"Private - Append the extra long instruction prefix to the stream"

	stream nextPutAll: 'Ex Long '!

printInstVarSuffix: offset 
	"Private - Append the instance variable access suffix to the stream."

	| instVarName |
	instVarName := self method methodClass allInstVarNames at: offset + 1 ifAbsent: ['**Invalid**'].
	stream
		nextPutAll: 'Inst Var[';
		print: offset;
		nextPut: $];
		nextPutAll: ': ' , instVarName!

printJumpOffset: offset 
	"Note that the offset is from the current IP, which is of the instruction immediately after the
	jump."

	offset > 0 ifTrue: [stream nextPut: $+].
	stream
		print: offset;
		nextPutAll: ' to ';
		print: dispatcher ip + offset!

printLiteral: offset 
	| literal cc |
	literal := (self method literalAt: offset + 1) debugPrintString.
	cc := (literal indexOf: Character cr ifAbsent: [literal size + 1]) - 1 min: self maxLiteralPrint.
	stream 
		next: cc
		putAll: literal
		startingAt: 1.
	cc < literal size ifTrue: [stream nextPutAll: '...']!

printLongPrefix
	"Private - Append the long instruction prefix to the stream"

	stream nextPutAll: 'Long '!

printOuter: contextDepth temp: envTempIndex 
	stream
		nextPutAll: 'Outer[';
		print: contextDepth;
		nextPutAll: '] Temp[';
		print: envTempIndex;
		nextPut: $]!

printPopPrefix
	stream nextPutAll: 'Pop '!

printPseudoSuffix: offset 
	"Private - Append the pseudo variable access suffix to the stream."

	stream nextPutAll: (#('true' 'false' 'nil') at: offset + 1)!

printPushPrefix
	"Private - Append the push instruction prefix to the stream"

	stream nextPutAll: 'Push '!

printReturnPrefix
	"Private - Append the return instruction prefix to the stream"

	stream nextPutAll: 'Return '!

printSendPrefix
	"Private - Append the send instruction prefix to the stream."

	stream nextPutAll: 'Send'!

printSendSuffix: extensionByte
	"Private - Append the suffix for a double byte send instruction."

	self printSendSuffix: (extensionByte bitAnd: 31) args: (extensionByte bitShift: -5)!

printSendSuffix: selectorIndex args: argCount 
	"Private - Append the suffix for a double byte send instruction."

	stream
		nextPut: $[;
		display: selectorIndex;
		nextPutAll: ']: '.
	self printLiteral: selectorIndex.
	stream
		nextPutAll: ' with ';
		print: argCount;
		nextPutAll: ' args'!

printShortJumpOffset: offset 
	"Private - Append a short jump offset to the stream."

	stream
		print: offset + 2;
		nextPutAll: ' to ';
		print: dispatcher ip + offset + 1!

printShortPrefix
	"Private - Append the short push instruction prefix to the stream"

	"stream nextPutAll: 'Short '"!

printStaticSuffix: offset 
	"Private - Append the literal variable access suffix to the stream."

	stream
		nextPutAll: 'Static[';
		print: offset;
		nextPutAll: ']: '.
	self printLiteral: offset!

printStorePrefix
	"Private - Append the store instruction prefix to the stream."

	stream nextPutAll: 'Store '!

printSupersendPrefix
	"Private - Append the supersend instruction prefix to the stream."

	stream nextPutAll: 'Supersend '!

printTempSuffix: offset
	"Private - Append the temporary access suffix to the stream."

	stream nextPutAll: 'Temp['; print: offset; nextPut: $]!

printUnusedPrefix: byteCode
	"Private - Append the prefix for an unused/invalid instruction to the stream."

	stream
		nextPutAll: '**INVALID: ';
		print: byteCode!

pushActiveFrame
	"Private - Interpret a Push Active Frame instruction."

	stream nextPutAll: 'Push Active Frame'!

pushCharacter: aCharacter
	"Private - Interpret a Push Char instruction."

	self printPushPrefix.
	stream print: aCharacter!

pushConst: offset
	"Private - Interpret a Push Literal Constant instruction."

	self printPushPrefix.
	self printConstSuffix: offset!

pushImmediateInteger: anInteger 
	"Private - Interpret a Push -Immediate instruction."

	self printPushPrefix.
	stream print: anInteger!

pushInstVar: offset
	"Private - Interpret a Push Instance Variable instruction."

	self printPushPrefix.
	self printInstVarSuffix: offset!

pushOuter: contextDepth temp: envTempIndex 
	self printPushPrefix.
	self printOuter: contextDepth temp: envTempIndex!

pushPseudo: offset 
	"Private - Interpret a Short Push nil/true/false/self instruction."

	self printPushPrefix.
	self printPseudoSuffix: offset!

pushSelf
	self printPushPrefix.
	stream nextPutAll: 'Self'!

pushStatic: offset
	"Private - Interpret a Short Push Literal Variable instruction."

	self printPushPrefix.
	self printStaticSuffix: offset!

pushTemp: offset
	"Private - Interpret a Push Temporary Variable instruction."

	self printPushPrefix.
	self printTempSuffix: offset!

reset
	super reset.
	stream reset!

returnFromBlock
	"Private - Interpret a return from block."

	self printReturnPrefix.
	stream nextPutAll: 'From Block'!

returnFromBlockHome
	"Private - Interpret a return from block's home method."

	stream nextPutAll: 'Far Return'!

returnFromMessage
	"Private - Interpret a return from message."

	self printReturnPrefix!

returnPseudo: offset
	"Private - Interpret a Return nil/true/false/self instruction."

	self printReturnPrefix.
	self printPseudoSuffix: offset!

returnSelf
	self printReturnPrefix.
	stream nextPutAll: 'self'!

send: literalIndex args: argumentCount 
	"Private - Interpret a Send [N][M] instruction."

	self printSendPrefix.
	self printSendSuffix: literalIndex args: argumentCount!

shortSpecialSend: anInteger
	"Private - Interpret a Short Special Send instruction."

	self printShortPrefix.
	stream nextPutAll: 'Special '.
	self printSendPrefix.
	stream
		space;
		print: (dispatcher selectorOfSpecialSend: anInteger)!

shortSpecialSendEx: anInteger
	"Private - Interpret a Short Special Send Ex instruction."

	self printShortPrefix.
	stream nextPutAll: 'Special '.
	self printSendPrefix.
	stream
		space;
		print: (dispatcher selectorOfSpecialSendEx: anInteger)!

storeInstVar: offset
	"Private - Interpret a Store Instance Variable instruction."

	self printStorePrefix.
	self printInstVarSuffix: offset!

storeOuter: contextDepth temp: envTempIndex 
	"Private - Interpret a Store Environment Temporary Variable instruction."

	self printStorePrefix.
	self printOuter: contextDepth temp: envTempIndex!

storeStatic: offset
	"Private - Interpret a Store Literal Variable instruction."

	self printStorePrefix.
	self printStaticSuffix: offset!

storeTemp: offset
	"Private - Interpret a Store Temporary Variable instruction."

	self printStorePrefix.
	self printTempSuffix: offset!

supersend: literalIndex args: argumentCount 
	"Private - Interpret a Send [N][M] instruction."

	self printSupersendPrefix.
	self printSendSuffix: literalIndex args: argumentCount!

unused
	"Private - Interpret an unused short instruction."

	self printUnusedPrefix: (dispatcher byteCodes at: dispatcher ip - 1)!

unused: extensionByte 
	"Private - Interpret an unused double byte instruction."

	self printUnusedPrefix: (dispatcher byteCodes at: dispatcher ip - 2).
	stream
		nextPutAll: ' with extension ';
		print: extensionByte;
		cr!

unused: extensionByte1 with: extensionByte2 
	"Private - Interpret an unused triple byte instruction."

	self printUnusedPrefix: (dispatcher byteCodes at: dispatcher ip - 3).
	stream
		nextPutAll: ' with extension ';
		print: extensionByte1;
		nextPutAll: ' and ';
		print: extensionByte2;
		cr!

unused: extensionByte1 with: extensionByte2 with: extensionByte3 
	"Private - Interpret an unused quad byte instruction."

	self printUnusedPrefix: (dispatcher byteCodes at: dispatcher ip - 2).
	stream
		nextPutAll: ' with extension ';
		print: extensionByte1;
		nextPutAll: ' and ';
		print: extensionByte2;
		nextPutAll: ' and ';
		print: extensionByte3;
		cr! !
!Tools.Disassembler categoriesFor: #blockCopy:stack:env:copy:offset1:offset2:!instructions-miscellaneous!private! !
!Tools.Disassembler categoriesFor: #break!instructions-miscellaneous!private! !
!Tools.Disassembler categoriesFor: #decodeHeaderOn:!private! !
!Tools.Disassembler categoriesFor: #decPushTemp:temp:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #decrementStackTop!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #decTemp:temp:!instructions-miscellaneous!private! !
!Tools.Disassembler categoriesFor: #disassemble!printing!public! !
!Tools.Disassembler categoriesFor: #disassembleUntil:!printing!public! !
!Tools.Disassembler categoriesFor: #duplicateStackTop!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #exLongPushImmediate:byte2:byte3:byte4:!instructions-stack ops!public! !
!Tools.Disassembler categoriesFor: #fullDisassembly!public! !
!Tools.Disassembler categoriesFor: #incPushTemp:temp:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #incrementStackTop!instructions-miscellaneous!private! !
!Tools.Disassembler categoriesFor: #incTemp:temp:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #initialize!initializing!private! !
!Tools.Disassembler categoriesFor: #isZero!instructions-miscellaneous!private! !
!Tools.Disassembler categoriesFor: #jump:!interpreting!private! !
!Tools.Disassembler categoriesFor: #jumpIfFalse:!interpreting!private! !
!Tools.Disassembler categoriesFor: #jumpIfNil:!interpreting!private! !
!Tools.Disassembler categoriesFor: #jumpIfNotNil:!interpreting!private! !
!Tools.Disassembler categoriesFor: #jumpIfTrue:!interpreting!private! !
!Tools.Disassembler categoriesFor: #listing!printing!public! !
!Tools.Disassembler categoriesFor: #macroInstructionPart2!interpreting!public! !
!Tools.Disassembler categoriesFor: #maxLiteralPrint!constants!private! !
!Tools.Disassembler categoriesFor: #methodClass!accessing!public! !
!Tools.Disassembler categoriesFor: #nop!instructions-miscellaneous!private! !
!Tools.Disassembler categoriesFor: #popInstVar:!instructions-stack ops!public! !
!Tools.Disassembler categoriesFor: #popOuter:temp:!interpreting!private! !
!Tools.Disassembler categoriesFor: #popStackTop!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #popStatic:!instructions-stack ops!public! !
!Tools.Disassembler categoriesFor: #popTemp:!instructions-stack ops!public! !
!Tools.Disassembler categoriesFor: #printConstSuffix:!printing!private! !
!Tools.Disassembler categoriesFor: #printExLongPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printInstVarSuffix:!printing!private! !
!Tools.Disassembler categoriesFor: #printJumpOffset:!printing!private! !
!Tools.Disassembler categoriesFor: #printLiteral:!printing!private! !
!Tools.Disassembler categoriesFor: #printLongPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printOuter:temp:!printing!private! !
!Tools.Disassembler categoriesFor: #printPopPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printPseudoSuffix:!printing!private! !
!Tools.Disassembler categoriesFor: #printPushPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printReturnPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printSendPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printSendSuffix:!printing!private! !
!Tools.Disassembler categoriesFor: #printSendSuffix:args:!printing!private! !
!Tools.Disassembler categoriesFor: #printShortJumpOffset:!printing!private! !
!Tools.Disassembler categoriesFor: #printShortPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printStaticSuffix:!printing!private! !
!Tools.Disassembler categoriesFor: #printStorePrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printSupersendPrefix!printing!private! !
!Tools.Disassembler categoriesFor: #printTempSuffix:!printing!private! !
!Tools.Disassembler categoriesFor: #printUnusedPrefix:!printing!private! !
!Tools.Disassembler categoriesFor: #pushActiveFrame!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #pushCharacter:!interpreting!private! !
!Tools.Disassembler categoriesFor: #pushConst:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #pushImmediateInteger:!interpreting!private! !
!Tools.Disassembler categoriesFor: #pushInstVar:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #pushOuter:temp:!interpreting!private! !
!Tools.Disassembler categoriesFor: #pushPseudo:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #pushSelf!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #pushStatic:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #pushTemp:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #reset!public! !
!Tools.Disassembler categoriesFor: #returnFromBlock!instructions-returning!private! !
!Tools.Disassembler categoriesFor: #returnFromBlockHome!instructions-returning!private! !
!Tools.Disassembler categoriesFor: #returnFromMessage!instructions-returning!private! !
!Tools.Disassembler categoriesFor: #returnPseudo:!instructions-returning!private! !
!Tools.Disassembler categoriesFor: #returnSelf!instructions-returning!private! !
!Tools.Disassembler categoriesFor: #send:args:!interpreting!private! !
!Tools.Disassembler categoriesFor: #shortSpecialSend:!instructions-sending!private! !
!Tools.Disassembler categoriesFor: #shortSpecialSendEx:!instructions-sending!private! !
!Tools.Disassembler categoriesFor: #storeInstVar:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #storeOuter:temp:!interpreting!private! !
!Tools.Disassembler categoriesFor: #storeStatic:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #storeTemp:!instructions-stack ops!private! !
!Tools.Disassembler categoriesFor: #supersend:args:!interpreting!private! !
!Tools.Disassembler categoriesFor: #unused!instructions-unused!private! !
!Tools.Disassembler categoriesFor: #unused:!instructions-unused!private! !
!Tools.Disassembler categoriesFor: #unused:with:!instructions-unused!private! !
!Tools.Disassembler categoriesFor: #unused:with:with:!instructions-unused!private! !

!Tools.Disassembler class methodsFor!

disassemble: aCompiledMethod 
	"Answer a String containing a disassembly listing for aMethod."

	^(self method: aCompiledMethod) disassemble!

disassemble: aSymbol in: aClass 
	"Answer a String containing a disassembly of aClass' method with selector, aSymbol."

	^self disassemble: (aClass compiledMethodAt: aSymbol)! !
!Tools.Disassembler class categoriesFor: #disassemble:!instance creation!public! !
!Tools.Disassembler class categoriesFor: #disassemble:in:!instance creation!public! !


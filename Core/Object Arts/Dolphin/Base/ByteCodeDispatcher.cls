"Filed out from Dolphin Smalltalk"!

Object subclass: #ByteCodeDispatcher
	instanceVariableNames: 'byteCodes method ip interpreter instructionLength byteCode instructions'
	classVariableNames: 'FirstShowSpecialSend InstructionLengths Instructions RunStarts'
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''!

ByteCodeDispatcher guid: (GUID fromString: '{87b4c45d-026e-11d3-9fd7-00a0cc3e4a32}')!

ByteCodeDispatcher addClassConstant: 'FirstShowSpecialSend' value: 16r7E!
ByteCodeDispatcher addClassConstant: 'InstructionLengths' value: #[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 7 4 4 5 ]!
ByteCodeDispatcher addClassConstant: 'Instructions' value: #(#break #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #pushContextTemp: #pushContextTemp: #shortPushOuterTemp: #shortPushOuterTemp: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #pushSelf #pushPseudo: #pushPseudo: #pushPseudo: #shortPushImmediate: #shortPushImmediate: #shortPushImmediate: #shortPushImmediate: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortStoreTemp: #shortStoreTemp: #shortStoreTemp: #shortStoreTemp: #shortPopPushTemp: #shortPopPushTemp: #popPushSelf #popDup #popContextTemp: #popContextTemp: #shortPopOuterTemp: #shortPopOuterTemp: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #popStackTop #incrementStackTop #decrementStackTop #duplicateStackTop #returnSelf #returnPseudo: #returnPseudo: #returnPseudo: #returnFromMessage #returnFromBlock #returnFromBlockHome #popReturnSelf #nop #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #isZero #pushActiveFrame #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #pushInstVar: #pushTemp: #pushConst: #pushStatic: #storeInstVar: #storeTemp: #storeStatic: #popInstVar: #popTemp: #popStatic: #pushImmediate: #pushChar: #send: #supersend: #specialSend: #nearJump: #nearJumpIfTrue: #nearJumpIfFalse: #nearJumpIfNil: #nearJumpIfNotNil: #unused: #unused: #sendTempZeroArgs: #pushSelfAndTemp: #pushOuterTemp: #storeOuterTemp: #popOuterTemp: #sendSelfZeroArgs: #unused: #pushTempPair: #longPushConst:with: #longPushStatic:with: #longStoreStatic:with: #longPopStoreStatic:with: #longPushImmediate:with: #longSend:with: #longSupersend:with: #longJump:with: #longJumpIfTrue:with: #longJumpIfFalse:with: #longJumpIfNil:with: #longJumpIfNotNil:with: #pushOuter:temp: #storeOuter:temp: #incTemp:temp: #incPushTemp:temp: #decTemp:temp: #decPushTemp:temp: #blockCopy:stack:env:copy:offset1:offset2: #exLongSend:with:with: #exLongSupersend:with:with: #exLongPushImmediate:byte2:byte3:byte4:)!

ByteCodeDispatcher comment: 'ByteCodeDispatchers decode bytecodes in <CompiledMethod>s and dispatches them to a plug-in <bytecodeInterpreter> client.

Instance Variables:
	byteCodes			<ByteArray>
	method			<CompiledCode>
	ip				<integer>
	interpreter		<bytecodeInterpreter>
	instructionLength	<integer>
	byteCode			<integer>

Class Variables:
	Instructions		<sequencedReadableCollection>
	RunStarts			<IdentityDictionary>

'!

!ByteCodeDispatcher categoriesForClass!Kernel-Objects! !

!ByteCodeDispatcher methodsFor!

accessesInstVarAt: anInteger 
	"Answer whether the method which the receiver is interpreting accesses the
	instance variable with the index, anInteger."

	| offset |
	offset := anInteger - 1.	"instructions use 0 based offsets, not 1 based indices"
	self reset.
	[self atEnd] 
		whileFalse: [(self indexOfInstVarAccess: self fetch) == offset ifTrue: [^true]].
	^false!

accessesInstVarAtAnyOf: indices 
	"Answer whether the method which the receiver is interpreting accesses any
	of the instance variables with indices in the <Array> of <integer>, indices."

	self reset.
	[self atEnd] whileFalse: 
			[(self indexOfInstVarAccess: self fetch) 
				ifNotNil: [:offset | (indices identityIncludes: offset + 1) ifTrue: [^true]]].
	^false!

accessToInstVarAt: anInteger 
	"Answer a <Symbol> indicating the type of access that method which the receiver is
	interpreting makes to the instance variable with the index, anInteger:
		nil			The method does not access the instance variable 
		#read		The method reads, but does not write, the instance variable 
		#write		The method writes, but does not read, the instance variable 
		#readWrite 	The method reads and writes the instance variable"

	| offset access |
	offset := anInteger - 1.	"instructions use 0 based offsets, not 1 based indices"
	self reset.
	access := nil.
	[self atEnd] whileFalse: 
			[| byte |
			byte := self fetch.
			access == #read 
				ifTrue: [(self indexOfInstVarWrite: byte) == offset ifTrue: [^#readWrite]]
				ifFalse: 
					[(self indexOfInstVarRead: byte) == offset 
						ifTrue: [access ifNil: [access := #read] ifNotNil: [^#readWrite]]]].
	^access!

atEnd
	"Private - Answer whether the receiver is at the end of the method it is disassembling."

	^ip > byteCodes basicSize!

byteCodes
	"Answer the byte codes of the method being disassembled by the receiver."

	^byteCodes!

containsInstruction: discriminator
	"Answer whether the dyadic valuable, discriminator, evaluates to true for
	any instruction/parameter pair in the receiver."

	self reset.
	[ip > byteCodes basicSize]
		whileFalse: [(self instruction: (instructions at: self next + 1) do: discriminator) ifTrue: [^true]].
	^false!

dispatchAll
	"Private - Interpret the receiver's method sending messages for each instruction to the client."

	| count |
	count := byteCodes basicSize.
	self reset.
	[ip > count] whileFalse: [self dispatchNext]!

dispatchNext
	"Private - Dispatch the next instruction in the receiver's method to the interpreter."

	"Implementation Note: For performance reasons this effectively duplicates the code in #instruction:do:"

	self fetch
		ifNotNil: 
			[:instr |
			instructionLength == 1
				ifTrue: 
					[instr last == $:
						ifTrue: [interpreter perform: instr with: byteCode - (RunStarts at: instr)]
						ifFalse: [interpreter perform: instr]]
				ifFalse: 
					[instructionLength == 2
						ifTrue: [interpreter perform: instr with: (byteCodes at: ip - 1)]
						ifFalse: 
							[instructionLength == 3
								ifTrue: 
									[interpreter
										perform: instr
										with: (byteCodes at: ip - 2)
										with: (byteCodes at: ip - 1)]
								ifFalse: 
									[instructionLength == 4
										ifTrue: 
											[interpreter
												perform: instr
												with: (byteCodes at: ip - 3)
												with: (byteCodes at: ip - 2)
												with: (byteCodes at: ip - 1)]
										ifFalse: 
											[| args argc |
											argc := instructionLength - 1.
											args := Array new: argc.
											1 to: argc do: [:i | args at: argc - i + 1 put: (byteCodes at: ip - i)].
											interpreter perform: instr withArguments: args]]]]]!

fetch
	^instructions at: self next + 1!

indexOfInstVarAccess: aSymbol 
	^(self indexOfInstVarRead: aSymbol) ifNil: [self indexOfInstVarWrite: aSymbol]!

indexOfInstVarRead: aSymbol 
	aSymbol == #shortPushInstVar: ifTrue: [^byteCode - ShortPushInstVar].
	aSymbol == #pushInstVar: ifTrue: [^byteCodes at: ip - 1].
	^nil!

indexOfInstVarWrite: aSymbol 
	aSymbol == #shortPopInstVar: ifTrue: [^byteCode - ShortPopInstVar].
	(aSymbol == #storeInstVar: or: [aSymbol == #popInstVar:]) ifTrue: [^byteCodes at: ip - 1].
	^nil!

indexOfIP: anInteger
	"Private - Answer the index of the instruction line in a disassembly listing for
	the specified ip (which might be a data byte)."

	| i |
	i := 1.
	[ip < anInteger] whileTrue: [i := i + 1. self next].
	^i!

instruction: aSymbol do: aDyadicValuable
	instructionLength == 1
		ifTrue: 
			[^aDyadicValuable value: aSymbol
				value: (aSymbol last == $: ifTrue: [{byteCode - (RunStarts at: aSymbol)}] ifFalse: [#()])].
	instructionLength == 2 ifTrue: [^aDyadicValuable value: aSymbol value: {byteCodes at: ip - 1}].
	instructionLength == 3
		ifTrue: 
			[^aDyadicValuable value: aSymbol
				value: {byteCodes at: ip - 2. byteCodes at: ip - 1}].
	^instructionLength == 4
		ifTrue: 
			[aDyadicValuable value: aSymbol
				value: {byteCodes at: ip - 3. byteCodes at: ip - 2. byteCodes at: ip - 1}]
		ifFalse: 
			[| args argc |
			argc := instructionLength - 1.
			args := Array new: argc.
			1 to: argc do: [:i | args at: argc - i + 1 put: (byteCodes at: ip - i)].
			aDyadicValuable value: aSymbol value: args]!

instructions
	"Answer a sequenceable collection of associations between symbolic instruction names and argument
	in the receiver."

	| answer |
	answer := OrderedCollection new.
	self instructionsDo: [:selector :args | answer add: (selector -> args)].
	^answer!

instructions: anArray 
	instructions := anArray!

instructionsDo: operation
	"Evaluate the dyadic valuable, operation, for each instruction in the receiver, passing 
	the instruction symbolic name (a keyword selector) and an array of arguments (which should not be
	modified)."

	| count |
	self reset.
	count := byteCodes basicSize.
	[ip > count] whileFalse: [self instruction: (instructions at: self next + 1) do: operation]!

interpreter: anInstructionInterpreter 
	"Private - Set the receiver's interpreter client. The client is sent messages (the
	selectors for which it can supply) for each of the instructions in the the receivers
	method."

	interpreter := anInstructionInterpreter!

ip
	"Answer the current instruction pointer."

	^ip!

ip: newIP
	"Set the current instruction pointer to the <integer> argument.
	N.B. This should be used with care, since it needs to be the index of the start
	of a byte code."

	ip := newIP!

method
	"Answer the method to being decoded by the receiver."

	^method!

method: aCompiledMethod
	ip := 1.
	method := aCompiledMethod.
	byteCodes := aCompiledMethod byteCodes.
	instructions := Instructions.
	^self!

next
	"Answer the next instruction byte code of the receiver, advancing ip appropriately."

	ip := ip + (instructionLength := InstructionLengths at: (byteCode := byteCodes at: ip) + 1).
	^byteCode!

nextInstructionDo: operation 
	"Private - Answer the result of evaluating the dyadic valuable, operation, for the next 
	instruction in receiver's stream, passing the instruction symbolic name (a keyword selector) 
	and an array of argument bytes (N.B. not a ByteArray, but an Array of bytes)."

	^self instruction: self fetch do: operation!

peekForSelector
	"Answer the message selector of the next byte code, or nil if it is not a message
	send instruction. The instruction pointer is advanced.
	Note that this method used to be a private method #selectorOfNextIfSend, but has been
	renamed for VW compatibility."

	^self selectorOfMessageSend: self fetch!

prevIP: anInteger
	"Answer the ip of the instruction immediately preceding that with IP, anInteger."

	| prevIP |
	prevIP := 0.
	ip := 1.
	[ip < anInteger] whileTrue: [prevIP := ip. self next].
	^prevIP
!

readsInstVarAt: anInteger 
	"Answer whether the method which the receiver is interpreting reads the
	instance variable with the index, anInteger."

	| offset |
	offset := anInteger - 1.	"instructions use 0 based offsets, not 1 based indices"
	self reset.
	[self atEnd] 
		whileFalse: [(self indexOfInstVarRead: self fetch) == offset ifTrue: [^true]].
	^false!

readsStatic: anAssociation
	"Answer whether the method which the receiver is interpreting reads the
	static variable argument."

	| offset |
	offset := (method literals identityIndexOf: anAssociation) - 1.
	^offset >= 0 and: 
			[self containsInstruction: 
					[:selector :args | 
					((#(#shortPushStatic: #pushStatic:) identityIncludes: selector) and: [args first == offset]) 
						or: [selector == #longPushStatic:with: and: [offset == (args first + (args last * 256))]]]]!

reset
	ip := 1!

segments
	"Answer an <Array> of segment <ByteArrays>, where each segment is the integer byte values of an individual instruction. The first element of each segment is the opcode, followed by any extension bytes."

	| answer |
	answer := Array writeStream: (byteCodes basicSize bitShift: -1).
	ip := 1.
	[self atEnd] whileFalse: 
			[| start |
			start := ip.
			self next.
			answer nextPut: (byteCodes copyFrom: start to: ip - 1)].
	^answer contents!

selectorOfMessageSend: aSymbol 
	aSymbol == #shortSendZeroArgs: 
		ifTrue: [^method literalAt: byteCode - ShortSendZeroArgs + 1].
	aSymbol == #shortSendSelfZeroArgs: 
		ifTrue: [^method literalAt: byteCode - ShortSendSelfZeroArgs + 1].
	aSymbol == #shortSpecialSend: 
		ifTrue: [^self selectorOfSpecialSend: byteCode - ShortSpecialSend].
	aSymbol == #shortSpecialSendEx: 
		ifTrue: [^self selectorOfSpecialSendEx: byteCode - ShortSpecialSendEx].
	aSymbol == #shortSendOneArg: ifTrue: [^method literalAt: byteCode - ShortSendOneArg + 1].
	aSymbol == #shortSendTwoArgs: 
		ifTrue: [^method literalAt: byteCode - ShortSendTwoArgs + 1].
	(aSymbol == #send: or: [aSymbol == #supersend:]) 
		ifTrue: [^method literalAt: ((byteCodes at: ip - 1) bitAnd: 31) + 1].
	(aSymbol == #sendSelfZeroArgs: 
		or: [aSymbol == #longSend:with: or: [aSymbol == #longSupersend:with:]]) 
			ifTrue: [^method literalAt: (byteCodes at: ip - 1) + 1].
	^nil!

selectorOfSpecialSend: anInteger
	"Private - Answer the selector which corresponds to the special send with the specified offset from the start
	of the special send instructions."

	^VMLibrary default selectorOfSpecialSend: anInteger!

selectorOfSpecialSendEx: anInteger
	"Private - Answer the selector which corresponds to the special send with the specified offset from the start
	of the extra special send instructions."

	^VMLibrary default selectorOfSpecialSendEx: anInteger!

sendsSpecialSelector: anInteger
	"Answer whether the method which the receiver is interpreting sends the special selector
	with the specified one-based <integer> index."

	| instr end |
	instr := ##(FirstShowSpecialSend - 1) + anInteger.
	end := byteCodes basicSize.
	ip := 1.
	[ip > end] whileFalse: [self next == instr ifTrue: [^true]].
	^false!

specialMessages
	"Private - Answer the set of special message sends in the byte code stream."

	| answer vmlib count |
	answer := IdentitySet new: 4.
	vmlib := VMLibrary default.
	self reset.
	count := byteCodes basicSize.
	[ip > count] whileFalse: 
			[| op |
			op := instructions at: self next + 1.
			op == #shortSpecialSend:
				ifTrue: [answer add: (vmlib selectorOfSpecialSend: byteCode - ShortSpecialSend)]
				ifFalse: 
					[op == #shortSpecialSendEx:
						ifTrue: [answer add: (vmlib selectorOfSpecialSendEx: byteCode - ShortSpecialSendEx)]]].
	^answer!

writesInstVarAt: anInteger 
	"Answer whether the method which the receiver is streaming over writes to the
	instance variable with the index, anInteger."

	| offset |
	offset := anInteger - 1.	"instructions use 0 based offsets, not 1 based indices"
	self reset.
	[self atEnd] 
		whileFalse: [(self indexOfInstVarWrite: self fetch) == offset ifTrue: [^true]].
	^false!

writesStatic: anAssociation 
	"Answer whether the method interpreted by the receiver writes to the specified 
	static variable."

	| offset |
	offset := (method literals identityIndexOf: anAssociation) - 1.
	^offset >= 0 and: 
			[self containsInstruction: 
					[:selector :args | 
					((#(#popStatic: #storeStatic:) identityIncludes: selector) and: [args first == offset]) 
						or: 
							[(#(#longPopStoreStatic:with: #longStoreStatic:with:) identityIncludes: selector) 
								and: [offset == (args first + (args last * 256))]]]]! !

!ByteCodeDispatcher categoriesForMethods!
accessesInstVarAt:!public!testing! !
accessesInstVarAtAnyOf:!public!testing! !
accessToInstVarAt:!public!testing! !
atEnd!private!testing! !
byteCodes!accessing!public! !
containsInstruction:!public!testing! !
dispatchAll!interpreting!private! !
dispatchNext!interpreting!private! !
fetch!interpreting!private! !
indexOfInstVarAccess:!interpreting!private! !
indexOfInstVarRead:!interpreting!private! !
indexOfInstVarWrite:!interpreting!private! !
indexOfIP:!accessing!private! !
instruction:do:!interpreting!private! !
instructions!interpreting!public! !
instructions:!public! !
instructionsDo:!interpreting!public! !
interpreter:!accessing!private! !
ip!accessing!public! !
ip:!accessing!public! !
method!accessing!public! !
method:!accessing!private! !
next!accessing!public! !
nextInstructionDo:!interpreting!private! !
peekForSelector!interpreting!public! !
prevIP:!accessing!public! !
readsInstVarAt:!public!testing! !
readsStatic:!public!testing! !
reset!interpreting!public! !
segments!accessing!public! !
selectorOfMessageSend:!interpreting!private! !
selectorOfSpecialSend:!enquiries!private! !
selectorOfSpecialSendEx:!accessing!private! !
sendsSpecialSelector:!public!testing! !
specialMessages!accessing!private! !
writesInstVarAt:!public!testing! !
writesStatic:!public!testing! !
!

!ByteCodeDispatcher class methodsFor!

bytecodeRuns
	^#(#(1 #break) #(16 #shortPushInstVar:) #(8 #shortPushTemp:) #(2 #pushContextTemp:) #(2 #shortPushOuterTemp:) #(16 #shortPushConst:) #(12 #shortPushStatic:) #(1 #pushSelf) #(3 #pushPseudo:) #(4 #shortPushImmediate:) #(4 #shortPushSelfAndTemp:) #(4 #shortStoreTemp:) #(2 #shortPopPushTemp:) #(1 #popPushSelf) #(1 #popDup) #(2 #popContextTemp:) #(2 #shortPopOuterTemp:) #(8 #shortPopInstVar:) #(8 #shortPopTemp:) #(1 #popStackTop) #(1 #incrementStackTop) #(1 #decrementStackTop) #(1 #duplicateStackTop) #(1 #returnSelf) #(3 #returnPseudo:) #(1 #returnFromMessage) #(1 #returnFromBlock) #(1 #returnFromBlockHome) #(1 #popReturnSelf) #(1 #nop) #(8 #shortJump:) #(8 #shortJumpIfFalse:) #(32 #shortSpecialSend:) #(13 #shortSendZeroArgs:) #(5 #shortSendSelfZeroArgs:) #(14 #shortSendOneArg:) #(8 #shortSendTwoArgs:) #(1 #isZero) #(1 #pushActiveFrame) #(4 #shortSpecialSendEx:) #(1 #pushInstVar:) #(1 #pushTemp:) #(1 #pushConst:) #(1 #pushStatic:) #(1 #storeInstVar:) #(1 #storeTemp:) #(1 #storeStatic:) #(1 #popInstVar:) #(1 #popTemp:) #(1 #popStatic:) #(1 #pushImmediate:) #(1 #pushChar:) #(1 #send:) #(1 #supersend:) #(1 #specialSend:) #(1 #nearJump:) #(1 #nearJumpIfTrue:) #(1 #nearJumpIfFalse:) #(1 #nearJumpIfNil:) #(1 #nearJumpIfNotNil:) #(2 #unused:) #(1 #sendTempZeroArgs:) #(1 #pushSelfAndTemp:) #(1 #pushOuterTemp:) #(1 #storeOuterTemp:) #(1 #popOuterTemp:) #(1 #sendSelfZeroArgs:) #(1 #unused:) #(1 #pushTempPair:) #(1 #longPushConst:with:) #(1 #longPushStatic:with:) #(1 #longStoreStatic:with:) #(1 #longPopStoreStatic:with:) #(1 #longPushImmediate:with:) #(1 #longSend:with:) #(1 #longSupersend:with:) #(1 #longJump:with:) #(1 #longJumpIfTrue:with:) #(1 #longJumpIfFalse:with:) #(1 #longJumpIfNil:with:) #(1 #longJumpIfNotNil:with:) #(1 #pushOuter:temp:) #(1 #storeOuter:temp:) #(1 #incTemp:temp:) #(1 #incPushTemp:temp:) #(1 #decTemp:temp:) #(1 #decPushTemp:temp:) #(1 #blockCopy:stack:env:copy:offset1:offset2:) #(1 #exLongSend:with:with:) #(1 #exLongSupersend:with:with:) #(1 #exLongPushImmediate:byte2:byte3:byte4:))!

decodeLongJump: byte1 byte2: byte2 
	^(byte2 >= 128 ifTrue: [byte2 - 256] ifFalse: [byte2]) * 256 + byte1!

indexOfIP: anInteger in: aCompiledMethod
	"Private - Answer the index of the instruction line in a disassembly listing for
	the specified ip (which might be a data byte)."

	^(self on: aCompiledMethod) 
		indexOfIP: anInteger!

initialize
	"
		self initialize
	"

	| instructions runStarts |
	instructions := OrderedCollection new.
	runStarts := IdentityDictionary new.
	self bytecodeRuns do: 
			[:each |
			| instruction runLength |
			instruction := each last.
			runLength := each first.
			runLength > 1 ifTrue: [runStarts at: instruction put: instructions size].
			runLength timesRepeat: [instructions add: instruction]].
	self assert: [instructions size = 256].
	self addClassConstant: 'Instructions' value: instructions asArray.
	RunStarts := runStarts.
	self addClassConstant: 'InstructionLengths'
		value: ((0 to: 255) collect: 
					[:i |
					i < FirstDoubleByte
						ifTrue: [1]
						ifFalse: 
							[i < FirstTripleByte
								ifTrue: [2]
								ifFalse: 
									[i < FirstMultiByte
										ifTrue: [3]
										ifFalse: [i == BlockCopy ifTrue: [7] ifFalse: [i == ExLongPushImmediate ifTrue: [5] ifFalse: [4]]]]]])
				asByteArray!

instructions
	^Instructions!

lengthOfInstruction: anInteger
	"Private - Answer the number of bytes for the bytecode identified by the <integer> argument."

	^InstructionLengths at: anInteger + 1!

on: aCompiledMethod
	"Answer a new instance of the receiver to interpret the <CompiledCode> argument."

	^self new
		method: aCompiledMethod!

on: aCompiledCode for: anInstructionInterpreter
	"Answer a new instance of the receiver to interpret, aMethod, which will dispatch
	instructions to the specified <bytecodeInterpreter> client."

	^(self on: aCompiledCode)
		interpreter: anInstructionInterpreter;
		yourself! !

!ByteCodeDispatcher class categoriesForMethods!
bytecodeRuns!constants!must not strip!private! !
decodeLongJump:byte2:!helpers!public! !
indexOfIP:in:!interpreting!private! !
initialize!development!initializing!public! !
instructions!accessing!public! !
lengthOfInstruction:!interpreting!private! !
on:!instance creation!public! !
on:for:!instance creation!public! !
!


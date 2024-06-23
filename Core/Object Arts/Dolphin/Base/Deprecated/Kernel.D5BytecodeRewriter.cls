"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.D5BytecodeRewriter'
	instanceVariableNames: 'blockStack instructions ip ipMap bytecodes bytecode newIP blockMap needsContext'
	classVariableNames: 'DispatchMap'
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.D5BytecodeRewriter guid: (Core.GUID fromString: '{37e0086f-1ccb-4fd0-a9c1-ef51056facb4}')!

Kernel.D5BytecodeRewriter comment: '`D5BytecodeRewriter` is a private system utility class for upgrading Dolphin 5 (pre-block closure) methods stored in STB files to be compatible with Dolphin 6 and later. Note that the translation is far from optimal, and where possible methods (blocks) saved in resources should be recompiled.'!

!Kernel.D5BytecodeRewriter methodsFor!

assemble
	| bytestream |
	bytestream := ByteArray writeStream: instructions size * 3.
	instructions do: 
			[:each |
			bytestream
				nextPut: each instruction;
				nextPutAll: each args].
	^bytestream contents!

atEnd
	^ip >= bytecodes size!

blockCopy
	| args argc byte1 byte2 instruction originalIP |
	self assert: [needsContext].
	argc := self fetch.
	byte1 := self fetch.
	byte2 := self fetch.
	originalIP := ip.
	"BlockCopy is now a much more complex instruction reflecting the multiple types of temps that are supported"
	args := ByteArray new: 6.
	"With the original Dolphin blocks, all temps were stored in a MethodContext (i.e. they were all env temps), so to reproduce that we never have any stack or env temps defined by the blocks themselves"
	args
		at: 1 put: argc;
		at: 2 put: 0;
		at: 3 put: 1;
		at: 4 put: 1.	"No extra stack temps will be used, as we store all in home context"	"7 bits for env slots, and bottom bit for outer ref required flag"	"7 bits for copied value count, and bottom bit for requires receiver flag"
	instruction := Bytecode
				instruction: BlockCopy
				arguments: args
				ip: ip - 4.
	instruction jumpTarget: (ByteCodeDispatcher decodeLongJump: byte1 byte2: byte2) + ip.
	self assert: 
			[| ret |
			ret := bytecodes at: instruction jumpTarget.
			ret == ReturnFromBlock or: [ret == ReturnFromMessage or: [ret between: ReturnSelf and: ReturnNil]]].
	blockStack addLast: instruction jumpTarget - 1.
	self emitInstruction: instruction.
	blockMap at: originalIP + 1 put: newIP + 1.
	self pushBlockArgs: argc!

blockDepth
	^blockStack size!

blockMap
	^blockMap!

convertHeader: aSmallInteger 
	| privacy |
	privacy := aSmallInteger >> 4 & 1.
	^aSmallInteger & ##(16rFFFF << 15) | (needsContext 
				ifTrue: 
					["On conversion the temp count of the old method's that need contexts
					becomes the env temp count of the new since all args/temps have a slot
					allocated there, with args copied over into those slots off the stack."

					| tempCount |
					tempCount := aSmallInteger >> 7 & 255.
					tempCount > 63 ifTrue: [self error: 'too many temporaries'].
					tempCount + 1 << 1]
				ifFalse: [aSmallInteger & ##(16rFFFFFF << 7)]) 
		| privacy!

copyMethodArgs: aCompiledMethod
	| argc |
	argc := aCompiledMethod argumentCount.
	0 to: (argc - 1 min: 11)
		do: 
			[:i |
			self emitInstruction: (Bytecode
						instruction: ShortPushTemp + i
						arguments: #[]
						ip: nil).
			self emitInstruction: (Bytecode
						instruction: PopOuterTemp
						arguments: (ByteArray with: i)
						ip: nil)].
	12 to: argc - 1
		do: 
			[:i |
			self emitInstruction: (Bytecode
						instruction: PushTemp
						arguments: (ByteArray with: i)
						ip: nil).
			self emitInstruction: (Bytecode
						instruction: PopOuterTemp
						arguments: (ByteArray with: i)
						ip: nil)]!

doubleByte
	| byte2 |
	byte2 := self fetch.
	self emitInstruction: (Bytecode
				instruction: bytecode
				arguments: {byte2}
				ip: ip - 2)!

emitInstruction: aBytecode 
	aBytecode ip ifNotNil: [:oldIP | ipMap at: oldIP put: aBytecode].
	aBytecode ip: newIP.
	newIP := newIP + 1 + aBytecode args size.
	instructions addLast: aBytecode!

emitJumpOnNil: aBoolean
	| offset instruction |
	offset := self fetchNearJumpOffset.
	instruction := offset abs > 64
				ifTrue: 
					[self emitInstruction: (Bytecode
								instruction: (aBoolean ifTrue: [ShortSendIsNil] ifFalse: [ShortSendNotNil])
								arguments: #[]
								ip: ip - 2).
					Bytecode
						instruction: LongJumpIfTrue
						arguments: (ByteArray with: 0 with: 0)
						ip: nil]
				ifFalse: 
					[Bytecode
						instruction: bytecode
						arguments: (ByteArray with: 0)
						ip: ip - 2].
	instruction jumpTarget: offset + ip.
	self emitInstruction: instruction!

emitNearJump: offsetInteger asLongJump: jumpInteger
	| instruction |
	#todo.	"Determine whether near or long needed in a more intelligent way"
	instruction := offsetInteger abs > 64
				ifTrue: 
					[Bytecode
						instruction: jumpInteger
						arguments: (ByteArray with: 0 with: 0)
						ip: ip - 2]
				ifFalse: 
					[Bytecode
						instruction: bytecode
						arguments: (ByteArray with: 0)
						ip: ip - 2].
	instruction jumpTarget: offsetInteger + ip.
	self emitInstruction: instruction!

emitNearJumpAsLongJump: anInteger 
	"Determine whether near or long needed in a more intelligent way"

	self emitNearJump: self fetchNearJumpOffset asLongJump: anInteger!

emitShortJump: offsetInteger asNearJump: instructionInteger
	| instruction |
	instruction := Bytecode
				instruction: instructionInteger
				arguments: (ByteArray with: 0)
				ip: ip - 1.
	"Min short jump is +2, so add 1"
	instruction jumpTarget: offsetInteger + 1 + ip.
	self emitInstruction: instruction!

exLongSend
	"Private - This instruction has been remapped to a different code. It
	is very unlikely to appear anyway since it is only used for extremely
	large methods (such as auto-generated ones)."

	| args |
	args := ByteArray
				with: self fetch
				with: self fetch
				with: self fetch.
	self emitInstruction: (Bytecode
				instruction: ExLongSend
				arguments: args
				ip: ip - 4)!

exLongSupersend
	"Private - This instruction has been remapped to a different code. It
	is very unlikely to appear anyway since it is only used for extremely
	large methods (such as auto-generated ones)"

	| args |
	args := ByteArray
				with: self fetch
				with: self fetch
				with: self fetch.
	self emitInstruction: (Bytecode
				instruction: ExLongSupersend
				arguments: args
				ip: ip - 4)!

fetch
	ip := ip + 1.
	^bytecodes at: ip!

fetchNearJumpOffset
	| byte |
	byte := self fetch.
	^byte >= 128 ifTrue: [byte - 256] ifFalse: [byte]!

isInBlock
	^blockStack notEmpty!

longJump
	| byte1 byte2 instruction |
	byte1 := self fetch.
	byte2 := self fetch.
	instruction := Bytecode
				instruction: bytecode
				arguments: (ByteArray with: byte1 with: byte2)
				ip: ip - 3.
	instruction jumpTarget: (ByteCodeDispatcher decodeLongJump: byte1 byte2: byte2) + ip.
	self emitInstruction: instruction!

nearJump
	self emitNearJumpAsLongJump: LongJump!

nearJumpIfFalse
	self emitNearJumpAsLongJump: LongJumpIfFalse!

nearJumpIfNil
	self emitJumpOnNil: true!

nearJumpIfNotNil
	self emitJumpOnNil: false!

nearJumpIfTrue
	self emitNearJumpAsLongJump: LongJumpIfTrue!

popStoreTemp
	| temp outer |
	temp := self fetch.
	self assert: [temp < 31].
	outer := blockStack size.
	self assert: [outer < 8].
	self emitInstruction: (Bytecode
				instruction: PopOuterTemp
				arguments: (ByteArray with: (outer << 5 bitOr: temp))
				ip: ip - 2)!

pushActiveFrame
	self emitInstruction: (Bytecode
				instruction: PushActiveFrame
				arguments: #[]
				ip: ip - 1)!

pushBlockArgs: anInteger
	self assert: [needsContext].
	0 to: (anInteger - 1 min: 11)
		do: 
			[:i |
			self emitInstruction: (Bytecode
						instruction: ShortPushTemp + i
						arguments: #[]
						ip: nil)].
	12 to: anInteger - 1
		do: 
			[:i |
			self emitInstruction: (Bytecode
						instruction: PushTemp
						arguments: (ByteArray with: i)
						ip: nil)]!

pushSelfAndTemp
	self emitInstruction: (Bytecode
				instruction: PushSelf
				arguments: #()
				ip: ip - 1).
	self
		tempInstr: PushTemp
		outerInstr: PushOuterTemp
		ip: nil!

pushTemp
	self 
		tempInstr: PushTemp
		outerInstr: PushOuterTemp
		ip: ip - 1!

quadByte
	| args |
	args := ByteArray
				with: self fetch
				with: self fetch
				with: self fetch.
	self emitInstruction: (Bytecode
				instruction: bytecode
				arguments: args
				ip: ip - 4)!

returnFromBlock
	| blocks |
	self assert: [needsContext].
	blocks := blockStack size.
	self assert: [blocks > 0 and: [ip-1 <= blockStack last]].
	self singleByte!

returnFromMessage
	blockStack notEmpty ifTrue: [bytecode := ReturnFromBlockHome].
	self singleByte!

returnPseudo
	self isInBlock
		ifTrue: 
			[| which |
			self assert: [needsContext].
			which := bytecode - 16r65.
			bytecode := PushSelf + which.
			self singleByte.
			self emitInstruction: (Bytecode
						instruction: ReturnFromBlockHome
						arguments: #()
						ip: nil)]
		ifFalse: [self singleByte]!

rewriteBytecodesOf: aCompiledMethod
	bytecodes := aCompiledMethod byteCodes.
	blockStack := OrderedCollection new.
	instructions := OrderedCollection new.
	ipMap := IdentityDictionary new.
	blockMap := IdentityDictionary new.
	ip := 0.
	newIP := 0.
	needsContext := aCompiledMethod header allMask: 16r40.
	needsContext ifTrue: [self copyMethodArgs: aCompiledMethod].
	[self atEnd] whileFalse: 
			[[blockStack notEmpty and: [ip > blockStack last]] whileTrue: [blockStack removeLast].
			bytecode := self fetch.
			self perform: (DispatchMap at: bytecode + 1)].
	self assert: [blockStack isEmpty].
	self updateJumps.
	^self assemble!

rewriteMethod: aCompiledMethod 
	^(aCompiledMethod copy)
		byteCodes: (self rewriteBytecodesOf: aCompiledMethod);
		header: (self convertHeader: aCompiledMethod header);
		yourself!

shortJump
	| offset |
	offset := bytecode - ShortJump.
	self emitShortJump: offset asNearJump: NearJump!

shortJumpIfFalse
	| offset |
	offset := bytecode - ShortJumpIfFalse.
	self emitShortJump: offset asNearJump: NearJumpIfFalse!

shortPopStoreTemp
	self shortTempInstr: ShortPopTemp outerInstr: PopOuterTemp!

shortPushTemp
	self shortTempInstr: 17 outerInstr: PushOuterTemp!

shortSendNoArgs
	"New instruction set has fewer sends with 0 args, because some are now used
	for sends to self with zero args, therefore we may need to emit a longer instruction"

	| index code args |
	index := bytecode - 158.
	index < 12
		ifTrue: 
			[code := ShortSendZeroArgs + index.
			args := #[]]
		ifFalse: 
			[self assert: [index < 32].
			code := Send.
			args := ByteArray with: index	"0 << 5 | "].
	self emitInstruction: (Bytecode
				instruction: code
				arguments: args
				ip: ip - 1)!

shortSendOneArg
	| index code args |
	index := bytecode - 174.
	index < 13
		ifTrue: 
			[code := ShortSendOneArg + index.
			args := #[]]
		ifFalse: 
			[self assert: [index < 32].
			code := Send.
			args := ByteArray with: 1 << 5 | index].
	self emitInstruction: (Bytecode
				instruction: code
				arguments: args
				ip: ip - 1)!

shortSendTwoArgs
	| index code args |
	index := bytecode - 190.
	index < 8
		ifTrue: 
			[code := ShortSendTwoArgs + index.
			args := #[]]
		ifFalse: 
			[self assert: [index < 32].
			code := Send.
			args := ByteArray with: 2 << 5 | index].
	self emitInstruction: (Bytecode
				instruction: code
				arguments: args
				ip: ip - 1)!

shortTempInstr: shortInteger outerInstr: outerInteger
	"Note: New instruction set has only twelve short push temps, used to be 16, with the remainder being 
	used for short pushes of context temps"

	| args temp byte |
	temp := bytecode - shortInteger.
	#todo.	"Handle conversion of more than 12 temps"
	self assert: [temp < 12].
	byte := needsContext
				ifTrue: 
					[args := ByteArray with: (1 << 5 bitOr: temp).
					outerInteger]
				ifFalse: 
					[args := #[].
					bytecode].
	self emitInstruction: (Bytecode
				instruction: byte
				arguments: args
				ip: ip - 1)!

singleByte
	self emitInstruction: (Bytecode
				instruction: bytecode
				arguments: #[]
				ip: ip - 1)!

storeTemp
	self 
		tempInstr: StoreTemp
		outerInstr: StoreOuterTemp
		ip: ip - 1!

tempInstr: codeInteger outerInstr: outerInteger ip: ipInteger
	| pushTemp temp |
	temp := self fetch.
	pushTemp := needsContext
				ifTrue: 
					[
					self assert: [temp < 32].
	"In the original Dolphin block implementation, the temps were always allocated in a MethodContext. Later with BlockClosures (D6) temps could be on the stack, or in a Context. Where there are nested blocks, not all in the nesting stack need have their own Context. In rewriting to simulate the original implementation, only the outermost block will have a context. At some point in the D6 history an optimisation was added so that Context's would only be allocated where required, so for example there could be a doubly-nested block accessing a temp from the outermost block, but the immediate parent block does not itself have any shared temps, and so need not have its own context. This would mean that the intermediate context would be optimised away, so the outer depth is always 1 in the rewritten methods."
					temp := 1 << 5 bitOr: temp.
					outerInteger]
				ifFalse: [codeInteger].
	self emitInstruction: (Bytecode
				instruction: pushTemp
				arguments: (ByteArray with: temp)
				ip: ipInteger)!

testIsZero
	self emitInstruction: (Bytecode
				instruction: IsZero
				arguments: #[]
				ip: ip - 1)!

trebleByte
	| args |
	args := ByteArray with: self fetch with: self fetch.
	self emitInstruction: (Bytecode
				instruction: bytecode
				arguments: args
				ip: ip - 3)!

unusedDoubleByte
	self error: 'Invalid double byte instruction: ' , bytecode printString!

unusedQuadByte
	self error: 'Invalid quad byte instruction: ' , bytecode printString!

unusedSingleByte
	self error: 'Invalid single byte instruction: ' , bytecode printString!

unusedTrebleByte
	self error: 'Invalid treble byte instruction: ' , bytecode printString!

updateJumps
	instructions do: 
			[:each | 
			each jumpTarget notNil 
				ifTrue: [each jumpOffset: (ipMap at: each jumpTarget) ip - (each ip + 1 + each args size)]]! !

!Kernel.D5BytecodeRewriter categoriesForMethods!
assemble!operations!public! !
atEnd!private!testing! !
blockCopy!interpreting!private! !
blockDepth!accessing!private! !
blockMap!accessing!public! !
convertHeader:!helpers!private! !
copyMethodArgs:!helpers!private! !
doubleByte!interpreting!private! !
emitInstruction:!helpers!private! !
emitJumpOnNil:!helpers!private! !
emitNearJump:asLongJump:!helpers!private! !
emitNearJumpAsLongJump:!helpers!private! !
emitShortJump:asNearJump:!helpers!private! !
exLongSend!interpreting!private! !
exLongSupersend!interpreting!private! !
fetch!helpers!interpreting!private! !
fetchNearJumpOffset!helpers!private! !
isInBlock!private!testing! !
longJump!interpreting!private! !
nearJump!interpreting!private! !
nearJumpIfFalse!interpreting!private! !
nearJumpIfNil!interpreting!private! !
nearJumpIfNotNil!interpreting!private! !
nearJumpIfTrue!interpreting!private! !
popStoreTemp!interpreting!private! !
pushActiveFrame!interpreting!private! !
pushBlockArgs:!interpreting!private! !
pushSelfAndTemp!interpreting!private! !
pushTemp!interpreting!private! !
quadByte!interpreting!private! !
returnFromBlock!interpreting!private! !
returnFromMessage!interpreting!private! !
returnPseudo!interpreting!private! !
rewriteBytecodesOf:!initializing!private! !
rewriteMethod:!initializing!private! !
shortJump!interpreting!private! !
shortJumpIfFalse!interpreting!private! !
shortPopStoreTemp!interpreting!private! !
shortPushTemp!interpreting!private! !
shortSendNoArgs!interpreting!private! !
shortSendOneArg!interpreting!private! !
shortSendTwoArgs!interpreting!private! !
shortTempInstr:outerInstr:!helpers!private! !
singleByte!interpreting!private! !
storeTemp!interpreting!private! !
tempInstr:outerInstr:ip:!helpers!private! !
testIsZero!interpreting!private! !
trebleByte!interpreting!private! !
unusedDoubleByte!exceptions!private! !
unusedQuadByte!exceptions!private! !
unusedSingleByte!exceptions!private! !
unusedTrebleByte!exceptions!private! !
updateJumps!helpers!private! !
!

!Kernel.D5BytecodeRewriter class methodsFor!

initialize
	"
		self initialize

		PLEASE DO NOT REFORMAT ME
	"

	| instructions |
	instructions := OrderedCollection new.
	#(#(1 #singleByte) #(16 #singleByte) #(12 #shortPushTemp) #(16 #singleByte) #(12 #singleByte) #(4 #singleByte) #(4 #singleByte) #(16 #singleByte) #(8 #singleByte) #(8 #shortPopStoreTemp) #(1 #singleByte) #(1 #singleByte) #(1 #singleByte) #(1 #singleByte) #(4 #returnPseudo) #(1 #returnFromMessage) #(1 #returnFromBlock) #(1 #returnFromBlockHome) #(1 #pushActiveFrame) #(1 #singleByte) #(8 #shortJump) #(8 #shortJumpIfFalse) #(32 #singleByte) #(16 #shortSendNoArgs) #(16 #shortSendOneArg) #(8 #shortSendTwoArgs) #(1 #testIsZero) #(5 #singleByte) #(1 #doubleByte) #(1 #pushTemp) #(1 #doubleByte) #(1 #doubleByte) #(1 #doubleByte) #(1 #storeTemp) #(1 #doubleByte) #(1 #doubleByte) #(1 #popStoreTemp) #(1 #doubleByte) #(1 #doubleByte) #(1 #doubleByte) #(1 #doubleByte) #(1 #doubleByte) #(1 #doubleByte) #(1 #nearJump) #(1 #nearJumpIfTrue) #(1 #nearJumpIfFalse) #(1 #nearJumpIfNil) #(1 #nearJumpIfNotNil) #(3 #unusedDoubleByte) #(1 #pushSelfAndTemp) #(6 #unusedDoubleByte) #(7 #trebleByte) #(3 #longJump) #(7 #unusedTrebleByte) #(1 #blockCopy) #(1 #exLongSend) #(1 #exLongSupersend) #(2 #unusedQuadByte))
		do: [:each | each first timesRepeat: [instructions add: each last]].	"break"	"short push inst var"	"short push const"	"short push static"	"push pseudo var"	"short push immediate"	"unused"	"pop store inst var"	"pop"	"inc"	"dec"	"dup"	"nop"	"short special send"	"unused"	"push inst var"	"push const"	"push static"	"store inst var"	"store static"	"pop store inst var"	"pop store static"	"push immediate"	"push char"	"send"	"supersend"	"special send (reserved)"	"long pushes and stores, pop store static, send and supersend"
	self assert: [instructions size = 256].
	DispatchMap := instructions asArray!

rewriteMethod: aCompiledMethod 
	^self new rewriteMethod: aCompiledMethod! !

!Kernel.D5BytecodeRewriter class categoriesForMethods!
initialize!initializing!public! !
rewriteMethod:!operations!public! !
!


"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DebuggerTest
	instanceVariableNames: 'process savedShowWalkbacks'
	classVariableNames: ''
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''!
DebuggerTest guid: (GUID fromString: '{29CFD485-34B1-41D6-A030-30D1FE5A9EDD}')!
DebuggerTest comment: ''!
!DebuggerTest categoriesForClass!Unclassified! !
!DebuggerTest methodsFor!

setUp
	CompiledCode initializeInfoCache.
	savedShowWalkbacks := Debugger showWalkbacks.
	Debugger showWalkbacks: false!

tearDown
	process isNil ifFalse: [process terminate].
	Debugger showWalkbacks: savedShowWalkbacks!

testNoShowWalkbacks
	Transcript clear.
	process := 
			[(ResourceIdentifier class: ContainerView name: 'Default view') loadWithContext: DeafObject current] 
					fork.
	Processor sleep: 1000.
	self assert: process state = #debug.
	self 
		assert: (Transcript contents beginsWith: 'Forcibly unhooked failed window create of a ContainerView')!

testRemapIPOfSendSelf
	"#1309"

	"This test relies on the fact that there are only four ShortSendNoArgs instructions to
	be able to test the SendNoArgs instruction by inserting some dummy literals in the frame."

	| block method info debugMethod debugInfo startIP byte |
	self assert: ShortSendOneArg - ShortSendSelfZeroArgs == 5.
	block := Compiler 
				evaluate: '#literal0. #literal1. #literal2. #literal3. [self shortSendNoArgs. self sendNoArgs]'.
	method := block method.
	self assert: (method byteCodes at: 1) == BlockCopy.
	startIP := block initialIP.
	self assert: startIP = ((ByteCodeDispatcher lengthOfInstruction: BlockCopy) + 1).
	self assert: (method byteCodes at: startIP) = (ShortSendSelfZeroArgs + 4).
	info := block method debugInfo.
	debugMethod := block method asDebugMethod.
	self assert: (debugMethod byteCodes at: 1) == BlockCopy.
	"The ShortSendSelfNoArgs will be separated into a pair of instructions in a debug/unoptimized compilation of the method"
	self assert: (debugMethod byteCodes at: startIP) = PushSelf.
	self assert: (debugMethod byteCodes at: startIP + 1) = Break.
	self assert: (debugMethod byteCodes at: startIP + 2) = (ShortSendZeroArgs + 4).
	debugInfo := debugMethod debugInfo.
	"Initial IP should not change in debug method because there are no instructions before the BlockCopy"
	"self 
		assert: (BlockFrame new 
				mapIP: startIP
				from: info
				to: debugInfo) = startIP."
	"Test remapping of the instruction in the middle of the block"
	byte := debugMethod byteCodes at: startIP + 3.
	self assert: (byte = Pop or: [byte = PopPushSelf])!

testRemapIPSmokeTest
	| frame instructions debugMethod debugInstructions info debugInfo textMap ip segment offset debugTextMap |
	CompiledCode initializeInfoCache.
	frame := StackFrame new.
	CompiledCode allSubinstances do: 
			[:each | 
			instructions := each byteCodeSegments.
			debugMethod := each asDebugMethod.
			debugInstructions := debugMethod byteCodeSegments.
			info := each debugInfo.
			debugInfo := debugMethod debugInfo.
			ip := 1.
			textMap := info textMap.
			debugTextMap := debugInfo textMap.
			textMap with: debugTextMap do: [:a :b | self assert: a value = b value].
			debugTextMap do: 
					[:assoc | 
					| byte |
					byte := debugMethod byteCodes at: assoc key.
					self assert: byte ~= 0]
			"			instructions do: 
					[:bytes | 
					segment := frame findIP: ip inTextMap: textMap.
					self deny: segment = 0.
					offset := ip - (textMap at: segment) key.
					self assert: offset >= 0.
					ip := ip + bytes size]"]! !
!DebuggerTest categoriesFor: #setUp!private!unit tests! !
!DebuggerTest categoriesFor: #tearDown!private!unit tests! !
!DebuggerTest categoriesFor: #testNoShowWalkbacks!public!unit tests! !
!DebuggerTest categoriesFor: #testRemapIPOfSendSelf!public!unit tests! !
!DebuggerTest categoriesFor: #testRemapIPSmokeTest!public! !


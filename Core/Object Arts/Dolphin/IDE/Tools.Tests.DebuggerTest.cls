"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.DebuggerTest'
	instanceVariableNames: 'process savedShowWalkbacks savedView'
	classVariableNames: ''
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.DebuggerTest guid: (Core.GUID fromString: '{29cfd485-34b1-41d6-a030-30d1fe5a9edd}')!
Tools.Tests.DebuggerTest comment: ''!
!Tools.Tests.DebuggerTest categoriesForClass!Unclassified! !
!Tools.Tests.DebuggerTest methodsFor!

setUp
	CompiledCode initializeInfoCache.
	savedShowWalkbacks := Debugger showWalkbacks.
	savedView := Debugger defaultView.
	Debugger
		showWalkbacks: false;
		defaultView: 'Basic debugger'!

tearDown
	process isNil
		ifFalse: 
			[process terminate.
			process := nil].
	Debugger
		showWalkbacks: savedShowWalkbacks;
		defaultView: savedView!

testNoShowWalkbacks
	| start |
	process := [self halt] forkAt: Processor userInterruptPriority.
	start := Delay millisecondClockValue.
	SessionManager inputState
		loopWhile: [Delay millisecondClockValue < (start + 5000) and: [process state ~= #debug]].
	self assert: process state equals: #debug!

testRemapIPOfSendSelf
	"#1309"

	"This test relies on the fact that there are only four ShortSendNoArgs instructions to
	be able to test the SendNoArgs instruction by inserting some dummy literals in the frame."

	| block method info debugMethod debugInfo startIP byte |
	self assert: ShortSendOneArg - ShortSendSelfZeroArgs identicalTo: 5.
	block := Compiler
				evaluate: '#literal0. #literal1. #literal2. #literal3. [self shortSendNoArgs. self sendNoArgs]'.
	method := block method.
	self assert: (method byteCodes at: 1) identicalTo: BlockCopy.
	startIP := block initialIP.
	self assert: startIP equals: (ByteCodeDispatcher lengthOfInstruction: BlockCopy) + 1.
	self assert: (method byteCodes at: startIP) equals: ShortSendSelfZeroArgs + 4.
	info := block method debugInfo.
	debugMethod := block method asDebugMethod.
	self assert: (debugMethod byteCodes at: 1) identicalTo: BlockCopy.
	"The ShortSendSelfNoArgs will be separated into a pair of instructions in a debug/unoptimized compilation of the method"
	self assert: (debugMethod byteCodes at: startIP) equals: PushSelf.
	self assert: (debugMethod byteCodes at: startIP + 1) equals: Break.
	self assert: (debugMethod byteCodes at: startIP + 2) equals: ShortSendZeroArgs + 4.
	debugInfo := debugMethod debugInfo.
	"Initial IP should not change in debug method because there are no instructions before the BlockCopy"
	"self 
		assert: (BlockFrame new 
				mapIP: startIP
				from: info
				to: debugInfo) = startIP."
	"Test remapping of the instruction in the middle of the block"
	byte := debugMethod byteCodes at: startIP + 3.
	self assert: (byte = Pop or: [byte = PopPushSelf])! !
!Tools.Tests.DebuggerTest categoriesFor: #setUp!private!unit tests! !
!Tools.Tests.DebuggerTest categoriesFor: #tearDown!private!unit tests! !
!Tools.Tests.DebuggerTest categoriesFor: #testNoShowWalkbacks!public!unit tests! !
!Tools.Tests.DebuggerTest categoriesFor: #testRemapIPOfSendSelf!public!unit tests! !


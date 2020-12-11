"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.EventMessageSendTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.EventMessageSendTest guid: (Core.GUID fromString: '{d55436fd-a2dc-4d79-a1c1-c8b5351a6ef1}')!
Kernel.Tests.EventMessageSendTest comment: ''!
!Kernel.Tests.EventMessageSendTest categoriesForClass!Tests-Kernel-Objects! !
!Kernel.Tests.EventMessageSendTest methodsFor!

testNoArguments
	| m |
	m := EventMessageSend receiver: true selector: #yourself.
	self should: [m value]!

testOneArgument
	| m |
	m := EventMessageSend
				receiver: Array
				selector: #with:
				argument: 1.
	MemoryManager current collectGarbage.
	self should: [m value = #(1)]!

testOneArgumentWithGC
	| m |
	m := EventMessageSend
				receiver: OrderedCollection new
				selector: #addAll:
				arguments: {Object new}.
	MemoryManager current collectGarbage.
	self should: [m value] raise: MessageNotUnderstood!

testReceiverWithGC
	| m |
	m := EventMessageSend receiver: Object new selector: #yourself.
	MemoryManager current collectGarbage.
	self assert: m value equals: DeadObject current!

testTwoArguments
	| m |
	m := EventMessageSend
				receiver: Array
				selector: #with:with:
				arguments: #(1 2).
	MemoryManager current collectGarbage.
	self should: [m value = #(1 2)]! !
!Kernel.Tests.EventMessageSendTest categoriesFor: #testNoArguments!public!testing! !
!Kernel.Tests.EventMessageSendTest categoriesFor: #testOneArgument!public!testing! !
!Kernel.Tests.EventMessageSendTest categoriesFor: #testOneArgumentWithGC!public!testing! !
!Kernel.Tests.EventMessageSendTest categoriesFor: #testReceiverWithGC!public!testing! !
!Kernel.Tests.EventMessageSendTest categoriesFor: #testTwoArguments!public!testing! !


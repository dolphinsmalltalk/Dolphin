"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #EventMessageSendTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EventMessageSendTest guid: (GUID fromString: '{d55436fd-a2dc-4d79-a1c1-c8b5351a6ef1}')!

EventMessageSendTest comment: ''!

!EventMessageSendTest categoriesForClass!Tests-Kernel-Objects! !

!EventMessageSendTest methodsFor!

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
				arguments: (Array with: Object new).
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

!EventMessageSendTest categoriesForMethods!
testNoArguments!public!testing! !
testOneArgument!public!testing! !
testOneArgumentWithGC!public!testing! !
testReceiverWithGC!public!testing! !
testTwoArguments!public!testing! !
!


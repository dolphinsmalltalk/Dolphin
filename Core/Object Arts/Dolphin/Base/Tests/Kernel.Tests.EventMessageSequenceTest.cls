"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.EventMessageSequenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.EventMessageSequenceTest guid: (Core.GUID fromString: '{da236161-671a-45ed-95d6-c4c21c41e462}')!
Kernel.Tests.EventMessageSequenceTest comment: ''!
!Kernel.Tests.EventMessageSequenceTest methodsFor!

testMessages
	| receiver1 receiver2 subject message1 message2 |
	receiver1 := Object new.
	receiver2 := Object new.
	subject := EventMessageSequence new.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend receiver: receiver2 selector: #bar.
	subject add: message2.
	self assert: subject messages equals: (OrderedCollection with: message1 with: message2).
	receiver1 := nil.
	MemoryManager current collectGarbage.
	self assert: subject messages equals: (OrderedCollection with: message2).
! !
!Kernel.Tests.EventMessageSequenceTest categoriesForMethods!
testMessages!public! !
!


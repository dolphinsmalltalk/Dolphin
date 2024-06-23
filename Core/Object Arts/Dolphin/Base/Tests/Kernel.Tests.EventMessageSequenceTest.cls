"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.EventMessageSequenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.EventMessageSequenceTest guid: (Core.GUID fromString: '{da236161-671a-45ed-95d6-c4c21c41e462}')!

Kernel.Tests.EventMessageSequenceTest comment: ''!

!Kernel.Tests.EventMessageSequenceTest methodsFor!

testForwardTo
	| receiver1 receiver2 subject message1 message2 message3 receiver3 messages |
	receiver1 := Object new.
	receiver2 := Object new.
	receiver3 := Object new.
	subject := EventMessageSequence new.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend
				receiver: receiver2
				selector: #foo:
				argument: 'arg1'.
	subject add: message2.
	message3 := EventMessageSend
				receiver: receiver3
				selector: #foo:bar:
				arguments: #('arg1' 'arg2').
	subject add: message3.
	messages := OrderedCollection new.
	[subject forwardTo: self] on: MessageNotUnderstood
		do: 
			[:ex |
			messages add: ex message.
			ex resume].
	self assert: messages asArray
		equals: {
				Message selector: #foo.
				Message selector: #foo: argument: 'arg1'.
				Message selector: #foo:bar: arguments: #('arg1' 'arg2')
			}.
	receiver2 := nil.
	MemoryManager current collectGarbage.
	messages := OrderedCollection new.
	[subject forwardTo: self] on: MessageNotUnderstood
		do: 
			[:ex |
			messages add: ex message.
			ex resume].
	self assert: messages asArray
		equals: { Message selector: #foo. Message selector: #foo:bar: arguments: #('arg1' 'arg2') }!

testIncludes
	| receiver1 receiver2 subject message1 message2 |
	receiver1 := Object new.
	receiver2 := Object new.
	subject := EventMessageSequence new.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend receiver: receiver2 selector: #bar.
	subject add: message2.
	self assert: (subject includes: message1).
	self assert: (subject includes: message1 copy).
	self assert: (subject includes: message2).
	self assert: (subject includes: message2 copy).
	self deny: (subject includes: (MessageSend receiver: receiver1 selector: #foo))!

testMessages
	| receiver1 receiver2 subject message1 message2 |
	receiver1 := Object new.
	receiver2 := Object new.
	subject := EventMessageSequence new.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend receiver: receiver2 selector: #bar.
	subject add: message2.
	self assert: subject size equals: 2.
	self deny: subject isEmpty.
	self assert: subject messages equals: (OrderedCollection with: message1 with: message2).
	receiver1 := nil.
	MemoryManager current collectGarbage.
	self assert: subject messages equals: (OrderedCollection with: message2).
	self assert: subject size equals: 1.
	self deny: subject isEmpty!

testRemoveMessagesFor
	| receiver1 receiver2 subject message1 message2 message3 receiver3 message4 |
	receiver1 := Object new.
	receiver2 := Object new.
	receiver3 := Object new.
	subject := EventMessageSequence new.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend receiver: receiver2 selector: #foo.
	subject add: message2.
	message3 := EventMessageSend receiver: receiver1 selector: #bar.
	subject add: message3.
	message4 := EventMessageSend receiver: receiver3 selector: #bar.
	subject add: message4.
	self assert: subject size equals: 4.
	self deny: subject isEmpty.
	self assert: subject messages asArray equals: { message1. message2. message3. message4 }.
	subject removeMessagesFor: Object new.
	self assert: subject size equals: 4.
	self deny: subject isEmpty.
	self assert: subject messages asArray equals: { message1. message2. message3. message4 }.
	subject removeMessagesFor: receiver2.
	self assert: subject size equals: 3.
	self deny: subject isEmpty.
	self assert: subject messages asArray equals: { message1. message3. message4 }.
	subject removeMessagesFor: receiver3.
	self assert: subject size equals: 2.
	self deny: subject isEmpty.
	self assert: subject messages asArray equals: { message1. message3 }.
	subject removeMessagesFor: receiver1.
	self assert: subject size equals: 0.
	self assert: subject isEmpty.
	self assert: subject messages asArray equals: {}.
	subject removeMessagesFor: receiver1.
	self assert: subject messages asArray equals: {}!

testValue
	| receiver1 receiver2 subject message1 message2 message3 receiver3 messages result |
	receiver1 := Object new.
	receiver2 := Object new.
	receiver3 := Object new.
	subject := EventMessageSequence new.
	self assertIsNil: subject value.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend
				receiver: receiver2
				selector: #foo:
				argument: 'arg1'.
	subject add: message2.
	message3 := EventMessageSend
				receiver: receiver3
				selector: #foo:bar:
				arguments: #('arg1' 'arg2').
	subject add: message3.
	messages := OrderedCollection new.
	result := [subject value] on: MessageNotUnderstood
				do: 
					[:ex |
					messages add: ex message.
					ex resume: ex message arguments].
	self assert: messages asArray
		equals: {
				Message selector: #foo.
				Message selector: #foo: argument: 'arg1'.
				Message selector: #foo:bar: arguments: #('arg1' 'arg2')
			}.
	self assert: result equals: messages last arguments.
	receiver3 := nil.
	MemoryManager current collectGarbage.
	messages := OrderedCollection new.
	result := [subject value] on: MessageNotUnderstood
				do: 
					[:ex |
					messages add: ex message.
					ex resume: ex message arguments].
	self assert: messages asArray
		equals: { Message selector: #foo. Message selector: #foo: argument: 'arg1' }.
	self assert: result equals: messages last arguments!

testValueWithArguments
	"Tests argument substitution."

	| receiver1 receiver2 subject message1 message2 message3 receiver3 messages result |
	receiver1 := Object new.
	receiver2 := Object new.
	receiver3 := Object new.
	subject := EventMessageSequence new.
	self assertIsNil: subject value.
	message1 := EventMessageSend receiver: receiver1 selector: #foo.
	subject add: message1.
	message2 := EventMessageSend
				receiver: receiver2
				selector: #foo:
				argument: 'arg1'.
	subject add: message2.
	message3 := EventMessageSend
				receiver: receiver3
				selector: #foo:bar:
				arguments: #('arg1' 'arg2').
	subject add: message3.
	messages := OrderedCollection new.
	result := [subject valueWithArguments: #()] on: MessageNotUnderstood
				do: 
					[:ex |
					messages add: ex message.
					ex resume: ex message arguments].
	self assert: messages asArray
		equals: {
				Message selector: #foo.
				Message selector: #foo: argument: 'arg1'.
				Message selector: #foo:bar: arguments: #('arg1' 'arg2')
			}.
	messages := OrderedCollection new.
	result := [subject valueWithArguments: #('subst1')] on: MessageNotUnderstood
				do: 
					[:ex |
					messages add: ex message.
					ex resume: ex message arguments].
	self assert: messages asArray
		equals: {
				Message selector: #foo.
				Message selector: #foo: argument: 'subst1'.
				Message selector: #foo:bar: arguments: #('subst1' 'arg2')
			}.
	self assert: result equals: messages last arguments.
	messages := OrderedCollection new.
	result := [subject valueWithArguments: #('subst1' 'subst2')] on: MessageNotUnderstood
				do: 
					[:ex |
					messages add: ex message.
					ex resume: ex message arguments].
	self assert: messages asArray
		equals: {
				Message selector: #foo.
				Message selector: #foo: argument: 'subst1'.
				Message selector: #foo:bar: arguments: #('subst1' 'subst2')
			}.
	self assert: result equals: messages last arguments! !

!Kernel.Tests.EventMessageSequenceTest categoriesForMethods!
testForwardTo!public!unit tests! !
testIncludes!public! !
testMessages!public! !
testRemoveMessagesFor!public!unit tests! !
testValue!public!unit tests! !
testValueWithArguments!public!unit tests! !
!


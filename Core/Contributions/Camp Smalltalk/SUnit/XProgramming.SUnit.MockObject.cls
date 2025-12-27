"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.MockBasicObject
	subclass: #'XProgramming.SUnit.MockObject'
	instanceVariableNames: 'messages'
	classVariableNames: 'Any'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockObject guid: (Core.GUID fromString: '{0e7ca831-f07e-43dd-b4c0-9924bc163c49}')!

XProgramming.SUnit.MockObject comment: 'I am a test double object that can be used as a stub, a fake, or a mock.

I provide a simple protocol so that the user can teach me what messages to expect, and how to behave or respond to these messages. Notice that I can handled the fact that a sequence of the same message may return different results.

# Usage
A new object can be created with `MockObject new`, or using the utility methods on the class side _instance creation_ protocol.

The main message to teach a `MockObject` is `on:withArguments:verify:`; the other methods in the _teaching_ protocol all send this message.

This message takes a selector symbol, a collection of arguments, and a block. By sending this message, the mock object is trained to evaluate the block when receiving a message matching the selector and the arguments.
Other variations of this message have more specialized behaviour: `#on:withArguments:respond:` will simply return its third argument when the mock receives a matching message; likewise `on:withArguments:` will return the mock itself.
The other methods in the _teaching_ protocol provide an ergonomic API for this behaviour.

A mock object will expect to receive only the messages it has been trained on, in the same order and number as it was trained. If it receives an unknown message, or a known message but in the wrong order, it will simply return itself.


# Stubs, Fakes, and Mocks
A MockObject can be used as a stub by not using the `verify:` variants of the _teaching_ protocol.

It can also be used as a fake by using the `verify:` variants with a non-trivial block.

To use the MockObject as a real mock, the user needs to verify its use. This is done by means of the `TestCase>>#verify:` message. Verification needs to be triggered by the user - it''s not automatic.

The `verify:` message will assert 
- 1) that the mock has received all the messages it has been trained on, 
- 2) that it has not received only those messages.

# About MockObject any

The Any object is a "don''t care" object. It''s useful for those cases where we want the mock to verify only some of the arguments of a message.

For example, when executing this code

```
sqlConnection := MockObject new.
sqlConnection
  on: #executeCleanly:with:
  with: ''INSERT INTO table VALUES(?1, ?2);''
  with: MockObject any.
sqlConnection executeCleanly: ''INSERT INTO table VALUES(?1, ?2);'' with: {''key''. ''value''}.
```
when sqlConnection receives the `#executeCleanly:with:` with those arguments, it will check that the message has two arguments, but it will then only check that the first one matches exactly what it was taught, and ignore the second argument.

'!

!XProgramming.SUnit.MockObject methodsFor!

doesNotUnderstand: aMessage
	"When a message is not understood, check if this is one that have been taught and if this is the case remove it from the list of messages. This supports the possibility to have sequence of similar messages with different responses. In particular I handle also Joker objects as part of the message argument. See MockObject any"

	| expected |
	expected := messages removeFirstIfAbsent: nil.
	expected
		ifNotNil: 
			[(expected matches: aMessage)
				ifTrue: [^expected valueWithPossibleArgs: aMessage arguments]
				ifFalse: [messages addFirst: expected]].
	TestFailure
		signal: ('Unexpected (<1p>) received while awaiting <2p>' expandMacrosWith: aMessage
				with: expected).
	^super doesNotUnderstand: aMessage!

initialize
	messages := OrderedCollection new!

on: aSymbol withArguments: anArray verify: aBlock
	messages add: (MockMessageSend
				on: aSymbol
				with: anArray
				do: aBlock)!

verifyIn: aTestCase
	"Private - Verify that the test did not fail and that all the messages were consumed."

	aTestCase assert: messages isEmpty description: 'Mock still has messages pending'! !

!XProgramming.SUnit.MockObject categoriesForMethods!
doesNotUnderstand:!exceptions!public! !
initialize!initialization!private! !
on:withArguments:verify:!public!teaching / verifying! !
verifyIn:!private!verifying! !
!

!XProgramming.SUnit.MockObject class methodsFor!

any
	"This is joker object to say that we do not care of the message argument. See the class comment for an example."

	^Any!

on: aSymbol
	^self new
		on: aSymbol;
		yourself!

on: aSymbol respond: anObject
	^self new
		on: aSymbol respond: anObject;
		yourself! !

!XProgramming.SUnit.MockObject class categoriesForMethods!
any!accessing!public! !
on:!instance creation!public! !
on:respond:!instance creation!public! !
!


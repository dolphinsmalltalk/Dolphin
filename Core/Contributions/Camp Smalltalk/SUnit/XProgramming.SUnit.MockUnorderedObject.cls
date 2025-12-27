"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.MockBasicObject
	subclass: #'XProgramming.SUnit.MockUnorderedObject'
	instanceVariableNames: 'vocabularyDictionary'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockUnorderedObject guid: (Core.GUID fromString: '{fc0916bd-e15c-4c3e-8296-72615eec38a5}')!

XProgramming.SUnit.MockUnorderedObject comment: 'Similar to `MockObject`, but accepts taught messages in any order and also repetition of messages.'!

!XProgramming.SUnit.MockUnorderedObject methodsFor!

doesNotUnderstand: aMessage
	"We override this message to check if the receiver was taught to understand the given message"

	(vocabularyDictionary lookup: aMessage selector)
		ifNotNil: 
			[:response |
			| args |
			args := aMessage arguments.
			(response matchesArguments: args) ifTrue: [^response valueWithPossibleArgs: args]].
	TestFailure
		signal: ('Unexpected message <1p> received' expandMacrosWith: aMessage).
	^super doesNotUnderstand: aMessage!

initialize
	super initialize.
	vocabularyDictionary := LookupTable new!

on: aSymbol evaluate: aBlock
	"Teach the receiver to evaluate a block when when he receives a message identified by the given Symbol"

	self on: aSymbol verify: aBlock!

on: aSymbol withArguments: anArray verify: aBlock
	vocabularyDictionary at: aSymbol
		put: (MockMessageSend
				on: aSymbol
				with: anArray
				do: aBlock)! !

!XProgramming.SUnit.MockUnorderedObject categoriesForMethods!
doesNotUnderstand:!exceptions!public! !
initialize!initialization!private! !
on:evaluate:!public!reflective operations! !
on:withArguments:verify:!public!teaching / verifying! !
!

!XProgramming.SUnit.MockUnorderedObject class methodsFor!

example
	<script>
	<ignoreNotImplementedSelectors: #(#doit #negate:)>
	| teachable |
	teachable := self new.
	teachable
		on: #help respond: 'ok';
		on: #doit evaluate: [1 + 3];
		on: #negate: evaluate: [:num | num negated].
	self assert: teachable help = 'ok'.
	self assert: teachable doit = 4.
	self assert: (teachable negate: 120) = -120! !

!XProgramming.SUnit.MockUnorderedObject class categoriesForMethods!
example!examples!public! !
!


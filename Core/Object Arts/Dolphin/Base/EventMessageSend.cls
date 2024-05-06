"Filed out from Dolphin Smalltalk"!

MessageSendAbstract variableSubclass: #EventMessageSend
	instanceVariableNames: 'expectedArgCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EventMessageSend guid: (GUID fromString: '{87b4c663-026e-11d3-9fd7-00a0cc3e4a32}')!

EventMessageSend comment: 'An EventMessageSend is a fully closed <Message>, including receiver object, the message selector, and an array of sufficient arguments, however the receiver is referenced weakly.

When evaluate with extra arguments, an EventMessageSend merges its own argument with those supplied at evaluation time with the latter taking precedence from the left. For example if the message requires two arguments, and one is supplied at evaluation time, then the first argument sent will be that one, and the second the second of the arguments stored in the EventMessageSend itself.'!

!EventMessageSend categoriesForClass!System-Support! !

!EventMessageSend methodsFor!

asMessageSend
	^MessageSend 
		receiver: self receiver
		selector: selector
		arguments: (Array withAll: self arguments)!

forwardTo: anObject withArguments: triggerArguments
	"Private - Send the receiver Message to the <Object>, anObject, with the <Array> of arguments, anArray.	
	If insufficient arguments are supplied then these are substituted with arguments supplied at the 	
	time the event handler was registered, or nils if there are still insufficient. If the combined number 
	of arguments is greater than that required, then the arguments supplied at trigger time take precedence."

	^anObject perform: selector
		withArguments: (expectedArgCount == triggerArguments basicSize 
				ifTrue: [triggerArguments]
				ifFalse: [self mergeArguments: triggerArguments])!

mergeArguments: triggerArguments
	| actualArgs |
	actualArgs := Array new: expectedArgCount.
	actualArgs
		replaceFrom: 1
			to: (expectedArgCount min: args basicSize)
			with: args
			startingAt: 1;
		replaceFrom: 1
			to: (expectedArgCount min: triggerArguments basicSize)
			with: triggerArguments
			startingAt: 1.
	^actualArgs!

postCopy
	self beWeak.
	^self!

receiver
	^self basicAt: 1!

receiver: anObject
	self basicAt: 1 put: anObject!

selector: aSelector
	"Sets the selector for the receiver to aSelector. Also
	computes the expected argument count that will be required
	when the selector is sent."

	super selector: aSelector.
	expectedArgCount := aSelector argumentCount.
	args := #()!

setSelector: aSymbol arguments: argArray
	"Private - Initialize the receiver's instance variables."

	selector := aSymbol.
	expectedArgCount := aSymbol argumentCount.
	args := argArray!

value
	"Evaluates the receiver send the message identified by the 
	receiver's selector to the receiver's receiver, with the 
	receiver's arguments, and answers the result."

	^self forwardTo: self receiver withArguments: #()! !

!EventMessageSend categoriesForMethods!
asMessageSend!public! !
forwardTo:withArguments:!evaluating!private! !
mergeArguments:!evaluating!private! !
postCopy!copying!public! !
receiver!accessing!debugger-step over!public! !
receiver:!accessing!public! !
selector:!accessing!public! !
setSelector:arguments:!initializing!private! !
value!evaluating!public! !
!

!EventMessageSend class methodsFor!

new
	^(self new: 1) beWeak; yourself! !

!EventMessageSend class categoriesForMethods!
new!instance creation!public! !
!


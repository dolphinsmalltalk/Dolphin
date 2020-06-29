"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Message
	instanceVariableNames: 'selector args'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Message guid: (GUID fromString: '{87b4c49e-026e-11d3-9fd7-00a0cc3e4a32}')!
Message comment: ''!
!Message categoriesForClass!Kernel-Methods! !
!Message methodsFor!

= aMessage
	"Answer true if the receiver and aMessage are equal.
	Since we override = we also override hash."

	^self == aMessage or: [
		self species == aMessage species and: [
			self selector == aMessage selector and: [self arguments = aMessage arguments]]]!

argumentCount
	"Answer the <integer> number of arguments in the receiver's
	message."

	^args size!

arguments
	"Answer a <sequencedReadableCollection> containing the receiver's
	arguments."

	^args!

arguments: anArray
	"Set the argument list of the receiver to anArray.
	Answer the receiver."

	args := anArray
!

asSymbol
	"Answer the receiver's <selector>."

	^selector!

forwardTo: anObject
	"Send the receiver Message to anObject for evaluation, 
	answering the result"

	^anObject perform: selector withArguments: args!

forwardTo: anObject with: aParameter
	"Private - Send the receiver Message to anObject for evaluation with aParameter, 
	answering the result"

	^anObject perform: selector with: aParameter

!

forwardTo: anObject withArguments: anArray
	"Private - Send the receiver Message to anObject for evaluation with anArray of arguments, 
	answering the result"

	^anObject perform: selector withArguments: anArray
!

hash
	"Since we implement = we must also implement hash to match"
	
	^selector hash + args hash!

messages
	"Answer a <collection> of the messages sent by the receiver."

	^{self selector}!

numArgs
	^self argumentCount!

printOn: target 
	"Append a short textual description of the receiver to the <puttableStream>, 
	target, in the form a developer might want to see it (attempt an evaluable
	literal representation)."

	target
		nextPutAll: self class name;
		nextPutAll: ' selector: ';
		print: selector.
	args notEmpty 
		ifTrue: 
			[target
				nextPutAll: ' arguments: ';
				print: args]!

selector
	"Answer the receiver's <selector>"

	^selector!

selector: aSymbol
	"Set the <selector> for the receiver to the argument."

	selector := aSymbol.!

setSelector: aSymbol arguments: argArray
	"Private - Initialize the receiver's instance variables."

	selector := aSymbol.
	args := argArray!

value: anObject
	"Answer the result of sending the receiver to the object, anObject.
	Implementation Note: By implementing this selector from the monadic
	valuable protocol, we enable the substitution of Messages for a
	large number of parameterization cases where blocks would otherwise
	be required."

	^self forwardTo: anObject


!

value: receiver value: argument
	"Answer the result of sending the receiving message to the object, receiver,
	with the argument, argument.
	Implementation Note: By implementing this selector from the dyadic
	valuable protocol, we enable the substitution of Messages for a
	further set of parameterization cases where blocks would otherwise
	be required."

	^self forwardTo: receiver with: argument!

valueWithArguments: argArray
	"Evaluate the receiver with an <Array> of arguments in argArray"

	^self forwardTo: argArray first withArguments: (argArray copyFrom: 2)! !
!Message categoriesFor: #=!comparing!public! !
!Message categoriesFor: #argumentCount!accessing!public! !
!Message categoriesFor: #arguments!accessing!public! !
!Message categoriesFor: #arguments:!accessing!public! !
!Message categoriesFor: #asSymbol!converting!public! !
!Message categoriesFor: #forwardTo:!operations!public! !
!Message categoriesFor: #forwardTo:with:!operations!private! !
!Message categoriesFor: #forwardTo:withArguments:!operations!private! !
!Message categoriesFor: #hash!comparing!public! !
!Message categoriesFor: #messages!enquiries!public! !
!Message categoriesFor: #numArgs!accessing!public! !
!Message categoriesFor: #printOn:!printing!public! !
!Message categoriesFor: #selector!accessing!public! !
!Message categoriesFor: #selector:!accessing!public! !
!Message categoriesFor: #setSelector:arguments:!accessing!private! !
!Message categoriesFor: #value:!evaluating!public! !
!Message categoriesFor: #value:value:!evaluating!public! !
!Message categoriesFor: #valueWithArguments:!evaluating!public! !

Message methodProtocol: #commandMessage attributes: #(#readOnly) selectors: #(#asSymbol #forwardTo:)!
Message methodProtocol: #dyadicValuable attributes: #(#readOnly) selectors: #(#argumentCount #value:value: #valueWithArguments:)!
Message methodProtocol: #failedMessage attributes: #(#ansi #readOnly) selectors: #(#arguments #selector)!
Message methodProtocol: #message attributes: #() selectors: #(#argumentCount #forwardTo: #value: #value:value: #valueWithArguments:)!
Message methodProtocol: #messageSender attributes: #(#readOnly) selectors: #(#messages)!
Message methodProtocol: #monadicValuable attributes: #(#readOnly) selectors: #(#argumentCount #value: #valueWithArguments:)!

!Message class methodsFor!

selector: aSymbol 
	"Answer a new instance of the receiver with the selector, aSymbol"

	^self selector: aSymbol arguments: #()!

selector: aSymbol argument: anObject
	"Answer a new instance of the receiver with selector, aSymbol, and argument, 
	anObject"

	^self selector: aSymbol arguments: {anObject}!

selector: aSymbol arguments: anArray 
	"Answer a new instance of the receiver with selector, aSymbol, and arguments, anArray"

	<primitive: 157>
	^self new setSelector: aSymbol arguments: anArray! !
!Message class categoriesFor: #selector:!instance creation!public! !
!Message class categoriesFor: #selector:argument:!instance creation!public! !
!Message class categoriesFor: #selector:arguments:!instance creation!public! !


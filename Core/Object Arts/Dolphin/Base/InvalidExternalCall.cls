"Filed out from Dolphin Smalltalk 7"!

Error subclass: #InvalidExternalCall
	instanceVariableNames: 'argument type'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InvalidExternalCall guid: (GUID fromString: '{87b4c55b-026e-11d3-9fd7-00a0cc3e4a32}')!
InvalidExternalCall comment: 'Exception to represent an invalid attempt to invoke an external procedure call, perhaps because of passing an invalid object type as an argument.

See <ExternalDescriptor>''s class comment for a description of the argument types supported by Dolphin.'!
!InvalidExternalCall categoriesForClass!System-Exception Handling! !
!InvalidExternalCall methodsFor!

_descriptionArguments
	"Answer the set of arguments to be substitued into the receiver's descriptionFormat
	String."

	^super _descriptionArguments, 
		(Array 
			with: argument basicPrintString
			with: type displayString)!

_descriptionFormat
	"Private - Answer a string which is the message format for the receiver's description.
	Implementation Note: Parameter 1 is the message text, which we don't use in this
	case, 2 is the index of the offending argument, 3 the object passed, and 4 the type
	expected."

	^'Invalid arg %2: Cannot coerce %3 to %4'!

argument: anObject
	"Private - Set the arguments passed to the invalid call which the receiver represents to anArray."

	argument := anObject!

type: anObject
	"Private - Set the type expected by the argument for which the receiver represents an
	invalid call to anObject."

	type := anObject! !
!InvalidExternalCall categoriesFor: #_descriptionArguments!displaying!public! !
!InvalidExternalCall categoriesFor: #_descriptionFormat!displaying!private! !
!InvalidExternalCall categoriesFor: #argument:!accessing!private! !
!InvalidExternalCall categoriesFor: #type:!accessing!private! !

!InvalidExternalCall class methodsFor!

invalidArgument: anInteger got: anObject expected: type
	"Private - Validate the attempted invocation of the ExternalMethod in
	the StackFrame argument, raising an appropriate Error if validation of an 
	argument fails."

	##(ExternalDescriptor initialize).	"cause ExternalDescriptor to be initialized during boot"

	^self new
		argument: anObject;
		type: type;
		signalWith: anInteger! !
!InvalidExternalCall class categoriesFor: #invalidArgument:got:expected:!instance creation!private! !


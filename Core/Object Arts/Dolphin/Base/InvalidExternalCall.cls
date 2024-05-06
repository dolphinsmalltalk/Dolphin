"Filed out from Dolphin Smalltalk"!

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

	^super _descriptionArguments , {argument basicPrintString. type displayString}!

_descriptionFormat
	"Private - Answer a string which is the message format for the receiver's description.
	Implementation Note: Parameter 1 is the message text, which we don't use in this
	case, 2 is the index of the offending argument, 3 the object passed, and 4 the type
	expected."

	^'Invalid arg %2: Cannot coerce %3 to %4'!

argument
	"Answer the <Object> which is the invalid argument."

	^argument!

argument: anObject
	argument := anObject!

hresult
	"Answer the <HRESULT> error code associated with the receiver.
	Overridden by subclasses to answer more specified HRESULT codes."

	^HRESULT fromPrimitiveFailureCode: ( _PrimitiveFailureCode.InvalidParameter1 + self tag - 1)!

type
	"Answer the type  expected by the argument for which the receiver represents an invalid call to anObject."

	^type!

type: anObject
	"Private - Set the type expected by the argument for which the receiver represents an
	invalid call to anObject."

	type := anObject! !

!InvalidExternalCall categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!private! !
argument!accessing!public! !
argument:!accessing!private! !
hresult!accessing!public! !
type!accessing!public! !
type:!accessing!private! !
!

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

!InvalidExternalCall class categoriesForMethods!
invalidArgument:got:expected:!instance creation!private! !
!


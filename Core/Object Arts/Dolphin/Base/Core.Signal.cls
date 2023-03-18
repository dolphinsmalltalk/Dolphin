"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Signal'
	instanceVariableNames: 'description resumable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Signal guid: (Core.GUID fromString: '{87b4c4b9-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Signal comment: ''!
!Core.Signal categoriesForClass!Kernel-Exception Handling! !
!Core.Signal methodsFor!

, arg
	"Answer a new <ExceptionSet> containing the receiver and the argument."

	^ExceptionSet selectors: {self. arg}!

defaultAction: exception
	"Private - Perform the default action for the raised incarnation of the receiver,
	exception, as it has not been handled.
	Implementation Note: forward to the SessionManager for application specific handling."

	"Will not return unless execution is to be resumed"

	^SessionManager current onUnhandledError: exception!

defaultResumption
	"Private - Answer the default setting for the receiver's resumable flag."

	^false!

description
	"Private - Answer the receiver's description format string."

	^description!

description: aString
	"Set the description of the receiver to be aString. The description can include
	Win32 format substitution specifiers."

	description := aString!

exceptionClass
	"Private - Answer the class of Exception to be raised when the receiver
	is signalled."

	^RaisedSignal!

handles: exception
	"Answer whether the receiver matches the <exceptionDescription>, exception, and 
	any handler at this scope should be invoked."

	^exception signalType == self
!

initialize
	"Private - Initialize the receiver's instance variables."

	resumable := self defaultResumption.
	description := '%1'!

isResumable
	"Answer whether the receiver represents a resumable Signal."

	^resumable!

makeNonResumable
	"Make the receiver a non-resumable Signal. Answer the receiver."

	resumable := false!

makeResumable
	"Make the receiver a resumable Signal. Answer the receiver."

	resumable := true!

matching: aMonadicValuable 
	^ExceptionFilter select: self matching: aMonadicValuable!

newException
	"Answer a new <Exception> instantiated on the receiver, but as yet unsignalled."

	^self exceptionClass new
		signalType: self;
		yourself!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self description;
		nextPut: $)
!

resumable: aBoolean
	"Set whether the receiver represents a resumable Signal."

	resumable := aBoolean!

signal
	"Signal the occurrence of an exceptional condition.
	This method will not normally return to its sender.
	Implementation Note: A new <Exception> is instantiated and
	signalled, initiating a search for an ExceptionHandler prepared to
	handle that exception."

	^self newException signal!

signal: signalerText
	"Signal the occurrence of an exceptional condition with the specified description.
	This method will not normally return to its sender.
	N.B. X3J20 requires that the argument, signalDescription, conform to the 
	<readableString> protocol, but we relax this to permit an object (which is sent 
	#displayString to get a <readableString>).
	Portable code should use only <readableString> descriptions.
	Implementation Note: Raise a new <Exception> instance with the specified details, 
	initiating a search for an ExceptionHandler prepared to handle that exception."
	
	^self newException signal: signalerText!

signal: signalerText with: signalerTag
	"Signal the occurrence of an exceptional condition with the specified description
	and tag. This method will not normally return to its sender."
	
	^self newException
		signal: signalerText
		with: signalerTag
!

signalWith: signalerTag
	"Signal the occurrence of an exceptional condition with the specified tag object.
	This method will not normally return to its sender."
	
	^self newException signalWith: signalerTag! !
!Core.Signal categoriesForMethods!
,!filtering!public! !
defaultAction:!handling!private! !
defaultResumption!constants!private! !
description!accessing!private! !
description:!accessing!public! !
exceptionClass!constants!private! !
handles:!filtering!public! !
initialize!initializing!private! !
isResumable!public!testing! !
makeNonResumable!accessing!public! !
makeResumable!accessing!public! !
matching:!filtering!public! !
newException!public!raising! !
printOn:!printing!public! !
resumable:!accessing!public! !
signal!public!raising! !
signal:!public!raising! !
signal:with:!public!raising! !
signalWith:!public!raising! !
!

Core.Signal methodProtocol: #exceptionSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!
Core.Signal methodProtocol: #exceptionSignaler attributes: #(#ansi #readOnly) selectors: #(#signal #signal:)!

!Core.Signal class methodsFor!

description: anObject
	"Answer a new, non-resumable, instance of the receiver with the specified description"

	^self new description: anObject!

new
	"Answer a new correctly initialize instance of the receiver."
	
	^super new initialize!

resumableDescription: anObject
	"Answer a new continuable instance of the receiver with the specified description."

	^self new 
		description: anObject;
		makeResumable! !
!Core.Signal class categoriesForMethods!
description:!instance creation!public! !
new!instance creation!public! !
resumableDescription:!instance creation!public! !
!


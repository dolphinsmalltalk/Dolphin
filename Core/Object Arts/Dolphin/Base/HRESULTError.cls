"Filed out from Dolphin Smalltalk 7"!

Error subclass: #HRESULTError
	instanceVariableNames: 'errorInfo'
	classVariableNames: 'FacilityClasses'
	poolDictionaries: 'FacilityCodes'
	classInstanceVariableNames: ''!
HRESULTError guid: (GUID fromString: '{87b4c55a-026e-11d3-9fd7-00a0cc3e4a32}')!
HRESULTError comment: ''!
!HRESULTError categoriesForClass!System-Exception Handling! !
!HRESULTError methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	| hresult |
	hresult := self hresult.
	^{hresult. self messageText. hresult facility}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'HRESULT Error: %2 (%3)'!

hresult
	"Answer the HRESULT error code associated with the receiver."

	^tag ifNil: [HRESULT fail]!

hresult: hr
	"Set the HRESULT error code associated with the receiver to the <integer>
	argument, hr."

	^self tag: (HRESULT fromInteger: hr)!

messageText
	"Answer the <readableString> message text supplied when the receiver was signalled,
	or nil if none was provided."

	messageText isNil ifTrue: [
		errorInfo notNull ifTrue: [messageText := errorInfo description trimBlanks]].
	(messageText isNil or: [messageText isEmpty])
		ifTrue: [messageText := self osErrorMessage].
	^messageText!

osErrorMessage
	"Answer a String representation of the OS error code."

	^self hresult displayString!

statusCode
	"Answer the error status code from the receiver's details."

	^self hresult statusCode! !
!HRESULTError categoriesFor: #_descriptionArguments!displaying!public! !
!HRESULTError categoriesFor: #_descriptionFormat!displaying!public! !
!HRESULTError categoriesFor: #hresult!accessing!public! !
!HRESULTError categoriesFor: #hresult:!accessing!public! !
!HRESULTError categoriesFor: #messageText!accessing!public! !
!HRESULTError categoriesFor: #osErrorMessage!displaying!public! !
!HRESULTError categoriesFor: #statusCode!accessing!public! !

!HRESULTError class methodsFor!

fromInteger: anInteger 
	| hr |
	hr := HRESULT fromInteger: anInteger.
	^((FacilityClasses at: hr facilityCode ifAbsent: [self]) new)
		tag: hr;
		yourself!

initialize
	"Private - Initialize the receiver's class variables.
		HRESULTError initialize
	"

	FacilityClasses := 
		IdentityDictionary new
			at: FACILITY_NULL put: Win32Error;
			at: FACILITY_WIN32 put: Win32Error;
			yourself!

registerFacility: anInteger class: anExceptionClass
	"Register the specified exception class as the exception type
	to be raised for HRESULTs with the facility code, anInteger.
	Normally anExceptionClass will be a subclass of the receiver."

	FacilityClasses at: anInteger put: anExceptionClass!

signal: messageText with: anInteger
	"Raise a new instance of the receiver, with the error message, msg, initiating a search for an 
	ExceptionHandler prepared to handle instances of the receiver. This method will not return to its 
	sender, unless the new instance is resumable, and the handler which catches it directs that it 
	should be resumed."

	self signalHRESULT: (HRESULT fromInteger: anInteger)!

signalCode: statusCode facility: facilityCode
	"Raise a new instance of the receiver, with the error message, msg, initiating a search for an 
	ExceptionHandler prepared to handle instances of the receiver. This method will not return to its 
	sender, unless the new instance is resumable, and the handler which catches it directs that it 
	should be resumed."

	^self signalHRESULT: (HRESULT status: statusCode facility: facilityCode)!

signalHRESULT: anInteger 
	"Raise a new Error subinstance, with the specified error code, of an appropriate type 
	(depending on the facility of that code)."

	^(self fromInteger: anInteger) signal!

unregisterFacilityClass: anExceptionClass
	"Unregister the specified exception class, if registered."

	FacilityClasses removeKey: (FacilityClasses keyAtValue: anExceptionClass ifAbsent: [^self])
! !
!HRESULTError class categoriesFor: #fromInteger:!instance creation!public! !
!HRESULTError class categoriesFor: #initialize!development!initializing!private! !
!HRESULTError class categoriesFor: #registerFacility:class:!initializing!public! !
!HRESULTError class categoriesFor: #signal:with:!instance creation!public! !
!HRESULTError class categoriesFor: #signalCode:facility:!instance creation!public! !
!HRESULTError class categoriesFor: #signalHRESULT:!instance creation!public! !
!HRESULTError class categoriesFor: #unregisterFacilityClass:!initializing!public! !


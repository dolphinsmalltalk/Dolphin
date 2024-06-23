"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'OS.HRESULTError'
	instanceVariableNames: 'errorInfo osErrorMessage'
	classVariableNames: 'FacilityClasses'
	imports: #(#{OS.FacilityCodes private})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.HRESULTError guid: (Core.GUID fromString: '{87b4c55a-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.HRESULTError comment: ''!

!OS.HRESULTError categoriesForClass!System-Exception Handling! !

!OS.HRESULTError methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	| hresult |
	hresult := self hresult.
	^{hresult asUnsignedInteger. self messageText. hresult facility. self osErrorMessage}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^self hasMessageText 
		ifTrue: ['%2: %4']
		ifFalse: ['HRESULT Error 0x%1!!X!!: %4 (%3)']!

errorInfo
	"Private - Answer the IErrorInfo/EXCEPINFO associated with the receiver."

	^errorInfo!

errorInfo: err
	"Private - Set the IErrorInfo/EXCEPINFO associated with the receiver."

	errorInfo := err!

hasMessageText
	messageText isNil
		ifTrue: 
			[errorInfo notNull
				ifTrue: [messageText := errorInfo description ifNil: [''] ifNotNil: [:desc | desc trimBlanks]]].
	^(messageText isNil or: [messageText isEmpty]) not!

hresult
	"Answer the HRESULT error code associated with the receiver."

	^tag ?? HRESULT.Fail!

hresult: hr
	"Set the HRESULT error code associated with the receiver to the <integer>
	argument, hr."

	^self tag: (HRESULT fromInteger: hr)!

messageText
	"Answer the <readableString> message text supplied when the receiver was signalled,
	or nil if none was provided."

	^self hasMessageText ifTrue: [messageText] ifFalse: [self osErrorMessage]!

osErrorMessage
	"Answer a <String> representation of the HRESULT error code."

	^osErrorMessage ifNil: [osErrorMessage := self hresult displayString]!

source
	"Answer the 'source' of the error (by convention the Prog ID of the component which raised the error).
	This is only available if extended error information is associated with the receiver."

	^errorInfo notNull ifTrue: [errorInfo source]!

statusCode
	"Answer the error status code from the receiver's details."

	^self hresult statusCode! !

!OS.HRESULTError categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
errorInfo!accessing!private! !
errorInfo:!accessing!private! !
hasMessageText!private!testing! !
hresult!accessing!public! !
hresult:!accessing!public! !
messageText!accessing!public! !
osErrorMessage!displaying!public! !
source!accessing!public! !
statusCode!accessing!public! !
!

!OS.HRESULTError class methodsFor!

fromHRESULT: anHRESULT
	^(FacilityClasses at: anHRESULT facilityCode ifAbsent: [self]) new
		tag: anHRESULT;
		yourself!

fromInteger: anInteger
	^self fromHRESULT: (HRESULT fromInteger: anInteger)!

initialize
	"Private - Initialize the receiver's class variables.
		HRESULTError initialize
	"

	FacilityClasses := IdentityDictionary new
				at: FACILITY_NULL put: Win32Error;
				at: FACILITY_WIN32 put: Win32Error;
				yourself!

registerFacility: anInteger class: anExceptionClass
	"Register the specified exception class as the exception type
	to be raised for HRESULTs with the facility code, anInteger.
	Normally anExceptionClass will be a subclass of the receiver."

	FacilityClasses at: anInteger put: anExceptionClass!

signal: aString with: anInteger
	"Raise a new instance of the receiver, with the <readableString> error message, aString, and <integer> HRESULT code, anInteger, initiating a search for an ExceptionHandler prepared to handle instances of the receiver. This method will not return to its sender, unless the new instance is resumable, and the handler which catches it directs that it should be resumed."

	^(self fromHRESULT: (HRESULT fromInteger: anInteger))
		messageText: aString;
		signal!

signal: messageText withFailureCode: anInteger
	self signal: messageText with: (HRESULT decodePrimitiveFailureCode: anInteger)!

signalCode: statusCode facility: facilityCode
	"Raise a new instance of the receiver, with the error message, msg, initiating a search for an 
	ExceptionHandler prepared to handle instances of the receiver. This method will not return to its 
	sender, unless the new instance is resumable, and the handler which catches it directs that it 
	should be resumed."

	^self signalHRESULT: (HRESULT status: statusCode facility: facilityCode)!

signalFailureCode: anInteger
	"Private - Signal an HRESULTError from an HRESULT packed into a primitive failure code by the VM."

	^(self fromHRESULT: (HRESULT fromPrimitiveFailureCode: anInteger)) signal!

signalHRESULT: anHRESULT
	"Raise a new Error subinstance, with the specified error code, of an appropriate type (depending on the facility of that code)."

	^(self fromHRESULT: anHRESULT) signal!

unregisterFacilityClass: anExceptionClass
	"Unregister the specified exception class, if registered."

	FacilityClasses removeKey: (FacilityClasses keyAtValue: anExceptionClass ifAbsent: [^self])
! !

!OS.HRESULTError class categoriesForMethods!
fromHRESULT:!instance creation!public! !
fromInteger:!instance creation!public! !
initialize!development!initializing!private! !
registerFacility:class:!initializing!public! !
signal:with:!instance creation!public! !
signal:withFailureCode:!instance creation!public! !
signalCode:facility:!instance creation!public! !
signalFailureCode:!instance creation!private! !
signalHRESULT:!instance creation!public! !
unregisterFacilityClass:!initializing!public! !
!


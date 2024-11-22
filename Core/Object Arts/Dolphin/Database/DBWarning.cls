"Filed out from Dolphin Smalltalk"!

Notification subclass: #DBWarning
	instanceVariableNames: ''
	classVariableNames: 'TraceStream'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBWarning guid: (GUID fromString: '{87b4c574-026e-11d3-9fd7-00a0cc3e4a32}')!

DBWarning comment: 'Instances of DBWarning hold exception information for Database Connection non-fatal warnings (essentially those resulting from SQLSuccessWithInfo return codes).

'!

!DBWarning categoriesForClass!ODBC Interface! !

!DBWarning methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'%1 %2'!

exceptionDetails
	^tag!

nativeError
	^self primaryError nativeError!

primaryError
	^self exceptionDetails errors first!

signal
	"Signal this exception."

	self tag buildErrorInfo.
	super signal!

sqlState
	^self primaryError sqlState!

traceStream
	^TraceStream ifNil: [super traceStream]! !

!DBWarning categoriesForMethods!
_descriptionFormat!displaying!public! !
exceptionDetails!accessing!public! !
nativeError!accessing!public! !
primaryError!accessing!public! !
signal!public!signalling! !
sqlState!accessing!public! !
traceStream!accessing!private! !
!

!DBWarning class methodsFor!

traceStream
	^TraceStream!

traceStream: aWriteStream
	TraceStream := aWriteStream! !

!DBWarning class categoriesForMethods!
traceStream!public! !
traceStream:!public! !
!


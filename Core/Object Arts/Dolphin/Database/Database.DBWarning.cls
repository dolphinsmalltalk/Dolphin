"Filed out from Dolphin Smalltalk"!

Core.Notification
	subclass: #'Database.DBWarning'
	instanceVariableNames: ''
	classVariableNames: 'TraceStream'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBWarning guid: (Core.GUID fromString: '{87b4c574-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBWarning comment: 'Instances of DBWarning hold exception information for Database Connection non-fatal warnings (essentially those resulting from SQLSuccessWithInfo return codes).

'!

!Database.DBWarning categoriesForClass!ODBC Interface! !

!Database.DBWarning methodsFor!

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

!Database.DBWarning categoriesForMethods!
_descriptionFormat!displaying!public! !
exceptionDetails!accessing!public! !
nativeError!accessing!public! !
primaryError!accessing!public! !
signal!public!signalling! !
sqlState!accessing!public! !
traceStream!accessing!private! !
!

!Database.DBWarning class methodsFor!

traceStream
	^TraceStream!

traceStream: aWriteStream
	TraceStream := aWriteStream! !

!Database.DBWarning class categoriesForMethods!
traceStream!public! !
traceStream:!public! !
!


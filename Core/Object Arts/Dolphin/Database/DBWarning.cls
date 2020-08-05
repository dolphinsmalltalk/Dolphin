"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #DBWarning
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
DBWarning guid: (GUID fromString: '{87b4c574-026e-11d3-9fd7-00a0cc3e4a32}')!
DBWarning comment: 'Instances of DBWarning hold exception information for Database Connection non-fatal warnings (essentially those resulting from SQLSuccessWithInfo return codes).

'!
!DBWarning categoriesForClass!ODBC Interface! !
!DBWarning methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'%1 %2'!

signal
	"Signal this exception."

	self tag buildErrorInfo.
	super signal! !
!DBWarning categoriesFor: #_descriptionFormat!displaying!public! !
!DBWarning categoriesFor: #signal!public!signalling! !


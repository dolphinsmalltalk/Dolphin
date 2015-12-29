"Filed out from Dolphin Smalltalk X6"!

Notification subclass: #DBWarning
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBWarning guid: (GUID fromString: '{87B4C574-026E-11D3-9FD7-00A0CC3E4A32}')!
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


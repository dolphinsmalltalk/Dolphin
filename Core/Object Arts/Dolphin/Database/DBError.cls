"Filed out from Dolphin Smalltalk X6"!

Error subclass: #DBError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCRetCodes'
	classInstanceVariableNames: ''!
DBError guid: (GUID fromString: '{87B4C559-026E-11D3-9FD7-00A0CC3E4A32}')!
DBError comment: 'Instances of DBError hold exception information for Database Connection errors.'!
!DBError categoriesForClass!ODBC Interface! !
!DBError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'%1 %2'!

signal
	"Signal this exception."

	self tag buildErrorInfo.
	super signal! !
!DBError categoriesFor: #_descriptionFormat!displaying!public! !
!DBError categoriesFor: #signal!public!signalling! !

